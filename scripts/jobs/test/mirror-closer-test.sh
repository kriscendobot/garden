#!/bin/bash
# mirror-closer-test.sh — validate the mirror-closer on throwaway fixtures.
#
# PART 1 (hermetic, always runs): the upstream/mirror PR-state reader and the
# close-with-comment poster are STUBBED deterministically; the mapping read, the
# open→closed decision, the merged-vs-closed wording, idempotency, the
# no-mapping-no-close invariant, the per-mapping durable cursor (closed_at), and
# loud failure all run for real against a throwaway journal. No GitHub, no claude.
#
# PART 2 (synthetic real-repo E2E, REQUIRED by the maintainer; gated on a working
# bot `gh`): creates a throwaway repo kriscendobot/mirror-closer-selftest with a
# stand-in "upstream" PR and a "mirror" PR, records the mapping, closes the
# upstream, runs mirror-closer.sh with the REAL gh handlers, and asserts the
# mirror PR is closed with the expected comment; then asserts idempotency and that
# an unmapped PR is left untouched. PRs are closed and branches deleted on
# teardown; the repo is left (the bot token has no delete_repo scope) clearly
# labelled for inspection.
#
# Usage: mirror-closer-test.sh [--no-e2e]
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
BRANCH=journal2
TR=/home/kris/.garden-mc-test
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }
WANT_E2E=1; [ "${1:-}" = --no-e2e ] && WANT_E2E=0

rm -rf "$TR"; mkdir -p "$TR"
git_id=(-c user.name=test -c user.email=test@localhost)

seed_bare() {  # seed_bare <bare-path>
  local bare="$1" seed; seed="$(mktemp -d "$TR/seed.XXXXXX")"
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
  ( cd "$seed"
    mkdir -p jobs/todo jobs/doin jobs/tada pr-mirrors cursors entries
    for d in jobs/todo jobs/doin jobs/tada pr-mirrors cursors entries; do touch "$d/.gitkeep"; done )
  git -C "$seed" add -A; git -C "$seed" "${git_id[@]}" commit -q -m seed
  git -C "$seed" remote add origin "$bare"; git -C "$seed" push -q -u origin "$BRANCH"
  rm -rf "$seed"
}
mapping_of() {  # mapping_of <bare> <key-basename>  -> prints mapping file body
  local v; v="$(mktemp -d "$TR/mv.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  cat "$v/pr-mirrors/$2" 2>/dev/null; rm -rf "$v"
}

# ============================================================================
# PART 1 — hermetic stub-driven logic
# ============================================================================
# STATE stub: looks up "<repo>#<num>" in a TSV fixture ($MC_STATES); emits
# "<state>\t<merged>". Unknown → "open\tfalse" (a PR we have no fixture for is
# treated as open, the safe default).
STATESTUB="$TR/state-stub.sh"
cat > "$STATESTUB" <<'EOF'
#!/bin/bash
repo="$1"; num="$2"
line="$(grep -E "^${repo}#${num}"$'\t' "${MC_STATES:?set MC_STATES}" | head -1)"
if [ -z "$line" ]; then printf 'open\tfalse\n'; exit 0; fi
printf '%s\t%s\n' "$(cut -f2 <<<"$line")" "$(cut -f3 <<<"$line")"
EOF
chmod +x "$STATESTUB"

# CLOSE stub: append "<repo>#<num>" and the comment body to a log so the test can
# count calls and assert the wording.
CLOSESTUB="$TR/close-stub.sh"
cat > "$CLOSESTUB" <<'EOF'
#!/bin/bash
printf '%s#%s\n' "$1" "$2" >> "${MC_CLOSE_LOG:?set MC_CLOSE_LOG}"
cat "$3" >> "${MC_CLOSE_LOG}"
printf '<<<END>>>\n' >> "${MC_CLOSE_LOG}"
EOF
chmod +x "$CLOSESTUB"

# A close stub that FAILS (to prove a failed close leaves the mapping unresolved).
FAILCLOSE="$TR/close-fail.sh"
printf '#!/bin/bash\necho "boom" >&2; exit 1\n' > "$FAILCLOSE"; chmod +x "$FAILCLOSE"
# A state stub that FAILS (to prove loud failure on an unreadable PR state).
FAILSTATE="$TR/state-fail.sh"
printf '#!/bin/bash\necho "boom" >&2; exit 1\n' > "$FAILSTATE"; chmod +x "$FAILSTATE"

