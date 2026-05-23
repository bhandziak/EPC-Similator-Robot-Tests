import pytest
from fastapi import HTTPException

from epc.api import get_ue
from epc.db import EPCRepository


@pytest.fixture()
def repo(tmp_path):
    return EPCRepository(db_path=str(tmp_path / "test.db"))


def test_get_ue_function_returns_default_and_added_bearer(repo):
    repo.attach_ue(10)
    repo.add_bearer(10, 1)

    response = get_ue(ue_id=10, repo=repo)

    assert response.ue_id == 10
    assert set(response.bearers.keys()) == {1, 9}
    assert response.bearers[9].bearer_id == 9
    assert response.bearers[1].bearer_id == 1


def test_get_ue_function_after_attach_returns_only_default_bearer(repo):
    repo.attach_ue(11)

    response = get_ue(ue_id=11, repo=repo)

    assert response.ue_id == 11
    assert set(response.bearers.keys()) == {9}
    assert response.bearers[9].bearer_id == 9


def test_get_ue_function_for_unknown_ue_raises_http_exception(repo):
    with pytest.raises(HTTPException) as exc_info:
        get_ue(ue_id=99, repo=repo)

    assert exc_info.value.status_code == 400
    assert exc_info.value.detail == "UE not found"
