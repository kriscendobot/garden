#!/bin/bash
# Regression coverage for scripts/secrets/watchdog.sh.
#
# Pins: an installed key whose kind has NO outbound/<kind> directory in the
# ledger clone counts as zero accepted uses — the sweep must not abort under
# `set -euo pipefail` (2026-11-13: typesafe.key installed, no outbound/typesafe)
# and must still raise the idle alert; a second sweep with an unchanged
# fingerprint (alert_maintainer_edge returns 1) must also exit cleanly.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../../.." && pwd)"
BRANCH=journal2
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1
TR="$(mktemp -d "${TMPDIR:-$HOME}/.garden-secret-watchdog-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
git_id=(-c user.name=test -c user.email=test@localhost)

bare="$TR/journal.git" seed="$TR/seed"
git init -q --bare "$bare"
git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
mkdir -p "$seed"/inbox/maintainer/{unread,read} "$seed/outbound/anthropic"
touch "$seed/inbox/maintainer/unread/.gitkeep" "$seed/inbox/maintainer/read/.gitkeep" \
  "$seed/outbound/anthropic/.gitkeep"
git -C "$seed" add -A
git -C "$seed" "${git_id[@]}" commit -q -m seed
git -C "$seed" remote add origin "$bare"
git -C "$seed" push -q -u origin "$BRANCH"

export JOURNAL_REMOTE="$bare" JOURNAL_BRANCH="$BRANCH" GARDEN=testhost
export GARDEN_STATE="$TR/state" GARDEN_SECRETS_DIR="$TR/secrets"
export GARDEN_SECRET_WATCHDOG_CLONE="$TR/state/secret-watchdog/journal"
export GARDEN_SECRET_IDLE_DAYS=30 GARDEN_FETCH_MAX_AGE_OVERRIDE=0

# Install typesafe.key (a `direct` consumer) placed 40 days ago; no outbound/typesafe.
mkdir -p "$TR/secrets"; chmod 0700 "$TR/secrets"
printf '%s' 'typesafe-watchdog-fixture-000000' > "$TR/secrets/typesafe.key"
chmod 0600 "$TR/secrets/typesafe.key"
touch -d '40 days ago' "$TR/secrets/typesafe.key"

fp="$GARDEN_STATE/alerts/secret-idle-typesafe-testhost.fingerprint"
rc=0; out="$("$ROOT/scripts/secrets/watchdog.sh" 2>&1)" || rc=$?
[ "$rc" -eq 0 ] && ok "sweep exits 0 with no outbound/typesafe directory" \
  || { bad "sweep aborted rc=$rc"; printf '%s\n' "$out" | tail -20; }
[ -d "$GARDEN_SECRET_WATCHDOG_CLONE/.git" ] && [ ! -e "$GARDEN_SECRET_WATCHDOG_CLONE/outbound/typesafe" ] \
  && ok "fixture ledger clone lacks outbound/typesafe" || bad "fixture ledger shape"
if [ -f "$fp" ] && grep -q '^none:40:direct$' "$fp"; then
  ok "missing directory counts as zero uses and raises the idle alert"
else
  bad "idle alert fingerprint: $(cat "$fp" 2>/dev/null || echo absent)"
fi

rc=0; out="$("$ROOT/scripts/secrets/watchdog.sh" 2>&1)" || rc=$?
[ "$rc" -eq 0 ] && ok "repeat sweep with an unchanged fingerprint exits 0" \
  || { bad "repeat sweep aborted rc=$rc"; printf '%s\n' "$out" | tail -20; }

printf 'secret-watchdog-test: %d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
