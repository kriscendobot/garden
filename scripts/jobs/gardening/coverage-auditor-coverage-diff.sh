#!/bin/bash
# coverage-auditor-coverage-diff.sh — deterministic (no-LLM) computation of the
# UNCOVERED NEW LINES a change introduces, from a c8 (Istanbul) coverage report.
# It is the pre-pass that COST-GATES the coverage-auditor jury seat: the seat's
# `claude -p` runs ONLY when this script finds at least one uncovered new line.
#
# NEW LINES are the change's ADDED (`+`) lines from `git diff <base>...HEAD`,
# mapped to their line numbers in the NEW file (the merge-base diff the gardening
# panel already computes). COVERAGE comes from c8's machine-readable Istanbul JSON
# (`coverage/coverage-final.json`): per file a `statementMap` (each statement's
# line range) and `s` (each statement's hit count).
#
# The covered/uncovered/N-A decision per added line mirrors Istanbul's own
# `getLineCoverage` exactly: line coverage keys on each statement's START line and
# takes the MAX hit count among statements starting on that line. So for an added
# line L in a file that HAS a coverage entry:
#   * L is a statement-start with max-hits == 0  -> UNCOVERED (reported).
#   * L is a statement-start with max-hits  > 0  -> covered (silent).
#   * L is NOT a statement-start (blank, comment, type-only, decl-only, or a line
#     inside a multi-line statement)            -> N/A, NOT "uncovered" (silent).
# A file with no coverage entry at all is N/A (not scanned): c8 has already applied
# the repo's coverage-config excludes when emitting the report, so generated,
# vendored, and config-excluded files simply do not appear — keying off "present in
# the report" gives us the repo's exclusion semantics for free. NON-code paths are
# likewise skipped by extension.
#
# CAVEAT (stated loudly, never failed-open silently): a brand-new source file that
# is ENTIRELY untested only appears in the report — with all statements at zero
# hits, so every executable added line is flagged — when c8 is run with `--all`
# (`all: true`). Without `--all` such a file is absent from the report and treated
# as N/A here; run c8 with `--all` so wholly-untested new files are represented,
# and the coverage-auditor seat's semantic read of the diff is the backstop.
#
# EXIT / SIGNAL CONVENTION (the loop / seat gate keys on this):
#   check:  exit 0 -> uncovered new lines present  => DISPATCH the juror `claude -p`
#           exit 1 -> clean (zero uncovered) OR no resolvable base (nothing to
#                     review) => SKIP the juror entirely (quiet)
#           exit 2 -> CANNOT DETERMINE (no coverage report, or no jq): a LOUD
#                     stderr reason, never the silent "covered" answer. The seat
#                     gate surfaces this as a comment-only block.
#   lines:  print each uncovered new line as `<path>:<line>` (the digest handed to
#           the juror), sorted; exit 0. Empty output when clean.
#   report: the `lines` list plus a trailing `summary: N uncovered new line(s)
#           across M file(s)` count; exit 0.
#
# Usage: coverage-auditor-coverage-diff.sh <check|lines|report> <worktree> [base] [coverage-json]
#   base          diff base (default HEAD~1).
#   coverage-json c8 report path (default $GARDEN_COVERAGE_JSON, else
#                 <worktree>/coverage/coverage-final.json).

set -uo pipefail

cmd="${1:?usage: coverage-auditor-coverage-diff.sh <check|lines|report> <worktree> [base] [coverage-json]}"
wt="${2:?worktree}"
base="${3:-HEAD~1}"
cov="${4:-${GARDEN_COVERAGE_JSON:-$wt/coverage/coverage-final.json}}"

case "$cmd" in
  check|lines|report) ;;
  *) echo "coverage-auditor-coverage-diff.sh: unknown subcommand '$cmd'" >&2; exit 2 ;;
esac

have_base() { git -C "$wt" rev-parse --verify --quiet "$base^{commit}" >/dev/null 2>&1; }

