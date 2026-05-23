import pytest
from fastapi import HTTPException
from pydantic import ValidationError
from unittest.mock import patch

from epc.api import add_bearer
from epc.models import AddBearerRequest


class TestAddBearerApi:
    def test_add_new_bearer_success(self, mock_repo):
        repo, _mock_db = mock_repo

        body = AddBearerRequest(bearer_id=5) # create a request

        with patch.object(repo, "add_bearer", return_value=None) as add_bearer_mock: # mock db fun
            resp = add_bearer(ue_id=1, body=body, repo=repo) # call an api fun (using mocked db fun)

        add_bearer_mock.assert_called_once_with(1, 5) # check if api tried to save to db
        # check if api response correct (data matching with request)
        assert resp.status == "bearer_added"
        assert resp.ue_id == 1
        assert resp.bearer_id == 5

    @pytest.mark.parametrize("bearer_id", [-1, 0, 10, 99])
    def test_add_bearer_out_of_range_400(self, mock_repo, bearer_id):
        repo, _mock_db = mock_repo

        with pytest.raises(ValidationError): # if ValidationError occurs - good
            body = AddBearerRequest(bearer_id=bearer_id) #create a request
            add_bearer(ue_id=1, body=body, repo=repo) # call an api fun

    def test_add_already_added_bearer_400(self, mock_repo):
        repo, _mock_db = mock_repo

        body = AddBearerRequest(bearer_id=5)

        # mock response from db that says that bearer already exists
        with patch.object(repo, "add_bearer", side_effect=ValueError("Bearer already exists")):
            # try to add bearer with an api fun
            with pytest.raises(HTTPException) as exc:
                add_bearer(ue_id=1, body=body, repo=repo)

        assert exc.value.status_code == 400
        assert exc.value.detail == "Bearer already exists"