import os
import time
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI(title="Mjolnir Example API", version="0.1.0")

START_TIME = time.time()


class MessageResponse(BaseModel):
    message: str


class HealthResponse(BaseModel):
    status: str
    version: str
    uptime: str


@app.get("/", response_model=MessageResponse)
async def root():
    return MessageResponse(message="Mjolnir Example API")


@app.get("/health", response_model=HealthResponse)
async def health():
    uptime_sec = int(time.time() - START_TIME)
    return HealthResponse(
        status="healthy",
        version="0.1.0",
        uptime=f"{uptime_sec}s"
    )


@app.get("/api/hello", response_model=MessageResponse)
async def hello():
    return MessageResponse(message="Hello, World!")


@app.get("/api/hello/{name}", response_model=MessageResponse)
async def hello_name(name: str):
    return MessageResponse(message=f"Hello, {name}!")


if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("PORT", 8080))
    uvicorn.run(app, host="0.0.0.0", port=port)
