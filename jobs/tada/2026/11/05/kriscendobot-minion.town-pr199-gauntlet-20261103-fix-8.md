**Fix round 8 for kriscendobot/minion.town#199: all panel-8 must-fix items are applied, and CI is green at head `c3ce331c`.** No deterministic pre-pass block came with this job, so I worked from the latest panel verdict (review 5778806352). As instructed, I did not re-run the panel.

CI was read through the Actions runs API because the PAT can't read `statusCheckRollup`, so commit statuses and non-Actions checks weren't visible. Both visible runs passed: `test (typecheck + vitest)` and `clip frame browser gate`. Locally, typecheck and the coupon, home-page and deploy test files passed. The daemon suite skips locally, and I did not confirm that it ran in CI. ESLint couldn't run because the repo has no ESLint config.

**Must-fix items**
- **Ledger replay (locksmith, breaker, purist, wire-watcher):**
  - Rows now hold only a digest of the redemption nonce, so a value read from a row is refused at redemption.
  - Replay ends one day after redemption, or as soon as the sweep drops the name. New tests cover both.
- **`coupon-airdrop all` skipped signed-in guests (breaker):** it now includes `g-<digest>` guests, using the pinned handle grammar instead of the loose regex.
- **Flip could silently reopen admission (integrator):**
  - The README now names the drop-in `/etc/systemd/system/minion-mcp.service.d/guest-coupons.conf`.
  - `deploy-app.sh` now fails the deploy if `/api/guest/admission` differs from what the unit and drop-ins render. That check has only had a syntax check, because it can't run off the box.

**Should-fix items also applied**
- **Ledger and output:**
  - Rows no longer store `attachedTo`.
  - `coupon-revoke` prints only the serial and status.
- **Invitations:**
  - `attachForHolder` reads a new `HOLDER#<digest>` index instead of scanning the table.
  - A ledger failure now costs an invitation its coupon, not the invitation.
  - The unused `attachCoupon` option is gone.
- **Air-drop:** a recipient that doesn't resolve fails alone, with `count: 0` and an `error`. It has no book, so a resume won't retry it.
- **Daemon connection:**
  - The shared connection now drops only on a transport failure.
  - `provideCouponGuest` no longer retries on a fresh connection.
  - `root-ctl`'s sweep leaves stale leases to the service.
- **Browser:** a refused coupon on an invitation link falls back to `POST /api/guest`. Under coupon admission the visitor still sees the coupon's own refusal.
- **Docs:**
  - Pruner's comment cuts are done.
  - Stale prose is fixed in the waitlist design, `DEPLOYMENT.md` and the § 6 diagram.
  - `recursive-dynamodb-capabilities.md` lists the new `HOLDER#` items.
  - Design § 12 and the PR body now label the rules added after approval, and the flip wording is reconciled with the 2026-11-03 comment.

**Not fixed; panel-9 may raise these again**
- **Create authority (locksmith):** closed admission is still a runtime gate over retained create authority, including the delete-then-provide race in `closedToNewGuests`.
- **Attachment by digest (locksmith):** coupons still attach by digest match rather than from a held coupon. Design § 12 now records this as a phase 1 limitation.
- **Sweep cost (engine-realist):** the sweep still scans all history on every tick, and there is no TTL or archive for terminal rows.
- **Attach reads (engine-realist):** `attachForHolder` still does one `GetItem` per delivered serial.
- **Overlapping binds (saboteur, engine-realist):** `bindCoupon` can still overlap across processes in a narrow window.
- **`couponId` left readable:** an `issued` row's `couponId` still redeems, so a ledger read can spend a pool unit. It can't yield an existing guest's credential, and § 12 records this as a decision for the maintainer to veto.

**Commits:** `0edfbcd6` (docs) and `c3ce331c` (fixes and tests), pushed with `safe-push-pr-head.sh`. The PR is still a draft.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr199-gauntlet-20261103-fix-8.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (2802191 cached reads)
- Output: 42864 tokens
- Cost: $2.8931502
- Wall-clock: 902s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
