# Gauntlet FIX round 1: endojs/endo-but-for-bots PR #1481

I applied both must-fix items and three cheap should-fixes from the panel-1 review in one follow-up commit, `e2709d679`. It is pushed to `build/ocapn-noise-session-reconnect-rekey`, and CI is green: all 35 checks passed, with `ci-wait-merge` rc 0.

**Must-fix items (both fixed):**
- **Responder could deliver a frame twice across a reconnect** (raised by the assessor, saboteur and breaker seats). The responder used to read its received-frame count for the resume reply, then wait for that write to finish before attaching the new transport. In that gap the old transport could still deliver frames, which the dialer would then send again. The `Reconnector` now has a `suspend()` method that treats the old transport as lost before returning the count, so the advertised count is final. This keeps the "replayed exactly once" claim true. The responder now also starts its hard-timeout clock at that point, so a reply write that fails falls back to normal loss handling.
- **Inline JSDoc `import()`** (typist seat). All the `@typedef {import(...)}` lines in `src/network.js`, plus the inline `AsyncQueue` type, are now top-of-file `@import` blocks. I did the same for the two `@param {import(...)}` tags in `test/reconnect.test.js`.

**Should-fixes also addressed:**
- **Write-stall timer:** an old transport's write loop could clear the new transport's stall timer when it finished. Each write now clears only its own timer.
- **`close()` on a stalled transport:** it waited forever on the end-of-session write and leaked the socket. That write is now capped at 1 s (new constant `SESSION_END_WRITE_TIMEOUT_MS`), after which the transport is closed anyway.
- **Changeset:** added `.changeset/ocapn-noise-session-reconnect-network.md` for `@endo/ocapn-noise`. It describes the reconnect feature, the new `getLiveness()` fields, `lastAckedRecvNonce` now possibly being `undefined`, and the fact that this version can't talk to peers from before the session hello was added.

Locally, `yarn lint` (tsc plus eslint) had no errors and all 103 tests in the `ocapn-noise` package passed.

**Not done, for later:**
- **No regression test for the duplicate delivery.** The breaker and saboteur seats asked for one. Reproducing it needs frames held in flight exactly while the responder writes its reply, and the current loss injector can't time that reliably. It would need a new hook on the responder's transport.
- **Should-fixes left open:**
  - A lost resume reply aborts the session instead of letting it recover; the suggested fix is to accept a redial at the same epoch number.
  - Responder-side reconnects skip the in-progress handshake cap.
  - The outbound queue has no size limit while reconnecting.
  - Typist's suggestions: move the multi-field typedefs into `types.d.ts` and give the new codec helpers real types instead of `any`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1481-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1737473 cached reads)
- Output: 12656 tokens
- Cost: $1.2110225999999997
- Wall-clock: 2416s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
