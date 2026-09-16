#!/bin/bash
# worktree-sweeper.sh — leader-only terminal-worktree safety net.
#
# The completion and doom paths remove project worktrees promptly.  This timer
# covers interrupted cleanup, removes the trusted spine's garden-root worktrees,
# and collects legacy directories which are no longer registered in their bare
# repository.  It intentionally has NO fleet-drain guard: inode exhaustion is a
# reason to run cleanup, not a reason to suspend it.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="worktree-sweeper"

: "${GARDEN_WORKTREE_SWEEP_MAX:=100}"
CLONE="${GARDEN_WORKTREE_SWEEPER_CLONE:-$GARDEN_STATE/worktree-sweeper/journal}"
removed=0

case "$GARDEN_WORKTREE_SWEEP_MAX" in
  ''|*[!0-9]*) die "GARDEN_WORKTREE_SWEEP_MAX must be a non-negative integer" ;;
esac

ensure_clone "$CLONE"
sync_clone "$CLONE"

under_limit() { [ "$removed" -lt "$GARDEN_WORKTREE_SWEEP_MAX" ]; }

has_live_process() { # has_live_process <directory>
  local target="$1"
  # One find process is materially cheaper than spawning one readlink for every
  # process on a large fleet host.  Match the directory itself or a descendant.
  find /proc -mindepth 2 -maxdepth 2 -path '/proc/[0-9]*/cwd' \
    \( -lname "$target" -o -lname "$target/*" \) -print -quit 2>/dev/null \
    | grep -q .
}

# pr_disposition_allows_sweep <job-file>
# No PR reference means a garden-internal terminal job and needs no external
# confirmation.  If PRs are named, every unique PR must be CLOSED or MERGED in
# live GitHub state.  A failed/ambiguous query fails safe toward retaining.
pr_disposition_allows_sweep() {
  local file="$1" refs repo number state saw=0
  refs="$(
    {
      grep -Eo 'https://github\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+/(pull|pulls)/[0-9]+' "$file" 2>/dev/null \
        | sed -E 's#https://github\.com/([^/]+/[^/]+)/(pull|pulls)/([0-9]+).*#\1 \3#'
      grep -Eo '[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+#[0-9]+' "$file" 2>/dev/null \
        | sed 's/#/ /'
    } | sort -u
  )"
  [ -n "$refs" ] || return 0
  while read -r repo number; do
    [ -n "${repo:-}" ] || continue
    saw=1
    state="$(timeout 30 "${GARDEN_GH:-gh}" pr view "$number" --repo "$repo" --json state --jq .state 2>/dev/null || true)"
    case "$state" in CLOSED|MERGED) : ;;
      *) log "keeping terminal checkout referenced by $file: $repo#$number is ${state:-unverifiable}"; return 1 ;;
    esac
  done <<< "$refs"
  [ "$saw" -eq 1 ]
}

remove_garden_worktree() { # remove_garden_worktree <path>
  local path="$1"
  [ -e "$path" ] || return 0
  has_live_process "$path" && { log "keeping $path: a live process is rooted there"; return 0; }
  git -C "$GARDEN_ROOT" worktree remove --force "$path" >/dev/null 2>&1 || return 0
  removed=$((removed + 1))
  log "removed terminal garden worktree $path"
}

sweep_terminal_base() { # sweep_terminal_base <base> <job-file> <github-check:true|false>
  local base="$1" file="$2" verify="$3" key legacy path name suffix before
  under_limit || return 0
  if [ "$verify" = true ] && ! pr_disposition_allows_sweep "$file"; then return 0; fi

  path="$GARDEN_SCRATCH/gardener-wt-$base"
  remove_garden_worktree "$path"
  under_limit || return 0

  # Use the shared terminal helper, but account its removals so the whole tick
  # remains bounded.  Count candidates first; the helper itself is idempotent.
  key="$(project_worktree_base_key "$base")"
  legacy="${base//[^A-Za-z0-9._-]/-}"
  before=0
  for path in "$GARDEN_SCRATCH/project-wt-${key}-"* \
              "$GARDEN_SCRATCH/project-wt-${legacy}-"*; do
    [ -e "$path" ] || continue
    name="$(basename "$path")"
    suffix="${name#project-wt-${key}-}"
    if ! [[ "$suffix" =~ ^[0-9a-f]{8}$ ]]; then
      suffix="${name#project-wt-${legacy}-}"
      [[ "$suffix" =~ ^[0-9a-f]{8}$ ]] || continue
    fi
    has_live_process "$path" && continue
    scratch_cleanup "$path"
    before=$((before + 1)); removed=$((removed + 1))
    under_limit || break
  done
  [ "$before" -eq 0 ] || log "removed $before terminal project checkout(s) for '$base'"
}

# Doom is a terminal disposition for the current attempt.  It deliberately does
# not require GitHub state: the reaper has already removed the claim from doin.
for file in "$CLONE/$JOBS_PLAN"/*.md; do
  [ -e "$file" ] || continue
  grep -q '^doomed:[[:space:]]*true[[:space:]]*$' "$file" || continue
  sweep_terminal_base "$(basename "$file" .md)" "$file" false
  under_limit || break
done

# Completion residue is a safety-net case.  For a PR-bound report, corroborate
# terminality with the live GitHub state; open PR jobs are expected to have been
# removed by complete-job.sh and are retained here on any ambiguity.
if under_limit; then
  for file in "$CLONE/$JOBS_TADA"/*.md; do
    [ -e "$file" ] || continue
    sweep_terminal_base "$(basename "$file" .md)" "$file" true
    under_limit || break
  done
fi

# Legacy pre-scratch worktrees lived at worktrees/<owner>-<repo>/<name>.  A
# directory absent from every bare repository's authoritative worktree list is an
# orphan by definition (including a dead .git gitdir).  Since no registration
# exists for `git worktree remove` to consume, remove the directory and prune the
# bare repo; registered trees are never touched by this pass.
if under_limit; then
  all_registered="$(
    for registry_bare in "$GARDEN_ROOT"/worktrees/*.git; do
      [ -d "$registry_bare" ] || continue
      git --git-dir="$registry_bare" worktree list --porcelain 2>/dev/null | sed -n 's/^worktree //p'
    done | sort -u
  )"
  for bare in "$GARDEN_ROOT"/worktrees/*.git; do
    [ -d "$bare" ] || continue
    parent="${bare%.git}"
    [ -d "$parent" ] || continue
    for path in "$parent"/*; do
      [ -d "$path" ] || continue
      printf '%s\n' "$all_registered" | grep -qxF "$path" && continue
      has_live_process "$path" && { log "keeping orphan candidate $path: a live process is rooted there"; continue; }
      rm -rf -- "$path"
      removed=$((removed + 1))
      log "removed unregistered legacy worktree directory $path"
      under_limit || break 2
    done
    git --git-dir="$bare" worktree prune >/dev/null 2>&1 || true
  done
fi

# Repair relocation-staled live root registrations before pruning dead ones.
prune_worktrees_preserving_live "$GARDEN_ROOT"

if [ "$removed" -ge "$GARDEN_WORKTREE_SWEEP_MAX" ] && [ "$GARDEN_WORKTREE_SWEEP_MAX" -gt 0 ]; then
  log "sweep cap reached after $removed removal(s); remaining candidates wait for the next tick"
elif [ "$removed" -gt 0 ]; then
  log "worktree sweep removed $removed checkout(s)"
fi
