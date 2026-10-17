Fix round 3 for endojs/endo-but-for-bots#1476 is pushed and CI is green (35 checks, 0 failed). One must-fix, the PR-body edit, is not applied yet. This host's token got a 403 on the edit, so I handed it to a separate job pinned to an endolin host.

**Fixes pushed** (head `bf0d59985` → `88b95820a`, two follow-up commits):

- **Decomplector must-fix, `cc884de17`.** I removed the read-ahead pump and its bounded queue, along with all the pause/resume and re-queue machinery around them. `reader.next` now skips heartbeat frames itself. The liveness timeout runs only while a read is waiting. This also covers:
  - **Corner-prober's pump findings:** these no longer apply, because the pump is gone.
  - **Assessor's writer finding:** a close now ends a pending heartbeat read, so `writer.return` no longer leaves a consumer blocked.
  - **Breaker's teardown finding:** reader and writer `return`/`throw` now call `fireOnClose` in a `finally`, so a failing transport half can't leave the heartbeat timer running.
  - **A malformed heartbeat** now closes the session before the error is thrown.
- **Corner-prober must-fix (timing bounds).** `intervalMs` and `sessionTimeoutMs` above 2**31−1 ms are now refused, because timers clamp such values to 1 ms. New tests cover NaN, −0, Infinity, 2**31, the exact 3× minimum and the 2**31−1 maximum, plus a test that closing the writer ends a pending read. I adjusted the existing tests to match: the slow-consumer test is renamed, and tests that relied on background reads now read explicitly.
- **Archivist must-fix, `88b95820a`.** The README now says the timeout only runs while the consumer is waiting on the reader, which was the false claim. It also says:
  - the first tick sends only `op:ping`;
  - older `@endo/ocapn` peers abort the session on these frames;
  - a peer that sends no heartbeats is declared lost whenever it stays quiet for a full timeout.

  Following the pruner's comments, I cut the changeset and the `HeartbeatOptions` JSDoc down to point at the README. I also corrected the `operations.js` comment about other networks.

**Local checks:**
- `yarn lint` for `ocapn-noise`: 0 errors.
- The heartbeat tests passed 8 runs in a row.
- `heartbeat` + `integration` + `network` tests: 54 passed.
- Full-suite runs sometimes show a test file exiting non-zero. In the one case I traced, the cause was ses-ava's concurrent configurations racing on the shared `.cache/ava` folder (ENOENT), not this code. CI is green.

**PR body (integrator and pruner must-fix): handed off.** On this host (oros-studio) the bot token got a 403 on the `updatePullRequest` call, so I posted job `endojs-endo-but-for-bots-pr1476-gauntlet-fix-3-pr-body`, pinned with `requires: host=endolin-garden-ece02cb4`, with the full new body embedded. The new body:
- adds the missing `### Documentation Considerations` section;
- cuts the prose to about 250 words;
- changes the Phase 2 ledger line to `in-progress | stacked draft #1478 … not in this diff`.

If panel-4 runs before that job does, the template finding will fire again.

**Should-fix items left alone:**
- `getLiveness()` is still required on `OcapnNoiseSession` rather than optional (decomplector #3).
- No shared heartbeat helper in the style of `makeIrohHeartbeat` (decomplector #2).
- The `HeartbeatMessage` typing notes from the typist are unchanged.
- The commits have not been regrouped before un-drafting (integrator #3).

I also added this 403 to the memory note about this host's token.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1476-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 100 tokens (5462131 cached reads)
- Output: 32251 tokens
- Cost: $2.8160142000000015
- Wall-clock: 3402s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