run_closer() {  # run_closer <state-dir> <bare> <state-fixture> <close-log> [state-handler] [close-handler]
  env GARDEN_STATE="$1" JOURNAL_REMOTE="$2" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_NO_MAINTAINER_ALERT=1 \
      MC_STATES="$3" MC_CLOSE_LOG="$4" \
      GARDEN_MIRROR_PR_STATE="${5:-$STATESTUB}" \
      GARDEN_MIRROR_CLOSE="${6:-$CLOSESTUB}" \
      "$JOBS/mirror-closer.sh" >/dev/null 2>&1
}
record() {  # record <state-dir> <bare> <up-ref> <mir-ref>
  env GARDEN_STATE="$1" JOURNAL_REMOTE="$2" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_NO_MAINTAINER_ALERT=1 \
      "$JOBS/record-mirror.sh" "$3" "$4" "test" >/dev/null 2>&1
}

hr; echo "A — upstream MERGED + mirror open → close with 'was merged', stamp mapping"; hr
BARE_A="$TR/a.git"; seed_bare "$BARE_A"
ST_A="$TR/states-a.tsv"; CL_A="$TR/close-a.log"; : > "$CL_A"
record "$TR/state-a" "$BARE_A" "up/repo#10" "garden/mir#20"
printf 'up/repo#10\tclosed\ttrue\n'   > "$ST_A"   # upstream merged
printf 'garden/mir#20\topen\tfalse\n' >> "$ST_A"  # mirror still open
run_closer "$TR/state-a" "$BARE_A" "$ST_A" "$CL_A"
grep -qxF 'garden/mir#20' "$CL_A" && ok "mirror garden/mir#20 was closed" || bad "mirror not closed ($(cat "$CL_A"))"
grep -qF 'was merged' "$CL_A" && ok "comment says the upstream was merged" || bad "comment wording wrong"
grep -qF 'https://github.com/up/repo/pull/10' "$CL_A" && ok "comment names the upstream PR URL" || bad "comment missing upstream URL"
MAP_A="$(mapping_of "$BARE_A" up-repo-10.md)"
grep -q '^closed_at:' <<<"$MAP_A" && grep -q '^upstream_outcome: merged' <<<"$MAP_A" \
  && ok "mapping stamped closed_at + upstream_outcome: merged (durable cursor)" || bad "mapping not stamped: $MAP_A"

hr; echo "B — idempotent: a second run closes nothing and does not re-stamp"; hr
: > "$CL_A"
run_closer "$TR/state-a" "$BARE_A" "$ST_A" "$CL_A"
[ ! -s "$CL_A" ] && ok "second run made no close call (resolved mapping skipped)" || bad "re-closed: $(cat "$CL_A")"
n_closed=$(mapping_of "$BARE_A" up-repo-10.md | grep -c '^closed_at:')
[ "$n_closed" -eq 1 ] && ok "exactly one closed_at on the mapping (no duplicate stamp)" || bad "closed_at count=$n_closed"

hr; echo "C — upstream still OPEN → mirror left alone"; hr
BARE_C="$TR/c.git"; seed_bare "$BARE_C"
ST_C="$TR/states-c.tsv"; CL_C="$TR/close-c.log"; : > "$CL_C"
record "$TR/state-c" "$BARE_C" "up/repo#11" "garden/mir#21"
printf 'up/repo#11\topen\tfalse\n' > "$ST_C"
run_closer "$TR/state-c" "$BARE_C" "$ST_C" "$CL_C"
[ ! -s "$CL_C" ] && ok "open upstream → no close call" || bad "closed a mirror whose upstream is open"
mapping_of "$BARE_C" up-repo-11.md | grep -q '^closed_at:' && bad "stamped a still-open mapping" || ok "mapping left unresolved while upstream open"

hr; echo "D — closed upstream with NO mapping → closes nothing"; hr
BARE_D="$TR/d.git"; seed_bare "$BARE_D"
ST_D="$TR/states-d.tsv"; CL_D="$TR/close-d.log"; : > "$CL_D"
# A mapping exists for an OPEN upstream; a DIFFERENT PR is closed but unmapped.
record "$TR/state-d" "$BARE_D" "up/repo#12" "garden/mir#22"
printf 'up/repo#12\topen\tfalse\n'      > "$ST_D"   # the mapped one is open
printf 'up/repo#999\tclosed\ttrue\n'   >> "$ST_D"   # closed but unmapped
printf 'garden/mir#888\topen\tfalse\n' >> "$ST_D"
run_closer "$TR/state-d" "$BARE_D" "$ST_D" "$CL_D"
[ ! -s "$CL_D" ] && ok "an unmapped closed PR is never even looked at (no close)" || bad "closed something unmapped: $(cat "$CL_D")"

