#!/usr/bin/env bash
# Host-only pilot. --dry-run is a read-only plan, never a guard override.
set -euo pipefail
script_directory=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
exec python3 "$script_directory/openshell-pilot/pilot.py" "$@"
