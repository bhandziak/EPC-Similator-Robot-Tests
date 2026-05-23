import pytest
from unittest.mock import MagicMock, patch

from fastapi import HTTPException

from epc.api import stop_traffic
from epc.models import BearerConfig


class TestStopTransmissionApi:
    def test_stop_transmission_for_one_ue_success(self, mock_repo):
        repo, _mock_db = mock_repo

        bearer = BearerConfig(bearer_id=5, protocol="tcp", target_bps=1_000_000, active=True)

        state = MagicMock()
        state.bearers = {5: bearer}

        tm = MagicMock()

        with patch.object(repo, "get_ue", return_value=state) as get_ue_mock:
            with patch("epc.api.get_traffic_manager", return_value=tm) as get_tm_mock:
                with patch.object(repo, "update_bearer", return_value=None) as update_bearer_mock:
                    resp = stop_traffic(ue_id=1, bearer_id=5, repo=repo)

        get_ue_mock.assert_any_call(1)
        get_tm_mock.assert_called()
        tm.stop.assert_called_once_with(1, 5)
        update_bearer_mock.assert_called()

        assert bearer.active is False

        assert resp.status == "traffic_stopped"
        assert resp.ue_id == 1
        assert resp.bearer_id == 5

    def test_stop_transmission_for_non_existing_bearer_400(self, mock_repo):
        repo, _mock_db = mock_repo

        state = MagicMock()
        state.bearers = {}

        with patch.object(repo, "get_ue", return_value=state):
            with pytest.raises(HTTPException) as exc:
                stop_traffic(ue_id=1, bearer_id=99, repo=repo)

        assert exc.value.status_code == 400
        assert exc.value.detail == "Bearer not found"

    def test_stop_transmission_for_non_existing_ue_400(self, mock_repo):
        repo, _mock_db = mock_repo

        with patch.object(repo, "get_ue", side_effect=ValueError("UE not found")):
            with pytest.raises(HTTPException) as exc:
                stop_traffic(ue_id=123, bearer_id=5, repo=repo)

        assert exc.value.status_code == 400
        assert exc.value.detail == "UE not found"