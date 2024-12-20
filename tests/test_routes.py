import pytest
from ib_rest_api import create_app

@pytest.fixture
def client():
    app = create_app()
    app.testing = True
    return app.test_client()

def test_index_route(client):
    response = client.get("/")
    assert response.status_code == 200
    assert response.json["message"] == "Welcome to IB REST API!"
