#!/bin/bash
# dependabot-watcher-test.sh — validate the dependabot-PR watcher on throwaway
# fixtures, with no GitHub. The open-PR SOURCE is stubbed deterministically; the
# dependabot-author gate, the dependabot[bot] → botanist mapping, the idempotency,
# and the deterministic basename all run for real against a throwaway journal.
#
# Asserts:
#   A. an OPEN dependabot[bot]-authored PR → exactly one <slug>-pr<N>-dependabot
#      botanist job (no maintainer comment)
#   B. re-poll of the same PR → idempotent (still exactly one, no duplicate)
#   C. a PR authored by a NON-dependabot login (the bot itself, a human) → no
#      botanist job (author gate)
#   D. a repo with several PRs of mixed authorship → exactly the dependabot PRs get
#      one botanist job each, the others none
#   E. NOT bot-repo-scoped: a dependabot PR on an UPSTREAM slug the bot does not own
#      still gets a botanist job (the botanist renders a recommendation there — the
#      producer must not silently drop it the way the branch-driving ci-watcher does)
#   F. an already-live botanist job (present in todo/) → idempotent skip (no dup)
#
# Usage: dependabot-watcher-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
BRANCH=journal2
TR=/home/kris/.garden-depw-test
SLUG=endojs-endo-but-for-bots
REPO=endojs/endo-but-for-bots
DEP='dependabot[bot]'
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet GARDEN_*/JOURNAL_* so a live gardener running this test cannot
# splice the real journal under the fixture (the run-test.sh isolation rationale).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|CI_)' || true) 2>/dev/null || true

rm -rf "$TR"; mkdir -p "$TR"
git_id=(-c user.name=test -c user.email=test@localhost)

seed_bare() {  # seed_bare <bare-path>
  local bare="$1" seed; seed="$(mktemp -d "$TR/seed.XXXXXX")"
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
  ( cd "$seed"
    mkdir -p jobs/plan jobs/todo jobs/doin jobs/tada work comment-repos
    for d in jobs/plan jobs/todo jobs/doin jobs/tada work comment-repos; do touch "$d/.gitkeep"; done )
  git -C "$seed" add -A; git -C "$seed" "${git_id[@]}" commit -q -m seed
  git -C "$seed" remote add origin "$bare"; git -C "$seed" push -q -u origin "$BRANCH"
  rm -rf "$seed"
}

# --- deterministic stub ------------------------------------------------------
SRCSTUB="$TR/pr-source-stub.sh"
cat > "$SRCSTUB" <<'EOF'
#!/bin/bash
# emit the fixture verbatim (ignores repo/bot); the watcher applies the author gate.
cat "${DEP_FIXTURE:?set DEP_FIXTURE}"
EOF
chmod +x "$SRCSTUB"

board_has() {  # board_has <bare> <base>  -> 0 if job present in plan/todo/doin/tada
  local v; v="$(mktemp -d "$TR/bv.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  local rc=1 s
  for s in plan todo doin tada; do [ -e "$v/jobs/$s/$2.md" ] && rc=0; done
  rm -rf "$v"; return $rc
}
todo_count() {  # todo_count <bare>  -> non-gitkeep entries in jobs/todo
  local v n; v="$(mktemp -d "$TR/tc.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  n=$(ls -1 "$v/jobs/todo" | grep -vxc '.gitkeep' || true); rm -rf "$v"; printf '%s' "$n"
}

# fixture line: number \t author \t head_repo \t updated_at (only cols 1-2 matter)
FRESH_TS="$(date -u -d '-1 hour' +%Y-%m-%dT%H:%M:%SZ)"
prline() { printf '%s\t%s\t%s\t%s\n' "$1" "$2" "${3:-$REPO}" "${4:-$FRESH_TS}"; }

run_dep() {  # run_dep <state> <bare> <fixture> [slug]
  env GARDEN_STATE="$1" JOURNAL_REMOTE="$2" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_BOT_LOGIN=kriscendobot \
      GARDEN_DEP_PR_SOURCE="$SRCSTUB" DEP_FIXTURE="$3" \
      GARDEN_DEP_POST="$JOBS/post-job.sh" \
      "$JOBS/dependabot-watcher.sh" "${4:-$SLUG}" >/dev/null 2>&1
}

