#!/bin/bash
# Hermetic regression: a verdict-comment 403 must not suppress a proven close.
set -euo pipefail
export GARDEN_TEST=1 GARDEN_API_COOLDOWN_SECS=0
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLOSE="$(cd "$HERE/../handlers" && pwd)/dependabot-terminal-close-gh.sh"
TR="$(mktemp -d)"; trap 'rm -rf "$TR"' EXIT

cat > "$TR/job" <<'EOF'
---
role: botanist
requires: host=testhost
dependabot-terminal-close: v1
dependabot-close-kind: node
dependabot-close-repo: endojs/endo-but-for-bots
dependabot-close-pr: 1439
dependabot-close-package: '@earendil-works/pi-ai'
dependabot-close-old: '0.87.1'
dependabot-close-new: '1.0.2'
dependabot-close-proof-a: '20.17.0'
dependabot-close-proof-project: '^20.17.0 || >=22.9.0'
dependabot-close-proof-required: '>=22.19.0'
dependabot-close-proof-path: 'package.json'
dependabot-close-project: endo-but-for-bots
---
EOF
cat > "$TR/gh" <<'EOF'
#!/bin/bash
printf '%s\n' "$*" >> "${GH_LOG:?}"
if [ "$1" = api ]; then
  case "$*" in
    *'/pulls/1439') printf '%s\n' '{"state":"open","user":{"login":"dependabot[bot]"},"title":"Bump @earendil-works/pi-ai from 0.87.1 to 1.0.2"}' ;;
    *'/pulls/560') printf '%s\n' '{"state":"open","user":{"login":"dependabot[bot]"},"title":"Bump ses from 1.9.0 to 1.10.0"}' ;;
    *'/pulls/561') printf '%s\n' '{"state":"open","user":{"login":"dependabot[bot]"},"title":"Bump ses from 1.9.0 to 1.10.0"}' ;;
    *'/issues/1439/comments'*) printf '%s\n' '[]' ;;
    *'/issues/560/comments'*) printf '%s\n' '[]' ;;
    *) exit 1 ;;
  esac
elif [ "$1 $2" = 'pr comment' ]; then
  echo 'HTTP 403: Resource not accessible by personal access token' >&2
  exit 1
elif [ "$1 $2" = 'pr close' ]; then
  exit 0
fi
EOF
cat > "$TR/compat" <<'EOF'
#!/bin/bash
printf 'incompatible\tnode\t20.17.0\t^20.17.0 || >=22.9.0\t>=22.19.0\tpackage.json\n'
EOF
cat > "$TR/journal" <<'EOF'
#!/bin/bash
cp "$2" "${JOURNAL_BODY:?}"
EOF
chmod +x "$TR/gh" "$TR/compat" "$TR/journal"

GH_LOG="$TR/gh.log" JOURNAL_BODY="$TR/journal.body" GARDEN_GH="$TR/gh" \
  GARDEN_DEP_CLOSE_COMPAT="$TR/compat" GARDEN_DEP_CLOSE_JOURNAL="$TR/journal" \
  GARDEN=testhost GARDEN_STATE="$TR/state" \
  "$CLOSE" "$TR/job" "$TR/report"

grep -q '^pr comment 1439 ' "$TR/gh.log"
grep -q '^pr close 1439 ' "$TR/gh.log"
grep -q '^comment-status: failed$' "$TR/report"
grep -q '^close-status: closed$' "$TR/report"
grep -q '^comment-status: failed$' "$TR/journal.body"
grep -q '^close-status: closed$' "$TR/journal.body"
echo 'PASS: terminal close is attempted after a 403 verdict-comment failure, with partial failure recorded separately'

cat > "$TR/superseded-job" <<'EOF'
---
role: botanist
requires: host=testhost
dependabot-terminal-close: v1
dependabot-close-kind: superseded
dependabot-close-repo: endojs/endo-but-for-bots
dependabot-close-pr: 560
dependabot-close-package: 'ses'
dependabot-close-old: '1.9.0'
dependabot-close-new: '1.10.0'
dependabot-close-peer: 561
dependabot-close-peer-new: '1.10.0'
dependabot-close-project: endo-but-for-bots
---
EOF
: > "$TR/gh.log"
GH_LOG="$TR/gh.log" JOURNAL_BODY="$TR/journal.body" GARDEN_GH="$TR/gh" \
  GARDEN_DEP_CLOSE_COMPAT="$TR/compat" GARDEN_DEP_CLOSE_JOURNAL="$TR/journal" \
  GARDEN=testhost GARDEN_STATE="$TR/state" \
  "$CLOSE" "$TR/superseded-job" "$TR/superseded-report"
grep -q '^pr close 560 ' "$TR/gh.log"
grep -q '^verdict: REJECT-superseded$' "$TR/superseded-report"
echo 'PASS: a literal-supersession directive revalidates both live PRs and closes deterministically'
