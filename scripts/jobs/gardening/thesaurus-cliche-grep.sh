#!/bin/bash
# thesaurus-cliche-grep.sh — deterministic (no-LLM) detection of Botese (AI-slop
# cliché) phrases a change INTRODUCES, greped against the curated phrase list
# `skills/botese-normalization/cliches.tsv`. It is the pre-pass that COST-GATES the
# thesaurus jury seat (a `claude -p` runs ONLY when this finds at least one
# candidate) AND the terminating oracle of the deslopper's apply-then-re-grep loop
# (the loop stops only when this returns clean). It is a direct structural port of
# orthographer-divergence-grep.sh — the same deterministic-pre-pass-then-cost-gated-
# handler split — differing in ONE dimension: it matches curated MULTI-WORD PHRASES
# (a distinctive construction) rather than single whole words, because a Botese word
# ("seam", "load-bearing") is a cliché only in a specific collocation, not on its own.
#
# CANDIDATE LINES are the change's ADDED (`+`) lines from `git diff <base>...HEAD`,
# mapped to their line numbers in the NEW file. Each line is whitespace-normalized
# (runs of blanks collapsed to one space) so a phrase survives incidental spacing.
# For each added line and each row of cliches.tsv, a WHOLE-PHRASE, CASE-INSENSITIVE
# match of the `phrase` emits one candidate:
#   <path>:<line>: <phrase> [<category>] rewrite: <suggestion>
#
# WIDE NET, by design: it scans all added text lines regardless of whether the
# phrase sits in prose, a comment, a string, or a genuinely literal sentence — the
# literal-vs-cliché precision is the LLM seat's job, exactly the division of labor
# the orthographer/coverage-auditor seats use (cheap deterministic candidate set;
# LLM judgment on the candidates). Obvious non-prose paths (lockfiles, minified
# bundles, the phrase list itself) are skipped so they cannot self-trigger.
#
# EXIT / SIGNAL CONVENTION (the loop / seat gate keys on this):
#   check:  exit 0 -> at least one candidate  => DISPATCH the juror `claude -p`
#           exit 1 -> clean (zero candidates) OR no resolvable base => SKIP quietly
#           exit 2 -> CANNOT DETERMINE (no phrase list, no git): a LOUD stderr reason.
#   lines:  print each candidate as `<path>:<line>: <phrase> [<cat>] rewrite: <sug>`,
#           sorted; exit 0. Empty output when clean.
#   report: the `lines` list plus a trailing `summary: N candidate(s) across M
#           file(s)` count; exit 0.
#
# Usage: thesaurus-cliche-grep.sh <check|lines|report> <worktree> [base] [tsv]
#   base  diff base (default HEAD~1).
#   tsv   phrase list (default $GARDEN_CLICHES_TSV, else the skill's cliches.tsv).

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
: "${GARDEN_ROOT:=$(cd "$HERE/../../.." && pwd)}"

cmd="${1:?usage: thesaurus-cliche-grep.sh <check|lines|report> <worktree> [base] [tsv]}"
wt="${2:?worktree}"
base="${3:-HEAD~1}"
tsv="${4:-${GARDEN_CLICHES_TSV:-$GARDEN_ROOT/skills/botese-normalization/cliches.tsv}}"

case "$cmd" in
  check|lines|report) ;;
  *) echo "thesaurus-cliche-grep.sh: unknown subcommand '$cmd'" >&2; exit 2 ;;
esac

[ -r "$tsv" ] || { echo "thesaurus-cliche-grep.sh: no phrase list at $tsv" >&2; exit 2; }
command -v git  >/dev/null 2>&1 || { echo "thesaurus-cliche-grep.sh: git not found" >&2; exit 2; }
command -v awk  >/dev/null 2>&1 || { echo "thesaurus-cliche-grep.sh: awk not found" >&2; exit 2; }

# No resolvable base -> nothing to review (skip quietly), NOT an error.
git -C "$wt" rev-parse --verify -q "$base^{commit}" >/dev/null 2>&1 || {
  [ "$cmd" = check ] && exit 1
  exit 0
}

