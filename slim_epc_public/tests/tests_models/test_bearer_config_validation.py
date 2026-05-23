import pytest
from pydantic import ValidationError

from epc.models import BearerConfig


# Test model - BearerConfig validation

class TestBearerConfigValidation:

    @pytest.mark.parametrize("valid_id", [1, 5, 9])
    def test_accepts_valid_bearer_id(self, valid_id):

        bearer = BearerConfig(bearer_id=valid_id)

        assert bearer.bearer_id == valid_id

    def test_rejects_bearer_id_below_range(self):

        with pytest.raises(ValidationError):
            BearerConfig(bearer_id=0)