hr; echo "E — upstream closed-not-merged → 'was closed without merging', outcome=closed"; hr
BARE_E="$TR/e.git"; seed_bare "$BARE_E"
ST_E="$TR/states-e.tsv"; CL_E="$TR/close-e.log"; : > "$CL_E"
record "$TR/state-e" "$BARE_E" "up/repo#13" "garden/mir#23"
printf 'up/repo#13\tclosed\tfalse\n'  > "$ST_E"
printf 'garden/mir#23\topen\tfalse\n' >> "$ST_E"
run_closer "$TR/state-e" "$BARE_E" "$ST_E" "$CL_E"
grep -qF 'was closed without merging' "$CL_E" && ok "comment says closed without merging" || bad "wording wrong: $(cat "$CL_E")"
mapping_of "$BARE_E" up-repo-13.md | grep -q '^upstream_outcome: closed' && ok "outcome stamped 'closed'" || bad "outcome not 'closed'"

hr; echo "F — upstream closed, mirror ALREADY closed → reconcile only, no comment"; hr
BARE_F="$TR/f.git"; seed_bare "$BARE_F"
ST_F="$TR/states-f.tsv"; CL_F="$TR/close-f.log"; : > "$CL_F"
record "$TR/state-f" "$BARE_F" "up/repo#14" "garden/mir#24"
printf 'up/repo#14\tclosed\ttrue\n'    > "$ST_F"
printf 'garden/mir#24\tclosed\tfalse\n' >> "$ST_F"  # mirror already closed
run_closer "$TR/state-f" "$BARE_F" "$ST_F" "$CL_F"
[ ! -s "$CL_F" ] && ok "no close/comment call when mirror already closed" || bad "posted to an already-closed mirror"
mapping_of "$BARE_F" up-repo-14.md | grep -q '^closed_at:' && ok "mapping reconciled (closed_at stamped)" || bad "mapping not reconciled"

hr; echo "G — record-mirror idempotency + conflict refusal"; hr
BARE_G="$TR/g.git"; seed_bare "$BARE_G"
record "$TR/state-g" "$BARE_G" "up/repo#15" "garden/mir#25"
record "$TR/state-g" "$BARE_G" "up/repo#15" "garden/mir#25"   # same → no-op
n_map=$(git clone -q --single-branch --branch "$BRANCH" "$BARE_G" "$TR/gv" && ls -1 "$TR/gv/pr-mirrors" | grep -vxc '.gitkeep'); rm -rf "$TR/gv"
[ "$n_map" -eq 1 ] && ok "re-recording the same pair is a no-op (one mapping file)" || bad "duplicate mapping ($n_map)"
set +e
env GARDEN_STATE="$TR/state-g" JOURNAL_REMOTE="$BARE_G" JOURNAL_BRANCH="$BRANCH" GARDEN_NO_MAINTAINER_ALERT=1 \
   "$JOBS/record-mirror.sh" "up/repo#15" "garden/OTHER#99" "test" >/dev/null 2>&1; rcc=$?
# NOTE: this script runs WITHOUT `set -e` (see top), so several subtests below
# deliberately invoke expected-nonzero commands (run_closer in H/H2) unguarded.
[ "$rcc" -ne 0 ] && ok "recording a DIFFERENT mirror for the same upstream is refused (rc=$rcc)" || bad "conflicting mirror silently overwrote"

hr; echo "H — loud failure: a failed PR-state read aborts nonzero (no silent no-op)"; hr
BARE_H="$TR/h.git"; seed_bare "$BARE_H"
ST_H="$TR/states-h.tsv"; CL_H="$TR/close-h.log"; : > "$CL_H"; : > "$ST_H"
record "$TR/state-h" "$BARE_H" "up/repo#16" "garden/mir#26"
run_closer "$TR/state-h" "$BARE_H" "$ST_H" "$CL_H" "$FAILSTATE"; rch=$?
[ "$rch" -ne 0 ] && ok "mirror-closer exits nonzero when a state read fails (rc=$rch)" || bad "swallowed a failed state read (silent no-op!)"
mapping_of "$BARE_H" up-repo-16.md | grep -q '^closed_at:' && bad "stamped a mapping despite the failure" || ok "mapping left unresolved on failure (will retry)"

