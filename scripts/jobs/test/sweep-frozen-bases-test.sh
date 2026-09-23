#!/bin/bash
# sweep-frozen-bases-test.sh — the close-time frozen-base sweep and its race
# repair (kriscendobot/minion.town#114, 2026-09-23: a sweep deleted the shared
# `main-8e9f2be` eight seconds after a new PR opened on it; GitHub auto-closed
# the PR with `base_ref_deleted`).
#
# Under test (deterministic, NO network — a stateful fake gh):
#   * an unused pinned base from the PR's history + current base is deleted.
#   * a base still used by another OPEN PR is retained (authoritative REST list,
#     not the lagging search index).
#   * a floating trunk is never a candidate, even when it appears in history.
#   * a base that is the head of an open PR is retained.
#   * THE RACE: a PR that lands on the base between the check and the delete is
#     auto-closed by the delete; the sweep re-creates the ref at the captured
#     SHA and reopens the PR.
#   * a failed restore exits 1 (surface), never silently 0.
#   * --dry-run deletes nothing.
#   * an unreadable PR is INCONCLUSIVE (4) and deletes nothing.

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
SWEEP="$JOBS/gardening/sweep-frozen-bases.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1 GARDEN_SWEEP_SETTLE_SECONDS=0

# /tmp is noexec in the container; executable stubs live under $HOME.
TR="$(mktemp -d "$HOME/.garden-sweep-test.XXXXXX")"
trap '[ "$FAIL" -eq 0 ] && rm -rf "$TR"' EXIT

# The fake gh. State in $S: refs/<name> (sha), prs.json (the PR table),
# events.json (the swept PR's issue events), race/<ref> (a PR number that
# appears on <ref> just before the delete and is auto-closed BY the delete),
# fail-post (make ref creation fail). Every mutating call is appended to calls.
cat >"$TR/gh" <<'STUB'
#!/bin/bash
S="$GH_STATE"
[ "$1" = api ] || exit 1; shift
method=GET; jqf=""; paginate=0; slurp=0; fields=()
while [ "$#" -gt 0 ]; do
  case "$1" in
    -X) method="$2"; shift 2 ;;
    --jq) jqf="$2"; shift 2 ;;
    --paginate) paginate=1; shift ;;
    --slurp) slurp=1; shift ;;
    -f) fields+=("$2"); shift 2 ;;
    *) path="$1"; shift ;;
  esac
done
[ -f "$S/fail-all" ] && exit 1
now="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
emit() { local j="$1"; [ "$slurp" = 1 ] && j="[$j]"; if [ -n "$jqf" ]; then printf '%s' "$j" | jq -r "$jqf"; else printf '%s\n' "$j"; fi; }
q() { printf '%s' "$path" | sed -n "s/.*[?&]$1=\([^&]*\).*/\1/p"; }
case "$method $path" in
  "GET repos/"*/pulls/[0-9]*)
    n="${path##*/}"; emit "$(jq -c --argjson n "$n" '.[] | select(.number==$n) | {number, state, base:{ref:.base}}' "$S/prs.json")" ;;
  "GET repos/"*/issues/*/events)
    emit "$(cat "$S/events.json")" ;;
  "GET repos/"*/git/ref/heads/*)
    r="${path#*git/ref/heads/}"; [ -f "$S/refs/$r" ] || { echo '{"message":"Not Found"}' >&2; exit 1; }
    emit "{\"object\":{\"sha\":\"$(cat "$S/refs/$r")\"}}" ;;
  "GET repos/"*/pulls\?*)
    st="$(q state)"; b="$(q base)"; h="$(q head)"; h="${h#*:}"
    emit "$(jq -c --arg st "$st" --arg b "$b" --arg h "$h" \
      '[.[] | select($st=="all" or .state==$st) | select($b=="" or .base==$b) | select($h=="" or .head==$h)]' "$S/prs.json")" ;;
  "DELETE repos/"*/git/refs/heads/*)
    r="${path#*git/refs/heads/}"; echo "DELETE $r" >>"$S/calls"; rm -f "$S/refs/$r"
    if [ -f "$S/race/$r" ]; then  # the new PR GitHub auto-closes on base_ref_deleted
      jq --argjson n "$(cat "$S/race/$r")" --arg b "$r" --arg t "$now" \
        '. + [{number:$n, base:$b, head:"feat", state:"closed", merged_at:null, closed_at:$t}]' \
        "$S/prs.json" >"$S/p" && mv "$S/p" "$S/prs.json"
    fi ;;
  "POST repos/"*/git/refs)
    [ -f "$S/fail-post" ] && exit 1
    ref=""; sha=""; for f in "${fields[@]}"; do case "$f" in ref=*) ref="${f#ref=refs/heads/}";; sha=*) sha="${f#sha=}";; esac; done
    echo "POST $ref $sha" >>"$S/calls"; printf '%s' "$sha" >"$S/refs/$ref" ;;
  "PATCH repos/"*/pulls/*)
    n="${path##*/}"; echo "REOPEN $n" >>"$S/calls"
    jq --argjson n "$n" 'map(if .number==$n then .state="open" | .closed_at=null else . end)' \
      "$S/prs.json" >"$S/p" && mv "$S/p" "$S/prs.json" ;;
  *) echo "stub: unhandled $method $path" >&2; exit 1 ;;
esac
STUB
chmod +x "$TR/gh"
export GARDEN_GH="$TR/gh"

