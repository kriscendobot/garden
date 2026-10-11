#!/bin/bash
# Hermetic coverage for the deterministic Dependabot engine-conflict closer.
set -euo pipefail
export GARDEN_TEST=1 GARDEN_API_COOLDOWN_SECS=0
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLOSE="$(cd "$HERE/../handlers" && pwd)/dependabot-engine-close-gh.sh"
TR="$(mktemp -d)"; trap 'rm -rf "$TR"' EXIT
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

cat > "$TR/gh" <<'EOF'
#!/bin/bash
printf '%s\n' "$*" >> "${GH_LOG:?}"
if [ "$1" = api ]; then
  case "$*" in
    *'/pulls/1174') printf '%s\n' '{"state":"open","user":{"login":"dependabot[bot]"},"title":"Bump better-sqlite3 from 12.4.1 to 13.0.0"}' ;;
    *'/issues/1174/comments'*) printf '%s\n' '[]' ;;
    *) exit 1 ;;
  esac
fi
if [ "$1 $2" = 'pr comment' ] && [ "${COMMENT_FAIL:-0}" = 1 ]; then
  echo 'HTTP 403: Resource not accessible by personal access token' >&2
  exit 1
fi
EOF
cat > "$TR/compat" <<'EOF'
#!/bin/bash
printf '%s\n' "${COMPAT_PROOF:?}"
EOF
cat > "$TR/journal" <<'EOF'
#!/bin/bash
printf '%s\n' "$*" > "${JOURNAL_ARGS:?}"
cp "$2" "${JOURNAL_BODY:?}"
EOF
chmod +x "$TR/gh" "$TR/compat" "$TR/journal"

proof=$'incompatible\tnode\t20.0.0\t>=20\t20.19.0 || 22.12.0 || >=23\tpackage.json'
run_close() {
  set +e
  GH_LOG="$TR/gh.log" JOURNAL_ARGS="$TR/journal.args" JOURNAL_BODY="$TR/journal.body" \
    COMPAT_PROOF="$1" GARDEN_GH="$TR/gh" GARDEN_DEPB_COMPAT="$TR/compat" \
    GARDEN_DEPB_JOURNAL_RESULT="$TR/journal" GARDEN=testhost GARDEN_STATE="$TR/state" \
    "$CLOSE" endojs/endo-but-for-bots 1174 better-sqlite3 12.4.1 13.0.0 \
      20.0.0 '>=20' '20.19.0 || 22.12.0 || >=23' package.json endo-but-for-bots
  RC=$?
  set -e
}

: > "$TR/gh.log"
run_close "$proof"
[ "$RC" -eq 0 ] && ok "exact second proof closes and records" || bad "exact proof rc=$RC"
grep -q '^pr comment 1174 -R endojs/endo-but-for-bots --body-file ' "$TR/gh.log" \
  && grep -q '^pr close 1174 -R endojs/endo-but-for-bots$' "$TR/gh.log" \
  && ok "fixed verdict precedes close" || bad "GitHub actions wrong: $(tr '\n' ';' < "$TR/gh.log")"
grep -q '^result ' "$TR/journal.args" \
  && grep -q '^dependabotany-terminal-pr: 1174$' "$TR/journal.body" \
  && grep -q 'no botanist review is dispatched' "$TR/journal.body" \
  && ok "fixed journal result carries the per-PR terminal marker" \
  || bad "journal result missing: $(cat "$TR/journal.body" 2>/dev/null || true)"

: > "$TR/gh.log"; rm -f "$TR/journal.args" "$TR/journal.body"
run_close $'incompatible\tnode\t20.0.0\t>=20\t>=22\tpackage.json'
[ "$RC" -eq 1 ] && ! grep -q '^pr ' "$TR/gh.log" && [ ! -e "$TR/journal.body" ] \
  && ok "changed proof falls back without comment, close, or result" \
  || bad "changed proof acted (rc=$RC log=$(tr '\n' ';' < "$TR/gh.log"))"

: > "$TR/gh.log"; rm -f "$TR/journal.args" "$TR/journal.body"
COMMENT_FAIL=1 run_close "$proof"
[ "$RC" -eq 0 ] && grep -q '^pr close 1174 -R endojs/endo-but-for-bots$' "$TR/gh.log" \
  && grep -q '^comment-status: failed$' "$TR/journal.body" \
  && grep -q '^close-status: closed$' "$TR/journal.body" \
  && ok "comment 403 is recorded separately and does not suppress close" \
  || bad "comment 403 blocked close or was not recorded (rc=$RC log=$(tr '\n' ';' < "$TR/gh.log"))"

echo "TOTAL: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
