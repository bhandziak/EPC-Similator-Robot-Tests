from unittest.mock import MagicMock, patch
from epc.api import get_traffic_stats
from epc.models import ThroughputStats, UEState


def test_get_transfer_uses_kbps_as_default_unit(mock_repo):

    # Arrange
    repo, _ = mock_repo

    # Set 1 Mbps
    stats = ThroughputStats(
        bearer_id=5,
        ue_id=1,
        bytes_tx=125000,
        bytes_rx=125000,
        start_ts=0,
        last_update_ts=1,
        target_bps=1000000,
    )

    state = UEState(
        ue_id=1,
        stats={5: stats},
    )

    mock_tm = MagicMock()
    mock_tm.is_running.return_value = False

    with patch.object(repo, "get_ue", return_value=state), \
         patch("epc.api.get_traffic_manager", return_value=mock_tm), \
         patch("time.time", return_value=1):

        # Act
        response = get_traffic_stats(
            ue_id=1,
            bearer_id=5,
            repo=repo,
        )

        # Assert
        expected_kbps = 1000

        # Check default unit (should be kbps, but it is bps)
        # Test fails just by looking at field name
        assert response.target_bps == expected_kbps