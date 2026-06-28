# Empirically verify the ymax0 XS import overflow fix: `@agoric/internal/hex.js` `flatMap`→loop at stock stackCount=4096

Carries forward kriskowal's directive on kriskowal/garden issue #9 ("patch ses, replace flatMap with a loop, verify, restore the stack size limit"). The structural analysis (posted to issue #9, comment-4824906011) established that the wide flatMap is NOT in ses — it is the inlined `@agoric/internal/src/hex.js` `decodings = new Map(encodings.flatMap(...))` (1024 entries), which lives inside the contract bundle (`bundle-ymax0.json`, an endoZipBase64 wrapping the single flattened `portfolio.contract.bundle.js`). This job does the empirical confirmation the analysis projects.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriskowal-garden-9
issue_url: https://github.com/kriskowal/garden/issues/9#issuecomment-4824877758
submitter: kriskowal
----- END ISSUE NOTE -----

## Scope
Bot fork only: `kriscendobot/agoric-sdk` (in scope per the bot-repo-and-forks rule). Do NOT touch `agoric/agoric-sdk` upstream or open a PR against it. Read-only/on-host builds of public npm sources are fine. agoric/agoric-sdk and endojs/endo remain off-limits for autonomous merge/close.

## Task
1. In a `kriscendobot/agoric-sdk` worktree (beta3 / the v320 SHA `9d518832d4` lineage), patch `packages/internal/src/hex.js` `decodings` from `new Map(encodings.flatMap(...))` to the validated ordinary `for` loop that `.set()`s the four lower/upper permutations directly (functionally byte-identical Map; validated on V8 in the issue-9 analysis — 484 entries, round-trips ff/0A/aB).
2. Rebuild the ymax0 contract bundle (`packages/portfolio-deploy`, `bundle-ymax0.json`) with the patched dependency. Confirm the rebuilt bundle no longer contains the `encodings.flatMap` construct.
3. Restore the stock value-stack limit: `stackCount = 4096` in `xsnap-native/xsnap/sources/xsnap-worker.c` (the prior experiments left it bumped). Build the from-source xsnap-worker (engine binary already cached on host; the prior driver was wiped by a redeploy and must be re-wired).
4. Drive `importBundle(rebundled ymax0)` through the swingset/zcf xsnap supervisor on XS at stockCount=4096. Decision rule: exit 0 with the full export set (`AxelarConfigShape, contract, extractEvmRemoteAccountConfig, makeEip155ChainIdToAxelarChain, meta, privateArgsShape, start`) == fix confirmed; exit 12 (stack overflow) == the hex.js frame was not the whole deficit (then dump the new value-stack histogram and report the next-largest frame).
5. Capture the attribution + result in the xs-stack-overflow methodology notes on the bot fork (kriscendobot/agoric-sdk#6) so it survives a redeploy.

## Report back
Comment the empirical result on issue #9 (https://github.com/kriskowal/garden/issues/9) — the stockCount=4096 import exit code, the export set if it passed, and the updated histogram if it did not. Never close the issue (the submitter does that).

## Artifacts on host (may be redeploy-wiped — rebuild as needed)
- `~/.cache/garden-scratch/exp6-2worktree/beta3` — agoric-sdk beta3 checkout + built xsnap workers.
- `~/.cache/garden-scratch/exp6-2worktree/beta3/packages/portfolio-deploy/dist/bundle-ymax0.json` — the unpatched bundle.
- `~/.cache/garden-scratch/exp6-ymax0` — @agoric/xsnap wrapper harness + node_modules (ses 2.2.0, @agoric/internal, @endo/*).
- `~/.cache/agoric-sdk/xsnap/prebuilt/0.14.2/...` — cached prebuilt engine.

---
claim:
  host: endolinbot
  gardener: 74
  claimed_at: 2026-06-28T05:10:47Z
