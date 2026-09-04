CI is terminal and **green** — all 5 checks (browser-tests, test, lint, zizmor, build) succeeded on my commit `bbb779faf9`, which is still the PR head. The fix stage is complete.

## Completion report — gauntlet FIX round 6, endojs/endo-but-for-bots PR #1116

**PR:** design-only (`designs/guest-native-invitations.md` + `designs/README.md`). Applied the panel round-6 must-fix items once, pushed as a review-feedback follow-up commit, and CI is green.

**Commit pushed:** `bbb779faf9` on `design/guest-native-invitations` (via `safe-push-pr-head.sh`, advance mode, fast-forward over `9d4ae53e56`).

**Must-fix items addressed:**
- **critic 1** — Enumerated the store-controller layer the raw pet-store CAS bypasses and how each invariant is preserved: the winner now replays `removeEdgeIfUnreferenced(invitationId)` after the CAS so the consumed invitation formula's edge is released (matching store-controller's direct call, not wrapped in the lock), preventing a retention regression.
- **critic 2 / skeptic 1** — Ordered the inviter-side known-peers *write* behind the winning CAS (read-only conflict determination stays before it, keeping `peer-conflict` non-consuming), closing the spent-locator growth vector; narrowed Open Question 6.
- **critic 3 / skeptic 1** — Pre-check the acceptor pet name before spending the invitation, so a `name-in-use` collision no longer burns the one-time invitation (section 2 step 3, section 9 sequence).
- **critic 4** — Reframed the failure-taxonomy axis as exceptional-versus-terminal (not locally-vs-remotely decided) and marked each terminal status consumed/not-consumed.
- **critic 5** — Corrected "no CLI dispatch change needed": `accept.js` discards the result, so the throw→returned-status change must sweep that consumer (read status, exit nonzero on dead-link statuses).
- **skeptic 2** — Added a concurrency consume-once test (two concurrent accepts → exactly one `joined`, one `already-consumed`) and an overwritten-id collection test.
- **skeptic 3** — Named the consumer eventing story (`followNameChanges` edge + `locate` kind, or accepted polling).
- **ergonomist 1** — This increment makes `remove`/`rename` reject on a pending-invitation entry so neither ships as a silent false revocation affordance; narrowed Open Question 5.
- **copyeditor/novice/pedant** — Fixed the reversed `even though` connective, corrected the `fromNode`/`handleNode` attribution, dropped the panel-artifact leak, glossed `exo` and `handle`, removed all em-dashes and the `§` spelling, and added the missing README M8 estimate row + updated the net-new count and Total remaining.

**Follow-ups:** none for this stage. The driver re-posts panel-7 to re-review the applied fixes; I did not re-run the panel per the stage contract.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1116-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s)
- Input: 144 tokens (7267178 cached reads)
- Output: 50679 tokens
- Cost: $9.057686749999998
- Wall-clock: 1535s
- Model(s): claude-opus-4-8 ×4

<!-- garden-usage-end -->
