from unittest.mock import MagicMock

from epc.traffic import TrafficGeneratorManager


# Test method - TrafficGeneratorManager.is_running

class TestTrafficManagerIsRunning:

    def test_returns_true_for_running_task(self):

        # Arrange
        repo = MagicMock()

        manager = TrafficGeneratorManager(repo)

        manager.tasks[(1, 9)] = MagicMock()

        # Act
        result = manager.is_running(1, 9)

        # Assert
        assert result is True

    def test_returns_false_for_missing_task(self):

        # Arrange
        repo = MagicMock()

        manager = TrafficGeneratorManager(repo)

        # Act
        result = manager.is_running(1, 9)

        # Assert
        assert result is False