I applied the round-4 panel's must-fix items to PR #1412 and pushed them. CI had not finished when the 3600s limit ran out (`ci-wait-merge` rc 4), so this stage ends still-pending. 31 of 33 checks passed or were skipped, none failed, and the last two (`test (22.x, macos-15)` and `test (24.x, macos-15)`) were still running.

**Pushed:** `0bf0292c05..b1dd5c8a71` to the head branch `build/endo-claude-backends-1357`, using `safe-push-pr-head.sh` (a fast-forward).

**Code fixes** (commit `cd60db6671`, `fix(claude): close the round-4 panel's backend findings`):
- **assessor (must-fix):** in `cli-backend.js`, a `settled` flag is set in the `finally` block, and a late `'exit'` from a killed process now returns early. Before, every aborted turn left behind a 1s grace timer that nothing cleared. New test: "an exit after a killed turn returns starts no grace timer". To trigger the late exit, the fake spawn in `_backend-fixtures.js` now exposes `emitters`.
- **stylist (must-fix):** renamed `const env` to `environment`. Also reworded the `backends.types.d.ts` comment to say "The `environment` of a granted `acquire()`".
- **purist (must-fix):** when `acquire()` rejects, both backends now report the fixed detail `acquire rejected` instead of the error's message, which could contain the credential. A malformed grant still reports `malformed admission`. I updated the two tests that expected `vault sealed`.
- **benchmarker (must-fix):** the CLI line decoder now searches only each new chunk for a newline and joins the pending chunks once, so a long line costs linear time instead of quadratic. It uses a manual backward loop because `Uint8Array.prototype.lastIndexOf` returned -1 under SES lockdown when I probed it.
- **spec-keeper / benchmarker:** `serializedByteCount` in the SDK backend now marks only a true cycle, using an ancestor stack (no `WeakSet`). An object shared by siblings now counts in full each time. New test: "an object shared by siblings counts in full each time". I confirmed it fails on the old code.
- **breaker (should-fix):** in `stream-reducer.js`, any non-assistant event (such as a tool result) now ends the current message. A message id repeated across tool results therefore counts as a new turn each time. New test: "one id replayed across a tool result is a new turn". I confirmed it fails on the old code.
- **breaker (comment-only):** the `sdk-backend.js` header now says that confinement matching the CLI's `--bare` flag has not been verified for the SDK.

**Docs** (commit `b1dd5c8a71`), for the integrator and purist:
- **Design doc:** added a Known Gaps item to `designs/endo-claude-inference-backends.md`. It names `maxBudgetUsd` as a fourth limit outside `InferLimits` that the Claude Code binary enforces, says it is separate from the admission-time `budget-exhausted` refusal, and says a mid-turn budget trip is reported as `unavailable` until gate 3.
- **README:** added a sentence on how the phase-1 `make()` result tags relate to the new backends, plus a note on `maxBudgetUsd`.

**Local checks:** all 144 `packages/claude` tests pass. `yarn lint` (tsc and eslint) shows 0 errors; the warnings are existing ones in test files. Root `tsc` reports nothing for `claude` or `inference`, and Prettier is clean.

**Not changed** (comment-only items): spec-keeper's `UsageSinkInterface.write` `M.any()` return guard and its monotonic-clock note. The integrator also noted that the design's dependency table is stale about #1102 being closed.

**Next:** the driver should re-post this stage to see the two macOS checks finish.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1412-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 100 tokens (4624661 cached reads)
- Output: 22149 tokens
- Cost: $2.2443842000000003
- Wall-clock: 3917s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
