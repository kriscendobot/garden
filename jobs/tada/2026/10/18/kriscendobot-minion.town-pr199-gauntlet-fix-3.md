## Fix round 3: kriscendobot/minion.town PR #199

I applied the round-3 must-fix items and pushed them to `feat/guest-coupons` (41b506f → fc8d73bf) as two follow-up commits. CI is green: `ci-wait-merge.sh` returned rc 0, with `test` and both Claude harness checks passing.

**Must-fix items applied**
- **Short air-drop books (assessor 1, breaker 1, saboteur 1).** A short book stays `pending`, but its delivered coupons could not be attached, and every resume re-sent the whole book. That resend threw once a delivered coupon's name had been swept.
  - Books now record which serials were actually delivered.
  - `attachForHolder` draws only from delivered coupons.
  - `deliver` sends only still-issued coupons the holder doesn't already have.
  - This also fixes the resume duplicates (assessor 2, breaker 3) and the short-book attach gap (breaker 2).
- **Dangling design reference (archivist 1).** The code cited a `designs/guest-coupons.md` that isn't in this tree. Module headers now link to the design PR #144 instead, and the per-block `§` tags and the "open question 2" tag are gone (pruner 6).
- **README says `memory` is local-only (archivist 2, engine-realist 1).** The service now refuses to start with `COUPON_STORE=memory` alongside the Endo daemon (`ENDO_SOCK`), and the README says so.
- **Router built the invitation URL by hand (curator 1).** It now uses `buildInvitationUrl`, so the coupon goes through the builder's validation.
- **No phase-and-evidence ledger in the PR body (integrator 1).** I added one with `Disposition: orchestrated-slice` and `Successor: build-minion-town-guest-coupons-phase1-rest`. Under that disposition the PR stays draft until the successor fills in the evidence.

**Should-fix items also done**
- The sweep records `nameRemovedAt`, so it removes each terminal coupon's name once instead of every tick (assessor 3).
- The README no longer claims `COUPON_TABLE` is validated, and the table-layout paragraph is gone (archivist 3, pruner 2).
- `config.ts` and `store.ts` reuse the existing type unions instead of restating them (curator 3, integrator 4).
- I cut the comments that just restated code (pruner 4, 5).
- The PR body is trimmed. It now says #144's own review is halted and lists the HTTP redemption route as a deviation (integrator 2, 3; pruner 1).

**Tests:** new tests cover a short book being attachable, a resume that sends only the top-up after a delivered coupon is redeemed and swept, the sweep removing a name once, the DynamoDB writes for the two new fields, and the refused config. Locally, typecheck and build pass. The full suite has one failure, in `test/git-remote/capability.test.ts`, a git-remote test that looks like a local-environment problem. That code isn't part of this PR, and the same test passes in CI.

**Follow-ups**
- I posted `build-minion-town-guest-coupons-phase1-rest` as a parked job, released when #199 merges or closes. It owns the deferred phase-1 work: the MCP `invite` coupon argument, `coupon.describe()`, daily counter reconciliation and severing. It also lists the should-fix items I left open:
  - releasing an attached coupon once its invitation is accepted (locksmith 2)
  - expiring the redemption nonce's replay window and clearing it on "forget" (wire-watcher 1)
  - making `guest.js` parse fragments the same way as the reference parser (wire-watcher 2)
  - a per-holder book index so attaching doesn't scan the table (saboteur 2, engine-realist 2)
  - a DynamoDB TTL on terminal rows (engine-realist 3)
- `phase-evidence-gate.sh` still reports `undetermined` for this PR, because the design file only exists on #144's branch.
- **Host problem:** on this host (endolin-garden-ece02cb4), a `watchdog-notice.sh` process (pid 71859, more than 3h old) has held the journal producer lock while it retries a journal fetch that keeps timing out. It delayed posting the successor job by about 8 minutes. Someone should look at it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr199-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 110 tokens (7016622 cached reads)
- Output: 29069 tokens
- Cost: $3.191208399999999
- Wall-clock: 1483s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
