#!/bin/bash
# defer-doomed-plan-test.sh — hermetic coverage for the queue-wide doom regate.
set -euo pipefail

while IFS= read -r inherited; do
  unset "$inherited"
done < <(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true)
export GARDEN_TEST=1

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
SCRIPT="$JOBS/defer-doomed-plan.sh"
BRANCH=journal2
TR="$(mktemp -d "${TMPDIR:-$HOME}/.garden-defer-doomed-test.XXXXXX")"
BARE="$TR/origin.git"
SEED="$TR/seed"
git_id=(-c user.name=test -c user.email=test@localhost)
trap 'rm -rf "$TR"' EXIT

git init -q --bare "$BARE"
git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
mkdir -p "$SEED/jobs/plan" "$SEED/jobs/todo" "$SEED/jobs/doin" "$SEED/jobs/tada"
touch "$SEED/jobs/plan/.gitkeep" "$SEED/jobs/todo/.gitkeep" "$SEED/jobs/doin/.gitkeep" "$SEED/jobs/tada/.gitkeep"

plan() { # basename gate extra-frontmatter
  local base="$1" gate="$2" extra="$3"
  printf '%s\n' '---' "gate: $gate" 'priority: normal' "$extra" 'posted_at: 2026-09-19T00:00:00Z' '---' '' "body for $base" \
    > "$SEED/jobs/plan/$base.md"
}
plan doomed go-ahead 'doomed: true'
plan poisoned go-ahead 'poisoned: true'
plan decision go-ahead 'maintainer_question: choose an API'
plan already-deferred deferred 'doomed: true'

git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m seed
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"
export GARDEN=testhost GARDEN_STATE="$TR/state" GARDEN_ROOT="$TR"

dry="$(bash "$SCRIPT" --dry-run 2>/dev/null)"
[ "$(wc -l <<<"$dry")" -eq 2 ]
grep -qx doomed <<<"$dry"
grep -qx poisoned <<<"$dry"

bash "$SCRIPT" >/dev/null
show() { git -C "$BARE" show "$BRANCH:jobs/plan/$1.md"; }
[ "$(show doomed | grep -c '^gate: deferred$')" -eq 1 ]
[ "$(show poisoned | grep -c '^gate: deferred$')" -eq 1 ]
grep -q '^doomed: true$' < <(show doomed)
grep -q '^poisoned: true$' < <(show poisoned)
grep -q '^gate: go-ahead$' < <(show decision)
grep -q '^gate: deferred$' < <(show already-deferred)
grep -q '^body for doomed$' < <(show doomed)

# Idempotent after the first batch: no second commit and no changed content.
before="$(git -C "$BARE" rev-parse "$BRANCH")"
bash "$SCRIPT" >/dev/null
after="$(git -C "$BARE" rev-parse "$BRANCH")"
[ "$before" = "$after" ]

echo "PASS: doomed go-ahead jobs moved atomically to deferred; other plan jobs preserved"
