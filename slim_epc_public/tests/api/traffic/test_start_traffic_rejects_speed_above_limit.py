import pytest
from unittest.mock import patch
from fastapi import HTTPException
from epc.api import start_traffic
from epc.models import BearerConfig, StartTrafficRequest, UEState

def test_start_traffic_rejects_speed_above_limit(mock_repo):

    # Arrange
    repo, _ = mock_repo

    bearer = BearerConfig(bearer_id=5)

    state = UEState(
        ue_id=1,
        bearers={5: bearer},
    )

    body = StartTrafficRequest(protocol="tcp", Mbps=200)

    with patch.object(repo, "get_ue", return_value=state):

        # Act / Assert
        with pytest.raises(HTTPException):
            start_traffic(
                ue_id=1,
                bearer_id=5,
                body=body,
                repo=repo,
            )
