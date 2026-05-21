from epc.db import EPCRepository
from epc.models import BearerConfig


# Test method - EPCRepository.update_bearer

class TestUpdateBearer:

    def test_updates_existing_bearer_configuration(self, tmp_path):

        # Arrange
        db_path = tmp_path / "test.db"
        repo = EPCRepository(db_path=str(db_path))

        repo.attach_ue(1)

        bearer = BearerConfig(
            bearer_id=9,
            protocol="tcp",
            target_bps=50000000,
            active=True,
        )

        # Act
        repo.update_bearer(1, bearer)

        # Assert
        state = repo.get_ue(1)

        assert state.bearers[9].protocol == "tcp"
        assert state.bearers[9].target_bps == 50000000
        assert state.bearers[9].active is True

    def test_saves_updated_bearer_state(self, tmp_path):

        # Arrange
        db_path = tmp_path / "test.db"
        repo = EPCRepository(db_path=str(db_path))

        repo.attach_ue(1)

        bearer = BearerConfig(
            bearer_id=9,
            protocol="udp",
            target_bps=30000000,
            active=True,
        )

        # Act
        repo.update_bearer(1, bearer)

        # Assert
        updated_state = repo.get_ue(1)

        assert updated_state.bearers[9].protocol == "udp"
        assert updated_state.bearers[9].target_bps == 30000000