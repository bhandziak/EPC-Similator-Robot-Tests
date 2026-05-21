from epc.models import TrafficStatsResponse


# Test model - TrafficStatsResponse

class TestTrafficStatsResponseModel:

    def test_creates_valid_traffic_stats_response(self):

        response = TrafficStatsResponse(
            ue_id=1,
            bearer_id=9,
            protocol="tcp",
            target_bps=50000000,
            tx_bps=50000000,
            rx_bps=50000000,
            duration=1.0,
        )

        assert response.ue_id == 1
        assert response.bearer_id == 9
        assert response.protocol == "tcp"
        assert response.target_bps == 50000000
