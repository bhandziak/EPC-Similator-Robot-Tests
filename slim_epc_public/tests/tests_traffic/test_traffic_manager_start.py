from unittest.mock import MagicMock, patch

import pytest

from epc.models import BearerConfig
from epc.traffic import TrafficGeneratorManager


# Test method - TrafficGeneratorManager.start

class TestTrafficManagerStart:

    def test_starts_new_traffic_task(self):

        # Arrange
        repo = MagicMock()

        manager = TrafficGeneratorManager(repo)

        bearer = BearerConfig(
            bearer_id=9,
            protocol="tcp",
            target_bps=50000000,
            active=True,
        )

        fake_future = MagicMock()

        # Act
        with patch(
            "epc.traffic.asyncio.run_coroutine_threadsafe",
            return_value=fake_future,
        ):
            manager.start(1, bearer)

        # Assert
        assert (1, 9) in manager.tasks

    def test_saves_future_in_tasks_dictionary(self):

        # Arrange
        repo = MagicMock()

        manager = TrafficGeneratorManager(repo)

        bearer = BearerConfig(
            bearer_id=9,
            protocol="tcp",
            target_bps=50000000,
        )

        fake_future = MagicMock()

        # Act
        with patch(
            "epc.traffic.asyncio.run_coroutine_threadsafe",
            return_value=fake_future,
        ):
            manager.start(1, bearer)

        # Assert
        assert manager.tasks[(1, 9)] == fake_future

    def test_rejects_duplicate_running_traffic(self):

        # Arrange
        repo = MagicMock()

        manager = TrafficGeneratorManager(repo)

        bearer = BearerConfig(
            bearer_id=9,
            protocol="tcp",
            target_bps=50000000,
        )

        manager.tasks[(1, 9)] = MagicMock()

        # Act / Assert
        with pytest.raises(ValueError, match="Traffic already running"):
            manager.start(1, bearer)

    def test_rejects_missing_target_bps(self):

        # Arrange
        repo = MagicMock()

        manager = TrafficGeneratorManager(repo)

        bearer = BearerConfig(
            bearer_id=9,
            protocol="tcp",
            target_bps=None,
        )

        # Act / Assert
        with pytest.raises(
            ValueError,
            match="Bearer not configured for traffic",
        ):
            manager.start(1, bearer)
