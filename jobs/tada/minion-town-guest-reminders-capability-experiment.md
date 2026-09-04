Inbox empty. All deliverables complete. Writing the completion report.

---

## Completion report — `minion-town-guest-reminders-capability-experiment`

**Outcome: the `@reminders` capability was injected into a freshly-created minion.town guest and validated firing end-to-end in production.** The maintainer's "Report here" ask on endojs/endo-but-for-bots#935 is answered with concrete evidence.

### What I did
1. **Established ground truth** against the live daemon (SSM to `i-0380cd68b90020fad`): daemon active, socket up, pinned at `endo-but-for-bots@f6650503`; `@endo/reminder` absent; and — critically — the daemon's `EndoHost` **already has** `makeUnconfined` + `provideScratchMount` (the design's §2 primitives), so provisioning needs no daemon bump.
2. **Staged `@endo/reminder`** (llm `0eb88836`) onto the box with sibling `@endo/*` symlinks resolving against the daemon's own realm — the "minimum that unblocks" (scope 2).
3. **Provisioned a fresh guest as the daemon host** (`mkguest` → `mktmp` mounts named *into* the guest → `makeUnconfined('@endo/reminder', {powersName:<guest>})`), plus a small **recipient adapter** caplet that turns the plugin's `notify` into an inbox-mount write + `@self` guest-mail forward + one-shot resolve.
4. **Validated in production**: a fresh guest fired an `e2e-prod-test` reminder on a precise 2000 ms cadence — **44 firings**, each delivered to the recipient inbox mount (with reminderId `91ccee76…`, messageNumbers, `scheduledAt≈actualAt` timestamps) **and** the guest's own `@self` mailbox (count = 44). Capability confirmed present in the guest namehub; service formula id `16016db1…:9b03f5b4…`.
5. **Fully reversed**: removed test guests + all staged files; daemon pin and `/opt/endo` left **pristine** (verified).

### What changed (committed to `kriscendobot/minion.town@main`, `5a57175..a058f3d`)
- `deploy/aws/scripts/provision-guest-reminders.sh` — reproducible out-of-band provisioning (`stage`/`provision`/`demo`/`deprovision`/`unstage`).
- `deploy/aws/reminder/{reminder-recipient.js, store-deployed-daemon-shim.js, ENDO_REMINDER_SOURCE_COMMIT}`.
- `designs/endo-reminder-minion-town.md` §7 — production-experiment findings.
- Report comment: https://github.com/endojs/endo-but-for-bots/pull/935#issuecomment-5536446610

### Blocking unknown hit (and worked around)
The deployed daemon pin (`f6650503`) **predates the reconciliation of the mount's writable-tree verbs** the plugin's `store.js` expects (`writeText`/`maybeReadText`/1-arg `makeDirectory`/array `list()` vs. `write(name,text)`/`snapshot.json`/cursor). I ran the experiment via a store shim (a documented stopgap). The clean unblock is the design's Gate 1: **redeploy the daemon at llm `0eb88836`** and drop the shim — **protocol-safe for the app** (the ported CapTP client's source `packages/daemon/src/client.js` is byte-identical between the pins). I did **not** ship that coordinated daemon+app redeploy of the live serving path unilaterally under an experiment.

### Residual follow-ups (in the #935 comment + design §7)
(a) the daemon+app pin bump to `0eb88836`; (b) upstream the §4 guest-mail delivery so the recipient adapter retires; (c) auto-inject on new-guest creation via an app-side `ReminderTenantService` (needs the app to reach `makeUnconfined`); (d) `@pins` wake-on-restart not exercised.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-guest-reminders-capability-experiment.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 118 tokens (7098216 cached reads)
- Output: 105839 tokens
- Cost: $7.450179250000001
- Wall-clock: 1838s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
