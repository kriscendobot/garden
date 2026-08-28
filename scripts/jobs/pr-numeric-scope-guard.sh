#!/bin/bash
# pr-numeric-scope-guard.sh — refuse an AMBIGUOUS bare-numeric `gh pr` selector:
# a numeric PR reference (`51` or `#51`) given with NO explicit repository
# (-R/--repo) and NO PR URL, invoked OUTSIDE a project worktree.
#
# THE INCIDENT (a completed deadline-retirement job requeued)
# A finished deadline-retirement job was REQUEUED as a handler failure because a
# bare `gh pr … 51` resolved `#51` against whatever repo the cwd's git remote
# named — the garden's OWN repo, not the fork the number belonged to. GitHub
# numbers issues and pull requests in ONE shared space, so `51` was an ISSUE, and
# `gh pr` reported a "nonexistent PullRequest". That error propagated up and
# turned already-complete work into a spurious requeue. The number was never
# unambiguous: nothing told gh which repo `51` lived in.
#
# THE FIX
# A bare PR number is only unambiguous when gh can resolve the repository from the
# surrounding checkout. INSIDE a project worktree (an ensure-project-worktree.sh
# checkout of a fork, whose git *common dir* is the fork's bare clone under
# $GARDEN_ROOT/worktrees/<owner>-<repo>.git — NOT $GARDEN_ROOT/.git) a bare `51`
# resolves against that fork, so it is safe and passes through. EVERYWHERE ELSE —
# the garden root, the journal worktree, a per-job garden dev worktree
# (gardener-wt-*, whose common dir IS $GARDEN_ROOT/.git), or no git repo at all —
# the repo is ambiguous, so this guard REFUSES the call and names the remedy: pass
# `-R <owner>/<repo>` or a full PR URL. Blocking is cheap and self-correcting (the
# caller re-issues with explicit scope); silently misresolving is what cost a
# completed job its record.
#
# FAIL DIRECTION
# The guard blocks ONLY a positively-detected bare-numeric `gh pr <sub>` selector
# that carries neither -R/--repo nor a URL. It passes through on every other shape
# — a URL selector, a branch-name selector, an -R-scoped call, a non-selector
# subcommand (create/list/status). When it cannot POSITIVELY confirm a *project*
# worktree it treats the location as ambiguous and blocks: the safe direction,
# since the remedy is a one-line re-issue and the alternative is the very
# silent-misresolution this closes. An escape hatch (GARDEN_ALLOW_BARE_PR_NUMBER=1)
# bypasses the block for a caller that has arranged the repo context by other
# means.
#
# Pure/side-effect-free to source: defines functions only. Self-contained (does
# not source common.sh) so the hot gh path stays cheap.

# _prnsg_is_selector_sub <sub> — rc 0 when the `gh pr` subcommand takes a PR
# selector positional (`{<number> | <url> | <branch>}`). create/list/status do
# NOT, so they are naturally exempt.
_prnsg_is_selector_sub() {
  case "${1-}" in
    view|diff|checks|checkout|close|comment|edit|lock|merge|ready|reopen|review|unlock|update-branch)
      return 0 ;;
  esac
  return 1
}

# _prnsg_in_project_worktree — rc 0 when the cwd is inside a PROJECT worktree (a
# fork checkout whose git common dir is NOT the garden's own $GARDEN_ROOT/.git);
# rc 1 for a garden worktree (root/journal/gardener-wt-*), no git repo, or any
# doubt. Read-only: a single `git rev-parse`. Fails toward rc 1 (ambiguous), the
# safe direction for the guard.
_prnsg_in_project_worktree() {
  local groot="${GARDEN_ROOT:-}"
  if [ -z "$groot" ]; then
    # Derive the garden root from this library's own location:
    # …/scripts/jobs/pr-numeric-scope-guard.sh → up two dirs.
    groot="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." 2>/dev/null && pwd -P)" || return 1
  fi
  local garden_git
  garden_git="$(cd "$groot/.git" 2>/dev/null && pwd -P)" || return 1
  [ -n "$garden_git" ] || return 1
  local common
  common="$(git rev-parse --git-common-dir 2>/dev/null)" || return 1
  [ -n "$common" ] || return 1
  common="$(cd "$common" 2>/dev/null && pwd -P)" || return 1
  # A project worktree's common dir is the fork's bare clone, never the garden's.
  [ "$common" != "$garden_git" ]
}

