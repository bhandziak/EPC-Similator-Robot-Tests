import pytest

from epc.db import EPCRepository
from epc.models import ThroughputStats


def test_delete_bearer_removes_bearer_and_related_stats(tmp_path):
    repo = EPCRepository(db_path=str(tmp_path / "test.db"))
    repo.attach_ue(20)
    repo.add_bearer(20, 2)
    repo.update_stats(20, ThroughputStats(ue_id=20, bearer_id=2, bytes_tx=100))

    repo.delete_bearer(20, 2)

    state = repo.get_ue(20)
    assert 2 not in state.bearers
    assert 2 not in state.stats
    assert 9 in state.bearers


def test_delete_default_bearer_is_rejected(tmp_path):
    repo = EPCRepository(db_path=str(tmp_path / "test.db"))
    repo.attach_ue(21)

    with pytest.raises(ValueError, match="Cannot remove default bearer"):
        repo.delete_bearer(21, 9)


def test_delete_missing_bearer_is_rejected(tmp_path):
    repo = EPCRepository(db_path=str(tmp_path / "test.db"))
    repo.attach_ue(22)

    with pytest.raises(ValueError, match="Bearer not found"):
        repo.delete_bearer(22, 3)


def test_delete_out_of_range_bearer_is_rejected_as_missing(tmp_path):
    repo = EPCRepository(db_path=str(tmp_path / "test.db"))
    repo.attach_ue(23)

    with pytest.raises(ValueError, match="Bearer not found"):
        repo.delete_bearer(23, 10)
