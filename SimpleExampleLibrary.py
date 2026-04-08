"""Tiny Robot Framework library for a beginner example."""


class SimpleExampleLibrary:
    """Counter starts at 0; ROBOT_LIBRARY_SCOPE=TEST gives a new instance per test case."""

    ROBOT_LIBRARY_SCOPE = "TEST"

    def __init__(self) -> None:
        self._value = 0

    def reset_counter(self) -> None:
        """Set the internal counter back to zero."""
        self._value = 0

    def add_five_to_counter(self) -> None:
        """Increase the counter by five."""
        self._value += 5

    def get_counter_value(self) -> int:
        """Return the current counter so the test can verify with BuiltIn keywords."""
        return self._value
