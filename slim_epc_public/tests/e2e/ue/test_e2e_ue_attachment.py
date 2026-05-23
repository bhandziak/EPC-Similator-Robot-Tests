
class TestUeE2EAttachment:

    def test_successful_ue_attachment(self, e2e_client):
        # Given
        ue_id = 1

        # When
        # attach ue to network
        attach_payload = {"ue_id": ue_id}
        response = e2e_client.post("/ues", json=attach_payload)

        # Then
        # check if ue is attached
        assert response.status_code == 200
        json_data = response.json()
        assert json_data["status"] == "attached"
        assert json_data["ue_id"] == ue_id

        # check stats
        get_response = e2e_client.get(f"/ues/{ue_id}")
        assert get_response.status_code == 200

        # check ue existence
        ue_state = get_response.json()
        assert ue_state["ue_id"] == ue_id

        # check default bearer
        assert "9" in ue_state["bearers"]