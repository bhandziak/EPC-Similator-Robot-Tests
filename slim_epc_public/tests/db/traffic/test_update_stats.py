from epc.db import EPCRepository
from epc.models import ThroughputStats


# Test method - EPCRepository.update_stats

class TestUpdateStats:

    def test_updates_existing_stats(self, tmp_path):

        # Arrange
        db_path = tmp_path / "test.db"
        repo = EPCRepository(db_path=str(db_path))

        repo.attach_ue(1)

        stats = ThroughputStats(
            bearer_id=9,
            ue_id=1,
            bytes_tx=6250000,
            bytes_rx=6250000,
            protocol="tcp",
            target_bps=50000000,
        )

        # Act
        repo.update_stats(1, stats)

        # Assert
        state = repo.get_ue(1)

        assert state.stats[9].bytes_tx == 6250000
        assert state.stats[9].bytes_rx == 6250000
