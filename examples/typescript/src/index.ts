const startTime = Date.now();

interface MessageResponse {
  message: string;
}

interface HealthResponse {
  status: string;
  version: string;
  uptime: string;
}

const server = Bun.serve({
  port: process.env.PORT || 8080,

  fetch(req) {
    const url = new URL(req.url);
    const path = url.pathname;

    // Root endpoint
    if (path === "/" && req.method === "GET") {
      return Response.json({
        message: "Mjolnir Example API",
      } as MessageResponse);
    }

    // Health endpoint
    if (path === "/health" && req.method === "GET") {
      const uptimeMs = Date.now() - startTime;
      const uptimeSec = Math.floor(uptimeMs / 1000);

      return Response.json({
        status: "healthy",
        version: "0.1.0",
        uptime: `${uptimeSec}s`,
      } as HealthResponse);
    }

    // Hello endpoint
    if (path === "/api/hello" && req.method === "GET") {
      return Response.json({
        message: "Hello, World!",
      } as MessageResponse);
    }

    // Hello with name endpoint
    const helloMatch = path.match(/^\/api\/hello\/(.+)$/);
    if (helloMatch && req.method === "GET") {
      const name = decodeURIComponent(helloMatch[1]);
      return Response.json({
        message: `Hello, ${name}!`,
      } as MessageResponse);
    }

    // 404 for unknown routes
    return new Response("Not Found", { status: 404 });
  },
});

console.log(`Starting server on http://localhost:${server.port}`);
