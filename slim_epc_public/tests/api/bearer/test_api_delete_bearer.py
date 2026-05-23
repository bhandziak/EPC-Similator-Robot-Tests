import pytest
from fastapi import HTTPException

from epc.api import delete_bearer
from epc.db import EPCRepository
from epc.models import ThroughputStats


@pytest.fixture()
def repo(tmp_path):
    return EPCRepository(db_path=str(tmp_path / "test.db"))


def test_delete_bearer_function_returns_success_and_removes_bearer(repo):
    repo.attach_ue(20)
    repo.add_bearer(20, 2)

    response = delete_bearer(ue_id=20, bearer_id=2, repo=repo)

    assert response.status == "bearer_deleted"
    assert response.ue_id == 20
    assert response.bearer_id == 2

    state = repo.get_ue(20)
    assert 2 not in state.bearers
    assert 9 in state.bearers


def test_delete_bearer_function_removes_related_stats(repo):
    repo.attach_ue(21)
    repo.add_bearer(21, 3)
    repo.update_stats(21, ThroughputStats(ue_id=21, bearer_id=3, bytes_tx=100, bytes_rx=200))

    response = delete_bearer(ue_id=21, bearer_id=3, repo=repo)

    assert response.status == "bearer_deleted"
    state = repo.get_ue(21)
    assert 3 not in state.bearers
    assert 3 not in state.stats


def test_delete_bearer_function_for_unknown_ue_raises_http_exception(repo):
    with pytest.raises(HTTPException) as exc_info:
        delete_bearer(ue_id=98, bearer_id=2, repo=repo)

    assert exc_info.value.status_code == 400
    assert exc_info.value.detail == "UE not found"


def test_delete_bearer_function_for_not_active_bearer_raises_http_exception(repo):
    repo.attach_ue(22)

    with pytest.raises(HTTPException) as exc_info:
        delete_bearer(ue_id=22, bearer_id=3, repo=repo)

    assert exc_info.value.status_code == 400
    assert exc_info.value.detail == "Bearer not found"


def test_delete_bearer_function_for_default_bearer_raises_http_exception(repo):
    repo.attach_ue(23)

    with pytest.raises(HTTPException) as exc_info:
        delete_bearer(ue_id=23, bearer_id=9, repo=repo)

    assert exc_info.value.status_code == 400
    assert exc_info.value.detail == "Cannot remove default bearer"


def test_delete_bearer_function_for_out_of_range_bearer_raises_http_exception(repo):
    repo.attach_ue(24)

    with pytest.raises(HTTPException) as exc_info:
        delete_bearer(ue_id=24, bearer_id=10, repo=repo)

    assert exc_info.value.status_code == 400
    assert exc_info.value.detail == "Bearer not found"
