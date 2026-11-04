I fixed all four must-fix items from the round-4 panel on kriscendobot/minion.town#239 and pushed them as three follow-up commits (`44215036..9b22457d`). CI is green on all 7 checks. That includes the live-daemon invite/accept leg, so the new forged-`from` test and the normal accept both ran against a real daemon.

**What changed**

1. **Rewritten `from`/`fromNode` (wire-watcher must-fix; same issue as locksmith #1 and saboteur #4)** — commit `097369ca`.
   - **The hole:** the daemon links the invitee's new contact to whatever `from` and `fromNode` the locator carries and never checks them against the real inviter. Anyone holding a live link could rewrite `from` so the victim's contact pointed at a third party.
   - **The fix:** `BrowserGuestDirectory.localNode()` is replaced by `isLocalInvitation(locator)`. Before accepting, it looks the invitation up on this daemon and compares the locator with what the invitation's own `locate()` reports: node, number, `from` and `fromNode` (connection hints aside).
   - **Effect on the route:** it answers only yes or no and never dials. A locator from another node, a forged number, a non-invitation formula, or a rewritten `from`/`fromNode` now gets a 404 before the daemon's accept runs. This also covers saboteur #2 (a forged number naming a non-invitation formula got 503, not 404).
   - **Comments:** the directory's contract comment is corrected (locksmith #2). The "no gap" and "possession is the authority" wording is gone from the router.
   - **Tests and docs:** the design doc states the inviter check. The fake-daemon fault tests got the new refusal cases, and the real-daemon test gained rewritten-`from` and rewritten-`fromNode` cases.
2. **Invitation card hidden for a visitor who already has a guest (integrator must-fix)** — commit `a6815672`. In `home.js`, a visitor with a live guest and an invitation in the link now sees the invitation card instead of being sent straight to the shell. This is the same guard as #243.
3. **Locator form missing from the typed parser and design (surfacer must-fix-loop #1 and #2)** — commit `9b22457d`.
   - `src/web/invitation-envelope.ts` now parses `#v=1&locator=`. It refuses a repeated locator, and a locator together with another credential. It also adds a `locator` startup decision.
   - Envelope tests cover these cases.
   - The landing table in `designs/closed-beta-waitlist.md` now lists the locator link.

**Verification**
- Type-check is clean, and the local `test/web` run passed (190 passed; the 8 skipped need a live daemon locally).
- The full local suite had one failure, `test/git-remote/capability.test.ts`. That module isn't touched by this PR, it matches a known local git-wrapper false-fail, and it passed in CI.

**Not done**
- I left the should-fix and comment-only items alone: pruner trims, decomplector, engine-realist, and the changeset wording.
- I also left the minor Caddy comment that only lists `invitation=`.
- The PR body still needs touching up in a later round.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr239-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 90 tokens (3826843 cached reads)
- Output: 19559 tokens
- Cost: $1.9693406
- Wall-clock: 655s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
