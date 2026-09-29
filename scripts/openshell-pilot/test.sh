#!/usr/bin/env bash
# Safe to run inside the garden container: inert fixtures and mocked processes.
set -euo pipefail
script_directory=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
PYTHONDONTWRITEBYTECODE=1 python3 "$script_directory/test_pilot.py"
shellcheck "$script_directory/../openshell-pilot.sh" "$script_directory/test.sh"
