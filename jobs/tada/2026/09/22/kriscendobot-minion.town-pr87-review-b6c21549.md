---
handed-off: fix-minion-town-migrate-tests-to-ava-20260922
deliverable-complete: false
---
The successor job is confirmed on the board (`origin/journal2`). All work is durably captured.

## Completion report

**Job:** Review triage of kriscendobot/minion.town PR #87 (kriskowal review `pullrequestreview-5273122355`).

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED) — no prior peer resolution.

**The review, enumerated:** One top-level directive, zero inline comments (verified via `gh api .../comments` filtered on `pull_request_review_id==5273122355` → empty). Review body (untrusted, treated as data): *"This house uses `ava` for testing."*

**Finding (verified in an isolated checkout of `build/claude-agents-capability`):** The directive contradicts the repo's reality. minion.town has used **vitest**, not ava, since its initial commit (`315fbd0`):
- 51 test files import from `vitest` (`describe`/`it`/`expect`); **zero** use ava.
- `vitest.config.ts` present; `npm test` == `vitest run`; devDep is `vitest`, no ava.
- PR #87's 6 new `test/claude-*.test.ts` files follow the existing house vitest style.

Satisfying "use ava" coherently requires a **repo-wide** vitest→ava migration — two runners can't cleanly coexist, and converting only #87's files would break CI (`vitest run` won't collect ava tests; ava isn't installed). That is a large, hygiene-sensitive change whose scope (fold into this feature PR vs. a dedicated migration PR) only the maintainer should settle, so I confirmed first rather than guessing.

**Actions taken (all durable):**
1. **Escalated to the maintainer** via `message-user` — full finding + scope question + recommendation (option a: dedicated repo-wide migration PR, then #87 rebases onto it). Reply routes back to this job's inbox.
2. **Posted a reply on PR #87** for the record: `https://github.com/kriscendobot/minion.town/pull/87#issuecomment-5770104331`.
3. **Parked a successor job** `fix-minion-town-migrate-tests-to-ava-20260922` (gate `awaiting-maintainer`, `by: fixer`) that owns the migration end to end, with the conversion plan spelled out. Verified live on `origin/journal2` via the GitHub API.

**Nothing was changed on PR #87's branch.**

**Follow-up owner:** the parked migration job — promote it once the maintainer picks a scope option (a/b/c). Its `--question`/`--asked-at` fields point at the review URL.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr87-review-b6c21549.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 66 tokens (1797271 cached reads)
- Output: 36108 tokens
- Cost: $3.2803085000000003
- Wall-clock: 749s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
