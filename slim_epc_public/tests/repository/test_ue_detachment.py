import json
import pytest

from unittest.mock import patch
from pydantic import ValidationError

# Test method - detach_ue
class TestUeDetachment:
    def test_detach_ue_success(self, mock_repo):
        # Given
        repo, mock_db = mock_repo
        ue_id = 1

        # When
        with patch.object(repo, 'ue_exists', return_value=True):
            repo.detach_ue(ue_id)

        # Then
        assert mock_db.execute.called

        args, _ = mock_db.execute.call_args
        sql_query = args[0]
        sql_params = args[1]

        assert "DELETE FROM ue_state" in sql_query
        assert sql_params[0] == ue_id

    def test_detach_ue_fails_when_ue_not_found(self, mock_repo):
        # Given
        repo, mock_db = mock_repo
        ue_id = 1

        # When & Then
        with patch.object(repo, 'ue_exists', return_value=False):
            with pytest.raises(ValueError, match="UE not found"):
                repo.detach_ue(ue_id)

        assert not mock_db.execute.called

