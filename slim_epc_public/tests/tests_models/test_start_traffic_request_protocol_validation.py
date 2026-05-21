import pytest
from pydantic import ValidationError

from epc.models import StartTrafficRequest


# Test model - StartTrafficRequest protocol validation

class TestStartTrafficRequestProtocolValidation:

    def test_accepts_tcp_protocol(self):

        request = StartTrafficRequest(
            protocol="tcp",
            Mbps=50,
        )

        assert request.protocol == "tcp"

    def test_accepts_udp_protocol(self):

        request = StartTrafficRequest(
            protocol="udp",
            Mbps=50,
        )

        assert request.protocol == "udp"

    def test_rejects_invalid_protocol(self):

        with pytest.raises(ValidationError):
            StartTrafficRequest(
                protocol="http",
                Mbps=50,
            )