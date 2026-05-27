from unittest.mock import MagicMock, patch

import pytest

from fastapi import HTTPException

from epc.api import get_traffic_stats
from epc.models import ThroughputStats, UEState


# Test function - get_traffic_stats

class TestGetTrafficStats:

    def test_returns_transfer_stats_for_existing_bearer(self):

        # Arrange
        repo = MagicMock()

        stats = ThroughputStats(
            bearer_id=9,
            ue_id=1,
            bytes_tx=6250000,
            bytes_rx=6250000,
            start_ts=1,
            last_update_ts=2,
            protocol="tcp",
            target_bps=50000000,
        )

        state = UEState(
            ue_id=1,
            stats={9: stats},
        )

        repo.get_ue.return_value = state

        traffic_manager = MagicMock()
        traffic_manager.is_running.return_value = False

        # Act
        with (
            patch("epc.api.get_traffic_manager", return_value=traffic_manager),
            patch("time.time", return_value=2),
        ):
            response = get_traffic_stats(
                ue_id=1,
                bearer_id=9,
                repo=repo,
            )

        # Assert
        assert response.tx_bps == 50000

    def test_returns_zero_stats_for_missing_stats(self):

        # Arrange
        repo = MagicMock()

        state = UEState(
            ue_id=1,
            stats={},
        )

        repo.get_ue.return_value = state

        # Act
        response = get_traffic_stats(
            ue_id=1,
            bearer_id=9,
            repo=repo,
        )

        # Assert
        assert response.tx_bps == 0
        assert response.rx_bps == 0

    def test_calculates_tx_bps_correctly(self):

        # Arrange
        repo = MagicMock()

        stats = ThroughputStats(
            bearer_id=9,
            ue_id=1,
            bytes_tx=6250000,
            bytes_rx=6250000,
            start_ts=1,
            last_update_ts=2,
        )

        state = UEState(
            ue_id=1,
            stats={9: stats},
        )

        repo.get_ue.return_value = state

        traffic_manager = MagicMock()
        traffic_manager.is_running.return_value = False

        # Act
        with (
            patch("epc.api.get_traffic_manager", return_value=traffic_manager),
            patch("time.time", return_value=2),
        ):
            response = get_traffic_stats(
                ue_id=1,
                bearer_id=9,
                repo=repo,
            )

        # Assert
        assert response.tx_bps == 50000

    def test_calculates_duration_correctly(self):

        # Arrange
        repo = MagicMock()

        stats = ThroughputStats(
            bearer_id=9,
            ue_id=1,
            bytes_tx=6250000,
            bytes_rx=6250000,
            start_ts=1,
            last_update_ts=2,
        )

        state = UEState(
            ue_id=1,
            stats={9: stats},
        )

        repo.get_ue.return_value = state

        traffic_manager = MagicMock()
        traffic_manager.is_running.return_value = False

        # Act
        with (
            patch("epc.api.get_traffic_manager", return_value=traffic_manager),
            patch("time.time", return_value=2),
        ):
            response = get_traffic_stats(
                ue_id=1,
                bearer_id=9,
                repo=repo,
            )

        # Assert
        assert response.duration == 1

    def test_uses_current_time_when_traffic_running(self):

        # Arrange
        repo = MagicMock()

        stats = ThroughputStats(
            bearer_id=9,
            ue_id=1,
            bytes_tx=6250000,
            bytes_rx=6250000,
            start_ts=1,
            last_update_ts=5,
        )

        state = UEState(
            ue_id=1,
            stats={9: stats},
        )

        repo.get_ue.return_value = state

        traffic_manager = MagicMock()
        traffic_manager.is_running.return_value = True

        # Act
        with (
            patch("epc.api.get_traffic_manager", return_value=traffic_manager),
            patch("time.time", return_value=3),
        ):
            response = get_traffic_stats(
                ue_id=1,
                bearer_id=9,
                repo=repo,
            )

        # Assert
        assert response.duration == 2
