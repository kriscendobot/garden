Viability gate for endojs/endo-but-for-bots PR #1100 (`feat(exo-stream)!: use one stream method for byte streams`): **proceed**. No other work has taken its place, and the reason for it still holds. I spent no clean, panel, fix, CI-wait or un-draft budget.

The first attempt had already reached `viability=proceed`, but it was requeued. Its likely fault was the order of the last two lines: it put the stage marker after the completion line, and the completion line must come last. On resuming I checked the PR and `llm` again, and nothing has changed. There was no uncommitted work in the worktree.

**PR facts:** The PR is open, unmerged and still a draft. Its head is `f8c369ddf5` and its base is the pinned branch `llm-f9cbcfc` (`f9cbcfc426`).

Deciding question: Does `llm` still expose byte streams through the bytes-only `streamBase64()` method with base64 encoding, so that this PR is still the only change making `stream()` the single byte-stream method carrying passable `Uint8Array`s?

Evidence:
- **The PR's base is still the tip of `llm`.** `llm` is at `f9cbcfc426f726858a671bcb09f7c2c774cc659e`, the same commit as the PR's base, so nothing has landed since the 2026-09-23 rebase.
- **`llm` still uses the old method.** Its `packages/exo-stream/bytes-reader-from-iterator.js` still exports `streamBase64: pump` and still calls `encodeBase64(result.value)`. Its own comment says it "Uses streamBase64() method instead of stream() to allow future migration", which is the migration this PR makes.
- **The change it depends on has landed.** The linked #475 (`feat(pass-style)!: narrow byteArray to a frozen Uint8Array`) merged to `llm` on 2026-08-30, so the passable `Uint8Array` form this PR relies on is available.
- **The last rebase already checked for a newer replacement and found none.** The rebase comment of 2026-09-23 found that `exo-stream` on `llm` had not changed and that `streamBase64` was still called at every platform call site. The newer range-attenuation code, which added its own `streamBase64` readers, was switched over in commit `f8c369ddf5`.
- **Review is still active.** Six panel rounds have each ended "must-fix" and each was followed by fixes. The round-6 items were addressed before the rebase, and the next step is a new panel.

My GitHub search for other PRs mentioning `streamBase64` hit the API rate limit, so I could not run it. That leaves open only an unmerged competing PR. Nothing replacing this PR has landed, because `llm` equals the PR's base and still uses `streamBase64`.

No follow-ups from this stage; the gauntlet can go on to clean and panel.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-exo-stream-pr1100-gauntlet-20260923-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 14 tokens (337528 cached reads)
- Output: 3731 tokens
- Cost: $0.9925532000000001
- Wall-clock: 47s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
