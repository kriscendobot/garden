The PR head is at my commit `baa20aa` and the `test` check is SUCCESS. Both must-fix items are resolved, pushed, and CI is green.

## Completion report

**Job:** FIX round 5 for kriscendobot/minion.town PR #95 (design panel gauntlet, doc `designs/mcp-guest-surface-documentation.md`).

**Panel round-5 must-fix items applied:**

1. **skeptic — wrong `remove` fix site.** § 1 pointed the build at `root-host-socket.ts`'s `removeValue` (`await E(host).remove` — the `RootHost` admin view used by `repointRoot`'s grant revocation), which is *not* the guest surface. I verified the actual call chain against the PR-head source: the guest MCP `remove` tool → `GuestFacet.remove`'s `await guest.remove(name)` (`guest-control.ts:313`) → the live `GuestAgent.remove` pass-through `remove: (name) => E(guest).remove(name)` in `guestPowersFromDaemon` (`root-host-socket.ts:263`). Rewrote § 1's `remove` narrative, the discriminator paragraph, the Vehicle bullet, and the Verification note to name the correct pass-through, and added an explicit clause flagging `removeValue` as a *different* method so a builder cannot re-conflate them.

2. **pedant — pervasive em-dashes.** Removed all 15 U+2014 em-dashes from prose per `skills/em-dash-style`, each rewritten by judgment (period, colon, or parentheses — not mechanical substitution). The `1–255` en-dash inside the quoted literal error string is exempt (data) and preserved.

**Push & CI:** committed to the project worktree, pushed as a review-feedback follow-up (`944a7d1..baa20aa`) with `safe-push-pr-head.sh --mode advance` (clean fast-forward). CI watched bounded to terminal: `test` check = SUCCESS, rollup **GREEN** (rc 0) on head `baa20aa`.

**Verification:** post-edit grep confirms 0 em-dashes remaining and the sole surviving `removeValue` mention is the deliberate "different method" clarification.

**Follow-ups:** none for this stage. The driver re-posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr95-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 132 tokens (6304907 cached reads)
- Output: 34249 tokens
- Cost: $5.2531785
- Wall-clock: 1128s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
