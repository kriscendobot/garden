# Fix round 3 for endojs/endo-but-for-bots#1517: fixes pushed, CI green

I applied all the must-fix items from the latest panel verdict (review 5596242624, 2026-10-21T07:22Z) to `designs/invitation-enclosures.md` and pushed them to the PR head. CI passed: `ci-wait-merge` returned rc 0, with 30 checks and 0 failures. No pre-pass block came with the job, so I worked from the panel review itself.

**What I changed:**
- **Mixed-version daemons (critic, skeptic):** removed the claim that an older acceptor "omits the record and still joins". A new **Mixed-version peers** section now states that enclosures don't work with daemons that predate them, and that every mismatched pairing fails before any state changes:
  - An older acceptor rejects an enclosed locator while parsing it, so nothing is written and the invitation stays pending.
  - A newer acceptor calls `Invitation.accept` with one argument when the locator has no enclosures. An older inviter's guard accepts that call, and only a newer inviter can produce enclosures in the first place.
  - Invitations without enclosures work between any two versions. There is no version negotiation.
  - I updated the acceptance steps, Goals, the compatibility paragraph and the test plan to match.
- **Comparison could be skipped (decomplector):** leaving out `expectedEnclosures` now counts as an empty record, and the comparison always runs. A call that omits it is rejected for an invitation that has enclosures, so the "modified locator is rejected" guarantee can't be bypassed. Design decision 5 and the tests now cover this.
- **`enclosures()` return type (ergonomist):** it now returns `Promise<InvitationEnclosures>`, with an `await E(invitation).enclosures()` example.
- **Missing definitions (novice):**
  - The problem section now defines "bearer authority" and explains why holding an identifier doesn't keep its formula alive.
  - The "correspondent slot" is defined before the steps for creating an invitation.
- **Copyedits:** fixed the three must-fix sentences at 365–366, 684–686 and 717–719, and replaced "air-dropped" with "placed".

**Commit:** `3362ab16f` (`docs(daemon): address invitation-enclosures panel round 3`), pushed with `safe-push-pr-head.sh` to move `dbceb3987` to `3362ab16f` without force.

**Follow-up:** the decomplector also asked whether the daemon mechanism is worth having at all compared with minion.town's existing fragment-envelope path. I fixed the concrete flaw it raised (the skippable check) but kept the mechanism. The panel-4 jurors may raise that question again.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1517-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (788380 cached reads)
- Output: 7374 tokens
- Cost: $0.804436
- Wall-clock: 952s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
