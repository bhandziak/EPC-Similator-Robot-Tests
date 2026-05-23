import pytest
from pydantic import ValidationError

from epc.models import StartTrafficRequest


# Test model - StartTrafficRequest.exactly_one_throughput

class TestStartTrafficRequestExactlyOneThroughput:

    def test_accepts_only_mbps(self):

        request = StartTrafficRequest(
            protocol="tcp",
            Mbps=50,
        )

        assert request.Mbps == 50

    def test_accepts_only_kbps(self):

        request = StartTrafficRequest(
            protocol="tcp",
            kbps=1000,
        )

        assert request.kbps == 1000

    def test_accepts_only_bps(self):

        request = StartTrafficRequest(
            protocol="tcp",
            bps=50000000,
        )

        assert request.bps == 50000000

    def test_rejects_missing_throughput(self):

        with pytest.raises(ValidationError):
            StartTrafficRequest(protocol="tcp")

    def test_rejects_multiple_throughput_values(self):

        with pytest.raises(ValidationError):
            StartTrafficRequest(
                protocol="tcp",
                Mbps=50,
                kbps=1000,
            )