# pr_numeric_scope_guard_argv <argv...> — the wrapper hook. rc 0 = BLOCK (an
# ambiguous bare-numeric `gh pr` selector was positively detected and not
# overridden); the wrapper must refuse the call. rc 1 = passthrough (not a
# guardable shape, explicit repo/URL present, inside a project worktree, or
# override set). On a block it prints a loud, remedy-naming message to stderr.
# Never mutates argv.
pr_numeric_scope_guard_argv() {
  [ "${GARDEN_ALLOW_BARE_PR_NUMBER:-0}" = 1 ] && return 1
  [ "${1-}" = pr ] || return 1
  local sub="${2-}"
  _prnsg_is_selector_sub "$sub" || return 1

  local -a args=("${@:3}")
  local n="${#args[@]}" i=0
  local has_repo=0 has_url=0 bare_number=""
  while [ "$i" -lt "$n" ]; do
    local a="${args[$i]}"
    case "$a" in
      -R|--repo)     has_repo=1; i=$((i+1)) ;;   # -R and its value
      -R=*|--repo=*) has_repo=1 ;;
      # Value-bearing flags: consume flag + value so the value can never be
      # mistaken for the selector positional below. (The --flag=value forms fall
      # through to the -* boolean case, which is correct — they carry no separate
      # positional.)
      -q|--jq|-t|--template|-b|--body|-F|--body-file|-T|--title|-B|--base|-H|--head|\
      -a|--assignee|-l|--label|--add-label|--remove-label|--add-reviewer|--remove-reviewer|\
      --add-assignee|--remove-assignee|--add-project|--remove-project|--milestone|--json|\
      --author|--search|-L|--limit|--subject)
                     i=$((i+1)) ;;
      -*)            : ;;                          # boolean/unknown/--flag=value
      http://*|https://*)
                     has_url=1 ;;                  # explicit PR (or issue) URL
      *)
        # A bare positional. Treat a purely-numeric one (optionally #-prefixed) as
        # the ambiguous selector; a branch name (e.g. `51-foo`, `main`) is not.
        local cand="${a#\#}"
        case "$cand" in
          ''|*[!0-9]*) : ;;
          *)           [ -z "$bare_number" ] && bare_number="$a" ;;
        esac ;;
    esac
    i=$((i+1))
  done

  [ "$has_repo" -eq 1 ] && return 1   # explicit repository → unambiguous
  [ "$has_url" -eq 1 ] && return 1    # explicit PR URL → unambiguous
  [ -n "$bare_number" ] || return 1   # no bare-numeric selector → nothing to guard

  # A bare number, no repo, no URL: safe ONLY inside a project worktree.
  _prnsg_in_project_worktree && return 1

  local nhash="${bare_number#\#}"
  # shellcheck disable=SC2016  # backticks in the message are literal operator prose.
  printf 'gh-wrapper: ERROR kind:error REFUSING a bare-numeric `gh pr %s %s` with no explicit repository or PR URL, invoked OUTSIDE a project worktree. A bare PR number resolves against the cwd git remote (here the garden'\''s own repo, where issues and PRs share ONE number space) — the deadline-retirement requeue: `#%s` was an issue, so `gh pr` reported a nonexistent PullRequest and turned completed work into a handler failure. Re-issue with explicit scope: `gh pr %s %s -R <owner>/<repo>`, or a full PR URL (https://github.com/<owner>/<repo>/pull/%s). Override with GARDEN_ALLOW_BARE_PR_NUMBER=1 only if the repo is unambiguous by other means.\n' \
    "$sub" "$bare_number" "$nhash" "$sub" "$bare_number" "$nhash" >&2
  return 0
}
