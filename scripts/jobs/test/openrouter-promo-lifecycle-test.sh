#!/bin/bash
# openrouter-promo-lifecycle-test.sh — the cloaked lane's journal-backed ledger tooling.
#
# Exercises attest → classify → recheck(auto-disable) → drop against a throwaway local
# journal (never the production remote). Asserts the re-review cadence actually DISABLES
# an id (both the stale-attestation path and the 404-rotated-away path) and that the
# rip-cord (drop) removes a row.
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

mkdir -p "$ROOT/scratch"
TR="$(mktemp -d "$ROOT/scratch/garden-promo-life.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

# --- a throwaway bare journal2 with the minimal shape the producer clone expects ----
BARE="$TR/journal.git"; SEED="$TR/seed"
git init -q --bare "$BARE"
git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
( cd "$SEED"; mkdir -p config msgs; touch config/.gitkeep msgs/.gitkeep )
git -C "$SEED" -c user.name=test -c user.email=test@localhost add -A
git -C "$SEED" -c user.name=test -c user.email=test@localhost commit -q -m seed
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin journal2

# Common env for every fleet-tool invocation below: sandboxed state + non-prod remote.
common_env=(
  GARDEN=testhost GARDEN_TEST=1
  GARDEN_STATE="$TR/state"
  GARDEN_PRODUCER_CLONE="$TR/producer/journal"
  JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2
  GARDEN_ROOT="$ROOT"
)

# read the ledger from a FRESH clone of the bare (what a worker on another host sees)
ledger_rows() {
  local v="$TR/verify.$RANDOM"
  git clone -q --single-branch --branch journal2 "$BARE" "$v" 2>/dev/null
  [ -f "$v/config/openrouter-promos" ] && grep -vE '^#' "$v/config/openrouter-promos" | grep -c . || echo 0
  rm -rf "$v"
}
ledger_has() { # <wire-id>
  local v="$TR/verify.$RANDOM" rc=1
  git clone -q --single-branch --branch journal2 "$BARE" "$v" 2>/dev/null
  [ -f "$v/config/openrouter-promos" ] && awk -F'\t' -v w="$1" '$1==w{f=1} END{exit !f}' "$v/config/openrouter-promos" && rc=0
  rm -rf "$v"; return $rc
}

echo 'ATTEST — enables an id and classification binds it'
env "${common_env[@]}" "$JOBS/openrouter-promo-attest.sh" openrouter/horizon-beta minion tester >/dev/null 2>&1 \
  && ok "attest exits 0" || bad "attest failed"
ledger_has openrouter/horizon-beta && ok "ledger carries the attested id" || bad "attested id missing from ledger"
# classification binds it when the ledger is visible
V="$TR/verify.class"; git clone -q --single-branch --branch journal2 "$BARE" "$V" 2>/dev/null
bound="$(env "${common_env[@]}" GARDEN_OPENROUTER_PROMOS_FILE="$V/config/openrouter-promos" \
  bash -c 'source "$1"; resolve_model_tier openrouter-promo openrouter-promo/openrouter/horizon-beta' _ "$JOBS/common.sh")"
[ "$bound" = "openrouter-promo/openrouter/horizon-beta" ] && ok "fresh attested id classifies (binds)" || bad "fresh id did not bind ($bound)"
rm -rf "$V"

echo 'RECHECK — a 404 (rotated-away) id is auto-disabled'
BIN="$TR/bin"; mkdir -p "$BIN"
cat > "$BIN/curl" <<'EOF'
#!/bin/bash
printf '%s' "${FAKE_OPENROUTER_STATUS:-200}"
EOF
chmod +x "$BIN/curl"
rc=0; env "${common_env[@]}" PATH="$BIN:$PATH" OPENROUTER_API_KEY=offline-fixture FAKE_OPENROUTER_STATUS=404 \
  "$JOBS/openrouter-promo-recheck.sh" >/dev/null 2>&1 || rc=$?
[ "$rc" -eq 2 ] && ok "recheck exits 2 (no LLM dispatch, preflight-gate contract)" || bad "recheck exit code ($rc)"
ledger_has openrouter/horizon-beta && bad "404 id was NOT auto-disabled" || ok "404 id auto-disabled (row dropped)"

echo 'RECHECK — a STALE attestation is auto-disabled without any network'
# write a ledger row attested 3 days ago directly, push it, then recheck with NO key.
V2="$TR/verify.stale"; git clone -q --single-branch --branch journal2 "$BARE" "$V2" 2>/dev/null
printf 'openrouter/old-ghost\tminion\t%s\ttester\n' "$(date -u -d '3 days ago' +%FT%TZ)" > "$V2/config/openrouter-promos"
git -C "$V2" -c user.name=test -c user.email=test@localhost add -A
git -C "$V2" -c user.name=test -c user.email=test@localhost commit -q -m 'stale row'
git -C "$V2" push -q origin journal2
rm -rf "$V2"
rc=0; env "${common_env[@]}" "$JOBS/openrouter-promo-recheck.sh" >/dev/null 2>&1 || rc=$?
[ "$rc" -eq 2 ] && ok "recheck (no key) exits 2" || bad "recheck-no-key exit code ($rc)"
ledger_has openrouter/old-ghost && bad "stale id was NOT auto-disabled" || ok "stale id auto-disabled with no network probe"

echo 'DROP — the per-id rip-cord removes a row'
env "${common_env[@]}" "$JOBS/openrouter-promo-attest.sh" openrouter/tmp-id minion tester >/dev/null 2>&1
ledger_has openrouter/tmp-id && ok "id present before drop" || bad "attest for drop test failed"
env "${common_env[@]}" "$JOBS/openrouter-promo-drop.sh" openrouter/tmp-id >/dev/null 2>&1 \
  && ok "drop exits 0" || bad "drop failed"
ledger_has openrouter/tmp-id && bad "drop did not remove the row" || ok "drop removed the row (rip-cord)"
env "${common_env[@]}" "$JOBS/openrouter-promo-drop.sh" openrouter/tmp-id >/dev/null 2>&1 \
  && ok "drop is idempotent (absent id is a clean no-op)" || bad "idempotent drop failed"

echo "openrouter-promo-lifecycle-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
