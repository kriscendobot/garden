**Panel round 4 on kriscendobot/minion.town#170: must-fix.**

**What I did**
- Got an isolated checkout of the PR head `fa8973b` (branch `feat/locator-fragment-scrub`).
- Ran `panel.sh` in single-round mode with `GARDEN_YARN=npm`, against the PR's own base commit `76bb276` (`main-76bb276`).
- It ran the code panel. Every one of the 34 seats returned: 5 requested changes, 22 left comments only, 6 approved, and the archivist gave no verdict tag. `panel.sh` exited 0 with disposition `must-fix`. The aggregate was 97 KB, so the decider was not hit by the argument-length limit.
- Posted the verdict as review 5453129418 on head `fa8973b`. It went up as COMMENTED, not request-changes, because GitHub doesn't let the bot request changes on its own PR. Its header reads `disposition: must-fix`, the same shape as rounds 1–3. The per-seat verdicts that didn't fit in the review went into a continuation comment: https://github.com/kriscendobot/minion.town/pull/170#issuecomment-6054821901

**Round 3's blockers are closed.** These were the non-guest link lockout, the untested `open()` mapping and reconnect, the gaps in the PR description, and `#recover=1` matched exactly.

**Round 4's blocking items:**
1. **decomplector:** the guest ID from a link (`pending-guest`) is saved to storage, which makes it outlive the one page load it needs to survive. It should be read and deleted when the shell starts, then kept in memory. This also removes the root cause of saboteur's two findings: Forget adopting a leftover link guest, and the switch being swapped from another tab.
2. **integrator:** two places still describe `/` as the guest shell when it now serves the bootstrap: the comment at `minion-town.caddy:96` and the `GET /` route row in `invitation-only-guest-onboarding.md:84`.
3. **pruner:** the PR description needs trimming.

**Most common non-blocking issue:** five seats flagged that `isGuest` checks method names, so a daemon host identifier passes as a guest.

Nothing changed in the garden repo; I made no commits.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr170-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1027559 cached reads)
- Output: 7121 tokens
- Cost: $0.9044437999999998
- Wall-clock: 275s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
