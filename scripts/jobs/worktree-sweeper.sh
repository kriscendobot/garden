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
# Stay well inside the unit's TimeoutStartSec=1800: a completion tick verifies
# each PR-bound checkout with a `gh pr view` (up to 30s each), so a long queue of
# terminal bases could otherwise let the GitHub-check sequence overrun the start
# timeout and get SIGKILLed mid-tick.  We checkpoint against this soft deadline
# and leave any unswept candidates for the next tick.  The 300s of headroom under
# 1800 comfortably absorbs a single in-flight base's remaining `gh` calls plus the
# self-heal responder.  0 disables the deadline.
: "${GARDEN_WORKTREE_SWEEP_DEADLINE_SECS:=1500}"
CLONE="${GARDEN_WORKTREE_SWEEPER_CLONE:-$GARDEN_STATE/worktree-sweeper/journal}"
removed=0
TICK_START="$(date +%s 2>/dev/null || echo 0)"

case "$GARDEN_WORKTREE_SWEEP_MAX" in
  ''|*[!0-9]*) die "GARDEN_WORKTREE_SWEEP_MAX must be a non-negative integer" ;;
esac
case "$GARDEN_WORKTREE_SWEEP_DEADLINE_SECS" in
  ''|*[!0-9]*) die "GARDEN_WORKTREE_SWEEP_DEADLINE_SECS must be a non-negative integer" ;;
esac

ensure_clone "$CLONE"
sync_clone "$CLONE"

under_limit() { [ "$removed" -lt "$GARDEN_WORKTREE_SWEEP_MAX" ]; }

# past_deadline — true once the elapsed tick time has reached the deadline
# budget.  Checked before starting each terminal base (and before its GitHub
# verification) so a slow sequence of checks stops gracefully rather than
# overrunning the unit's start timeout.  A budget of 0 disables it.
past_deadline() {
  [ "$GARDEN_WORKTREE_SWEEP_DEADLINE_SECS" -gt 0 ] || return 1
  local now; now="$(date +%s 2>/dev/null || echo 0)"
  [ "$((now - TICK_START))" -ge "$GARDEN_WORKTREE_SWEEP_DEADLINE_SECS" ]
}

# budget_remains — the whole-tick guard: work continues only while both the
# removal cap and the time budget hold.
budget_remains() { under_limit && ! past_deadline; }

has_live_process() { # has_live_process <directory>
  local target="$1"
  # One find process is materially cheaper than spawning one readlink for every
  # process on a large fleet host.  Match the directory itself or a descendant.
  find /proc -mindepth 2 -maxdepth 2 -path '/proc/[0-9]*/cwd' \
    \( -lname "$target" -o -lname "$target/*" \) -print -quit 2>/dev/null \
    | grep -q .
}

# Cache live PR disposition for this tick. Multiple completed jobs commonly name
# the same PR (gauntlet stages, repeated press jobs, follow-ups), so even the
# residue-only path below must not pay for the same remote fact repeatedly.
declare -A PR_DISPOSITION=()

# pr_disposition_allows_sweep <job-file>
# No PR reference means a garden-internal terminal job and needs no external
# confirmation.  If PRs are named, every unique PR must be CLOSED or MERGED in
# live GitHub state.  Read that state from the REST pull endpoint: `gh pr view`
# uses GraphQL, and this safety-net once queried every tada report twice an hour,
# burning the account's entire 5,000-point GraphQL bucket even when almost none
# of those reports still had a checkout to reclaim. A failed/ambiguous query
# fails safe toward retaining.
pr_disposition_allows_sweep() {
  local file="$1" refs repo number state key saw=0
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
    key="$repo#$number"
    if [ -v "PR_DISPOSITION[$key]" ]; then
      state="${PR_DISPOSITION[$key]}"
    else
      state="$(timeout 30 "${GARDEN_GH:-gh}" api "repos/$repo/pulls/$number" --jq .state 2>/dev/null || true)"
      PR_DISPOSITION["$key"]="$state"
    fi
    case "$state" in closed|CLOSED|MERGED) : ;;
      *) log "keeping terminal checkout referenced by $file: $repo#$number is ${state:-unverifiable}"; return 1 ;;
    esac
  done <<< "$refs"
  [ "$saw" -eq 1 ]
}

# terminal_worktree_exists <base>
# GitHub state is needed only to authorize an actual removal. Historically the
# sweep verified every PR mentioned by every tada report before discovering that
# no matching checkout existed. With thousands of accumulated reports, that made
# this local cleanup safety net the fleet's dominant GraphQL consumer. Keep the
# remote read strictly behind proof of residue.
terminal_worktree_exists() {
  local base="$1" key legacy path name suffix
  [ -e "$GARDEN_SCRATCH/gardener-wt-$base" ] && return 0
  key="$(project_worktree_base_key "$base")"
  legacy="${base//[^A-Za-z0-9._-]/-}"
  for path in "$GARDEN_SCRATCH/project-wt-${key}-"* \
              "$GARDEN_SCRATCH/project-wt-${legacy}-"*; do
    [ -e "$path" ] || continue
    name="$(basename "$path")"
    suffix="${name#project-wt-"${key}"-}"
    if ! [[ "$suffix" =~ ^[0-9a-f]{8}$ ]]; then
      suffix="${name#project-wt-"${legacy}"-}"
      [[ "$suffix" =~ ^[0-9a-f]{8}$ ]] || continue
    fi
    return 0
  done
  return 1
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
  budget_remains || return 0
  terminal_worktree_exists "$base" || return 0
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
    suffix="${name#project-wt-"${key}"-}"
    if ! [[ "$suffix" =~ ^[0-9a-f]{8}$ ]]; then
      suffix="${name#project-wt-"${legacy}"-}"
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
  budget_remains || break
done

# Completion residue is a safety-net case.  For a PR-bound report, corroborate
# terminality with the live GitHub state; open PR jobs are expected to have been
# removed by complete-job.sh and are retained here on any ambiguity.
if budget_remains; then
  # Flat AND date-sharded reports (completion writers use tada_write_path now).
  tada_recs="$(tada_list "$CLONE" | sed "s#^#$CLONE/#")"
  for file in $tada_recs; do
    [ -e "$file" ] || continue
    sweep_terminal_base "$(basename "$file" .md)" "$file" true
    budget_remains || break
  done
fi

# Legacy pre-scratch worktrees lived at worktrees/<owner>-<repo>/<name>.  A
# directory absent from every bare repository's authoritative worktree list is an
# orphan by definition (including a dead .git gitdir).  Since no registration
# exists for `git worktree remove` to consume, remove the directory and prune the
# bare repo; registered trees are never touched by this pass.
if budget_remains; then
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

if past_deadline; then
  log "sweep deadline (${GARDEN_WORKTREE_SWEEP_DEADLINE_SECS}s) reached after $removed removal(s); remaining candidates wait for the next tick"
elif [ "$removed" -ge "$GARDEN_WORKTREE_SWEEP_MAX" ] && [ "$GARDEN_WORKTREE_SWEEP_MAX" -gt 0 ]; then
  log "sweep cap reached after $removed removal(s); remaining candidates wait for the next tick"
elif [ "$removed" -gt 0 ]; then
  log "worktree sweep removed $removed checkout(s)"
fi
