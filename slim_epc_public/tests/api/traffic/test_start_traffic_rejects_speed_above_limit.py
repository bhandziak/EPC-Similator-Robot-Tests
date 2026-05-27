import pytest
from unittest.mock import patch
from fastapi import HTTPException
from pydantic import ValidationError

from epc.api import start_traffic
from epc.models import BearerConfig, StartTrafficRequest, UEState

def test_start_traffic_rejects_speed_above_limit(mock_repo):

    with pytest.raises(ValidationError) as exc_info:
        StartTrafficRequest(protocol="tcp", Mbps=200)

    assert "Mbps" in str(exc_info.value)
