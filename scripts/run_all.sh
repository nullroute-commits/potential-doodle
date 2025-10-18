#!/usr/bin/env bash
set -euo pipefail

# Load virtual environment
source .venv/bin/activate

# Sequential execution mirroring Makefile targets
make setup deps lint typecheck security test coverage build-docker build-podman docs

echo "✅ All steps completed successfully"
