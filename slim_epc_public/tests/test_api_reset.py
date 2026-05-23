import pytest

from epc.api import reset_all
from epc.db import EPCRepository


@pytest.fixture()
def repo(tmp_path):
    return EPCRepository(db_path=str(tmp_path / "test.db"))


def test_reset_all_function_returns_status_and_removes_all_ues(repo):
    repo.attach_ue(30)
    repo.attach_ue(31)
    repo.add_bearer(30, 1)

    response = reset_all(repo=repo)

    assert response.status == "reset"
    assert list(repo.list_ues()) == []


def test_reset_all_function_on_empty_repository_is_safe(repo):
    response = reset_all(repo=repo)

    assert response.status == "reset"
    assert list(repo.list_ues()) == []
