Fix round 3 complete for kriscendobot/minion.town PR #56 (design: invitation-only guest onboarding).

**What I did.** Read the panel-3 request-changes verdict (must-fix aggregate from critic, skeptic, decomplector, ergonomist, pedant, novice; copyeditor comment-only) and applied every finding once as a single review-feedback follow-up commit (`ccc31e1`) to the PR head, then pushed via `safe-push-pr-head.sh` and watched CI to green.

**What changed** (all in `designs/invitation-only-guest-onboarding.md`):
- **critic (must-fix):** rewrote §5's contradictory "ensure-shaped" idempotency claim as an explicit **claim-then-commit** protocol — an atomic token CAS claim must win *before* `accept` (which §4 says mints a fresh guest, so it is *not* idempotent), and the durable spend follows `provision`; a mid-flight crash leaves the claim reclaimable so retry re-drives idempotently.
- **skeptic:** named the uniqueness domain for the single shared app-held host's name-keyed handle exchange (slot names derived from the opaque token; read-back of the `void`-returning `accept` runs in one app-side critical section per redemption); named §2a's migration write surface (one-off admin-credentialed batch writer, not the serving path).
- **decomplector:** added the crash-between-mint-and-move recovery story to §4 and §9 Q5; recorded the `c-` lexical-prefix vs. structural-split tradeoff and filed the split as new §9 Q6.
- **ergonomist:** moved the "name already in use" sentinel off `guest_contacts` (a pure read) onto `guest_invite`; specified the caller-facing `guest_introduce(contactName, toContactName)` signature.
- **pedant (must-fix):** removed all em-dashes (project no-em-dash rule, verified zero U+2014 and zero other typist-hostile code points, including in my own additions); backticked the `retention-ocapn` test-lane reference.
- **novice/copyeditor:** glossed `formula`/`guestFormulaNumber`, `memberAgent`, `mapping storage: none`, SSM, exo, CapTP, ocap at first use; fixed the intransitive lede, the run-on, the semicolon splice, the ambiguous "It" antecedent, and the second-person voice shift.

**Result.** Pushed `5b21a64..ccc31e1`; CI terminal GREEN (rc 0, 1 check, 0 failed). Per the stage contract I stopped without re-running the panel; the driver re-posts panel-4.

**Follow-ups:** none blocking. Two new open questions (Q5 crash-recovery shape, Q6 contacts-namespace structure) are now maintainer-decidable in the design; the same-daemon-`accept` build-time spike remains the standing gate on the eventual build.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr56-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 95 tokens (4409528 cached reads)
- Output: 32529 tokens
- Cost: $3.940491999999998
- Wall-clock: 512s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
