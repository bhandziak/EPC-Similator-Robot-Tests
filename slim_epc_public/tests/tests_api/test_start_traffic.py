import pytest
from unittest.mock import MagicMock, patch

from fastapi import HTTPException

from epc.api import start_traffic
from epc.models import (
    BearerConfig,
    StartTrafficRequest,
    ThroughputStats,
    UEState,
)


# Test function - start_traffic

class TestStartTraffic:

    def test_starts_valid_traffic(self):

        # Arrange
        repo = MagicMock()

        bearer = BearerConfig(bearer_id=9)

        state = UEState(
            ue_id=1,
            bearers={9: bearer},
            stats={},
        )

        repo.get_ue.return_value = state

        body = StartTrafficRequest(
            protocol="tcp",
            Mbps=50,
        )

        traffic_manager = MagicMock()

        # Act
        with patch("epc.api.get_traffic_manager", return_value=traffic_manager):
            response = start_traffic(
                ue_id=1,
                bearer_id=9,
                body=body,
                repo=repo,
            )

        # Assert
        assert response.status == "traffic_started"
        assert response.target_bps == 50000000

    def test_activates_bearer(self):

        # Arrange
        repo = MagicMock()

        bearer = BearerConfig(bearer_id=9)

        state = UEState(
            ue_id=1,
            bearers={9: bearer},
            stats={},
        )

        repo.get_ue.return_value = state

        body = StartTrafficRequest(
            protocol="tcp",
            Mbps=50,
        )

        traffic_manager = MagicMock()

        # Act
        with patch("epc.api.get_traffic_manager", return_value=traffic_manager):
            start_traffic(
                ue_id=1,
                bearer_id=9,
                body=body,
                repo=repo,
            )

        # Assert
        assert bearer.active is True

    def test_sets_protocol_to_lowercase(self):

        # Arrange
        repo = MagicMock()

        bearer = BearerConfig(bearer_id=9)

        state = UEState(
            ue_id=1,
            bearers={9: bearer},
            stats={},
        )

        repo.get_ue.return_value = state

        body = StartTrafficRequest(
            protocol="tcp",
            Mbps=50,
        )

        traffic_manager = MagicMock()

        # Act
        with patch("epc.api.get_traffic_manager", return_value=traffic_manager):
            start_traffic(
                ue_id=1,
                bearer_id=9,
                body=body,
                repo=repo,
            )

        # Assert
        assert bearer.protocol == "tcp"

    def test_sets_target_bps(self):

        # Arrange
        repo = MagicMock()

        bearer = BearerConfig(bearer_id=9)

        state = UEState(
            ue_id=1,
            bearers={9: bearer},
            stats={},
        )

        repo.get_ue.return_value = state

        body = StartTrafficRequest(
            protocol="tcp",
            Mbps=50,
        )

        traffic_manager = MagicMock()

        # Act
        with patch("epc.api.get_traffic_manager", return_value=traffic_manager):
            start_traffic(
                ue_id=1,
                bearer_id=9,
                body=body,
                repo=repo,
            )

        # Assert
        assert bearer.target_bps == 50000000

    def test_initializes_stats_when_missing(self):

        # Arrange
        repo = MagicMock()

        bearer = BearerConfig(bearer_id=9)

        state = UEState(
            ue_id=1,
            bearers={9: bearer},
            stats={},
        )

        repo.get_ue.return_value = state

        body = StartTrafficRequest(
            protocol="tcp",
            Mbps=50,
        )

        traffic_manager = MagicMock()

        # Act
        with patch("epc.api.get_traffic_manager", return_value=traffic_manager):
            start_traffic(
                ue_id=1,
                bearer_id=9,
                body=body,
                repo=repo,
            )

        # Assert
        repo.update_stats.assert_called_once()

        args = repo.update_stats.call_args[0]

        assert isinstance(args[1], ThroughputStats)

    def test_calls_traffic_manager_start(self):

        # Arrange
        repo = MagicMock()

        bearer = BearerConfig(bearer_id=9)

        state = UEState(
            ue_id=1,
            bearers={9: bearer},
            stats={},
        )

        repo.get_ue.return_value = state

        body = StartTrafficRequest(
            protocol="tcp",
            Mbps=50,
        )

        traffic_manager = MagicMock()

        # Act
        with patch("epc.api.get_traffic_manager", return_value=traffic_manager):
            start_traffic(
                ue_id=1,
                bearer_id=9,
                body=body,
                repo=repo,
            )

        # Assert
        traffic_manager.start.assert_called_once()

    def test_rejects_missing_ue(self):

        # Arrange
        repo = MagicMock()

        repo.get_ue.side_effect = ValueError("UE not found")

        body = StartTrafficRequest(
            protocol="tcp",
            Mbps=50,
        )

        # Act / Assert
        with pytest.raises(HTTPException):
            start_traffic(
                ue_id=999,
                bearer_id=9,
                body=body,
                repo=repo,
            )

    def test_rejects_missing_bearer(self):

        # Arrange
        repo = MagicMock()

        state = UEState(
            ue_id=1,
            bearers={},
            stats={},
        )

        repo.get_ue.return_value = state

        body = StartTrafficRequest(
            protocol="tcp",
            Mbps=50,
        )

        # Act / Assert
        with pytest.raises(HTTPException):
            start_traffic(
                ue_id=1,
                bearer_id=9,
                body=body,
                repo=repo,
            )

    def test_rejects_already_running_traffic(self):

        # Arrange
        repo = MagicMock()

        bearer = BearerConfig(bearer_id=9)

        state = UEState(
            ue_id=1,
            bearers={9: bearer},
            stats={},
        )

        repo.get_ue.return_value = state

        body = StartTrafficRequest(
            protocol="tcp",
            Mbps=50,
        )

        traffic_manager = MagicMock()

        traffic_manager.start.side_effect = ValueError(
            "Traffic already running"
        )

        # Act / Assert
        with (
            patch("epc.api.get_traffic_manager", return_value=traffic_manager),
            pytest.raises(HTTPException),
        ):
            start_traffic(
                ue_id=1,
                bearer_id=9,
                body=body,
                repo=repo,
            )