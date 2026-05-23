from epc.db import EPCRepository


def test_reset_all_removes_all_ues(tmp_path):
    repo = EPCRepository(db_path=str(tmp_path / "test.db"))
    repo.attach_ue(30)
    repo.attach_ue(31)
    repo.add_bearer(30, 1)

    repo.reset_all()

    assert list(repo.list_ues()) == []


def test_reset_all_on_empty_repository_is_safe(tmp_path):
    repo = EPCRepository(db_path=str(tmp_path / "test.db"))

    repo.reset_all()

    assert list(repo.list_ues()) == []
