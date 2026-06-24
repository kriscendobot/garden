#!/bin/bash
# sense.sh — cheap heuristics that decide whether an automation is worth running.
#
# QUIET BY DESIGN: prints nothing; it answers only through exit status
#   exit 0 → "yes, run that automation"
#   exit 1 → "no, you can skip it"
# This keeps a supervising agent's context clean (see the gardening state machine
# design). It deliberately FAVORS FALSE POSITIVES over false negatives: on any
# ambiguity or error (shallow clone, missing base ref, git failure) it answers
# YES (exit 0), because running a wasted check is cheap but skipping a needed one
# before CI is not.
#
# Subcommands (each takes a worktree, then an optional base ref; default HEAD~1):
#   changed-glob <worktree> <glob>   [base]   a changed path matches <glob>?
#   changed-md   <worktree>          [base]   any Markdown changed?
#   diff-keyword <worktree> <keyword>[base]   <keyword> appears in the diff hunks?
#   any-change   <worktree>          [base]   any change at all?

set -uo pipefail
cmd="${1:?usage: sense.sh <changed-glob|changed-md|diff-keyword|any-change> <worktree> ...}"; shift
wt="${1:?worktree}"; shift

# resolve a usable base ref; if HEAD~1 doesn't exist, we cannot diff → assume YES
have_base() { git -C "$wt" rev-parse --verify --quiet "$1^{commit}" >/dev/null 2>&1; }

names_changed() {  # prints changed paths vs base, or nothing
  local base="$1"
  git -C "$wt" diff --name-only "$base" 2>/dev/null
}

case "$cmd" in
  changed-glob)
    glob="${1:?glob}"; base="${2:-HEAD~1}"
    have_base "$base" || exit 0
    while IFS= read -r p; do [ -n "$p" ] || continue; case "$p" in $glob) exit 0;; esac; done < <(names_changed "$base")
    exit 1 ;;
  changed-md)
    base="${1:-HEAD~1}"
    have_base "$base" || exit 0
    while IFS= read -r p; do case "$p" in *.md|*.markdown|*.mdx) exit 0;; esac; done < <(names_changed "$base")
    exit 1 ;;
  diff-keyword)
    kw="${1:?keyword}"; base="${2:-HEAD~1}"
    have_base "$base" || exit 0
    if git -C "$wt" diff "$base" 2>/dev/null | grep -E '^[+-]' | grep -qF -- "$kw"; then exit 0; fi
    exit 1 ;;
  any-change)
    base="${1:-HEAD~1}"
    have_base "$base" || exit 0
    git -C "$wt" diff --quiet "$base" 2>/dev/null && exit 1 || exit 0 ;;
  *)
    echo "sense.sh: unknown subcommand '$cmd'" >&2; exit 0 ;;  # unknown → assume YES
esac
