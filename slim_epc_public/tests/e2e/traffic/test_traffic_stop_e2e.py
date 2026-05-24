import time


class TestTrafficStopE2E:
    import time

    def test_traffic_stop_for_single_bearer_e2e(self, e2e_client):
        # Given
        ue_id = 1
        bearer_id = 5

        e2e_client.post("/ues", json={"ue_id": ue_id})
        e2e_client.post(f"/ues/{ue_id}/bearers", json={"bearer_id": bearer_id})

        # When
        # start traffic
        start_payload = {"protocol": "tcp", "Mbps": 10}
        start_resp = e2e_client.post(f"/ues/{ue_id}/bearers/{bearer_id}/traffic", json=start_payload)
        assert start_resp.status_code == 200

        # wait 1 sek for traffic transfer
        time.sleep(1)

        # stop traffic
        stop_resp = e2e_client.delete(f"/ues/{ue_id}/bearers/{bearer_id}/traffic")
        assert stop_resp.status_code == 200

        # Then
        stats_resp = e2e_client.get(f"/ues/{ue_id}/bearers/{bearer_id}/traffic")
        assert stats_resp.status_code == 200

        data = stats_resp.json()

        assert data["duration"] > 0.0

        assert data["tx_bps"] == 0
        assert data["rx_bps"] == 0