I applied the round-5 panel's must-fix items to endojs/endo-but-for-bots#1478 and pushed them; CI is green (35 checks, 0 failed).

**Commits pushed** (head moved `dc57f6fc62` → `385e99301d`, via `safe-push-pr-head.sh` in advance mode):
- **`64c1578d3f` — `Buffer` aliasing** (spec-keeper must-fix, breaker should-fix): `enqueueFrame` now copies with `new Uint8Array(plainText)`. Node's `Buffer.prototype.slice` returns a view over the caller's memory, not a copy. New test: write a `Buffer`, mutate it, check the queued frame is unchanged.
- **`d8159b3b00` — retained reactions** (engine-realist must-fix): each frame's `Promise.race` against the session-long `closedPromise` added a reaction that lived until the session closed. The drain now waits on a per-frame promise that either the write or `fireOnClose` settles, and drops it when the frame completes. I did not add a retention test, which engine-realist also asked for.
- **`3be0b5f26f` — teardown on a failed transport call** (breaker should-fix): `writer.throw` and `writer.return` now run `fireOnClose` in a `finally`, so a rejected transport `throw`/`return` no longer strands waiting writers or the queue. New test covers it.
- **`385e99301d` — docs:** the frame-size comment cites Noise §3, and the `lastSentNonce` doc says it is a count kept at each `encrypt`.

**Testing:** with the fixes temporarily reverted, the `Buffer` test fails and the throw test hangs. With the fixes, all 14 `session-queue` tests pass and the full package suite passes (99 tests). Type checks (`tsc` for the package and the repo root), eslint (no errors) and prettier are clean.

**PR description:**
- **Decomplector must-fix:** the description now explains why the PR keeps the session queue instead of a simple promise chain. Phase 3 must carry accepted frames, still unencrypted, onto a new transport under the rekeyed cipher, and a chain tied to the current stream can't do that.
- **Pruner:** removed the three bullets that repeated the changeset. The ledger lines stay, since the pruner made cutting them conditional on checking the ledger parser and I didn't check it.
- I also posted a comment on the PR listing how each item was handled.

**Not done:** spec-keeper's ask to drive the tests with a fake clock instead of real timers, and engine-realist's per-frame stall timer. Both are should-fix and left for a later round.

**Notes:**
- `yarn install` touched the mode of `packages/relay-server/src/index.js`; I reverted it and it was not committed.
- My first one-hour CI wait was stopped by the tool's background time limit. A second, bounded foreground wait returned rc=0 (green).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1478-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (3246085 cached reads)
- Output: 18598 tokens
- Cost: $2.395001
- Wall-clock: 2223s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
