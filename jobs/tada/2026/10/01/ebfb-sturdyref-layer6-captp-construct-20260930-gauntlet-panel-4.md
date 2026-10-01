I ran panel round 4 of the gauntlet on endojs/endo-but-for-bots#1396 (head `13f96a7d89`) and the verdict is **must-fix**. `panel.sh` exited 0.

**What I did**
- Made an isolated checkout of `endojs/endo-but-for-bots@build/sturdyref-captp-construct` at `scratch/project-wt-ebfb-st-76ce462cafa6-7f1a01bc`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against the PR's real base SHA `2d2a656b84` (base branch `build/sturdyref-captp-wire-2d2a656`). All 33 seats returned: 4 request changes, 8 comment only, 21 approve. The `typist` seat timed out once and succeeded on its retry.
- Posted the result as review 5378052284: https://github.com/endojs/endo-but-for-bots/pull/1396#pullrequestreview-5378052284. GitHub doesn't let the bot request changes on its own PR, so it went up as COMMENTED, the same as rounds 1–3. The body states **must-fix**.
- The full aggregate was 75 KB, which is over GitHub's 65 KB limit for a review body. I wrote a summary header, then the seat blocks in order of severity. The blocks for 10 approving seats didn't fit and are listed by name only. Their full text is still in the run directory, which is temporary.

**Must-fix items (in scope)**
1. **`objectId` is shared, not copied, on the way out** (breaker, purist): `sturdyRefDetailsToData` in `packages/ocapn/src/client/sturdyrefs.js` returns the live secret `Uint8Array` itself. `harden()` doesn't stop writes to a byte array's elements, so a caller who changes the returned bytes changes which object the ref enlivens to. The fix is to copy on the way out, as the way in already does, and add a test for it.
2. **Typedef location** (typist): move the `SturdyRefData` typedef into `packages/captp/src/types.js`, where the related types already live.
3. **Round-trip tests** (fast-checker): add `fc.property` tests for `sturdyRefDetailsToData`∘`sturdyRefDataToDetails` and for `getSturdyRefData`∘`makeSturdyRefFromData`.

**Should-fix items**
- The defensive copy calls `.slice()`, which a `Uint8Array` subclass can override. Reuse the already-imported `thawedBytes` instead.
- The "no extra properties" check misses non-enumerable keys, in both captp and ocapn.
- The typedef marks `hints` optional, but captp's stored and returned value always has it.

I made no changes to the garden repo. Following the stage contract, I didn't fix anything or take the PR out of draft. The next fix-loop stage owns the items above.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1033963 cached reads)
- Output: 6995 tokens
- Cost: $0.8341406
- Wall-clock: 1511s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
