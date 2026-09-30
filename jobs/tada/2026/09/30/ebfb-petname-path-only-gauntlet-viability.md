Viability: **proceed**. PR #1390 is open and still a draft. It hasn't been superseded, and the reason for it still holds.

**Deciding question:** Does the current base (`origin/llm`) still accept a bare pet-name string and turn it into a one-component path, and is there no newer implementation that already restricts the daemon's methods to pet-name paths only?

**Evidence:**
- **PR facts:** state is OPEN, `isDraft=true`, not merged. It was opened 2026-09-30T05:43Z on head `build/pet-name-path-only@e76909d36c`, with base frozen at `llm-8e53cc0`.
- **Base code:** on current `origin/llm`, `packages/daemon/src/pet-name.js:148-152` still has `namePathFrom = nameOrPath => typeof nameOrPath === 'string' ? [nameOrPath] : nameOrPath`. The string is still quietly accepted, which is exactly what this PR removes.
- **Why the PR exists:** kriskowal asked for this directly in a review on #1343 (pullrequestreview-5360774903). The point is that agents get confused about whether a string is a delimited path, so the daemon should reject strings and tell the caller to pass an array.
- **Other PRs:**
  - #1343, which covers the endowment value side, is still OPEN and unmerged. It complements this PR rather than replacing it.
  - #1151, a design doc titled "eliminate single-segment string paths", is still OPEN. It points the same way and is not a competing implementation.
  - A search for other pet-name-path PRs found nothing newer that does this work.
- **Caveat for later stages:** the PR says itself that it is incomplete. Callers that pass names through string variables, the `@endo/agentry` credential field, several daemon and chat tests, and the question of whether the mount/`@endo/platform` filesystem surface should follow are all still to do. The job `ebfb-petname-path-only-sweep` owns that work on this same branch. That doesn't make the PR overtaken, but the clean and panel stages will be reviewing a branch that is still changing. Expect red CI and findings the sweep is already covering until it lands.

No changes were made.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (110592 cached reads)
- Output: 1488 tokens
- Cost: $0.3820624
- Wall-clock: 20s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
