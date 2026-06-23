#!/bin/bash
# sentence-per-line-md — markdown files use sentence-per-line shape (each
# sentence on its own physical line). Reject lines outside of code blocks that
# carry multiple sentences.
# Provenance: PR #75 r3270500584 + per-repo CONTRIBUTING.md style guide.
#
# Sentence detection is simple: a line that contains `. ` (period-space)
# followed by a capital letter, or `? ` / `! ` followed by capital, outside
# of fenced code blocks. False-positives on abbreviations (e.g., "Mr. Smith")
# are accepted; the probe's job is to surface candidates, not to be perfect.

set -uo pipefail

paths=$(git diff --cached --name-only --diff-filter=AM 2>/dev/null \
        | grep -E '\.md$' || true)
if [ -z "$paths" ]; then
  base=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null | sed 's|^origin/||' || echo master)
  paths=$(git diff "origin/$base...HEAD" --name-only --diff-filter=AM 2>/dev/null \
          | grep -E '\.md$' || true)
fi

findings=""
for p in $paths; do
  [ -f "$p" ] || continue
  # Skip changelogs; they are line-of-bullets shape rather than prose.
  case "$p" in
    *CHANGELOG*) continue;;
    *changeset/*) continue;;
    *SECURITY.md) continue;;
  esac
  awk '
    BEGIN { in_code = 0; bad = 0 }
    /^```/ { in_code = !in_code; next }
    in_code { next }
    # Detect: ". " followed by capital, "? " followed by capital, "! " followed by capital.
    # Allow common abbreviations: e.g., i.e., et al.
    /[.!?][[:space:]]+[A-Z]/ {
      # Skip lines that look like list items or table cells; sentence-per-line
      # mostly applies to paragraph prose.
      if ($0 ~ /^[[:space:]]*[-*+][[:space:]]/) next
      if ($0 ~ /^[[:space:]]*\|/) next
      if ($0 ~ /e\.g\.|i\.e\.|et al\./) next
      bad++
      if (bad <= 3) print FILENAME ":" NR ": " substr($0, 1, 80)
    }
  ' "$p" >>/tmp/sentence-per-line-md.findings.$$ 2>/dev/null || true
done

if [ -s "/tmp/sentence-per-line-md.findings.$$" ]; then
  findings=$(cat /tmp/sentence-per-line-md.findings.$$)
  rm -f /tmp/sentence-per-line-md.findings.$$
  printf 'fail: multi-sentence lines\n%s\n' "$findings"
  exit 1
fi
rm -f /tmp/sentence-per-line-md.findings.$$
echo "pass"
exit 0
