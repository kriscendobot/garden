Viability check for kriscendobot/minion.town PR #237 ("test(claude): poll the mailbox in the guest-pinned responder restart test"): **proceed**. It hasn't been replaced, and the flake it fixes is still present on `main`.

The PR is OPEN, not merged, and not a draft. Head is `304dd248`, base is `main` at `5e890519`. A GitHub compare shows the base is exactly `main`: 0 commits ahead, 0 behind.

Deciding question: does current `main` still check the mailbox only once, right after the effect-poll loop, while the caplet writes the effect before dismissing the message? And has no other PR or commit fixed that race?

Evidence:
- **The race is still in the caplet.** On `main`, `src/endo/claude/inbox-responder-caplet.ts:155-157` still writes the effect (`writeText`) and only then calls `dismiss`.
- **The test still checks once.** On `main`, `test/endo-daemon-integration.test.ts` still does a single `listMessages()` call followed by `expect(...).toBe(false)` after the effect poll. That is exactly the race the PR describes.
- **Nothing newer has touched the test file.** Its last commit on `main` is `05cc78fa` (2026-10-14), which predates this PR (opened 2026-11-04).
- **No competing fix exists.** A search of the repo's PRs (open and closed) turned up no other PR for this flake.
- **The need is real.** The PR links two failing runs: PR #234 (run 41613557847) and `main` at `9196892` (run 41729564029). The failure also skips the later guest-web daemon step in the same job, so red runs hide that coverage.
- **Earlier gauntlet history.** The previous gauntlet (`…-screen-b2cea1db-gauntlet`) ran out of its review budget after one round. Its fix round pushed changes and CI went green, and the assessor seat approved. It ended with no structured must-fix list, which leaves the PR worth finishing.

I changed nothing in the garden or in the project repo.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr237-screen-304dd248-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (192046 cached reads)
- Output: 1472 tokens
- Cost: $0.47018519999999997
- Wall-clock: 34s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
