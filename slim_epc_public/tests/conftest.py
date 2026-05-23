import pytest
from unittest.mock import MagicMock, patch

from fastapi import FastAPI
from starlette.testclient import TestClient

from epc.api import EPCRepository, router, get_repo


# Main mock for db
@pytest.fixture
def mock_repo():
    with patch("epc.api.EPCRepository._conn") as mock_conn_method:
        mock_db = MagicMock()
        mock_conn_method.return_value.__enter__.return_value = mock_db

        repo = EPCRepository(db_path="dummy.db")
        yield repo, mock_db

# Main api_client
@pytest.fixture
def api_client(mock_repo):
    repo_instance, _ = mock_repo

    app = FastAPI()
    app.include_router(router)

    app.dependency_overrides[get_repo] = lambda: repo_instance

    client = TestClient(app)
    yield client

    app.dependency_overrides.clear()