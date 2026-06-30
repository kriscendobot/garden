#!/bin/bash
# detect-home-coupling.sh — deterministic (no-LLM) detector for the developer's
# home directory leaking into a proposed change. It scans the change's ADDED diff
# lines (the new coupling, not pre-existing context) for the CURRENT user's home
# directory taken DYNAMICALLY from $HOME.
#
# Why dynamic, never a literal: a hardcoded `/home/<someone>` is the exact
# coupling this guards against — a path that is true on one contributor's
# workstation and wrong on the next. So this script (and every file the feature
# adds) reads $HOME at run time and contains no hardcoded home path; it stays
# clean under its own check.
#
# Mirrors sense.sh's discipline:
#   * QUIET BY DESIGN in `check` mode: prints nothing; answers via exit status.
#       check: exit 0 → coupling found   exit 1 → clean (path is quiet)
#   * FAVORS FALSE POSITIVES in what it matches: any added line that contains the
#     home path as a substring counts (comments and banners included). It is
#     cheaper to flag a borderline line than to let workstation coupling land.
#
# We can only speak about NEW coupling against a base: with no base ref (shallow
# clone, missing HEAD~1) or an empty/'/' $HOME there are no scannable added lines,
# so the honest, quiet answer is "no new coupling" (exit 1) — the conditional
# fixer downstream is an LLM and must not be run on noise it cannot act on.
#
# Subcommands:
#   check <worktree> [base]   exit 0 if the home dir appears in an added line
#   lines <worktree> [base]   print each offending added line as `<path>: <text>`
#                             (consumed by handlers/portability-coupling-claude.sh)
#
# base defaults to HEAD~1.

set -uo pipefail
cmd="${1:?usage: detect-home-coupling.sh <check|lines> <worktree> [base]}"; shift
wt="${1:?worktree}"; shift
base="${1:-HEAD~1}"

home="${HOME:-}"
# An empty or root $HOME is meaningless to match on — nothing to catch, stay quiet.
case "$home" in ""|/) exit 1;; esac

# A base we cannot resolve means we cannot isolate the ADDED lines; clean & quiet.
git -C "$wt" rev-parse --verify --quiet "$base^{commit}" >/dev/null 2>&1 || exit 1

# Emit each added line (unified-diff `+`, never the `+++` file header) that
# contains the home path, prefixed by the file it was added to. The added text is
# substr($0,2) to drop the leading `+`.
offending_lines() {
  git -C "$wt" diff "$base" -- 2>/dev/null | awk -v home="$home" '
    /^\+\+\+ /{ path=$0; sub(/^\+\+\+ b\//,"",path); sub(/^\+\+\+ /,"",path); next }
    /^\+/ && index($0, home) > 0 { print path ": " substr($0,2) }
  '
}

case "$cmd" in
  check) [ -n "$(offending_lines)" ] && exit 0 || exit 1 ;;
  lines) offending_lines ;;
  *) echo "detect-home-coupling.sh: unknown subcommand '$cmd'" >&2; exit 2 ;;
esac
