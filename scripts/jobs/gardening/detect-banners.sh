#!/bin/bash
# detect-banners.sh — deterministic (no-LLM) detector for comment BANNER RULES
# leaking into a proposed change. It scans the change's ADDED diff lines (the new
# decoration, not pre-existing context) for the banner shape defined in
# skills/no-comment-banners/SKILL.md: a code comment line whose body is nothing
# but a run of repeated rule characters used as a decorative separator.
#
# Why a third enforcement site: the banner rule is already enforced at generation
# (skills/pre-push-gates no-ascii-banners) and at review (the archivist juror).
# This gate catches a banner the moment it lands in a gardening diff, so the
# fixer can strip it before the panel ever sees it.
#
# Mirrors detect-home-coupling.sh's discipline:
#   * QUIET BY DESIGN in `check` mode: prints nothing; answers via exit status.
#       check: exit 0 -> banner added   exit 1 -> clean (path is quiet)
#   * FAVORS FALSE POSITIVES in what it matches: any added comment line that is a
#     4-or-more run of rule chars counts. It is cheaper to flag a borderline line
#     than to let a decorative rule land; the archivist juror is the backstop.
#
# We can only speak about NEW banners against a base: with no base ref (shallow
# clone, missing HEAD~1) there are no scannable added lines, so the honest, quiet
# answer is "no new banner" (exit 1) — the conditional fixer downstream is an LLM
# and must not be run on noise it cannot act on.
#
# Scope: only CODE files (js/ts/jsx/tsx/mjs/cjs). Markdown thematic breaks,
# fenced-code/data dashes, and directional-arrow prose ("foo -> bar") are NOT
# banners (skills/no-comment-banners SKILL.md, "What is not a banner") and never
# match — markdown is excluded by extension, and a rule run with any prose on the
# line fails the "nothing but rule chars" anchor.
#
# Subcommands:
#   check <worktree> [base]   exit 0 if a banner appears in an added line
#   lines <worktree> [base]   print each offending added line as `<path>: <text>`
#                             (consumed by handlers/banner-sweep-claude.sh)
#
# base defaults to HEAD~1.

set -uo pipefail
cmd="${1:?usage: detect-banners.sh <check|lines> <worktree> [base]}"; shift
wt="${1:?worktree}"; shift
base="${1:-HEAD~1}"

# A base we cannot resolve means we cannot isolate the ADDED lines; clean & quiet.
git -C "$wt" rev-parse --verify --quiet "$base^{commit}" >/dev/null 2>&1 || exit 1

# Emit each ADDED line (unified-diff `+`, never the `+++` file header) that is a
# banner rule, prefixed by the file it was added to. The added text is
# substr($0,2) to drop the leading `+`. Only code files are scanned; the rule-run
# is written as four explicit rule-char classes plus one (4+) so it needs no awk
# interval support, and the anchors demand the comment body be nothing but the
# run — prose on the line (a directional arrow, a sentence with a dash) fails it.
offending_lines() {
  git -C "$wt" diff "$base" -- 2>/dev/null | awk '
    /^\+\+\+ /{
      path=$0; sub(/^\+\+\+ b\//,"",path); sub(/^\+\+\+ /,"",path)
      iscode = (path ~ /\.(js|ts|jsx|tsx|mjs|cjs)$/)
      next
    }
    iscode && /^\+/ {
      text=substr($0,2)
      if (text ~ /^[ \t]*(\/\/|#|\*)[ \t]*[-=*~_][-=*~_][-=*~_][-=*~_]+[ \t]*$/ \
       || text ~ /\/\*[ \t]*[-=*~_][-=*~_][-=*~_][-=*~_]+[ \t]*\*\//)
        print path ": " text
    }
  '
}

case "$cmd" in
  check) [ -n "$(offending_lines)" ] && exit 0 || exit 1 ;;
  lines) offending_lines ;;
  *) echo "detect-banners.sh: unknown subcommand '$cmd'" >&2; exit 2 ;;
esac
