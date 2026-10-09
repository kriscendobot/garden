#!/bin/bash
# gauntlet-mustfix-summary.sh — render a bounded, deterministic (no-LLM) summary of
# the must-fix requests a gauntlet left UNADDRESSED when it ended early
# (review-budget-reached / halted / parked-ci-billing), so the maintainer can decide
# whether to add review budget and resume. gauntlet.sh appends the output to its
# terminal PR status comment.
#
# Usage: gauntlet-mustfix-summary.sh <journal-dir> <gauntlet-base> <last-round> [max-iterations]
#
# Input: the panel stage reports `jobs/tada/**/<base>-panel-<k>.md` for k=1..last
# round, and the fix reports `<base>-fix-<k>.md` (cost only). From each panel report
# it reads the LAST `must-fix items (N):` block (panel-run-record.sh's shape),
# whose bullets are `- <seat>: <text>` (or a bare `- <text>`). max-iterations, when
# omitted, is read from the gauntlet's own tada report frontmatter.
#
# An item's identity across rounds is <seat> + its text lowercased with everything
# but [a-z0-9] removed (first 80 chars) — exact-ish matching only; a reworded
# finding counts as a new one (designs/gauntlet-panel-fix-nonconvergence.md: the
# findings set moves round to round, and this summary makes that visible).
#
# Per-item class (items in the LAST round are the unaddressed ones):
#   persistent  — present in 2+ rounds, unbroken through the last round
#   reintroduced— present in 2+ rounds with a gap (addressed, then raised again)
#   new         — present only in the last round
# Per-round trend: raised = items in round k; carried = also in round k-1;
#   fixed = in round k-1 but not in round k.
# Verdict (first rule that matches; L = last-round item count):
#   1. L = 0                                   → converging (nothing outstanding)
#   2. persistent > 0 and 2*persistent >= L    → stuck on <persistent> persistent items
#   3. L < the previous round's count          → converging (shrinking)
#   4. otherwise (incl. a single round)        → moving target
#
# Must-fix text is untrusted DATA (an LLM seat wrote it, quoting PR content): control
# characters, backticks, and the markdown that can forge headings, links, images,
# HTML, or tables are stripped, `@` is defused, each item is truncated, the list is
# capped, and the whole list is emitted inside a fenced ```text block.
#
# Fail-soft: never exits non-zero. A report without a parseable bullet list yields
# the count line (when present) plus "list unavailable".
set -u

dir="${1:-}"; base="${2:-}"; last="${3:-}"; max="${4:-}"
MAX_ITEMS="${GARDEN_MUSTFIX_SUMMARY_MAX_ITEMS:-12}"
MAX_TEXT="${GARDEN_MUSTFIX_SUMMARY_MAX_TEXT:-160}"
TADA="$dir/jobs/tada"

find_report() {  # <base> → path or empty
  find "$TADA" -mindepth 1 -type f -name "$1.md" -print -quit 2>/dev/null
}

case "$last" in ''|*[!0-9]*|0) exit 0;; esac
[ -d "$TADA" ] || exit 0
if ! [[ "$max" =~ ^[0-9]+$ ]]; then
  own="$(find_report "$base")"
  max=""
  [ -n "$own" ] && max="$(sed -nE 's/^[[:space:]]*max_iterations:[[:space:]]*([0-9]+).*/\1/p' "$own" | head -1)"
fi

# Gather "<round>\t<raw-line>" records for every panel round, and cost.
recs="$(mktemp "${TMPDIR:-/tmp}/gauntlet-mustfix.XXXXXX")"
trap 'rm -f "$recs"' EXIT
cost_files=()
for k in $(seq 1 "$last"); do
  p="$(find_report "$base-panel-$k")"
  f="$(find_report "$base-fix-$k")"
  [ -n "$f" ] && cost_files+=("$f")
  [ -n "$p" ] || { printf '%s\tMISSING\n' "$k" >> "$recs"; continue; }
  cost_files+=("$p")
  # Last `must-fix items (N):` block: header, then the contiguous `- ` bullets.
  awk -v k="$k" '
    /^must-fix items \([0-9]+\):/ { n=0; hdr=$0; inb=1; next }
    inb && /^- / { b[++n]=$0; next }
    { inb=0 }
    END {
      if (hdr == "") { printf "%s\tNOHDR\n", k; exit }
      c=hdr; sub(/^must-fix items \(/, "", c); sub(/\).*/, "", c)
      printf "%s\tCOUNT\t%s\n", k, c
      for (i=1; i<=n; i++) printf "%s\tITEM\t%s\n", k, b[i]
    }' "$p" >> "$recs" 2>/dev/null || printf '%s\tNOHDR\n' "$k" >> "$recs"
done

cost=""
if [ "${#cost_files[@]}" -gt 0 ]; then
  cost="$(sed -nE 's/^- Cost: \$([0-9]+(\.[0-9]+)?).*/\1/p' "${cost_files[@]}" 2>/dev/null \
    | awk '{s+=$1; n++} END{if(n) printf "$%.2f", s}')"