# Added (`+`) lines, as `<relpath>\t<new-file-line>\t<text>`. Parses the unified
# diff, tracking the NEW-file line counter from each hunk's `+<start>` header (same
# shape as orthographer-divergence-grep.sh's added_lines). Skips obvious non-prose
# paths so they cannot self-trigger the phrase list.
added_lines() {
  git -C "$wt" diff "$base...HEAD" -- 2>/dev/null | awk '
    /^\\ /     { next }                                          # "\ No newline at end of file"
    /^\+\+\+ / {
      path=$0; sub(/^\+\+\+ b\//,"",path); sub(/^\+\+\+ /,"",path)
      scan = 1
      if (path == "/dev/null") scan = 0
      # skip lockfiles, minified/generated bundles, and the phrase list itself
      if (path ~ /(^|\/)(yarn\.lock|package-lock\.json|pnpm-lock\.yaml|Cargo\.lock)$/) scan = 0
      if (path ~ /\.(min\.js|min\.css|map|snap)$/) scan = 0
      if (path ~ /(^|\/)cliches\.tsv$/) scan = 0
      next
    }
    /^@@/      { h=$0; sub(/^@@ -[0-9,]+ \+/,"",h); sub(/[, ].*/,"",h); newline=h+0; next }
    /^\+/      { if (scan && newline>0) { t=substr($0,2); print path "\t" newline "\t" t } newline++; next }
    /^-/       { next }                                          # removed: old-file only
    /^ /       { newline++; next }                               # context advances new-file
  '
}

# Emit candidates: for each added line, for each cliché phrase, whole-phrase
# case-insensitive match. Runs of whitespace in the line are collapsed to one space
# so incidental spacing does not defeat a multi-word phrase. The whole-phrase test
# uses a space-padded, case-folded copy of the line and requires non-alphanumeric
# neighbours at both ends of the match (a-z0-9 are the word chars), which keeps
# `seam where` from matching inside a larger token and lets `Load-Bearing Invariant`
# match `load-bearing invariant`.
candidates() {
  added_lines | awk -v tsvfile="$tsv" '
    BEGIN {
      FS="\t"
      while ((getline row < tsvfile) > 0) {
        if (row ~ /^#/ || row ~ /^[[:space:]]*$/) continue
        n = split(row, c, "\t")
        if (n < 3) continue
        cat = c[1]; ph = c[2]; sug = c[3]
        if (ph == "" || sug == "") continue
        idx++
        P[idx] = ph; S[idx] = sug; C[idx] = cat
        PL[idx] = tolower(ph)
      }
      close(tsvfile)
    }
    {
      path=$1; ln=$2; text=$3
      low = tolower(text)
      gsub(/[ \t]+/, " ", low)          # collapse whitespace runs to one space
      # pad so first/last chars have a non-word neighbour
      padded = " " low " "
      for (i=1; i<=idx; i++) {
        tok = PL[i]
        start = 1
        tl = length(tok)
        while ((p = index(substr(padded, start), tok)) > 0) {
          abs = start + p - 1
          before = substr(padded, abs-1, 1)
          after  = substr(padded, abs+tl, 1)
          if (before !~ /[a-z0-9]/ && after !~ /[a-z0-9]/) {
            printf "%s:%s: %s [%s] rewrite: %s\n", path, ln, P[i], C[i], S[i]
            break   # one hit per phrase per line is enough for the digest
          }
          start = abs + 1
        }
      }
    }
  ' | sort -u
}

out="$(candidates)"
count="$(printf '%s' "$out" | grep -c ':' || true)"
[ -z "$out" ] && count=0

case "$cmd" in
  check)
    [ "$count" -gt 0 ] && exit 0 || exit 1
    ;;
  lines)
    [ -n "$out" ] && printf '%s\n' "$out"
    exit 0
    ;;
  report)
    [ -n "$out" ] && printf '%s\n' "$out"
    files="$(printf '%s\n' "$out" | grep ':' | sed 's/:.*//' | sort -u | grep -c . || true)"
    [ -z "$out" ] && files=0
    printf 'summary: %s candidate(s) across %s file(s)\n' "$count" "$files"
    exit 0
    ;;
esac
