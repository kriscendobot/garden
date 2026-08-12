#!/bin/bash
# safe-rebase.sh — bring a stale PR branch back onto a moved base DETERMINISTICALLY,
# or FAIL CLOSED. The routine stale-branch recovery a gardener used to do by hand is
# now mechanical; the non-deterministic case (a real code conflict) is refused for a
# weaver/fixer rather than resolved on agent discretion.
#
# The motivating case (endojs/endo-but-for-bots #868, 2026-08-12): an approved
# Dependabot PR had gone conflicting/dirty against a base that moved a shared
# dependency. A gardener manually rebased the reviewed commits and hand-resolved the
# `yarn.lock` conflict before CI and merge. Both halves are deterministic:
#   * the reviewed code commits replay onto the fresh base unchanged, and
#   * a lockfile conflict is the ONE conflict class git can resolve mechanically —
#     you never merge a lockfile, you drop both sides and regenerate it against the
#     new base (skills/conflict-resolution § generated files; yarn-lock-separate-commit
#     § Rebase recovery).
# So this helper automates exactly that shape and NOTHING wider.
#
# What it does, in order:
#   1. FRESH-BASE / HEAD CHECK. Optionally fetch the base branch fresh (so the
#      freshness test is against the live base, not a stale remote-tracking ref),
#      then compare HEAD to the base tip by ANCESTRY:
#        * base is an ancestor of HEAD  -> branch already carries the base tip; it is
#          FRESH. Nothing to rebase — quiet exit 0.
#        * HEAD is an ancestor of base  -> branch is strictly behind with no unique
#          commits; `git rebase` fast-forwards it. (Unusual for a PR; handled anyway.)
#        * base moved ahead + branch has its own commits -> rebase.
#   2. REBASE. `git rebase <base>` replays the reviewed commits onto the fresh base.
#        * clean            -> done (exit 0).
#        * conflict         -> the deterministic lockfile-recovery loop (step 3).
#   3. LOCKFILE-ONLY RECOVERY. While the rebase is stopped on a conflict: if EVERY
#      conflicted path is a lockfile AND the commit being replayed touches ONLY
#      lockfiles (the yarn-lock-separate-commit discipline guarantees the lockfile
#      lives in its own commit), `git rebase --skip` drops that stale lockfile commit
#      and the loop continues. ANY other conflict — a code file, or a lockfile commit
#      that also carries non-lockfile changes — is NON-DETERMINISTIC: `git rebase
#      --abort` and REFUSE (exit 3). A wrong lockfile resolution is recoverable; a
#      wrong code merge silently drops a reviewed intent.
#   4. REGENERATE. If any lockfile commit was skipped, regenerate the lockfile against
#      the new base and commit it as its own `chore: Update yarn.lock`, restoring the
#      PR's dependency resolution. A regeneration failure is fail-closed (exit 3): the
#      worktree is left un-pushed, so nothing broken can reach the remote — the
#      supervisor's later push stage never runs because garden-pr.sh's `fail` stops.
#
# Usage: safe-rebase.sh <worktree> [base-ref]
#   base-ref defaults to HEAD~1 (the scaffold value: HEAD already contains it, so the
#   freshness check short-circuits to a quiet no-op and the rebase never runs — a
#   supervisor passes a real moved base, e.g. origin/master, to make this act).
# Env:
#   GARDEN_BASE_REMOTE / GARDEN_BASE_BRANCH  when BOTH set, fetch that branch fresh
#     first and rebase onto the just-fetched sha (the honest fresh-base check).
#   GARDEN_LOCKFILE_REGEN  a command run as `<cmd> <worktree>` to regenerate the
#     lockfile; defaults to a package-manager-detected install (corepack yarn/pnpm/npm).
#   GARDEN_LOCKFILES  space-separated lockfile basenames to treat as regenerable
#     (default: yarn.lock package-lock.json pnpm-lock.yaml npm-shrinkwrap.json).
# Exit: 0 fresh / rebased (clean or via deterministic lockfile recovery);
#       3 REFUSED — a non-deterministic conflict or a failed regeneration; the caller
#         must weave/rebase by hand (a weaver/fixer job), never force past it;
#       1 usage / operational error.

set -euo pipefail

wt="${1:?usage: safe-rebase.sh <worktree> [base-ref]}"
base_ref="${2:-HEAD~1}"

git() { command git -C "$wt" "$@"; }   # every git op is against the worktree

: "${GARDEN_LOCKFILES:=yarn.lock package-lock.json pnpm-lock.yaml npm-shrinkwrap.json}"

is_lockfile() {  # is_lockfile <path> -> 0 if its basename is a known lockfile
  local b; b="${1##*/}"
  local L; for L in $GARDEN_LOCKFILES; do [ "$b" = "$L" ] && return 0; done
  return 1
}

all_lockfiles() {  # all_lockfiles <<< newline-separated paths; 0 iff non-empty AND all are lockfiles
  local any=0 p
  while IFS= read -r p; do
    [ -n "$p" ] || continue
    any=1
    is_lockfile "$p" || return 1
  done
  [ "$any" = 1 ]
}

GITDIR="$(git rev-parse --absolute-git-dir)" || { echo "safe-rebase: no git dir in $wt" >&2; exit 1; }
rebase_in_progress() { [ -d "$GITDIR/rebase-merge" ] || [ -d "$GITDIR/rebase-apply" ]; }

# A rebase left over from a crashed prior run would make every step below lie. Refuse
# rather than silently entangle with it.
if rebase_in_progress; then
  echo "safe-rebase: REFUSED — a rebase is already in progress in $wt; resolve or abort it first" >&2
  exit 3
fi

head="$(git rev-parse HEAD)" || { echo "safe-rebase: no HEAD in $wt" >&2; exit 1; }

