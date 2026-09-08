CI is green (rc 0). The fix stage succeeded.

## Completion report

Applied the round-4 design panel's must-fix items **once** to `designs/claude-on-minion-town-evaluation.md` on PR #98's head (`design/claude-on-minion-town-evaluation`), pushed as a review-feedback follow-up commit, and watched CI to green. Did **not** re-run the panel.

**What I changed** (one commit `153a88a`, single design-doc file):

Blocking (request-changes) items:
- **critic** — child-quota exhaustion: made per-attempt child dismissal an *authoritative* cleanup step (not the prior optional afterthought), citing the eight-per-`iss+sub` retained-child cap; `finish` now reclaims the slot before the daemon stops, and an unreclaimed slot marks the cell quota-leaked and fails the gate (§ 4 cleanup + § 8).
- **critic** — endowment idempotency: explicitly *owned* the redemption path's divergence from `create`'s idempotent get-or-create (a lost-ack retry resolves `ticket-spent`; recovery is an endowment-free `create` lookup), rather than silently dropping idempotency (§ 1.1).
- **decomplector** — isolation invariant: replaced timestamp-window correlation with an inference-scoped **nonce** correlated by exact value equality, dropping the clock-sync / window-boundary assumptions the invariant relied on (§ 1.1 table, § 1.2, § 6 row, § 7).
- **skeptic** — Flow B re-trigger: reframed the mailbox re-trigger as a hard checkpoint that current evidence (`endo-reminder-minion-town.md`) contradicts, with two named prerequisites and a fail-closed fallback (§ 4, § 7); added the two missing adversarial checks (stale-run/old-guest; post-seal setup authority) to the § 6 catalog.
- **copyeditor** — all five wording fixes (declarative voice, "graded as an isolation failure" consistency, dropped "that", "the product of", "a defense against the machine owner").

High-confidence should-fixes (comment-only jurors):
- **ergonomist** — renamed the `observe` subcommand to `assert-sealed` (stops colliding with `wait`'s `observe-token`/`observation.json`); reserved "harness" for the § 4 shell realization and used "driver" elsewhere, dropping the third "runner" synonym.
- **pedant** — removed ALL-CAPS emphasis in the shell comments.

Reverted an incidental `package-lock.json` change from the warm-cache install so only the design file was committed.

**Result:** pushed cleanly (`d76c9b4..153a88a`), CI GREEN (1/1, 0 failed). The driver re-posts panel-5.

Follow-ups: none from me — the design's own hard prerequisites (Flow B invitation primitive PR #1125, the mailbox re-trigger / concurrency lift, the credential broker + nonce channel) remain unbuilt blockers the document itself now tracks explicitly.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr98-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 120 tokens (5916106 cached reads)
- Output: 43825 tokens
- Cost: $5.228291999999999
- Wall-clock: 730s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
