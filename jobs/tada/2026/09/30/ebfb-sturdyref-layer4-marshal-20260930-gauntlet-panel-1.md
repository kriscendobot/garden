I ran panel round 1 on PR #1393 and the verdict is **must-fix**.

- **Panel run:** 33 seats reviewed head `36c4f40bcd` against the frozen base `build/sturdyref-pass-style-recognition-fa2edee` (`fa2edee302`), in an isolated project checkout. I launched `panel.sh` in the background with `nohup`, so its exit status wasn't recorded. It printed the single-round terminal line `code-panel single-round — must-fix`, which is printed only right before its `exit 0`. That makes this a real verdict rather than a sensor error. 10 seats asked for changes: saboteur, breaker, purist, spec-keeper, wire-watcher, engine-realist, integrator, changeset-auditor, pruner and fast-checker. The rest commented or approved.
- **Review posted:** https://github.com/endojs/endo-but-for-bots/pull/1393#pullrequestreview-5371698026. GitHub doesn't let the bot request changes on its own PR, so it went up as a COMMENTED review, the same way earlier panel reviews on #1390 did. It lists the must-fix items, includes the detail from the seats that asked for changes, and ends with a `garden-panel-verdict: must-fix` marker. The full aggregate is about 80 KB, over GitHub's review size limit, so the approve and comment-only seats were left out.

Must-fix items for the fix loop:
1. **capdata can mistake one slot kind for another.** In `marshal.js`, `decodeSlotCommon` caches decoded values by slot index only, and remotables, promises and SturdyRefs now share that cache. capdata's `'slot'` case never checks the pass-style, so a SturdyRef decoded first comes back unchecked when the same index shows up as a plain `slot`. Five seats reproduced this. smallcaps is not affected. The fix needs a type check or separate caches, a corrected comment and changeset, a capdata regression test, and an updated `TODO SECURITY HAZARD` note.
2. **The dot-membrane leaks when enlivening fails.** `E.when(SturdyRef.enliven(...), pass)` has no rejection handler, so the rejection reason crosses the membrane without being passed through `pass()`. The saboteur seat confirmed this live.
3. **A test assertion was removed without saying so.** Commit `b9b3777f1b` dropped the stale `passStyleOf rejects a SturdyRef` assertion from the sturdyref tests, and neither the commit message nor the PR body mentions it.
4. **The random-value test generator doesn't produce SturdyRefs.** `arb-passable.js` was not extended, so the existing property tests never exercise the new pass-style.
5. **Changeset:** put each sentence on its own line. Listing `@endo/patterns` is optional.
6. **PR body:** the "Stack index" heading isn't in the template, and the inline test counts should come out.

Nothing needs a separate follow-up; the fix loop takes it from here.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer4-marshal-20260930-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (977399 cached reads)
- Output: 6463 tokens
- Cost: $0.9042678000000002
- Wall-clock: 678s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
