import pytest
from unittest.mock import MagicMock, patch
from epc.api import EPCRepository

# Main mock for db
@pytest.fixture
def mock_repo():
    with patch("epc.api.EPCRepository._conn") as mock_conn_method:
        mock_db = MagicMock()
        mock_conn_method.return_value.__enter__.return_value = mock_db

        repo = EPCRepository(db_path="dummy.db")
        yield repo, mock_db