#!/bin/bash
# dep-base-ci-gh-test.sh — exercise the exact-rollup attribution handler without GitHub.
set -euo pipefail
export GARDEN_TEST=1 GARDEN_API_COOLDOWN_SECS=0
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HANDLER="$HERE/../handlers/dep-base-ci-gh.sh"
TR="$(mktemp -d)"
trap 'rm -rf "$TR"' EXIT
PASS=0; FAIL=0
ok() { echo "PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "FAIL: $*"; FAIL=$((FAIL+1)); }

BASE=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
HEAD=bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
GH="$TR/gh"
cat > "$GH" <<'EOF'
#!/bin/bash
case " $* " in
  *'pullRequest(number:'*) cat "$PR_JSON" ;;
  *'object(oid:'*) cat "$BASE_JSON" ;;
  *) echo "unexpected gh invocation: $*" >&2; exit 2 ;;
esac
EOF
chmod +x "$GH"

write_pr() { # write_pr <has-next> <nodes-json>
  printf '{"data":{"repository":{"pullRequest":{"state":"OPEN","baseRefOid":"%s","headRefOid":"%s","statusCheckRollup":{"contexts":{"nodes":%s,"pageInfo":{"hasNextPage":%s}}}}}}}\n' \
    "$BASE" "$HEAD" "$2" "$1" > "$TR/pr.json"
}
write_base() { # write_base <oid> <has-next> <nodes-json>
  printf '{"data":{"repository":{"object":{"__typename":"Commit","oid":"%s","statusCheckRollup":{"contexts":{"nodes":%s,"pageInfo":{"hasNextPage":%s}}}}}}}\n' \
    "$1" "$3" "$2" > "$TR/base.json"
}
run_handler() {
  GARDEN_GH="$GH" PR_JSON="$TR/pr.json" BASE_JSON="$TR/base.json" \
    "$HANDLER" owner/repo 7
}

# CheckRun and StatusContext identities are type-prefixed, deduplicated, and all
# PR failures are found on the base.
write_pr false '[{"__typename":"CheckRun","name":"build","status":"COMPLETED","conclusion":"FAILURE"},{"__typename":"CheckRun","name":"build","status":"COMPLETED","conclusion":"FAILURE"},{"__typename":"StatusContext","context":"build","state":"ERROR"}]'
write_base "$BASE" false '[{"__typename":"CheckRun","name":"build","status":"COMPLETED","conclusion":"TIMED_OUT"},{"__typename":"StatusContext","context":"build","state":"FAILURE"},{"__typename":"CheckRun","name":"lint","status":"COMPLETED","conclusion":"FAILURE"}]'
out="$(run_handler)"
[ "$out" = $'shared\t'$BASE$'\t'$HEAD$'\t2\t3\t2\t1' ] \
  && ok "exact typed identities yield an all-shared proof" \
  || bad "unexpected all-shared output: $out"

# A PR-only failure keeps the proof useful but marks it partial.
write_pr false '[{"__typename":"CheckRun","name":"build","status":"COMPLETED","conclusion":"FAILURE"},{"__typename":"CheckRun","name":"pr-only","status":"COMPLETED","conclusion":"FAILURE"}]'
write_base "$BASE" false '[{"__typename":"CheckRun","name":"build","status":"COMPLETED","conclusion":"FAILURE"}]'
out="$(run_handler)"
[ "$out" = $'shared\t'$BASE$'\t'$HEAD$'\t2\t1\t1\t0' ] \
  && ok "partial overlap is distinguished from all-shared" \
  || bad "unexpected partial output: $out"

# No overlap and truncated rollups must both fail open without a claim.
write_pr false '[{"__typename":"CheckRun","name":"pr-only","status":"COMPLETED","conclusion":"FAILURE"}]'
set +e; run_handler >/dev/null; rc=$?; set -e
[ "$rc" -ne 0 ] && ok "no overlap returns no proof" || bad "no overlap returned success"
write_pr true '[{"__typename":"CheckRun","name":"build","status":"COMPLETED","conclusion":"FAILURE"}]'
set +e; run_handler >/dev/null; rc=$?; set -e
[ "$rc" -ne 0 ] && ok "a rollup beyond the 100-context bound fails open" || bad "truncated rollup returned success"

echo "TOTAL: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
