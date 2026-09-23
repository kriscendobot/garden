Inbox empty. The fix stage is complete.

## Completion report — gauntlet FIX round 6, endojs/endo-but-for-bots PR #1310

Applied the panel round-6 must-fix items to the PR head (`bot/build/guest-native-accept`), pushed as review-feedback follow-up commits, and drove CI to green.

**What changed**
- **Inviter-side additive-write race (assessor + saboteur, both must-fix).** `Invitation.accept` made the same additive-only routing writes (`writeRemoteAgentKey`, `addPeerInfo`) as the acceptor-side `acceptInvitation`, but was guarded only by the per-invitation `invitationJobs` queue — fresh per invitation, so it did not serialize two invitations redeemed concurrently on the same inviting daemon. Two locators naming the same not-yet-known node could each pass the `=== undefined` additive guard before either wrote, letting the later write silently redirect the earlier one's route. Fixed by serializing the inviter-side check-then-write on the same daemon-wide `acceptInvitationJobs` queue the acceptor side uses. Verified deadlock-free (the acceptor's queue-holding round-trip only re-enters this handler in the same-daemon case, where the local-node skip fires first). Commit `f157fbfdd1`.
- **PR body template (integrator, must-fix).** Rewrote the description against the repo PR template (Refs + Description + Security/Scaling/Documentation/Testing/Compatibility/Upgrade sections) and stripped all file-path callouts.
- **Changeset sentence-per-line (changeset-auditor).** Rewrapped each sentence onto its own line; also updated the changeset to state the concurrency guarantee now holds on both sides. Commit `941b4c6093`.

**Surfaced, not changed:** breaker's must-fix (invitation `from`/`fromNode` authenticated only as well-formed, not as belonging to the redeemed party — a first-contact/TOFU squat) is a protocol-level change that predates the guest facet; noted under Security Considerations as a maintainer-facing follow-up rather than unilaterally redesigned in a fix round. Prover's/corner-prober's untested cross-daemon same-target race: documented in-code and under Testing Considerations as undrivable in-process (no timeout injection seam; same-process delivery already serializes same-daemon calls), so no meaningful fail-without-fix test could be added.

**Verification**
- Ran the ocapn multiplayer suite (34 tests, incl. the concurrency race) and the same-daemon `duplicate accept` test — all passed locally with the fix.
- Bounded CI watch: **GREEN** — 32 checks, 0 failed, head `941b4c6093`.
- Posted a completion-summary comment (#issuecomment-5747868503).

Did not re-run the panel (the driver re-posts panel-7).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1310-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s)
- Input: 152 tokens (7100276 cached reads)
- Output: 54869 tokens
- Cost: $7.8499919999999985
- Wall-clock: 2314s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
