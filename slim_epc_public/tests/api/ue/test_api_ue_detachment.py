import pytest
from unittest.mock import patch, MagicMock
from epc.models import UEState, BearerConfig


class TestApiUeDetachment:

    def test_detach_ue_with_bearers_cleans_bearers(self, api_client, mock_repo):
        # Given
        repo, mock_db = mock_repo
        ue_id = 1

        with patch.object(repo, 'ue_exists', return_value=True):
            # When
            response = api_client.delete(f"/ues/{ue_id}")

        # Then
        assert response.status_code == 200

        assert mock_db.execute.called
        args, _ = mock_db.execute.call_args
        assert "DELETE FROM ue_state" in args[0]
        assert args[1][0] == ue_id

    @patch("epc.api.get_traffic_manager")
    def test_detach_ue_with_active_traffic_stops_traffic(self, mock_get_tm, api_client, mock_repo):
        # Given
        repo, mock_db = mock_repo
        ue_id = 1
        bearer_id = 5

        state = UEState(ue_id=ue_id)
        state.bearers[bearer_id] = BearerConfig(bearer_id=bearer_id, active=True)

        # mock traffic - ue = 1 with bearer = 5 with active transmission
        mock_tm = MagicMock()
        mock_tm.is_running.return_value = True
        mock_get_tm.return_value = mock_tm


        with patch.object(repo, 'get_ue', return_value=state), patch.object(repo, 'ue_exists', return_value=True):
            # When
            response = api_client.delete(f"/ues/{ue_id}")

        # Then
        assert response.status_code == 200

        mock_tm.stop.assert_called_once_with(ue_id, bearer_id)