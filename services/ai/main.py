from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager

from routers import ocr, extraction, pdf


@asynccontextmanager
async def lifespan(app: FastAPI):
    yield


app = FastAPI(
    title="Pratak AI Service",
    version="0.1.0",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(ocr.router, prefix="/ocr", tags=["ocr"])
app.include_router(extraction.router, prefix="/extraction", tags=["extraction"])
app.include_router(pdf.router, prefix="/pdf", tags=["pdf"])


@app.get("/health")
async def health() -> dict:
    return {"status": "ok"}
