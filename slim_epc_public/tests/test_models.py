import pytest
from pydantic import ValidationError

from epc.models import UEState


# Test model - UESTATE
class TestUEStateModel:

    @pytest.mark.parametrize("valid_id", [1, 2, 99, 100])
    def test_ue_state_accepts_valid_boundaries(self, valid_id):
        ue = UEState(ue_id=valid_id)
        assert ue.ue_id == valid_id

    @pytest.mark.parametrize("invalid_id", [-1, 0, 101])
    def test_ue_state_rejects_out_of_bounds(self, invalid_id):
        with pytest.raises(ValidationError):
            UEState(ue_id=invalid_id)

    def test_ue_state_rejects_non_numeric_string(self):
        with pytest.raises(ValidationError):
            UEState(ue_id="string")

    def test_ue_state_initializes_empty_dicts(self):
        ue = UEState(ue_id=10)
        assert ue.bearers == {}
        assert ue.stats == {}