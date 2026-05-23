from epc.db import EPCRepository


def test_get_ue_returns_current_bearers_after_attach_and_add(tmp_path):
    repo = EPCRepository(db_path=str(tmp_path / "test.db"))

    repo.attach_ue(10)
    repo.add_bearer(10, 1)

    state = repo.get_ue(10)
    assert set(state.bearers.keys()) == {1, 9}
    assert state.bearers[9].bearer_id == 9
    assert state.bearers[1].bearer_id == 1


def test_get_ue_after_attach_contains_only_default_bearer(tmp_path):
    repo = EPCRepository(db_path=str(tmp_path / "test.db"))

    repo.attach_ue(11)

    state = repo.get_ue(11)
    assert list(state.bearers.keys()) == [9]
