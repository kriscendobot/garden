Inbox empty. Recap posted, investigation advanced as far as the export allows. Completion report follows.

---

# Completion report — `kriskowal-garden-pr9-d25b9529`

**Job:** attention directive on kriskowal/garden issue #9. Maintainer (kriskowal) asked, via the issue thread, to (1) continue the `investigate-beta3-ymax0-xs-repro-and-fix` investigation **without** the v320 swing-store export, and (2) recap findings so far.

## What I did
- Re-fetched the directive comment (treated as untrusted data) and the issue body/title, which pointed at the maintainer-inbox follow-up file naming the two prior investigations (`investigate-beta3-ymax0-portfolio-upgrade-stack-overflow` and `…-xs-repro-and-fix`). Read both `tada` reports off `origin/journal2` (read-only via `git show`).
- Found the prior session's built fork + XS toolchain at `/home/kris/agoric-sdk` is **gone** (wiped by a redeploy), so the heavy synthetic-XS-repro path can't resume from the built engine without re-provisioning a multi-GB fork.
- Pursued the feasible export-free continuation instead: dispatched a read-only source investigation over `kriscendobot/agoric-sdk@9d518832d4` (GitHub API, no clone/push) to close the prior report's one honest open gap — *which durable field accumulates depth per incarnation*.
- Posted a substantive recap+continuation comment on issue #9 per the issue-inbox consumer contract; left the issue **open** for the submitter to close.

## What changed / findings
- **No repo changes** — analysis only, no clones/pushes/PRs.
- **Recap delivered** (crash located at durable kind 17 `"offer handler taker"` rehydration; overflowing fn = `passStyleOf` copyRecord descent; XS-only because XS budget ≈115 levels vs V8 ≈2047; Endo empirically ruled out by beta2↔beta3 bisection → contract-side #12761).
- **New, this round (export-free advance):** portfolio durable state is uniformly flat/bounded, so the over-deep value must live in the **async-flow durable `log`** of an un-disposed (Sleeping) flow — best candidate an `M.any()` payload carrying an orchestration `ProgressTracker` `{value, tail}` chain. **New lead:** `agentMemo` (caller-supplied, `portfolio.exo.ts:700-710`) as a plausible untrusted-depth injection point in #12761 territory. Surfaced three confirm-without-export options (synthetic xsnap depth test, `LogEntryShape` depth bound, `LogStore.dumpUnfiltered()` measurement).
- **Honest limit:** no source path provably nests +1 level *per incarnation* into a single record; if it exists it's in a dep not fully opened (`@agoric/vow` durable resolution store / `replay-membrane.js`) or in `agentMemo`.

## Comment posted
https://github.com/kriskowal/garden/issues/9#issuecomment-4823197750

## Follow-ups (maintainer's call — agoric-sdk/chain territory, out of autonomous bounds)
1. **v320 swing-store export** remains the one blocker for a real-data trace; if sourced, replay under a rebuilt XS engine to dump the actual over-deep frame.
2. Optional: I can post a **synthetic-harness job** on the bot fork to confirm the mechanism without the export (multi-hour, needs the XS toolchain re-provisioned).
3. **Housekeeping (flagged, not actioned):** the deployed root checkout `/home/kris` carries stray untracked scratch from the prior session — `bundle-ymax0.json` and `wt-507/` (a leftover endo worktree). These can cause ff-wedges on deploy. I did not delete them (not mine to remove in the deployed root; that's wedge-resolution/watchman territory), but they should be reaped.
