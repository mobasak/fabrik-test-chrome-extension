"""Health endpoint tests."""

from fastapi.testclient import TestClient

from fabrik_test_chrome_extension.main import app

client = TestClient(app)


def test_health_returns_200():
    """Health returns 200."""
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["service"] == "fabrik-test-chrome-extension"
    assert data["status"] == "ok"


def test_root_endpoint():
    """Root endpoint returns welcome message."""
    response = client.get("/")
    assert response.status_code == 200
    assert "message" in response.json()
