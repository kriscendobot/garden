#!/bin/bash
# receipt-watcher-test.sh — failure-containment guards for the per-repo receipt
# watcher. All GitHub reads are stubbed and the journal is a throwaway bare repo.

set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d /home/kris/.garden-receipt-watcher.XXXXXX)"
TEST_KEEP="${GARDEN_TEST_KEEP:-0}"
trap '[ "$TEST_KEEP" = 1 ] || rm -rf "$TR"' EXIT
BRANCH=journal2
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

# Scrub ambient fleet configuration before constructing the isolated fixture.
# shellcheck disable=SC2046 # intentional variable-name expansion for unset
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

BARE="$TR/journal.git"
SEED="$TR/seed"
git init -q --bare "$BARE"
git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
mkdir -p "$SEED/jobs/todo" "$SEED/jobs/doin" "$SEED/jobs/tada" \
  "$SEED/work" "$SEED/cursors/receipts"
for slug in kriscendobot-race1 kriscendobot-race2 kriscendobot-race3 \
            kriscendobot-race4 kriscendobot-race5 kriscendobot-race6 \
            kriscendobot-source; do
  printf 'last_completed_at: 2026-09-01T00:00:00Z\n' > "$SEED/cursors/receipts/$slug"
done
touch "$SEED/jobs/todo/.gitkeep" "$SEED/jobs/doin/.gitkeep" \
  "$SEED/jobs/tada/.gitkeep" "$SEED/work/.gitkeep"
git -C "$SEED" add -A
git -C "$SEED" -c user.name=test -c user.email=test@localhost commit -q -m seed
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

STATE="$TR/state"
WATCH_CLONE="$STATE/receipt-watcher/journal"
CURSOR_CLONE="$STATE/cursors/journal"
mkdir -p "$(dirname "$WATCH_CLONE")"
git clone -q --single-branch --branch "$BRANCH" "$BARE" "$WATCH_CLONE"

mkdir -p "$TR/bin"
cat > "$TR/bin/offline-fetch" <<'EOF'
#!/bin/bash
echo 'fatal: unable to access remote: Could not resolve host: github.com' >&2
exit 128
EOF
cat > "$TR/bin/structural-fetch" <<'EOF'
#!/bin/bash
echo 'fatal: Authentication failed for journal remote' >&2
exit 128
EOF
cat > "$TR/bin/empty-source" <<'EOF'
#!/bin/bash
exit 0
EOF
cat > "$TR/bin/timeout-source" <<'EOF'
#!/bin/bash
exit 124
EOF
cat > "$TR/bin/structural-source" <<'EOF'
#!/bin/bash
echo 'jq: parse error: invalid schema returned by source' >&2
exit 2
EOF
chmod +x "$TR/bin/"*

run_watch() {  # run_watch <slug> <stderr-file> [fetch-command] [source-command]
  local slug="$1" err="$2" fetch="${3:-}" source="${4:-$TR/bin/empty-source}"
  local -a runenv=(env JOURNAL_REMOTE="$BARE" GARDEN_STATE="$STATE"
    GARDEN_RECEIPT_WATCH_CLONE="$WATCH_CLONE" GARDEN_CURSOR_CLONE="$CURSOR_CLONE"
    GARDEN_RECEIPT_PR_SOURCE="$source" GARDEN_RECEIPT_POST="$TR/bin/empty-source"
    GARDEN_FETCH_RETRIES=1 GARDEN_BACKOFF_BASE=0 GARDEN_BACKOFF_CAP=0
    GARDEN_API_COOLDOWN_SECS=120)
  [ -z "$fetch" ] || runenv+=(GARDEN_FETCH_CMD="$fetch")
  "${runenv[@]}" "$JOBS/receipt-watcher.sh" "$slug" >/dev/null 2>"$err"
}

# A fleet-wide journal outage races six independently-instantiated watchers. Every
# tick must be clean, one detector owns the warning, and one bounded marker backs the
# skip. This also proves sync_clone's internal exit(75) is contained by the watcher.
for n in 1 2 3 4 5 6; do
  ( set +e; run_watch "kriscendobot-race$n" "$TR/journal-$n.err" "$TR/bin/offline-fetch"; echo $? > "$TR/journal-$n.rc" ) &
done
wait
if [ "$(grep -hv '^0$' "$TR"/journal-*.rc | wc -l)" -eq 0 ]; then
  ok "six concurrent journal-outage ticks all exit cleanly"
else
  bad "a concurrent journal-outage tick returned nonzero"
fi
if [ "$(grep -hil 'cooling all receipt/gh-api watchers' "$TR"/journal-*.err | wc -l)" -eq 1 ]; then
  ok "one concurrent observer owns the shared outage warning"
else
  bad "shared journal outage did not emit exactly one warning"
fi
if [ -s "$STATE/gh-api-cooldown/marker" ]; then
  expiry="$(sed -n '1p' "$STATE/gh-api-cooldown/marker")"; now="$(date +%s)"
  if [ "$expiry" -gt "$now" ] && [ "$expiry" -le $((now + 120)) ]; then
    ok "journal outage opens a bounded host-wide cooldown"
  else
    bad "journal cooldown expiry is outside its bound"
  fi
else
  bad "journal outage did not create a shared cooldown marker"
fi

# Source-level wall-clock timeout is availability, even with empty stderr. It must
# skip and arm the same shared marker rather than becoming a systemd failure.
rm -f "$STATE/gh-api-cooldown/marker"
if run_watch kriscendobot-source "$TR/timeout.err" "" "$TR/bin/timeout-source"; then
  ok "source timeout exits as a skipped tick"
else
  bad "source timeout escaped as a failure"
fi
grep -q 'receipt PR source unavailable (transient, rc=124)' "$TR/timeout.err" \
  && [ -s "$STATE/gh-api-cooldown/marker" ] \
  && ok "source timeout emits one useful warning and opens the shared cooldown" \
  || bad "source timeout warning/cooldown missing"

# Persistent structural failures remain failures and retain the underlying stderr,
# so cooldown containment cannot hide broken credentials or a malformed source.
rm -f "$STATE/gh-api-cooldown/marker"
if run_watch kriscendobot-source "$TR/struct-source.err" "" "$TR/bin/structural-source"; then
  bad "structural source failure was swallowed"
else
  grep -q 'source: jq: parse error: invalid schema returned by source' "$TR/struct-source.err" \
    && grep -q 'FATAL: receipt PR source failed' "$TR/struct-source.err" \
    && ok "structural source failure stays loud with its diagnostic" \
    || bad "structural source failure lost its diagnostic"
fi

rm -f "$STATE/gh-api-cooldown/marker"
if run_watch kriscendobot-source "$TR/struct-journal.err" "$TR/bin/structural-fetch"; then
  bad "structural journal failure was swallowed"
else
  grep -q 'prerequisite:.*Authentication failed for journal remote' "$TR/struct-journal.err" \
    && grep -q 'FATAL: receipt journal prerequisite failed' "$TR/struct-journal.err" \
    && ok "structural journal failure stays loud with its diagnostic" \
    || bad "structural journal failure lost its diagnostic"
fi

echo "TOTAL: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
