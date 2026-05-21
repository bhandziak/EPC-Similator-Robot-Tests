from epc.models import StartTrafficRequest


# Test model - StartTrafficRequest.target_bps

class TestStartTrafficRequestTargetBps:

    def test_converts_mbps_to_bps(self):

        request = StartTrafficRequest(
            protocol="tcp",
            Mbps=50,
        )

        assert request.target_bps() == 50000000

    def test_converts_kbps_to_bps(self):

        request = StartTrafficRequest(
            protocol="tcp",
            kbps=1000,
        )

        assert request.target_bps() == 1000000

    def test_returns_bps_without_conversion(self):

        request = StartTrafficRequest(
            protocol="tcp",
            bps=50000000,
        )

        assert request.target_bps() == 50000000