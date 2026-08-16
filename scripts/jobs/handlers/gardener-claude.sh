#!/bin/bash
# gardener-claude.sh — LEGACY name of the Anthropic worker handler, retained as a
# warning-free forwarding wrapper onto handlers/monk-claude.sh (design
# anthropic-worker-kind-monk.md § Shared spine and handlers).
#
# The Anthropic worker kind was renamed gardener -> monk; the real handler now lives
# in monk-claude.sh. During the staged, reversible cutover the legacy `gardener`
# registry row still points here (so an un-migrated host's garden-gardener@ pool runs
# unchanged), and a rollback can re-point at this file too. It forwards its arguments
# verbatim and exec's, so there is exactly one implementation and no behavioral drift
# between the two spellings — and no deprecation noise on the still-supported path.
#
# Invoked by gardener.sh as: gardener-claude.sh <base> <job-file> <report-out>
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$HERE/monk-claude.sh" "$@"