fi

awk -F'\t' -v last="$last" -v max="$max" -v cost="$cost" \
    -v maxitems="$MAX_ITEMS" -v maxtext="$MAX_TEXT" '
  function clean(s,   t) {
    gsub(/[\001-\037\177]/, " ", s)
    gsub(/[`<>\[\]|*~!]/, "", s)
    gsub(/@/, "(at)", s)
    sub(/^[[:space:]#>=-]+/, "", s)
    gsub(/[[:space:]]+/, " ", s); sub(/ $/, "", s)
    if (length(s) > maxtext) s = substr(s, 1, maxtext - 1) "…"
    return s
  }
  function key(seat, text,   t) {
    t = tolower(text); gsub(/[^a-z0-9]/, "", t)
    return seat "|" substr(t, 1, 80)
  }
  $2 == "MISSING" || $2 == "NOHDR" { bad[$1] = 1; next }
  $2 == "COUNT" { cnt[$1] = $3 + 0; hascnt[$1] = 1; next }
  $2 == "ITEM" {
    r = $1 + 0; line = $3; sub(/^- /, "", line)
    seat = ""
    if (match(line, /^[A-Za-z0-9][A-Za-z0-9_.-]*: /)) {
      seat = substr(line, 1, RLENGTH - 2); line = substr(line, RLENGTH + 1)
    }
    kk = key(seat, line)
    if (!((r, kk) in in_r)) {
      in_r[r, kk] = 1; nr[r]++
      if (r == last + 0 && !(kk in lastseen)) {
        lastseen[kk] = 1; order[++nlast] = kk
        lseat[kk] = clean(seat); ltext[kk] = line
      }
    }
  }
  END {
    L = last + 0
    head = "Unaddressed must-fix"
    rounds = "rounds spent: " L (max != "" ? "/" max : "")
    costpart = (cost != "" ? " · cost so far: " cost : "")
    if (bad[L] || (hascnt[L] && cnt[L] > 0 && nr[L] == 0)) {
      c = (hascnt[L] ? cnt[L] "" : "unknown")
      printf "%s: %s · list unavailable (panel report has no structured must-fix list) · %s%s\n", head, c, rounds, costpart
      exit
    }
    npers = nnew = nre = 0
    for (i = 1; i <= nlast; i++) {
      kk = order[i]; first = 0; gap = 0; seen = 0
      for (r = 1; r <= L; r++) {
        if ((r, kk) in in_r) { if (!first) first = r; seen++ }
        else if (first) gap = 1
      }
      if (seen < 2) { cls[kk] = "new"; nnew++ }
      else if (gap) { cls[kk] = "reintroduced"; nre++ }
      else { cls[kk] = "persistent"; npers++ }
      firstr[kk] = first
    }
    if (nlast == 0) verdict = "converging"
    else if (npers > 0 && 2 * npers >= nlast) verdict = "stuck on " npers " persistent item" (npers == 1 ? "" : "s")
    else if (L > 1 && !bad[L - 1] && nlast < nr[L - 1] + 0) verdict = "converging"
    else verdict = "moving target"
    printf "**%s: %d** · verdict: %s · %s%s\n", head, nlast, verdict, rounds, costpart
    trend = "Trend:"
    for (r = 1; r <= L; r++) {
      if (bad[r]) { trend = trend " r" r " n/a;"; continue }
      fixed = carried = 0
      if (r > 1 && !bad[r - 1]) {
        for (pk in in_r) {
          split(pk, sp, SUBSEP)
          if (sp[1] + 0 != r - 1) continue
          if ((r, sp[2]) in in_r) carried++; else fixed++
        }
        trend = trend sprintf(" r%d raised %d (fixed %d, carried %d);", r, nr[r] + 0, fixed, carried)
      } else trend = trend sprintf(" r%d raised %d;", r, nr[r] + 0)
    }
    sub(/;$/, "", trend); print trend
    printf "Classes: %d persistent, %d new in last round, %d addressed-then-reintroduced\n", npers, nnew, nre
    if (nlast == 0) exit
    print "```text"
    for (i = 1; i <= nlast && i <= maxitems + 0; i++) {
      kk = order[i]
      loc = ""
      if (match(ltext[kk], /[A-Za-z0-9_.\/-]+\.[A-Za-z0-9]+:[0-9]+/)) loc = "(" clean(substr(ltext[kk], RSTART, RLENGTH)) ") "
      printf "[%s, since r%d] %s%s%s\n", cls[kk], firstr[kk], (lseat[kk] != "" ? lseat[kk] ": " : ""), loc, clean(ltext[kk])
    }
    if (nlast > maxitems + 0) printf "… and %d more\n", nlast - maxitems
    print "```"
  }' "$recs"
exit 0
