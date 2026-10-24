---
handed-off: migrate-coupons-onto-exo-dynamodb
deliverable-complete: false
---
I didn't start the migration because its precondition isn't met: the `@endo/exo-dynamodb` build PR doesn't exist yet. Instead I parked a successor job that owns all of the remaining work and starts on its own once the build lands.

**What I found**
- The design PR, kriscendobot/minion.town#221, is still an open draft and was last updated 2026-10-24T03:30Z.
- No `@endo/exo-dynamodb` PR exists in kriscendobot/minion.town.
- No `build-recursive-dynamodb-capabilities` job is anywhere on the board (todo, doin, plan, orch or tada).
- `jobs/plan/design-recursive-dynamodb-capabilities.md` is still parked as `gate: deferred`, even though its PR #221 is already open.

**What I did**
- Parked `migrate-coupons-onto-exo-dynamodb` in `plan/` with `gate: blocked` and `blocked_on: build-recursive-dynamodb-capabilities`; it is pushed to `origin/journal2`. Its body carries the full migration task (coupon ledger and confined issuer onto `@endo/exo-dynamodb`, separate PR, per the design's guest-coupons migration path) and an instruction to re-park if claimed before the build PR exists.
- I made no garden or project code changes and opened no PR.

**Follow-up for the maintainer or liaison**
- The successor only starts once a job named `build-recursive-dynamodb-capabilities` reaches `tada/`. No such job has been posted, so it will stay parked until the `@endo/exo-dynamodb` build is posted under exactly that basename, presumably after #221 clears review.
- The deferred design plan that already has PR #221 open may be stale; it's worth a look.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-design-recursive-dynamodb-capabilities-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (537291 cached reads)
- Output: 3645 tokens
- Cost: $0.5883022
- Wall-clock: 170s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
