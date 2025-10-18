"""
Basic test to ensure the test infrastructure is working.

This file can be removed once actual tests are added.
"""


def test_basic():
    """Test that basic Python operations work."""
    assert 1 + 1 == 2


def test_string_operations():
    """Test basic string operations."""
    assert "hello".upper() == "HELLO"
    assert "WORLD".lower() == "world"


def test_list_operations():
    """Test basic list operations."""
    test_list = [1, 2, 3]
    assert len(test_list) == 3
    assert test_list[0] == 1
