#!/bin/bash
# mentor-routine-result-filter-test.sh — clean approval/no-findings panel results
# are consumed without waking the mentor, while suspicious verdicts and alarms
# remain in its digest.
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
# shellcheck source=test-tmpdir.sh
source "$HERE/test-tmpdir.sh"
TR="$(mktemp -d "$(garden_test_exec_tmpdir)/garden-mentor-filter.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
BARE="$TR/journal.git"; SEED="$TR/seed"; BIN="$TR/bin"
mkdir -p "$BIN" "$TR/state"

git init -q --bare "$BARE"
git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED/entries"

add_entry() { # <name> <body>
  local name="$1" body="$2"
  printf '%s\n' "$body" > "$SEED/entries/$name"
  git -C "$SEED" add "entries/$name"
}
push_entries() { # <message>
  git -C "$SEED" -c user.name=test -c user.email=test@localhost commit -q -m "$1"
  if git -C "$SEED" remote get-url origin >/dev/null 2>&1; then
    git -C "$SEED" push -q origin journal2
  else
    git -C "$SEED" remote add origin "$BARE"
    git -C "$SEED" push -q -u origin journal2
  fi
}

# Keep journalctl deterministic and quiet.
cat > "$BIN/journalctl" <<'EOF'
#!/bin/sh
echo '-- No entries --'
EOF
cat > "$TR/handler" <<'EOF'
#!/bin/sh
printf 'called\n' >> "$CALL_LOG"
git -C "$2" cat-file -p "$1" > "$DIGEST_LOG"
EOF
chmod +x "$BIN/journalctl" "$TR/handler"
export CALL_LOG="$TR/calls" DIGEST_LOG="$TR/digest"

run_mentor() {
  env PATH="$BIN:$PATH" GARDEN=testhost GARDEN_ROOT="$(cd "$JOBS/../.." && pwd)" \
    GARDEN_STATE="$TR/state" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
    GARDEN_MENTOR_HANDLER="$TR/handler" "$JOBS/mentor.sh"
}

add_entry routine-none.md '---
kind: result
---
**Verdict:** approve

**Findings:**
- None. The reviewed surface is coherent.'
add_entry routine-role.md '---
kind: result
---
Verdict: approve.

Findings:
- No curator findings. No package surface changed.'
push_entries 'seed clean approvals'

run_mentor
[ ! -e "$CALL_LOG" ] || { echo 'FAIL: clean approvals woke the mentor'; exit 1; }
grep -qx 'entries/routine-none.md' "$TR/state/mentor/seen" \
  || { echo 'FAIL: exact None approval was not consumed'; exit 1; }
grep -qx 'entries/routine-role.md' "$TR/state/mentor/seen" \
  || { echo 'FAIL: role-specific no-findings approval was not consumed'; exit 1; }

add_entry routine-mixed.md '---
kind: result
---
**Verdict:** approve
**Findings:**
- None.'
add_entry warning.md '---
kind: result
---
**Verdict:** approve
**Findings:**
- None.
Warning: verification was unavailable.'
add_entry nonapproval.md '---
kind: result
---
**Verdict:** request-changes
**Findings:**
- None recorded because the preflight failed.'
add_entry odd-approval.md '---
kind: result
---
**Verdict:** approve
**Findings:**
- should-fix: investigate the ambiguous state.'
add_entry error.md '---
kind: error
---
service crashed before producing a verdict'
push_entries 'add mixed mentor inputs'

run_mentor
[ "$(wc -l < "$CALL_LOG")" -eq 1 ] \
  || { echo 'FAIL: mixed inputs did not wake the mentor exactly once'; exit 1; }
! grep -q 'routine-mixed.md' "$DIGEST_LOG" \
  || { echo 'FAIL: routine approval leaked into the mixed digest'; exit 1; }
for name in warning.md nonapproval.md odd-approval.md error.md; do
  grep -q "entry entries/$name" "$DIGEST_LOG" \
    || { echo "FAIL: actionable $name missing from digest"; exit 1; }
done

echo 'PASS: mentor consumes routine approvals and retains warnings, errors, and non-approval results'