# ============================================================================
hr; echo "A — dependabot PR → exactly one botanist job"; hr
BARE_A="$TR/a.git"; seed_bare "$BARE_A"
FIX_A="$TR/fix-a.tsv"; prline 849 "$DEP" > "$FIX_A"
run_dep "$TR/state-a" "$BARE_A" "$FIX_A"
board_has "$BARE_A" "$SLUG-pr849-dependabot" && ok "botanist job posted ($SLUG-pr849-dependabot)" || bad "botanist job missing"
[ "$(todo_count "$BARE_A")" -eq 1 ] && ok "exactly one job posted" || bad "expected one job, got $(todo_count "$BARE_A")"

# ============================================================================
hr; echo "B — re-poll the same dependabot PR → idempotent (no duplicate)"; hr
run_dep "$TR/state-a" "$BARE_A" "$FIX_A"
[ "$(todo_count "$BARE_A")" -eq 1 ] && ok "still exactly one botanist job on re-poll" || bad "job duplicated ($(todo_count "$BARE_A"))"

# ============================================================================
hr; echo "C — PR authored by a NON-dependabot login → no botanist job (author gate)"; hr
BARE_C="$TR/c.git"; seed_bare "$BARE_C"
FIX_C="$TR/fix-c.tsv"; { prline 60 kriscendobot; prline 61 0xpatrickdev; } > "$FIX_C"
run_dep "$TR/state-c" "$BARE_C" "$FIX_C"
[ "$(todo_count "$BARE_C")" -eq 0 ] && ok "no botanist job for bot/human-authored PRs" || bad "posted a botanist job for a non-dependabot PR"

# ============================================================================
hr; echo "D — mixed-authorship PRs → exactly the dependabot PRs get one each"; hr
BARE_D="$TR/d.git"; seed_bare "$BARE_D"
FIX_D="$TR/fix-d.tsv"
{ prline 70 "$DEP"; prline 71 kriscendobot; prline 72 "$DEP"; prline 73 someuser; } > "$FIX_D"
run_dep "$TR/state-d" "$BARE_D" "$FIX_D"
board_has "$BARE_D" "$SLUG-pr70-dependabot" && ok "#70 (dependabot) → botanist job" || bad "#70 missing"
board_has "$BARE_D" "$SLUG-pr72-dependabot" && ok "#72 (dependabot) → botanist job" || bad "#72 missing"
board_has "$BARE_D" "$SLUG-pr71-dependabot" && bad "#71 (bot) wrongly got a botanist job" || ok "#71 (bot) skipped"
board_has "$BARE_D" "$SLUG-pr73-dependabot" && bad "#73 (human) wrongly got a botanist job" || ok "#73 (human) skipped"
[ "$(todo_count "$BARE_D")" -eq 2 ] && ok "exactly two botanist jobs posted" || bad "expected two jobs, got $(todo_count "$BARE_D")"

# ============================================================================
hr; echo "E — dependabot PR on an UPSTREAM slug still gets a botanist job (no bot-repo gate)"; hr
UP_SLUG=endojs-endo
BARE_E="$TR/e.git"; seed_bare "$BARE_E"
FIX_E="$TR/fix-e.tsv"; prline 500 "$DEP" endojs/endo > "$FIX_E"
run_dep "$TR/state-e" "$BARE_E" "$FIX_E" "$UP_SLUG"
board_has "$BARE_E" "$UP_SLUG-pr500-dependabot" \
  && ok "upstream dependabot PR → botanist job (recommendation path, not dropped)" \
  || bad "upstream dependabot PR was wrongly dropped (bot-repo gate leaked in)"

# ============================================================================
hr; echo "F — a botanist job already live in todo/ → idempotent skip"; hr
BARE_F="$TR/f.git"; seed_bare "$BARE_F"
# Pre-seed a live botanist job for #849 directly onto the board.
v="$(mktemp -d "$TR/pf.XXXXXX")"
git clone -q --single-branch --branch "$BRANCH" "$BARE_F" "$v"
echo "pre-existing" > "$v/jobs/todo/$SLUG-pr849-dependabot.md"
git -C "$v" add -A; git -C "$v" "${git_id[@]}" commit -q -m "seed live botanist job"
git -C "$v" push -q origin "$BRANCH"; rm -rf "$v"
FIX_F="$TR/fix-f.tsv"; prline 849 "$DEP" > "$FIX_F"
run_dep "$TR/state-f" "$BARE_F" "$FIX_F"
[ "$(todo_count "$BARE_F")" -eq 1 ] && ok "no duplicate for an already-live botanist job" || bad "duplicated an already-live job ($(todo_count "$BARE_F"))"

# ============================================================================
hr
echo "TOTAL: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