# --- 1. resolve the base FRESH ----------------------------------------------
if [ -n "${GARDEN_BASE_REMOTE:-}" ] && [ -n "${GARDEN_BASE_BRANCH:-}" ]; then
  git fetch --quiet "$GARDEN_BASE_REMOTE" "$GARDEN_BASE_BRANCH" \
    || { echo "safe-rebase: fetch $GARDEN_BASE_REMOTE $GARDEN_BASE_BRANCH failed" >&2; exit 1; }
  base="$(git rev-parse FETCH_HEAD)" || { echo "safe-rebase: cannot read FETCH_HEAD" >&2; exit 1; }
else
  # An unresolvable LOCAL base ref means there is no base to rebase onto (the common
  # case: the scaffold's default HEAD~1 on a single-commit branch). That is "nothing
  # to do", not a conflict — skip, don't wedge the gauntlet. The loud fetch-failure
  # path above covers a genuinely misconfigured remote base a supervisor named.
  base="$(git rev-parse --verify --quiet "$base_ref^{commit}" || true)"
  if [ -z "$base" ]; then
    echo "safe-rebase: base ref '$base_ref' does not resolve; nothing to rebase (skipping)" >&2
    exit 0
  fi
fi

# --- 1b. fresh-base / head check --------------------------------------------
# Already carries the base tip: nothing to do. QUIET on success.
if git merge-base --is-ancestor "$base" "$head"; then
  exit 0
fi

# --- 2. rebase the reviewed commits onto the fresh base ---------------------
if git rebase "$base"; then
  echo "safe-rebase: rebased ${head:0:11} onto ${base:0:11} (${base_ref})"
  exit 0
fi

# --- 3. deterministic lockfile-only recovery loop ---------------------------
skipped_lock=0
while rebase_in_progress; do
  conflicted="$(git diff --name-only --diff-filter=U || true)"
  stopped="$(git rev-parse --verify --quiet REBASE_HEAD || true)"
  stopped_files=""
  [ -n "$stopped" ] && stopped_files="$(git diff-tree --no-commit-id --name-only -r "$stopped" 2>/dev/null || true)"

  if [ -n "$stopped" ] \
     && all_lockfiles <<<"$conflicted" \
     && all_lockfiles <<<"$stopped_files"; then
    # A lockfile-only commit that conflicts on a moved base: drop it; we regenerate
    # the lockfile against the new base below. --skip advances past this commit and
    # either finishes the rebase or stops on the next one (the loop re-checks).
    git rebase --skip >/dev/null 2>&1 || true
    skipped_lock=1
    continue
  fi

  # Anything else is a real conflict this helper must NOT resolve on its own.
  git rebase --abort >/dev/null 2>&1 || true
  cat >&2 <<EOF
safe-rebase: REFUSED — non-deterministic conflict rebasing onto ${base:0:11} (${base_ref}).
  Conflicted paths:
$(printf '%s\n' "$conflicted" | sed 's/^/    /')
  Only a lockfile-only conflict is auto-recoverable; this needs a weave/rebase by
  hand (a weaver, escalating to a fixer). Aborted; the worktree is unchanged.
EOF
  exit 3
done

# --- 4. regenerate the dropped lockfile against the new base ----------------
if [ "$skipped_lock" = 1 ]; then
  if [ -n "${GARDEN_LOCKFILE_REGEN:-}" ]; then
    "$GARDEN_LOCKFILE_REGEN" "$wt" || { echo "safe-rebase: REFUSED — lockfile regeneration ($GARDEN_LOCKFILE_REGEN) failed after skipping the stale lockfile commit; worktree left for a fixer" >&2; exit 3; }
  else
    # Default regeneration, detected from which lockfile the repo carries. Kept
    # scripts-agnostic and lockfile-only where the package manager supports it.
    if [ -f "$wt/yarn.lock" ]; then
      ( cd "$wt" && corepack yarn install ) || { echo "safe-rebase: REFUSED — 'corepack yarn install' failed regenerating yarn.lock; worktree left for a fixer" >&2; exit 3; }
    elif [ -f "$wt/pnpm-lock.yaml" ]; then
      ( cd "$wt" && corepack pnpm install --lockfile-only ) || { echo "safe-rebase: REFUSED — 'corepack pnpm install --lockfile-only' failed; worktree left for a fixer" >&2; exit 3; }
    elif [ -f "$wt/package-lock.json" ] || [ -f "$wt/npm-shrinkwrap.json" ]; then
      ( cd "$wt" && npm install --package-lock-only ) || { echo "safe-rebase: REFUSED — 'npm install --package-lock-only' failed; worktree left for a fixer" >&2; exit 3; }
    else
      echo "safe-rebase: REFUSED — a lockfile commit was skipped but no lockfile is present to regenerate; worktree left for a fixer" >&2
      exit 3
    fi
  fi
  # Stage only the lockfiles (never sweep in incidental install churn), and commit
  # them as their own chore, restoring the yarn-lock-separate-commit shape.
  staged_any=0
  for L in $GARDEN_LOCKFILES; do
    if [ -f "$wt/$L" ]; then git add -- "$L" 2>/dev/null && staged_any=1 || true; fi
  done
  if [ "$staged_any" = 1 ] && ! git diff --cached --quiet; then
    git commit --quiet -m "chore: Update yarn.lock" \
      || { echo "safe-rebase: REFUSED — could not commit the regenerated lockfile; worktree left for a fixer" >&2; exit 3; }
  fi
  echo "safe-rebase: rebased onto ${base:0:11} (${base_ref}); dropped + regenerated the lockfile commit"
  exit 0
fi

# Rebase completed with no lockfile skip needed (all reviewed commits replayed clean).
echo "safe-rebase: rebased onto ${base:0:11} (${base_ref})"
exit 0
