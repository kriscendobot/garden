#!/bin/bash
# set-mystics.sh — declare a host's bounded official-Kimi-Code worker count.
# Mystic workers claim only explicit `model: kimi-k3` jobs, so a nonzero count
# never makes Moonshot/Kimi a default route for another role.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$HERE/set-workers.sh" mystic "$@"
