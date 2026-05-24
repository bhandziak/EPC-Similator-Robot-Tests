import pytest

from unittest.mock import MagicMock, patch
from pydantic import ValidationError


class TestDbAddBearer:
    def test_add_new_bearer(self, mock_repo):
        repo, _mock_db = mock_repo
        state = MagicMock()
        state.bearers = {}

        with patch.object(repo, "get_ue", return_value=state):
            with patch.object(repo, "save_ue") as save_ue_mock:
                repo.add_bearer(ue_id=1, bearer_id=5)

        assert 5 in state.bearers
        assert save_ue_mock.called

    @pytest.mark.parametrize("bearer_id", [-1, 0, 10, 99])
    def test_add_bearer_out_of_range(self, mock_repo, bearer_id):
        repo, _mock_db = mock_repo

        state = MagicMock()
        state.bearers = {}

        with patch.object(repo, "get_ue", return_value=state):
            with patch.object(repo, "save_ue") as save_ue_mock:
                with pytest.raises(ValidationError):
                    repo.add_bearer(ue_id=1, bearer_id=bearer_id)

        assert not save_ue_mock.called

    def test_add_already_added_bearer(self, mock_repo):
        repo, _mock_db = mock_repo

        state = MagicMock()
        state.bearers = {5: MagicMock()}

        with patch.object(repo, "get_ue", return_value=state):
            with patch.object(repo, "save_ue") as save_ue_mock:
                with pytest.raises(ValueError) as exc:
                    repo.add_bearer(ue_id=1, bearer_id=5)

        assert str(exc.value) == "Bearer already exists"
        assert not save_ue_mock.called