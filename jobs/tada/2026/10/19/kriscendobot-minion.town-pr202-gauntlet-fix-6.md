I applied round 6's must-fix items to PR #202 and pushed them as two follow-up commits, `73b90be` and `12bc087`. CI is green at `12bc087` (`ci-wait-merge` rc 0). A few must-fix items are deferred, not fixed (listed below), because they need the PR rebuilt on #201's current head.

**What changed** (in response to the latest panel review, 5565781874 at `fedda26`):
- **Peer rebinding (locksmith, saboteur):** `chatAppAt` now also requires the app's own `inventory` to be a plain directory. That closes the remove → importLocator(guest) → invitePeer sequence that let a URL holder rebind a peer. A regression test covers it.
- **Earlier mail (breaker, locksmith):** mail from before an introduction no longer leaves the power at all; it used to be returned marked `earlier`. Acting on it is refused as "no such message". I removed the `earlier` field from the power, the page model, the types, the CSS and the tests.
- **Hung accept (assessor):** accepting an invitation outside a chat app's inventory now holds the lock only for its peer check, not for the `accept` call itself.
- **Remote calls holding the lock (saboteur, breaker):** `send`, `reply`, `resolve` and `reject` are checked and started inside the lock but finish outside it, so a peer that never answers no longer blocks every later call. I first tried a lock timeout, but the daemon's evaluation environment has no `setTimeout`. A test holds a send and an accept open while an unrelated write goes through. Cleanup after a failed introduction now also runs inside the lock.
- **Page `submit` (assessor 2–3):** it shows "Not sent" only when the send itself fails, and leaving the conversation mid-send no longer clears the next view's reply target.
- **Trims (pruner):** design § 3's per-method lock list, the repeated depth figure, the restating comments it flagged in code and tests, and the PR body's Verification and Follow-ons sections.
- **Browser demo (coverage-auditor):** `dev/chat-clip-browser-demo.mjs` now fails instead of skipping when it runs under CI without `ENDO_CHECKOUT`.
- **Design and PR body:** `designs/chat-clip.md` §§ 3, 5 and 6 describe the new rules. The PR body now states the PR stays draft behind #201 and #88.
- **Summary comment (scribe):** posted at https://github.com/kriscendobot/minion.town/pull/202#issuecomment-6257882894. It also covers the round-3 commits `44afc57`..`fedda26`, which never got one.

**Tests:** the four chat and New Clip unit suites (46 tests) pass and `tsc` is clean. The three new tests fail against the old code. I couldn't run the real-daemon suite on this host because `ENDO_CHECKOUT` isn't set here; CI ran it and passed.

**Deferred** (reasons are in the PR comment):
- **integrator 1:** #201 has moved past the frozen base, and its current design takes invitations and imports away from the public power, which Chat depends on. The fix is to rebase onto #201's current head and redo design §§ 2–3 behind an owner-held credential (#88).
- **decomplector 1:** moving peers out of the inventory is part of that same §§ 2–3 redesign.
- **coverage-auditor 1 / integrator 2:** the Playwright CI step only exists on #201's newer head, so it can be added after the rebase.
- **integrator 3:** regrouping the commits waits for that rebase so history is rewritten only once.

**Follow-up:** someone needs to decide on, and post, the weave of #202 onto #201's current head plus the §§ 2–3 redesign. Until then, the next panel round is likely to raise integrator 1 and decomplector 1 again.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr202-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (4291557 cached reads)
- Output: 27081 tokens
- Cost: $2.3438674
- Wall-clock: 2088s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
