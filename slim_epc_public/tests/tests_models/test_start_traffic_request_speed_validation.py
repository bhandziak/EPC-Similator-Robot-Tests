import pytest

from pydantic import ValidationError

from epc.models import StartTrafficRequest


# Test model - StartTrafficRequest speed validation

class TestStartTrafficRequestSpeedValidation:

    def test_rejects_speed_above_100_mbps(self):

        # Arrange / Act / Assert
        with pytest.raises(ValidationError):
            StartTrafficRequest(
                protocol="tcp",
                Mbps=200,
            )

    def test_rejects_negative_speed(self):

        # Arrange / Act / Assert
        with pytest.raises(ValidationError):
            StartTrafficRequest(
                protocol="tcp",
                Mbps=-10,
            )