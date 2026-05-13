from unittest.mock import patch

# Test method - attach_ue
def test_attach_ue_calls_insert(mock_repo):
    repo, mock_db = mock_repo

    with patch.object(repo, 'ue_exists', return_value=False):
        repo.attach_ue(42)

    assert mock_db.execute.called
    args, _ = mock_db.execute.call_args
    assert "INSERT INTO ue_state" in args[0]
    assert args[1][0] == 42