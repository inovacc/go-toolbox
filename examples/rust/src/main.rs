use actix_web::{get, web, App, HttpResponse, HttpServer, Responder};
use serde::Serialize;
use std::time::Instant;

static START_TIME: std::sync::OnceLock<Instant> = std::sync::OnceLock::new();

#[derive(Serialize)]
struct MessageResponse {
    message: String,
}

#[derive(Serialize)]
struct HealthResponse {
    status: String,
    version: String,
    uptime: String,
}

#[get("/")]
async fn root() -> impl Responder {
    HttpResponse::Ok().json(MessageResponse {
        message: "Mjolnir Example API".to_string(),
    })
}

#[get("/health")]
async fn health() -> impl Responder {
    let uptime = START_TIME
        .get()
        .map(|t| format!("{}s", t.elapsed().as_secs()))
        .unwrap_or_else(|| "unknown".to_string());

    HttpResponse::Ok().json(HealthResponse {
        status: "healthy".to_string(),
        version: env!("CARGO_PKG_VERSION").to_string(),
        uptime,
    })
}

#[get("/api/hello")]
async fn hello() -> impl Responder {
    HttpResponse::Ok().json(MessageResponse {
        message: "Hello, World!".to_string(),
    })
}

#[get("/api/hello/{name}")]
async fn hello_name(path: web::Path<String>) -> impl Responder {
    let name = path.into_inner();
    HttpResponse::Ok().json(MessageResponse {
        message: format!("Hello, {}!", name),
    })
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    START_TIME.get_or_init(Instant::now);

    let port = std::env::var("PORT").unwrap_or_else(|_| "8080".to_string());
    let addr = format!("0.0.0.0:{}", port);

    println!("Starting server on {}", addr);

    HttpServer::new(|| {
        App::new()
            .service(root)
            .service(health)
            .service(hello)
            .service(hello_name)
    })
    .bind(&addr)?
    .run()
    .await
}
