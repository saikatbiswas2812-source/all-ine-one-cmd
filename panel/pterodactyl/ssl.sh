#!/bin/bash

# --- Colors & Formatting ---
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m' # No Color
PHP_VERSION="8.3"
# --- Header ---
clear
echo -e "${CYAN}${BOLD}=========================================${NC}"
echo -e "${CYAN}      PTERODACTYL NGINX CONFIGURATOR     ${NC}"
echo -e "${CYAN}=========================================${NC}"
echo ""

# --- 1. Selection Menu ---
echo -e "${BOLD}Select Configuration Mode:${NC}"
echo -e "  ${GREEN}[1]${NC} SSL / HTTPS ${YELLOW}(Secure)${NC}"
echo -e "  ${RED}[2]${NC} No SSL / HTTP ${YELLOW}(Insecure)${NC}"
echo -e "  ${RED}[3]${NC} CREATE / HTTP/HTTPS ${YELLOW}(Insecure)${NC}"
echo ""
read -p "Select option [1-3]: " OPTION

echo ""
echo -e "${CYAN}--- Configuration Details ---${NC}"
read -p "Enter your Domain (e.g., panel.example.com): " DOMAIN
# --- Check & Prepare ---
echo ""
echo -e "${YELLOW}[*] Preparing environment...${NC}"
cd /var/www/pterodactyl || { echo -e "${RED}[!] Pterodactyl directory not found!${NC}"; exit 1; }

# Remove old configs
rm -f /etc/nginx/sites-enabled/default
rm -f /etc/nginx/sites-available/pterodactyl.conf

# ================= SSL CONFIGURATION =================
if [ "$OPTION" == "1" ]; then
    echo -e "${YELLOW}[?] SSL Certificate Path Selection:${NC}"
    echo -e "    ${BOLD}y${NC} = Let's Encrypt (Standard)"
    echo -e "    ${BOLD}n${NC} = Custom/Default (/etc/certs/panel)"
    read -p "Use Let's Encrypt path? (y/n): " SSLTYPE

    if [ "$SSLTYPE" == "y" ]; then
        SETUP="letsencrypt/live/${DOMAIN}"
        FULLCHAIN="/etc/letsencrypt/live/${DOMAIN}/fullchain.pem"
        PRIVKEY="/etc/letsencrypt/live/${DOMAIN}/privkey.pem"
    else
        SETUP="certs/panel"
        FULLCHAIN="/etc/certs/panel/fullchain.pem"
        PRIVKEY="/etc/certs/panel/privkey.pem"
    fi

    echo -e "${GREEN}[+] Setting APP_URL to HTTPS...${NC}"
    sed -i "s|APP_URL=.*|APP_URL=https://${DOMAIN}|g" .env

    # Create Nginx Config (SSL)
    cat > /etc/nginx/sites-available/pterodactyl.conf <<EOF
server {
    listen 80;
    server_name ${DOMAIN};
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl http2;
    server_name ${DOMAIN};

    root /var/www/pterodactyl/public;
    index index.php;

    ssl_certificate ${FULLCHAIN};
    ssl_certificate_key ${PRIVKEY};

    client_max_body_size 100m;
    client_body_timeout 120s;
    sendfile off;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php\$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)\$;
        fastcgi_pass unix:/run/php/php${PHP_VERSION}-fpm.sock;
        fastcgi_index index.php;
        include /etc/nginx/fastcgi_params;
        fastcgi_param PHP_VALUE "upload_max_filesize=100M \n post_max_size=100M";
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param HTTP_PROXY "";
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

# ================= NO SSL CONFIGURATION =================
elif [ "$OPTION" == "2" ]; then
    echo -e "${YELLOW}[*] Preparing environment...${NC}"
    cd /var/www/pterodactyl || { echo -e "${RED}[!] Pterodactyl directory not found!${NC}"; exit 1; }
    sed -i "s|^APP_URL=.*|APP_URL=http://${DOMAIN}|" .env

    cat > /etc/nginx/sites-available/pterodactyl.conf <<EOF
server {
    listen 80;
    server_name ${DOMAIN};
    root /var/www/pterodactyl/public;
    index index.php;
    charset utf-8;
    client_max_body_size 100m;
    client_body_timeout 120s;
    sendfile off;
    location / {
        try_files \\$uri \\$uri/ /index.php?\$query_string;
    }
    location ~ \.php\$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)\$;
        fastcgi_pass unix:/run/php/php${PHP_VERSION}-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \\$document_root\$fastcgi_script_name;
    }
    location ~ /\.ht { deny all; }
}
EOF

elif [ "$OPTION" == "3" ]; then
    echo -e "${YELLOW}[*] Requesting a Let's Encrypt certificate...${NC}"
    read -r -p "Enter email address for certificate notices: " EMAIL
    if [[ ! "${EMAIL}" =~ ^[^[:space:]@]+@[^[:space:]@]+\.[^[:space:]@]+$ ]]; then
        echo -e "${RED}[!] Invalid email address.${NC}"
        exit 1
    fi
    apt-get update
    apt-get install -y certbot python3-certbot-nginx
    certbot --nginx -d "${DOMAIN}" --non-interactive --agree-tos -m "${EMAIL}" --redirect
    exit $?

else
    echo -e "${RED}[!] Invalid option. Choose 1, 2, or 3.${NC}"
    exit 1
fi

# --- Finalize ---
echo -e "${YELLOW}[*] Enabling configuration...${NC}"
ln -sfn /etc/nginx/sites-available/pterodactyl.conf /etc/nginx/sites-enabled/pterodactyl.conf
echo -e "${YELLOW}[*] Testing Nginx configuration...${NC}"
if nginx -t; then
    systemctl reload nginx
    echo ""
    echo -e "${GREEN}✔ Configuration completed successfully.${NC}"
    echo -e "Panel URL: ${BOLD}https$( [ "$OPTION" == "1" ] && echo "s" )://${DOMAIN}${NC}"
else
    echo -e "${RED}[!] Nginx configuration failed. Fix the errors before reloading Nginx.${NC}"
    exit 1
fi
