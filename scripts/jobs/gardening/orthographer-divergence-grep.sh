#!/bin/bash
# orthographer-divergence-grep.sh — deterministic (no-LLM) detection of British
# spellings a change INTRODUCES, greped against the curated word list
# `skills/american-english-normalization/divergences.tsv`. It is the pre-pass that
# COST-GATES the orthographer jury seat (a `claude -p` runs ONLY when this finds at
# least one candidate) AND the terminating oracle of the americanizer's apply-then-
# re-grep loop (the loop stops only when this returns clean). It is the SAME
# deterministic-pre-pass-then-cost-gated-handler split the coverage-auditor uses:
# `coverage-auditor-coverage-diff.sh` is the pre-pass, `seat-gate-coverage-auditor.sh`
# is the gate. Here `orthographer-divergence-grep.sh` is the pre-pass and
# `seat-gate-orthographer.sh` is the gate.
#
# CANDIDATE LINES are the change's ADDED (`+`) lines from `git diff <base>...HEAD`,
# mapped to their line numbers in the NEW file. For each added line and each row of
# divergences.tsv, a WHOLE-WORD, CASE-INSENSITIVE match of the `british` token
# emits one candidate: `<path>:<line>: <british> -> <american> [category]`.
#
# WIDE NET, by design: it scans all added text lines regardless of whether the
# token sits in prose, a comment, a string, or an identifier — the identifier-vs-
# prose-vs-quoted-text precision is the LLM seat's job, exactly the division of
# labor the coverage-auditor uses (cheap deterministic candidate set; LLM judgment
# on the candidates). Obvious non-prose paths (lockfiles, minified bundles, the
# word list itself) are skipped so they cannot self-trigger.
#
# EXIT / SIGNAL CONVENTION (the loop / seat gate keys on this):
#   check:  exit 0 -> at least one candidate  => DISPATCH the juror `claude -p`
#           exit 1 -> clean (zero candidates) OR no resolvable base => SKIP quietly
#           exit 2 -> CANNOT DETERMINE (no word list, no git): a LOUD stderr reason.
#   lines:  print each candidate as `<path>:<line>: <british> -> <american> [cat]`,
#           sorted; exit 0. Empty output when clean.
#   report: the `lines` list plus a trailing `summary: N candidate(s) across M
#           file(s)` count; exit 0.
#
# Usage: orthographer-divergence-grep.sh <check|lines|report> <worktree> [base] [tsv]
#   base  diff base (default HEAD~1).
#   tsv   word list (default $GARDEN_DIVERGENCES_TSV, else the skill's
#         divergences.tsv).

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
: "${GARDEN_ROOT:=$(cd "$HERE/../../.." && pwd)}"

cmd="${1:?usage: orthographer-divergence-grep.sh <check|lines|report> <worktree> [base] [tsv]}"
wt="${2:?worktree}"
base="${3:-HEAD~1}"
tsv="${4:-${GARDEN_DIVERGENCES_TSV:-$GARDEN_ROOT/skills/american-english-normalization/divergences.tsv}}"

case "$cmd" in
  check|lines|report) ;;
  *) echo "orthographer-divergence-grep.sh: unknown subcommand '$cmd'" >&2; exit 2 ;;
esac

[ -r "$tsv" ] || { echo "orthographer-divergence-grep.sh: no word list at $tsv" >&2; exit 2; }
command -v git  >/dev/null 2>&1 || { echo "orthographer-divergence-grep.sh: git not found" >&2; exit 2; }
command -v awk  >/dev/null 2>&1 || { echo "orthographer-divergence-grep.sh: awk not found" >&2; exit 2; }

# No resolvable base -> nothing to review (skip quietly), NOT an error.
git -C "$wt" rev-parse --verify -q "$base^{commit}" >/dev/null 2>&1 || {
  [ "$cmd" = check ] && exit 1
  exit 0
}

# Added (`+`) lines, as `<relpath>\t<new-file-line>\t<text>`. Parses the unified
# diff, tracking the NEW-file line counter from each hunk's `+<start>` header
# (same shape as coverage-auditor-coverage-diff.sh's added_lines). Skips obvious
# non-prose paths so they cannot self-trigger the word list.
added_lines() {
  git -C "$wt" diff "$base...HEAD" -- 2>/dev/null | awk '
    /^\\ /     { next }                                          # "\ No newline at end of file"
    /^\+\+\+ / {
      path=$0; sub(/^\+\+\+ b\//,"",path); sub(/^\+\+\+ /,"",path)
      scan = 1
      if (path == "/dev/null") scan = 0
      # skip lockfiles, minified/generated bundles, and the word list itself
      if (path ~ /(^|\/)(yarn\.lock|package-lock\.json|pnpm-lock\.yaml|Cargo\.lock)$/) scan = 0
      if (path ~ /\.(min\.js|min\.css|map|snap)$/) scan = 0
      if (path ~ /(^|\/)divergences\.tsv$/) scan = 0
      next
    }
    /^@@/      { h=$0; sub(/^@@ -[0-9,]+ \+/,"",h); sub(/[, ].*/,"",h); newline=h+0; next }
    /^\+/      { if (scan && newline>0) { t=substr($0,2); print path "\t" newline "\t" t } newline++; next }
    /^-/       { next }                                          # removed: old-file only
    /^ /       { newline++; next }                               # context advances new-file
  '
}

# Emit candidates: for each added line, for each british token, whole-word
# case-insensitive match. One output line per (path,line,token) occurrence.
# The whole-word test is done in awk with a case-folded copy of the line and a
# space-padded scan so token boundaries are non-alphanumeric (a-z0-9 word chars),
# which keeps `colour` from matching inside `colourfulness` unless that is its own
# row, and lets `serialise` match `Serialise`/`SERIALISE`.
candidates() {
  added_lines | awk -v tsvfile="$tsv" '
    BEGIN {
      FS="\t"
      while ((getline row < tsvfile) > 0) {
        if (row ~ /^#/ || row ~ /^[[:space:]]*$/) continue
        n = split(row, c, "\t")
        if (n < 3) continue
        br = c[2]; am = c[3]; cat = c[1]
        if (br == "" || am == "") continue
        idx++
        B[idx] = br; A[idx] = am; C[idx] = cat
        BL[idx] = tolower(br)
      }
      close(tsvfile)
    }
    {
      path=$1; ln=$2; text=$3
      low = tolower(text)
      # pad so first/last chars have a non-word neighbor
      padded = " " low " "
      for (i=1; i<=idx; i++) {
        tok = BL[i]
        # scan every occurrence of tok in padded, requiring non-alnum boundaries
        start = 1
        tl = length(tok)
        while ((p = index(substr(padded, start), tok)) > 0) {
          abs = start + p - 1
          before = substr(padded, abs-1, 1)
          after  = substr(padded, abs+tl, 1)
          if (before !~ /[a-z0-9]/ && after !~ /[a-z0-9]/) {
            printf "%s:%s: %s -> %s [%s]\n", path, ln, B[i], A[i], C[i]
            break   # one hit per token per line is enough for the digest
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
