#!/bin/bash
# detect-banners.sh — deterministic (no-LLM) detector for comment BANNER RULES
# leaking into a proposed change. It scans the change's ADDED diff lines (the new
# decoration, not pre-existing context) for the banner shape defined in
# skills/no-comment-banners/SKILL.md: a code comment line whose body is nothing
# but a run of repeated rule characters used as a decorative separator, or whose
# body is a title bracketed by runs of 2+ rule characters on BOTH sides
# (`// --- Section title ---`, `# === Title ===`), or any comment line that draws
# with Unicode box-drawing or block-element characters (U+2500..U+259F: a title
# bracketed by U+2500 rules, or a shell box drawn with corners U+250C/U+2510/
# U+2514/U+2518 and sides U+2502). This file names those glyphs by code point
# rather than drawing them, so it stays clean under its own scan.
#
# This is a deterministic panel pre-pass. A hit forces the archivist juror into
# even a trimmed code panel and hands it the offending lines as review evidence;
# the normal disposition and fixer loop decides what happens next. The detector
# does not edit the proposed change.
#
# Mirrors detect-home-coupling.sh's discipline:
#   * QUIET BY DESIGN in `check` mode: prints nothing; answers via exit status.
#       check: exit 0 -> banner added   exit 1 -> clean (path is quiet)
#   * FAVORS FALSE POSITIVES in what it matches: any added comment line that is a
#     4-or-more run of rule chars (`-=*~_`, plus `#`, `/`, `+` for the
#     `##########`, `//////////`, and `+------+` shapes) counts, as does any title
#     bracketed by 2-or-more `-=*~_` runs on both sides, and any comment carrying a
#     single box-drawing or block-element character. It is cheaper to flag a
#     borderline line than to let a decorative rule land; the archivist juror
#     judges the result.
#
# We can only speak about NEW banners against a base: with no base ref (shallow
# clone, missing HEAD~1) there are no scannable added lines, so the honest, quiet
# answer is "no new banner" (exit 1), so the panel does not force an extra seat on
# evidence it cannot establish.
#
# Scope: only CODE files (js/ts/jsx/tsx/mjs/cjs and sh/bash). Markdown thematic
# breaks, fenced-code/data dashes, and directional-arrow prose ("foo -> bar") are NOT
# banners (skills/no-comment-banners SKILL.md, "What is not a banner") and never
# match — markdown is excluded by extension, and a rule run with any prose on the
# line fails the "nothing but rule chars" anchor. The bracketed-title shape needs
# a rule run anchored at BOTH ends of the comment body, separated from the title
# by whitespace, so `// foo -- bar` (no leading run), `// a -> b`, and JSDoc
# `* **bold**` emphasis (no whitespace inside the runs) do not match.
#
# Subcommands:
#   check <worktree> [base]   exit 0 if a banner appears in an added line
#   lines <worktree> [base]   print each offending added line as `<path>: <text>`
#                             (consumed by the panel's archivist pre-pass)
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
# The bracketed-title form (`// --- title ---`) is two 2+ runs anchored at the
# ends of the comment body with a whitespace-separated title between them; the
# title must start with a non-rule character. Box-drawing (U+2500..U+257F) and
# block elements (U+2580..U+259F) are UTF-8 `E2 94 xx`, `E2 95 xx`, `E2 96 80..9F`;
# awk runs under LC_ALL=C and matches those bytes, so mawk and gawk agree. Any one
# such character after a comment introducer (`//` or `/*` anywhere, `#` or `*` at
# line start) is a hit: these glyphs only ever draw rules, boxes, or line-art.
offending_lines() {
  git -C "$wt" diff "$base" -- 2>/dev/null | LC_ALL=C awk '
    /^\+\+\+ /{
      path=$0; sub(/^\+\+\+ b\//,"",path); sub(/^\+\+\+ /,"",path)
      iscode = (path ~ /\.(js|ts|jsx|tsx|mjs|cjs|sh|bash)$/)
      next
    }
    iscode && /^\+/ {
      text=substr($0,2)
      if (text ~ /^[ \t]*(\/\/|#|\*)[ \t]*[-=*~_#\/+][-=*~_#\/+][-=*~_#\/+][-=*~_#\/+]+[ \t]*$/ \
       || text ~ /\/\*[ \t]*[-=*~_][-=*~_][-=*~_][-=*~_]+[ \t]*\*\// \
       || text ~ /^[ \t]*(\/\/|#|\*)[ \t]*[-=*~_][-=*~_]+[ \t]+[^-=*~_ \t].*[ \t][-=*~_][-=*~_]+[ \t]*$/ \
       || text ~ /\/\*\*?[ \t]*[-=*~_][-=*~_]+[ \t]+[^-=*~_ \t].*[ \t][-=*~_][-=*~_]+[ \t]*\*\// \
       || text ~ /(^[ \t]*[#*]|\/\/|\/\*).*\342(\224[\200-\277]|\225[\200-\277]|\226[\200-\237])/)
        print path ": " text
    }
  '
}

case "$cmd" in
  check) [ -n "$(offending_lines)" ] && exit 0 || exit 1 ;;
  lines) offending_lines ;;
  *) echo "detect-banners.sh: unknown subcommand '$cmd'" >&2; exit 2 ;;
esac
