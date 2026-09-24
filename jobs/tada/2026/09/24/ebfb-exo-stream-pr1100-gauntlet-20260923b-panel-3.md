Round 3 of the review panel on endojs/endo-but-for-bots#1100 finished normally and returned **must-fix**. I posted the verdict to the PR.

- **Run:** I checked out the PR head `2500c24ed4` (branch `kriscendobot-exo-stream-drop-base64`) in an isolated project worktree. I ran `panel.sh` in single-round mode against the pinned base `llm-f9cbcfc` @ `f9cbcfc426`. It exited 0 and ended with `must-fix`.
- **Seat verdicts:** 32 seats ran. 27 blocks had parseable verdict lines: 5 request-changes, 7 comment-only and 15 approve. The other five seats (curator, stylist, spec-keeper, surfacer, releaser) wrote no verdict line in the usual format.
- **Posted review:** https://github.com/endojs/endo-but-for-bots/pull/1100#pullrequestreview-5298718881
  - It is a comment review, not a request-changes review, because GitHub won't let the PR author (the bot) request changes on its own PR. Earlier rounds on this PR were posted the same way.
  - The full aggregate was about 89 KB, over GitHub's 65,536-character limit. The review keeps a summary plus the full blocks for every seat that did not approve, and lists the 15 approving seats by name only.

**Items to fix:**
1. **packager:** the `yarn.lock` changes in commits `8f14dff6d6`, `ec7c30d51b` and `b739e6cf1e` need to be split into their own `chore: Update yarn.lock` commits.
2. **prover:** `packages/daemon/test/readable-blob-frame-limit.test.js` says it pins the limit `formulateReadableBlob` passes, but it never runs the real call site in `manager.js`. It passes the constant in by hand instead.
3. **saboteur:** the xattrs `set()` sink caps each 64 KiB frame but not the total across frames, so the `XATTR_SIZE_MAX` limit is never actually enforced. It also raised a should-fix on the order of steps when `writer-pump.js` aborts.
4. **scribe:** two items from the 2026-09-04 review round are still open:
   - the follow-up ledger `endo-but-for-bots--1100.md` was never created;
   - the proposed rules from the round before it were never forwarded to `role/gardener`.
5. **pruner:** the "Bytes Transport Decision" section of `DESIGN.md` repeats benchmark detail that is already in `BENCH.md`, and should be cut to one sentence that cites it.

Should-fix (spec-keeper): exo-stream's XS test script is `exit 0`, so the switch to the `@endo/immutable-arraybuffer` shim is never tested on XS.

I made no fixes and left the PR in draft, as this stage requires.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-exo-stream-pr1100-gauntlet-20260923b-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (914144 cached reads)
- Output: 5457 tokens
- Cost: $0.7796088000000001
- Wall-clock: 672s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
