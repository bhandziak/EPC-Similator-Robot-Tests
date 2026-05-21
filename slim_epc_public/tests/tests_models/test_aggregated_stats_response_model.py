from epc.models import AggregatedStatsResponse


# Test model - AggregatedStatsResponse

class TestAggregatedStatsResponseModel:

    def test_accepts_details_dictionary(self):

        response = AggregatedStatsResponse(
            scope="ue:1",
            ue_count=1,
            bearer_count=2,
            total_tx_bps=80000000,
            total_rx_bps=80000000,
            details={
                "1": {
                    "5": 50000000,
                    "9": 30000000,
                }
            },
        )

        assert response.details["1"]["5"] == 50000000
        assert response.details["1"]["9"] == 30000000