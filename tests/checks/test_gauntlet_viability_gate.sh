#!/bin/bash
# test_gauntlet_viability_gate.sh - the viability decision precedes all expensive
# gauntlet stages and overtaken premises retire with an explicit close option.

set -uo pipefail

HARNESS_DIR=$(cd "$(dirname "$0")" && pwd)
PROJECT_ROOT=${GAUNTLET_TEST_PROJECT_ROOT:-$(cd "$HARNESS_DIR/../.." && pwd)}
JOBS="$PROJECT_ROOT/scripts/jobs"
BRANCH=journal2
PASS=0
FAIL=0

ok() { PASS=$((PASS + 1)); echo "  PASS: $1"; }
ko() { FAIL=$((FAIL + 1)); echo "  FAIL: $1"; }

echo "=== test_gauntlet_viability_gate ==="
# shellcheck disable=SC2046  # intentional word-split over matched variable names
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

TEST_ROOT=$(mktemp -d "$HOME/.garden-gauntlet-viability.XXXXXX")
trap 'rm -rf "$TEST_ROOT"' EXIT
BARE="$TEST_ROOT/journal.git"
STATE="$TEST_ROOT/state"
VERIFY="$TEST_ROOT/verify"
git_id=(-c user.name=test -c user.email=test@localhost)

git init -q --bare "$BARE"
SEED="$TEST_ROOT/seed"
git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
for directory in jobs/todo jobs/doin jobs/tada jobs/plan jobs/gauntlet jobs/index work \
  inbox/maintainer/unread inbox/maintainer/read; do
  mkdir -p "$SEED/$directory"
  touch "$SEED/$directory/.gitkeep"
done
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m seed
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"
export GARDEN=testhost GARDEN_STATE="$STATE" GARDEN_POST_ATTEMPTS=20
export GARDEN_CLAIM_TTL=14400 GARDEN_HANDLER_KILL_AFTER=60
export GARDEN_SHEPHERD_HANDLER_TIMEOUT=7200

refresh() {
  rm -rf "$VERIFY"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$VERIFY"
}

exists() { refresh; [ -e "$VERIFY/$1/$2.md" ]; }
tick() { "$JOBS/gauntlet.sh" >"$TEST_ROOT/tick.log" 2>&1; }
post_gauntlet() { "$JOBS/post-gauntlet.sh" "$@" >/dev/null 2>&1; }

complete_viability() { # <base> <result> [report-prefix]
  local base="$1" result="$2" prefix="${3:-}"
  local edit="$TEST_ROOT/complete-$base"
  rm -rf "$edit"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$edit"
  git -C "$edit" rm -q "jobs/todo/$base-viability.md"
  {
    [ -z "$prefix" ] || printf '%s\n' "$prefix"
    printf 'Deciding question: Does this PR still implement a needed, unsuperseded change?\n'
    printf 'Evidence: current PR and base history inspected.\n'
    printf '<!-- gauntlet-stage-result: viability=%s -->\n' "$result"
  } > "$edit/jobs/tada/$base-viability.md"
  git -C "$edit" add "jobs/tada/$base-viability.md"
  git -C "$edit" "${git_id[@]}" commit -q -m "complete viability $base ($result)"
  git -C "$edit" push -q origin "HEAD:$BRANCH"
}

post_gauntlet viable testowner/testrepo#201
tick
if exists jobs/todo viable-viability && ! exists jobs/todo viable-clean; then
  ok "viability is the first stage and clean has spent no claim"
else
  ko "viability is the first stage and clean has spent no claim"
fi
refresh
viability_body=$(cat "$VERIFY/jobs/todo/viable-viability.md")
if printf '%s\n' "$viability_body" | grep -Fq 'Option: close as superseded' \
  && printf '%s\n' "$viability_body" | grep -Fq 'Deciding question:'; then
  ok "gate prompt requires the explicit close option and deciding question"
else
  ko "gate prompt requires the explicit close option and deciding question"
fi
complete_viability viable proceed
tick
if exists jobs/todo viable-clean; then
  ok "a viable PR advances to clean"
else
  ko "a viable PR advances to clean"
fi

post_gauntlet overtaken testowner/testrepo#202
tick
complete_viability overtaken overtaken 'Option: close as superseded'
tick
if exists jobs/tada overtaken && ! exists jobs/todo overtaken-clean; then
  ok "an overtaken premise retires before clean"
else
  ko "an overtaken premise retires before clean"
fi
refresh
overtaken_body=$(cat "$VERIFY/jobs/tada/overtaken.md")
if printf '%s\n' "$overtaken_body" | grep -Fq 'gauntlet-status: not-viable' \
  && printf '%s\n' "$overtaken_body" | grep -Fq 'Option: close as superseded' \
  && printf '%s\n' "$overtaken_body" | grep -Fq 'Deciding question:'; then
  ok "overtaken report preserves status, close option, and deciding question"
else
  ko "overtaken report preserves status, close option, and deciding question"
fi
if exists inbox/maintainer/unread overtaken-not-viable; then
  ok "the refusal is reported to the maintainer inbox"
else
  ko "the refusal is reported to the maintainer inbox"
fi

post_gauntlet malformed testowner/testrepo#203
tick
complete_viability malformed overtaken
tick
refresh
malformed_body=$(cat "$VERIFY/jobs/tada/malformed.md" 2>/dev/null)
if printf '%s\n' "$malformed_body" | grep -Fq 'orchestration-status: halted' \
  && printf '%s\n' "$malformed_body" | grep -Fq "exact 'Option: close as superseded'"; then
  ok "an overtaken verdict without the close option fails closed"
else
  ko "an overtaken verdict without the close option fails closed"
fi

post_gauntlet closed testowner/testrepo#204
tick
complete_viability closed closed
tick
if exists jobs/tada closed && ! exists jobs/todo closed-clean; then
  ok "a closed PR retires before clean"
else
  ko "a closed PR retires before clean"
fi

post_gauntlet merged testowner/testrepo#205
tick
complete_viability merged merged
tick
if exists jobs/tada merged && ! exists jobs/todo merged-clean; then
  ok "a merged PR retires before clean"
else
  ko "a merged PR retires before clean"
fi

echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
