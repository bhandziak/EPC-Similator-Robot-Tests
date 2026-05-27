from unittest.mock import MagicMock, patch

import pytest

from fastapi import HTTPException

from epc.api import get_ues_stats
from epc.models import ThroughputStats, UEState


# Test function - get_ues_stats

class TestGetUEsStats:

    def test_returns_aggregated_transfer_stats(self):

        # Arrange
        repo = MagicMock()

        stats = ThroughputStats(
            bearer_id=9,
            ue_id=1,
            bytes_tx=10000000,
            bytes_rx=10000000,
            start_ts=1,
            last_update_ts=2,
        )

        state = UEState(
            ue_id=1,
            stats={9: stats},
        )

        repo.list_ues.return_value = [1]
        repo.get_ue.return_value = state

        traffic_manager = MagicMock()
        traffic_manager.is_running.return_value = False

        # Act
        with (
            patch("epc.api.get_traffic_manager", return_value=traffic_manager),
            patch("time.time", return_value=2),
        ):
            response = get_ues_stats(repo=repo)

        # Assert
        assert response.total_tx_bps > 0

    def test_sums_transfer_for_multiple_bearers(self):

        # Arrange
        repo = MagicMock()

        stats_1 = ThroughputStats(
            bearer_id=9,
            ue_id=1,
            bytes_tx=3750000,
            bytes_rx=3750000,
            start_ts=1,
            last_update_ts=2,
        )

        stats_2 = ThroughputStats(
            bearer_id=5,
            ue_id=1,
            bytes_tx=6250000,
            bytes_rx=6250000,
            start_ts=1,
            last_update_ts=2,
        )

        state = UEState(
            ue_id=1,
            stats={
                9: stats_1,
                5: stats_2,
            },
        )

        repo.list_ues.return_value = [1]
        repo.get_ue.return_value = state

        traffic_manager = MagicMock()
        traffic_manager.is_running.return_value = False

        # Act
        with (
            patch("epc.api.get_traffic_manager", return_value=traffic_manager),
            patch("time.time", return_value=2),
        ):
            response = get_ues_stats(repo=repo)

        # Assert
        assert response.total_tx_bps == 80000

    def test_returns_correct_bearer_count(self):

        # Arrange
        repo = MagicMock()

        stats_1 = ThroughputStats(
            bearer_id=9,
            ue_id=1,
        )

        stats_2 = ThroughputStats(
            bearer_id=5,
            ue_id=1,
        )

        state = UEState(
            ue_id=1,
            stats={
                9: stats_1,
                5: stats_2,
            },
        )

        repo.list_ues.return_value = [1]
        repo.get_ue.return_value = state

        traffic_manager = MagicMock()
        traffic_manager.is_running.return_value = False

        # Act
        with patch("epc.api.get_traffic_manager", return_value=traffic_manager):
            response = get_ues_stats(repo=repo)

        # Assert
        assert response.bearer_count == 2