# Added (`+`) lines of CODE files, as `<relpath>\t<new-file-line>`. Parses the
# unified diff, tracking the NEW-file line counter from each hunk's `+<start>`
# header: a `+` line prints and advances it, a context line advances it, a `-`
# line does not. The `+++ ` file header is matched (and `next`-ed) before the
# generic `+` rule so it is never mistaken for an added line.
added_lines() {
  git -C "$wt" diff "$base...HEAD" -- 2>/dev/null | awk '
    /^\\ /            { next }                                   # "\ No newline at end of file"
    /^\+\+\+ /        {
      path=$0; sub(/^\+\+\+ b\//,"",path); sub(/^\+\+\+ /,"",path)
      iscode = (path ~ /\.(js|ts|jsx|tsx|mjs|cjs)$/)
      next
    }
    /^@@/             {
      h=$0; sub(/^@@ -[0-9,]+ \+/,"",h); sub(/[, ].*/,"",h); newline=h+0; next
    }
    /^\+/             { if (iscode && newline>0) print path "\t" newline; newline++; next }
    /^-/              { next }                                   # removed: old-file only
    /^ /              { newline++; next }                        # context advances new-file
  '
}

# Per-line max hit count from the c8 report, as `<relpath>\t<line>\t<hits>`.
# jq emits one tuple per statement (abs-path, statement start line, hit count);
# the abs path is normalised to repo-relative by stripping the worktree prefix.
line_hits_json() {
  jq -r '
    to_entries[]
    | .value as $c
    | (($c.path) // .key) as $p
    | ($c.s) as $s
    | ($c.statementMap | to_entries[])
    | [$p, (.value.start.line|tostring), ((($s[.key]) // 0)|tostring)] | @tsv
  ' "$cov"
}

# The uncovered new lines: added code lines that ARE a statement-start (executable)
# whose max hit count is 0. First stream (coverage tuples) builds the hit map; the
# second stream (added lines) is tested against it. Both are TSV.
uncovered_new_lines() {
  awk -F'\t' -v wt="$wt" '
    FNR==NR {
      rp=$1; pfx=wt "/"
      if (index(rp, pfx)==1) rp=substr(rp, length(pfx)+1)
      key=rp SUBSEP $2; h=$3+0
      if (!(key in hit) || h>hit[key]) hit[key]=h      # Istanbul getLineCoverage: max per line
      execline[key]=1
      next
    }
    {
      key=$1 SUBSEP $2
      if ((key in execline) && hit[key]==0) print $1 ":" $2
    }
  ' <(line_hits_json) <(added_lines) | sort -t: -k1,1 -k2,2n
}

# --- guards: never fail open silently as "covered" --------------------------
# No resolvable base => cannot isolate added lines => nothing to review. This is a
# SKIP with a stated reason, not a "covered" verdict (there are genuinely no
# visible added lines to judge).
if ! have_base; then
  echo "coverage-auditor-coverage-diff: base '$base' does not resolve; no added lines to check (skip)" >&2
  [ "$cmd" = "report" ] && echo "summary: 0 uncovered new line(s) across 0 file(s)"
  exit 1
fi

# No jq / no coverage report => CANNOT DETERMINE. Loud on stderr, exit 2 — the seat
# gate turns this into a surfaced comment-only block, never a silent "covered".
if ! command -v jq >/dev/null 2>&1; then
  echo "coverage-auditor-coverage-diff: jq not on PATH; cannot parse the c8 report — NOT assuming covered" >&2
  exit 2
fi
if [ ! -s "$cov" ]; then
  echo "coverage-auditor-coverage-diff: no c8 coverage report at '$cov' (run c8 with --all --reporter=json, or set GARDEN_COVERAGE_JSON); cannot verify new-line coverage — NOT assuming covered" >&2
  exit 2
fi

result="$(uncovered_new_lines)"

case "$cmd" in
  check)
    [ -n "$result" ] && exit 0 || exit 1 ;;
  lines)
    [ -n "$result" ] && printf '%s\n' "$result"
    exit 0 ;;
  report)
    if [ -z "$result" ]; then
      n=0; files=0
    else
      n=$(printf '%s\n' "$result" | grep -c .)
      files=$(printf '%s\n' "$result" | sed 's/:.*//' | sort -u | grep -c .)
      printf '%s\n' "$result"
    fi
    echo "summary: $n uncovered new line(s) across $files file(s)"
    exit 0 ;;
esac
