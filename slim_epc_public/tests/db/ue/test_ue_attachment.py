import json
import pytest

from unittest.mock import patch
from pydantic import ValidationError


# Test method - attach_ue
class TestUeAttachment:
    # Successful attachment
    @pytest.mark.parametrize("ue_id", [1, 2, 99, 100])
    def test_attach_ue_boundary_success(self, mock_repo, ue_id):
        # Given
        repo, mock_db = mock_repo

        # When
        with patch.object(repo, 'ue_exists', return_value=False):
            repo.attach_ue(ue_id)

        # Then
        assert mock_db.execute.called
        args, _ = mock_db.execute.call_args
        assert "INSERT INTO ue_state" in args[0]
        assert args[1][0] == ue_id

    # Failed attachment
    @pytest.mark.parametrize("ue_id", [-1, 0, 101])
    def test_attach_ue_boundary_fail(self, mock_repo, ue_id):
        # Given
        repo, mock_db = mock_repo

        # When
        with patch.object(repo, 'ue_exists', return_value=False):
            with pytest.raises(ValidationError):
                repo.attach_ue(ue_id)

        # Then
        assert not mock_db.execute.called

    # Check default bearer
    def test_attach_ue_adds_default_bearer(self, mock_repo):
        # Given
        repo, mock_db = mock_repo
        ue_id = 1

        # When
        with patch.object(repo, 'ue_exists', return_value=False):
            repo.attach_ue(ue_id)

        # Then
        assert mock_db.execute.called
        args, _ = mock_db.execute.call_args

        inserted_json_str = args[1][1]

        inserted_data = json.loads(inserted_json_str)

        assert "bearers" in inserted_data
        assert "9" in inserted_data["bearers"]
        assert inserted_data["bearers"]["9"]["bearer_id"] == 9

    def test_attach_ue_fails_when_already_attached(self, mock_repo):
        # Given
        repo, mock_db = mock_repo
        ue_id = 1

        # mock UE existence
        with patch.object(repo, 'ue_exists', return_value=True):
            # When & Then
            with pytest.raises(ValueError, match="UE already attached"):
                repo.attach_ue(ue_id)

        assert not mock_db.execute.called