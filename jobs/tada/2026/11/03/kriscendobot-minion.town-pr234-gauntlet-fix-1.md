Fix round 1 for PR #234 is done: the blocking style finding is cleared and CI is green on the new head, `ec58aa32`.

**What changed** (only `deploy/probe/prod-objectives.test.mjs`, in two follow-up commits on `probe/invitation-roundtrip`):
- **`c8778f5d`:** renamed the fixture `const ok` to `healthy` in the introduction-violations test.
- **`ec58aa32`:** rewrote the six `assert.ok(...)` lines this PR adds as `assert.equal(..., true/false)`. Re-running the probe after the rename showed it was still failing on the `ok` in `assert.ok`. Three older `assert.ok` lines stay because the PR doesn't add them, and the probe only scans added lines.

**Advisory left as is:** I kept the comment at `deploy/probe/prod-objectives.mjs:177`. It explains why the pet names are fixed (the standing guests stay the same size however often the probe runs), so it gives a reason rather than narrating the code.

**Verification:**
- **Tests:** `node --test deploy/probe/prod-objectives.test.mjs` passes 30 of 30.
- **Style gates:** `pre-push-gates.sh --no-auto-fix --probes-only --base-ref origin/main-c5c3504` exits 0, with only the advisory above. Probes only, so the mutating style checks did not run.
- **Push:** `safe-push-pr-head.sh` advanced the branch from `be39fa1d` to `ec58aa32`, and `ls-remote` confirms it.
- **CI:** `ci-wait-merge.sh` returned rc 0 (1 of 1 run, 0 failed). I ran it with a 540s deadline rather than 3600s to fit the tool limit, and it finished within that. This bot token can't read `statusCheckRollup`, so it used the Actions runs API, and commit statuses and non-Actions check runs weren't visible.

**Follow-up (not done, outside this job):** `spell-out-identifiers.sh` splits any code into identifier tokens without excluding property access, so it flags platform names like `assert.ok`. `response.ok` would trip it the same way on an added line. The `ok` entry from the 2026-10-23 sweep will therefore fail any PR that adds an `assert.ok`, so the probe could skip tokens that follow a `.`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr234-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (600525 cached reads)
- Output: 6797 tokens
- Cost: $0.7234530000000001
- Wall-clock: 642s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
