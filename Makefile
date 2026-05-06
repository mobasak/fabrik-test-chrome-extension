.PHONY: dev dev-server dev-ext build-ext install test docker-build docker-smoke clean

PROJECT_NAME := fabrik-test-chrome-extension
PORT := 8000

# Parallel dev: extension Vite dev + server uvicorn reload
dev:
	@trap 'kill 0' SIGINT; \
	cd extension && npm run dev & \
	.venv/bin/uvicorn fabrik_test_chrome_extension.main:app --reload --host 0.0.0.0 --port $(PORT) --app-dir server/src & \
	wait

# Server only (FastAPI with reload)
dev-server:
	.venv/bin/uvicorn fabrik_test_chrome_extension.main:app --reload --host 0.0.0.0 --port $(PORT) --app-dir server/src

# Extension only (Vite dev with HMR)
dev-ext:
	cd extension && npm run dev

# Production extension build (Vite)
build-ext:
	cd extension && npm run build

# Install all dependencies
install:
	python -m venv .venv
	.venv/bin/pip install -r requirements.txt
	cd extension && npm install

# Run tests
test:
	PYTHONPATH=server/src .venv/bin/pytest -v

# Docker build
docker-build:
	docker build -t $(PROJECT_NAME) .

# Docker smoke test
docker-smoke: docker-build
	@echo "Starting container..."
	@docker run -d --name $(PROJECT_NAME)-test -p $(PORT):$(PORT) -e PORT=$(PORT) $(PROJECT_NAME)
	@echo "Waiting for health check..."
	@sleep 5
	@curl -f http://localhost:$(PORT)/health || (docker logs $(PROJECT_NAME)-test && exit 1)
	@echo "✅ Health check passed"
	@docker stop $(PROJECT_NAME)-test
	@docker rm $(PROJECT_NAME)-test
	@echo "✅ Smoke test completed"

# Clean build artifacts
clean:
	rm -rf extension/dist extension/node_modules
	find . -type d -name "__pycache__" -exec rm -rf {} +
	docker rmi $(PROJECT_NAME) 2>/dev/null || true
