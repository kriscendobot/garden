#!/bin/bash
# assert-pinned-base.sh — the DETERMINISTIC merge-base-pinning sensor. A garden
# fork-side PR must target a FROZEN base snapshot (`<base>-<short-sha>`, e.g.
# `master-2708cac` / `llm-6beb4e5` / `main-abc1234`), never a floating trunk
# (`master` / `llm` / `main`). See skills/frozen-base-branch/SKILL.md.
#
# Why this exists — the `merge-base-pinning` review-miss cluster
# (review-misses/clusters/merge-base-pinning.md, count=4 across
# endojs/endo-but-for-bots #719/#831/#836): each PR reached maintainer review
# WITHOUT its merge base pinned to the frozen snapshot per standing instruction,
# so it entrained irrelevant commits or a stray artifact. The maintainer said the
# standing rule "may need to be reinforced." A standing instruction an agent can
# forget is not a gate; this is the gate that cannot forget.
#
# It names the two failure shapes the cluster records:
#   (1) FLOATING BASE — the PR's base is a bare `master`/`llm`/`main` instead of a
#       pinned `<base>-<sha>` snapshot (#836: "pin the llm branch base to llm-xxxx
#       by hash"; #719: the master-xxx pinned-base convention had not yet bound).
#       This is deterministically wrong: exit 5.
#   (2) WIDE ENTRAINED DELTA — the PR carries far more commits than its intended
#       delta, the tell of a rebase re-parented onto a moving branch (#831: "79
#       commits entrained, many irrelevant ... may need a restart from scratch").
#       This is a heuristic signal, not a proof: exit 6, for the caller to SURFACE
#       (a maintainer notice), not necessarily to hard-refuse.
#
# Subcommands:
#   name <base-branch>
#       Pure string check of a base-branch NAME (no network). This is the shape-(1)
#       gate ensure-pr.sh runs at PR-open time: a pinned name ends in `-<7..40 hex>`.
#       exit 0 pinned; exit 5 floating/unpinned.
#
#   pr <owner/repo> <pr-number>
#       Read the live PR's baseRefName and commit count with one `gh pr view`, then
#       apply BOTH checks. Shape (1): base name not pinned -> exit 5. Shape (2):
#       commit count > GARDEN_PIN_MAX_AHEAD (default 40) -> exit 6. A gh/parse
#       failure is INCONCLUSIVE -> exit 4 (the caller decides; never a silent pass
#       that reads as "pinned").
#
# Exit codes ARE the contract:
#   0  base is pinned (and, in `pr` mode, the entrained delta is within bounds)
#   4  INCONCLUSIVE — a gh read or parse failed; nothing was asserted
#   5  FLOATING/UNPINNED base — the shape-(1) miss; hard-wrong
#   6  WIDE ENTRAINED DELTA — the shape-(2) signal; a soft/surfacing verdict
#   2  usage error
#
# Env / test seams:
#   GARDEN_GH           the gh binary (a stub), resolved with the same
#                       stale-override-is-non-fatal guard as ensure-pr.sh.
#   GARDEN_PIN_MAX_AHEAD  the wide-delta threshold in `pr` mode (default 40).

set -uo pipefail

log() { echo "assert-pinned-base: $*" >&2; }
die() { log "$*"; exit 2; }

# A pinned base ends in `-<7..40 lowercase-hex>`: the `<base>-<short-sha>` snapshot
# shape (git's 7-char default through a full 40-char sha). A bare trunk name
# (`master`, `llm`, `main`) has no such suffix and fails — exactly the floating-base
# miss. A stacked PR's `<parent-head>-<sha>` base (frozen-base § Stacked PRs) also
# matches, so stacks are not false-flagged.
is_pinned() {  # is_pinned <base-branch-name>
  [[ "$1" =~ -[0-9a-f]{7,40}$ ]]
}

cmd_name() {
  local base="${1:-}"
  [ -n "$base" ] || die "usage: assert-pinned-base.sh name <base-branch>"
  if is_pinned "$base"; then
    return 0
  fi
  log "base '$base' is FLOATING (not a pinned <base>-<sha> snapshot) — skills/frozen-base-branch"
  exit 5
}

cmd_pr() {
  local repo="${1:-}" pr="${2:-}"
  [ -n "$repo" ] && [ -n "$pr" ] || die "usage: assert-pinned-base.sh pr <owner/repo> <pr-number>"

  # --- resolve the gh binary (stale GARDEN_GH override is non-fatal) ---------
  local GH="gh"
  if [ -n "${GARDEN_GH:-}" ]; then
    if [ -x "$GARDEN_GH" ] || command -v "$GARDEN_GH" >/dev/null 2>&1; then
      GH="$GARDEN_GH"
    else
      log "GARDEN_GH=$GARDEN_GH does not resolve; falling back to the PATH gh"
    fi
  fi
  command -v "$GH" >/dev/null 2>&1 || { log "gh not found — cannot read PR $repo#$pr"; exit 4; }
  command -v jq  >/dev/null 2>&1 || { log "jq not found — cannot read PR $repo#$pr"; exit 4; }

  local meta base commits
  meta="$("$GH" pr view "$pr" -R "$repo" --json baseRefName,commits 2>/dev/null)" \
    || { log "cannot read PR metadata for $repo#$pr (gh failed) — INCONCLUSIVE"; exit 4; }
  printf '%s' "$meta" | jq -e . >/dev/null 2>&1 \
    || { log "unparseable PR metadata for $repo#$pr — INCONCLUSIVE"; exit 4; }
  base="$(printf '%s' "$meta" | jq -r '.baseRefName // ""')"
  commits="$(printf '%s' "$meta" | jq -r '.commits | length')"
  [ -n "$base" ] || { log "PR $repo#$pr reports no baseRefName — INCONCLUSIVE"; exit 4; }

  # Shape (1): a floating base is deterministically wrong.
  if ! is_pinned "$base"; then
    log "$repo#$pr targets FLOATING base '$base' (not a pinned <base>-<sha> snapshot) — skills/frozen-base-branch"
    exit 5
  fi

  # Shape (2): a wide entrained delta is a heuristic tell of a moving-branch rebase.
  local max="${GARDEN_PIN_MAX_AHEAD:-40}"
  if [[ "$commits" =~ ^[0-9]+$ ]] && [ "$commits" -gt "$max" ]; then
    log "$repo#$pr carries $commits commits (> $max) on pinned base '$base' — possible entrained-delta from a moving-branch rebase (skills/frozen-base-branch, skills/rebase-hygiene-audit)"
    exit 6
  fi
  return 0
}

case "${1:-}" in
  name) shift; cmd_name "$@";;
  pr)   shift; cmd_pr "$@";;
  -h|--help)
    sed -n '2,/^set -/p' "$0" | sed '$d; s/^# \{0,1\}//'
    exit 0;;
  '')   die "usage: assert-pinned-base.sh {name <base-branch> | pr <owner/repo> <pr-number>}";;
  *)    die "unknown subcommand: '$1' (name | pr)";;
esac