hr; echo "H2 — loud failure: a failed close aborts nonzero and leaves mapping unresolved"; hr
BARE_H2="$TR/h2.git"; seed_bare "$BARE_H2"
ST_H2="$TR/states-h2.tsv"; CL_H2="$TR/close-h2.log"; : > "$CL_H2"
record "$TR/state-h2" "$BARE_H2" "up/repo#17" "garden/mir#27"
printf 'up/repo#17\tclosed\ttrue\n'    > "$ST_H2"
printf 'garden/mir#27\topen\tfalse\n' >> "$ST_H2"
run_closer "$TR/state-h2" "$BARE_H2" "$ST_H2" "$CL_H2" "$STATESTUB" "$FAILCLOSE"; rch2=$?
[ "$rch2" -ne 0 ] && ok "a failed close aborts nonzero (rc=$rch2)" || bad "swallowed a failed close"
mapping_of "$BARE_H2" up-repo-17.md | grep -q '^closed_at:' && bad "stamped despite a failed close" || ok "mapping unresolved after a failed close (retries next tick)"

# ============================================================================
# PART 2 — synthetic real-repo end-to-end (REQUIRED)
# ============================================================================
hr; echo "PART 2 — synthetic-repo END-TO-END (real gh)"; hr
SELF=kriscendobot/mirror-closer-selftest
if [ "$WANT_E2E" -eq 0 ]; then
  echo "  SKIP: --no-e2e requested"
elif ! command -v gh >/dev/null 2>&1; then
  echo "  SKIP: no gh on PATH"
elif [ "$(gh api user --jq .login 2>/dev/null)" != kriscendobot ]; then
  echo "  SKIP: fleet gh is not authenticated as kriscendobot (got '$(gh api user --jq .login 2>/dev/null)')"
