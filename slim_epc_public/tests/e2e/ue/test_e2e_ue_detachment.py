

class TestE2EUeDetachment:

    def test_double_detachment_of_the_same_ue(self, e2e_client):
        # Given
        ue_id = 1

        # Attach UE
        attach_response = e2e_client.post("/ues", json={"ue_id": ue_id})
        assert attach_response.status_code == 200

        # First detachemt
        first_delete_response = e2e_client.delete(f"/ues/{ue_id}")

        # check detachment
        assert first_delete_response.status_code == 200
        assert first_delete_response.json()["status"] == "detached"

        get_response = e2e_client.get(f"/ues/{ue_id}")
        assert get_response.status_code == 400

        # When
        # Second detachment
        second_delete_response = e2e_client.delete(f"/ues/{ue_id}")

        # Then
        # check 2. detachment
        assert second_delete_response.status_code == 400
        assert second_delete_response.json()["detail"] == "UE not found"