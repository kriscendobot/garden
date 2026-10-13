#!/usr/bin/env bash
set -euo pipefail

HERE="$(cd "$(dirname "$0")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
repo="$tmp/journal"
git init -q "$repo"
git -C "$repo" config user.email test@example.invalid
git -C "$repo" config user.name test

commit_at() {
  local at="$1" message="$2"
  GIT_AUTHOR_DATE="$at" GIT_COMMITTER_DATE="$at" git -C "$repo" add -A
  GIT_AUTHOR_DATE="$at" GIT_COMMITTER_DATE="$at" git -C "$repo" commit -q -m "$message"
}

mkdir -p "$repo/jobs"/{todo,doin,plan,orch,tada} "$repo/work"
printf '%s\n' '---' 'arc: sample' '---' 'initial alpha' > "$repo/jobs/todo/arc-alpha.md"
printf '%s\n' '---' 'arc: sample' '---' 'will disappear' > "$repo/jobs/todo/arc-vanish.md"
printf '%s\n' '---' 'arc: sample' 'doomed: true' 'doom_signature: policy-refusal' \
  'doomed_on: host-old' '---' > "$repo/jobs/plan/arc-old-doom.md"
printf '%s\n' '---' 'children:' '  - arc-child' '---' > "$repo/jobs/orch/sample-orch.md"
printf '%s\n' '---' 'orchestrated_by: sample-orch' '---' > "$repo/jobs/todo/arc-child.md"
commit_at 2026-01-01T00:00:00Z initial

git -C "$repo" mv jobs/todo/arc-alpha.md jobs/doin/arc-alpha.md
printf '%s\n' 'host: host-a' 'claimed_at: 2026-01-01T01:10:00Z' > "$repo/work/arc-alpha"
commit_at 2026-01-01T01:10:00Z claim-alpha

git -C "$repo" rm -q jobs/doin/arc-alpha.md work/arc-alpha
mkdir -p "$repo/jobs/tada/2026/01/01"
printf '%s\n' 'alpha completed' "- Cost: \$1.25" > "$repo/jobs/tada/2026/01/01/arc-alpha.md"
commit_at 2026-01-01T01:20:00Z complete-alpha

git -C "$repo" rm -q jobs/todo/arc-vanish.md
printf '%s\n' '---' 'arc: sample' 'doomed: true' 'doom_signature: deadline-overrun' \
  'doomed_on: host-new' 'doomed_at: 2026-01-01T01:30:00Z' '---' > "$repo/jobs/plan/arc-new-doom.md"
mkdir -p "$repo/jobs/doin" "$repo/work"
printf '%s\n' '---' 'arc: sample' 'role: gardener' '---' > "$repo/jobs/doin/arc-stall.md"
printf '%s\n' 'host: host-stall' 'claimed_at: 2026-01-01T01:00:00Z' > "$repo/work/arc-stall"
commit_at 2026-01-01T01:30:00Z reconcile

report="$tmp/report.json"
"$HERE/completion-window-report.py" --repo "$repo" --ref HEAD \
  --since 2026-01-01T01:00:00Z --until 2026-01-01T02:00:01Z --format json \
  --select-arc sample --select-orchestration sample-orch > "$report"

jq -e '
  .schema == 1 and
  .counts.claims == 2 and
  .counts.completions == 1 and
  .counts.current_dooms == 2 and
  .counts.new_dooms == 1 and
  .counts.stalled_claims == 1 and
  .counts.absent_prior_roster == 1 and
  .absent_prior_roster == ["arc-vanish"] and
  (.dooms | any(.base == "arc-new-doom" and .signature == "deadline-overrun" and .host == "host-new")) and
  (.stalled_claims | any(.base == "arc-stall" and .handler_timeout_s == 2400)) and
  (.jobs | any(.base == "arc-child" and .location == "todo")) and
  (.jobs | any(.base == "arc-alpha" and .location == "tada"))
' "$report" >/dev/null

# Legacy JSON remains one completion object per line, not the arc envelope.
legacy="$tmp/legacy.jsonl"
"$HERE/completion-window-report.py" --repo "$repo" --ref HEAD \
  --since 2026-01-01T01:00:00Z --until 2026-01-01T02:00:01Z --format json > "$legacy"
jq -e 'select(.base == "arc-alpha") | .cost.usd == 1.25' "$legacy" >/dev/null

echo "completion-window-report tests: PASS"
