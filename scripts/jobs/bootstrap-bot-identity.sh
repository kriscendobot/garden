#!/bin/bash
# bootstrap-bot-identity.sh — idempotently restore the fleet's BOT git identity on
# the garden repo's LOCAL .git/config (user.name / user.email), so a reset / fresh
# checkout / container recreation re-applies it with NO manual `git config` step.
#
# The local config is not tracked and not baked into the image (the bind mount
# masks it), so it is the one identity input a reset loses. This script rebuilds it
# from records a reset cannot lose, in precedence order:
#   1. the PER-HOST journal override  (identity/<host> on journal2, best-effort —
#      set by scripts/jobs/set-bot-identity.sh); then
#   2. the TRACKED canonical default  (bot-identity-defaults.tsv, keyed on
#      GARDEN_BOT_LOGIN) — always present in a fresh checkout.
# It writes only when the local config is MISSING or DIFFERENT (a no-op otherwise),
# and NEVER blocks bring-up: an unreachable journal simply falls back to (2).
#
# Wiring: the container entrypoint runs it at every container start (with
# GARDEN_BOOTSTRAP_SKIP_JOURNAL=1 — root must not write bot-owned journal state and
# the clone may be absent that early, so only the tracked default is applied), and
# the starting procedure re-runs it as the bot user once the journal is reachable
# so a per-host override lands. Safe to run by hand anytime.
#
# Env:
#   GARDEN_BOOTSTRAP_SKIP_JOURNAL=1  apply only the tracked default (no journal read)
#
# See common.sh (bot_name/bot_email + bot_default_*), CLAUDE.md § Host environment.

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="bootstrap-bot-identity"

name="" email=""

# Best-effort per-host override from the journal. A subshell CONTAINS any `die`
# ensure_clone/sync_clone may raise (network down on a fresh host), so a missing
# journal can never abort the bootstrap — we just fall back to the tracked default.
if [ "${GARDEN_BOOTSTRAP_SKIP_JOURNAL:-0}" != 1 ]; then
  DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
  if ( ensure_clone "$DIR" >/dev/null 2>&1 && sync_clone "$DIR" >/dev/null 2>&1 ); then
    name="$(journal_bot_identity_field "$DIR" bot_name)"
    email="$(journal_bot_identity_field "$DIR" bot_email)"
    [ -n "$name$email" ] && log "per-host override for $GARDEN: name='${name:-}' email='${email:-}'"
  else
    log "journal override unavailable for $GARDEN; using tracked canonical default"
  fi
fi

[ -n "$name" ]  || name="$(bot_default_name)"
[ -n "$email" ] || email="$(bot_default_email)"

changed=0
cur_name="$(git -C "$GARDEN_ROOT" config --get user.name  2>/dev/null || true)"
cur_email="$(git -C "$GARDEN_ROOT" config --get user.email 2>/dev/null || true)"
if [ "$cur_name" != "$name" ]; then
  git -C "$GARDEN_ROOT" config user.name "$name" || die "could not set user.name on $GARDEN_ROOT"
  changed=1
fi
if [ "$cur_email" != "$email" ]; then
  git -C "$GARDEN_ROOT" config user.email "$email" || die "could not set user.email on $GARDEN_ROOT"
  changed=1
fi

if [ "$changed" = 1 ]; then
  log "bot identity restored on $GARDEN_ROOT: $name <$email>"
else
  log "bot identity already correct on $GARDEN_ROOT: $name <$email>"
fi
