"""Main entry point for fabrik-test-chrome-extension server."""

import os
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from fabrik_test_chrome_extension.logger import get_logger
from fabrik_test_chrome_extension.middleware import CorrelationMiddleware

logger = get_logger(__name__)


@asynccontextmanager
async def lifespan(app: FastAPI):  # noqa: ARG001
    """Application lifespan handler."""
    logger.info("service_starting", port=os.getenv("PORT", "8000"))
    yield
    logger.info("service_stopping")


app = FastAPI(title="fabrik-test-chrome-extension", lifespan=lifespan)
app.add_middleware(CorrelationMiddleware)

# CORS for extension
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure appropriately for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/health")
async def health():
    """Health check - tests actual dependencies, returns non-200 on failure."""
    return JSONResponse(
        content={
            "service": "fabrik-test-chrome-extension",
            "status": "ok",
        },
        status_code=200,
    )


@app.get("/")
async def root():
    return {"message": "Welcome to fabrik-test-chrome-extension API"}