fresh() {  # fresh <name> — new state dir; swept PR #10 closed on main-aaaaaaa, history main-bbbbbbb + main
  S="$TR/$1"; mkdir -p "$S/refs" "$S/race"; : >"$S/calls"; export GH_STATE="$S"
  printf 'aaaaaaa1' >"$S/refs/main-aaaaaaa"
  printf 'bbbbbbb1' >"$S/refs/main-bbbbbbb"
  printf 'ffffff01' >"$S/refs/main"
  echo '[{"number":10,"base":"main-aaaaaaa","head":"feat10","state":"closed","merged_at":"2026-09-23T00:00:00Z","closed_at":"2026-09-23T00:00:00Z"}]' >"$S/prs.json"
  echo '[{"event":"base_ref_changed","base_ref":"main-bbbbbbb"},{"event":"base_ref_changed","base_ref":"main"},{"event":"labeled"}]' >"$S/events.json"
}
addpr() { jq --argjson n "$1" --arg b "$2" --arg h "${3:-x$1}" '. + [{number:$n, base:$b, head:$h, state:"open", merged_at:null, closed_at:null}]' "$S/prs.json" >"$S/p" && mv "$S/p" "$S/prs.json"; }
run() { out="$(bash "$SWEEP" "$@" 2>&1)"; rc=$?; }

hr; echo "STATIC"; hr
bash -n "$SWEEP" && ok "parses" || bad "syntax error"

hr; echo "PLAIN SWEEP — unused pinned bases go, trunk never a candidate"; hr
fresh plain; run o/r 10
[ "$rc" = 0 ] && ok "rc 0" || bad "rc $rc: $out"
grep -qx "DELETE main-aaaaaaa" "$S/calls" && ok "current base deleted" || bad "current base not deleted"
grep -qx "DELETE main-bbbbbbb" "$S/calls" && ok "historical base deleted" || bad "historical base not deleted"
grep -q "DELETE main$" "$S/calls" && bad "live trunk deleted!" || ok "live trunk untouched"
[ -f "$S/refs/main" ] && ok "trunk ref present" || bad "trunk ref gone"

hr; echo "RETAIN — another open PR uses the base"; hr
fresh retain; addpr 11 main-aaaaaaa; run o/r 10
grep -q "DELETE main-aaaaaaa" "$S/calls" && bad "in-use base deleted" || ok "in-use base retained"
printf '%s' "$out" | grep -q "retain o/r:main-aaaaaaa.*#11" && ok "retain names #11" || bad "no retain line: $out"
grep -qx "DELETE main-bbbbbbb" "$S/calls" && ok "unused sibling still swept" || bad "unused sibling not swept"

hr; echo "RETAIN — base is the head of an open (stacked) PR"; hr
fresh stackhead; addpr 12 main main-bbbbbbb; run o/r 10
grep -q "DELETE main-bbbbbbb" "$S/calls" && bad "stack parent head deleted" || ok "stack parent head retained"

hr; echo "THE RACE — minion.town#114: PR lands on the base inside the delete window"; hr
fresh race; echo 114 >"$S/race/main-aaaaaaa"; run o/r 10
[ "$rc" = 0 ] && ok "rc 0 after repair" || bad "rc $rc: $out"
grep -qx "POST main-aaaaaaa aaaaaaa1" "$S/calls" && ok "ref re-created at the captured SHA" || bad "ref not restored: $(cat "$S/calls")"
grep -qx "REOPEN 114" "$S/calls" && ok "victim #114 reopened" || bad "victim not reopened"
[ "$(jq -r '.[] | select(.number==114) | .state' "$S/prs.json")" = open ] && ok "#114 open at end" || bad "#114 not open"
printf '%s' "$out" | grep -q "^RACE o/r:main-aaaaaaa" && ok "race reported" || bad "race not reported"
grep -q "POST main-bbbbbbb" "$S/calls" && bad "un-raced base restored" || ok "un-raced base stays deleted"

hr; echo "THE RACE — restore fails → exit 1 (surface), not a silent pass"; hr
fresh racefail; echo 114 >"$S/race/main-aaaaaaa"; : >"$S/fail-post"; run o/r 10
[ "$rc" = 1 ] && ok "rc 1" || bad "rc $rc"
printf '%s' "$out" | grep -q "restore by hand" && ok "hand-restore recipe printed" || bad "no recipe: $out"

hr; echo "OLD CLOSED PR on the base is not a victim"; hr
fresh oldclosed
jq '. + [{number:13, base:"main-aaaaaaa", head:"x", state:"closed", merged_at:null, closed_at:"2020-01-01T00:00:00Z"}]' "$S/prs.json" >"$S/p" && mv "$S/p" "$S/prs.json"
run o/r 10
grep -q "POST" "$S/calls" && bad "restored for a long-closed PR" || ok "long-closed PR ignored"

hr; echo "DRY RUN + INCONCLUSIVE"; hr
fresh dry; run --dry-run o/r 10
[ -s "$S/calls" ] && bad "dry run mutated: $(cat "$S/calls")" || ok "dry run mutates nothing"
printf '%s' "$out" | grep -q "would-delete o/r:main-aaaaaaa" && ok "dry run reports" || bad "dry run silent"
fresh inc; : >"$S/fail-all"; run o/r 10
[ "$rc" = 4 ] && ok "unreadable PR → 4" || bad "rc $rc"
[ -s "$S/calls" ] && bad "inconclusive mutated" || ok "inconclusive deletes nothing"

hr; echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
