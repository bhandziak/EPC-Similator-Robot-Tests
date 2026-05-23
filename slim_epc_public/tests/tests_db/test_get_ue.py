import pytest

from epc.db import EPCRepository
from epc.models import UEState


# Test method - EPCRepository.get_ue

class TestGetUE:

    def test_raises_error_for_missing_ue(self, tmp_path):

        # Arrange
        db_path = tmp_path / "test.db"
        repo = EPCRepository(db_path=str(db_path))

        # Act / Assert
        with pytest.raises(ValueError, match="UE not found"):
            repo.get_ue(999)