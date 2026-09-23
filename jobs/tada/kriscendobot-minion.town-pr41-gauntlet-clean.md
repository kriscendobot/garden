This PR adds a single design document (`designs/git-remote-capability.md`, 707 lines, spec-only, no code change). There are no touched packages with testable code, so the coverage pass and dead-code removal are inapplicable. CI is already GREEN at the current head (the `test` check: SUCCESS/COMPLETED). This stage is a NO-OP.

## Completion report

**Stage:** clean — kriscendobot/minion.town PR #41 (gauntlet `kriscendobot-minion.town-pr41-gauntlet`)

**Findings:**
- PR #41 is a **spec-only design PR**: its sole change is adding `designs/git-remote-capability.md` (+707/−0, `changeType: ADDED`). No source packages are touched.
- **Coverage pass / dead-code removal: N/A** — there is no code the change added or orphaned, so there is nothing to cover or prune.
- **CI: GREEN at current head.** The `test (typecheck + vitest)` check is `SUCCESS` / `COMPLETED` (run 31537313081). Terminal and passing.

**Action taken:** none required. Nothing to push; the PR is already the right shape. No follow-ups.

The PR remains a draft (correct — undrafting is a later gauntlet stage, not this one).

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr41-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (97246 cached reads)
- Output: 1285 tokens
- Cost: $0.35643400000000003
- Wall-clock: 24s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
