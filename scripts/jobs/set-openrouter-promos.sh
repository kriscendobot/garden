#!/bin/bash
# set-openrouter-promos.sh: declare a host's explicit OpenRouter-promo worker count.
#
# Usage: set-openrouter-promos.sh <N> [host]
#
# The openrouter-promo lane is the deliberately-admitted rotating cloaked ("stealth")
# OpenRouter lane (designs/openrouter-provider.md § the stealth/promotional lane). Like
# the stable `openrouter` lane it is disabled by default and accepts only explicit
# `model: openrouter-promo/<wire-id>` jobs (or a `provider: openrouter-promo` canary),
# and its selectable ids are journal-backed + cadence-gated: a stealth id with no fresh
# attestation fails closed regardless of this count.
#
# THE RIP-CORD. `set-openrouter-promos.sh 0` is HALF the rip-cord — it zeroes the pool
# so no worker runs a cloaked model. The OTHER half drops the specific id's row so it
# can never be re-dispatched even at pool>0:
#     openrouter-promo-drop.sh <wire-id>
# See context/operations/openrouter.md § Rip-cord.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$HERE/set-workers.sh" openrouter-promo "$@"
