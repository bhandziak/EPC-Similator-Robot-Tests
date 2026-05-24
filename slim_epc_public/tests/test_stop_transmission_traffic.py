import pytest

from epc.models import BearerConfig
from epc.traffic import TrafficGeneratorManager


class TestTrafficStop:
    def test_stop_transmission_for_one_ue(self, mock_repo):
        repo, _mock_db = mock_repo
        tm = TrafficGeneratorManager(repo)

        bearer = BearerConfig(bearer_id=5, protocol="tcp", target_bps=1_000_000, active=True)

        tm.start(ue_id=1, bearer=bearer)
        assert tm.is_running(1, 5)

        tm.stop(ue_id=1, bearer_id=5)
        assert not tm.is_running(1, 5)

    def test_stop_transmission_for_all_ues(self, mock_repo):
        repo, _mock_db = mock_repo
        tm = TrafficGeneratorManager(repo)

        tm.start(ue_id=1, bearer=BearerConfig(bearer_id=5, protocol="tcp", target_bps=1_000_000, active=True))
        tm.start(ue_id=2, bearer=BearerConfig(bearer_id=6, protocol="tcp", target_bps=2_000_000, active=True))

        assert tm.is_running(1, 5)
        assert tm.is_running(2, 6)

        tm.stop_all()

        assert not tm.is_running(1, 5)
        assert not tm.is_running(2, 6)
