"""
Test configuration for pytest.

This file is automatically loaded by pytest and can be used to define
fixtures, hooks, and configuration for the test suite.
"""

import os
import sys

# Add the src directory to the Python path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src")))
