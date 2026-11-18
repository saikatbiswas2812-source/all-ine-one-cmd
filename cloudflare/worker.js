const INSTALLER_URL = "https://raw.githubusercontent.com/saikatbiswas2812-source/all-ine-one-cmd/main/install.sh";

export default {
  async fetch(request) {
    const url = new URL(request.url);

    if (url.pathname !== "/" && url.pathname !== "/install.sh") {
      return new Response("Not Found\n", { status: 404 });
    }

    if (request.method !== "GET" && request.method !== "HEAD") {
      return new Response("Method Not Allowed\n", {
        status: 405,
        headers: { Allow: "GET, HEAD" }
      });
    }

    const upstream = await fetch(INSTALLER_URL, {
      method: "GET",
      headers: { "User-Agent": "L4xxyHost-Installer-Endpoint" },
      cf: { cacheTtl: 0, cacheEverything: false }
    });

    if (!upstream.ok) {
      return new Response("L4xxyHost installer temporarily unavailable\n", {
        status: 502,
        headers: {
          "Content-Type": "text/plain; charset=utf-8",
          "Cache-Control": "no-store"
        }
      });
    }

    return new Response(request.method === "HEAD" ? null : upstream.body, {
      status: 200,
      headers: {
        "Content-Type": "text/plain; charset=utf-8",
        "Cache-Control": "no-store",
        "X-Content-Type-Options": "nosniff"
      }
    });
  }
};