else
  ts="$(date +%s)"
  echo "  using synthetic repo $SELF (ts=$ts); created PRs/branches are torn down, repo left for inspection"
  # 1. ensure the throwaway repo exists (private, with a README → a 'main' base).
  gh repo view "$SELF" >/dev/null 2>&1 || gh repo create "$SELF" --private --add-readme -d "garden mirror-closer self-test (throwaway)" >/dev/null 2>&1
  CLONE="$TR/selftest-clone"; rm -rf "$CLONE"
  if ! gh repo clone "$SELF" "$CLONE" -- -q 2>/dev/null; then
    bad "could not clone $SELF — E2E aborted"
  else
    git -C "$CLONE" "${git_id[@]}" >/dev/null 2>&1 || true
    base="$(git -C "$CLONE" symbolic-ref --short HEAD)"
    mkbranch() {  # mkbranch <branch> <file>
      git -C "$CLONE" checkout -q "$base"
      git -C "$CLONE" checkout -q -b "$1"
      echo "$1" > "$CLONE/$2"
      git -C "$CLONE" "${git_id[@]}" add -A
      git -C "$CLONE" "${git_id[@]}" commit -q -m "$1"
      git -C "$CLONE" push -q origin "$1"
    }
    UPB="selftest-upstream-$ts"; MIRB="selftest-mirror-$ts"; UNMB="selftest-unmapped-$ts"
    mkbranch "$UPB"  "up-$ts.txt"
    mkbranch "$MIRB" "mir-$ts.txt"
    mkbranch "$UNMB" "unm-$ts.txt"
    UPN=$(gh pr create -R "$SELF" --base "$base" --head "$UPB"  --title "selftest upstream $ts"  --body "synthetic upstream stand-in" --json number --jq .number 2>/dev/null || \
          gh pr create -R "$SELF" --base "$base" --head "$UPB"  --title "selftest upstream $ts"  --body "synthetic upstream stand-in" | grep -oE '[0-9]+$' | tail -1)
    MIRN=$(gh pr create -R "$SELF" --base "$base" --head "$MIRB" --title "selftest mirror $ts"   --body "synthetic mirror stand-in" | grep -oE '/pull/[0-9]+' | grep -oE '[0-9]+' | tail -1)
    UNMN=$(gh pr create -R "$SELF" --base "$base" --head "$UNMB" --title "selftest unmapped $ts" --body "synthetic unmapped stand-in" | grep -oE '/pull/[0-9]+' | grep -oE '[0-9]+' | tail -1)
    # gh pr create on older gh has no --json; recover the upstream number robustly.
    [ -n "${UPN:-}" ] || UPN=$(gh pr list -R "$SELF" --head "$UPB" --json number --jq '.[0].number')
    echo "  opened PRs: upstream #$UPN, mirror #$MIRN, unmapped #$UNMN"

    # 2. record the mapping (upstream #UPN → mirror #MIRN) on a throwaway journal.
    E2EBARE="$TR/e2e.git"; seed_bare "$E2EBARE"
    record "$TR/state-e2e" "$E2EBARE" "$SELF#$UPN" "$SELF#$MIRN"
    mkey="kriscendobot-mirror-closer-selftest-$UPN.md"
    mapping_of "$E2EBARE" "$mkey" | grep -q "^mirror: $SELF#$MIRN$" && ok "mapping recorded ($SELF#$UPN → $SELF#$MIRN)" || bad "mapping not recorded"

    # 3. CLOSE the upstream PR (the trigger), then run the closer with REAL gh I/O.
    gh pr close "$UPN" -R "$SELF" >/dev/null 2>&1
    env GARDEN_STATE="$TR/state-e2e" JOURNAL_REMOTE="$E2EBARE" JOURNAL_BRANCH="$BRANCH" \
        GARDEN_NO_MAINTAINER_ALERT=1 "$JOBS/mirror-closer.sh" >/dev/null 2>&1
    mstate=$(gh pr view "$MIRN" -R "$SELF" --json state --jq .state 2>/dev/null)
    [ "$mstate" = CLOSED ] && ok "E2E: mirror PR #$MIRN is now CLOSED" || bad "E2E: mirror PR #$MIRN state=$mstate (expected CLOSED)"
    mcomment=$(gh pr view "$MIRN" -R "$SELF" --json comments --jq '.comments[].body' 2>/dev/null)
    grep -qF 'Closing this mirror to follow' <<<"$mcomment" && grep -qF "/pull/$UPN" <<<"$mcomment" \
      && ok "E2E: mirror carries the close comment naming the upstream PR" || bad "E2E: close comment missing/incomplete"
    # unmapped PR untouched
    ustate=$(gh pr view "$UNMN" -R "$SELF" --json state --jq .state 2>/dev/null)
    [ "$ustate" = OPEN ] && ok "E2E: unmapped PR #$UNMN left OPEN (no mapping → no close)" || bad "E2E: unmapped PR touched (state=$ustate)"

    # 4. idempotency: re-run; mirror stays closed; mapping has one closed_at; no new comment.
    ncomment_before=$(grep -c 'Closing this mirror to follow' <<<"$mcomment")
    env GARDEN_STATE="$TR/state-e2e" JOURNAL_REMOTE="$E2EBARE" JOURNAL_BRANCH="$BRANCH" \
        GARDEN_NO_MAINTAINER_ALERT=1 "$JOBS/mirror-closer.sh" >/dev/null 2>&1
    mcomment2=$(gh pr view "$MIRN" -R "$SELF" --json comments --jq '.comments[].body' 2>/dev/null)
    ncomment_after=$(grep -c 'Closing this mirror to follow' <<<"$mcomment2")
    [ "$ncomment_after" -eq "$ncomment_before" ] && ok "E2E idempotent: no duplicate close comment on re-run" || bad "E2E: duplicate comment ($ncomment_before→$ncomment_after)"
    [ "$(mapping_of "$E2EBARE" "$mkey" | grep -c '^closed_at:')" -eq 1 ] && ok "E2E: exactly one closed_at after re-run" || bad "E2E: closed_at duplicated"

    # 5. teardown: close any open synthetic PRs, delete the branches. Repo stays.
    for pr in "$UNMN" "$MIRN" "$UPN"; do gh pr close "$pr" -R "$SELF" >/dev/null 2>&1 || true; done
    for b in "$UPB" "$MIRB" "$UNMB"; do gh api -X DELETE "repos/$SELF/git/refs/heads/$b" >/dev/null 2>&1 || true; done
    echo "  torn down: PRs #$UPN/#$MIRN/#$UNMN closed, branches deleted; repo $SELF left (no delete_repo scope)"
  fi
fi

hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
[ "$FAIL" -eq 0 ]
