The PR is a docs-only design document PR (adds `designs/sturdy-refs-agent-surface.md` + one line in `designs/README.md`), and its `statusCheckRollup` is entirely GREEN at the current head `f5df0a4c`. No code packages are touched, so there is no coverage to run and no dead code to orphan. The clean stage is a no-op.

## Completion report

**Stage:** CLEAN — endojs/endo-but-for-bots PR #695 ("design(sturdy-refs): agent provide/accept surface")

**What I did:**
- Checked PR idempotence via `gh pr view`. PR is OPEN/draft, head `f5df0a4c83f`.
- Inspected the diff: docs-only, +244/-0 across two files — a new `designs/sturdy-refs-agent-surface.md` (243 lines) and one line added to `designs/README.md`. No source packages touched.
- Confirmed CI status: all six checks (build, lint, test, browser-tests, zizmor, copilot-setup-steps) report `SUCCESS` at the current head. The CI legs are the "CI (docs-only)" workflow, matching the docs-only nature of the change.

**Conclusion:** No coverage pass applies (no code changed, no orphaned dead code), and CI is already GREEN at the current head. The clean stage is a no-op — nothing pushed, no follow-ups.

**Changes:** none.
**Follow-ups:** none.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr695-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (133708 cached reads)
- Output: 1498 tokens
- Cost: $0.430148
- Wall-clock: 27s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
