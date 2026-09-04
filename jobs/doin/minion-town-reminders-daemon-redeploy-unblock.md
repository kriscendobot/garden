---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot/minion.town (worktrees/kriscendobot-minion.town). Follow-up to commit a058f3d, "experiment(reminders): inject @endo/reminder into a live guest + validate".

That experiment validated @endo/reminder firing inside a live minion.town daemon guest, but only by way of `deploy/aws/reminder/store-deployed-daemon-shim.js` — a shim that speaks the DEPLOYED daemon pin's (f6650503) pre-reconciliation mount verbs. The findings section the commit added to `designs/endo-reminder-minion-town.md` names the clean unblock: redeploy the daemon at llm `0eb88836`, where the mount writable-tree reconciliation the plugin's store actually expects is present, and where `client.js` is byte-identical to the deployed pin (so the redeploy is protocol-safe for the app).

Do this:
1. Read `designs/endo-reminder-minion-town.md` (production-experiment findings section), `deploy/aws/scripts/provision-guest-reminders.sh`, `deploy/aws/reminder/store-deployed-daemon-shim.js`, and `deploy/aws/reminder/ENDO_REMINDER_SOURCE_COMMIT` to recover the experiment's exact provisioning path and the shimmed verbs.
2. Confirm on the live host (AWS/SSM Run Command access is available from this box) what daemon pin `/opt/endo` is actually running, and diff `client.js` between that pin and llm `0eb88836` to re-verify the byte-identical claim BEFORE proposing any move. If the claim no longer holds, stop and report — do not redeploy.
3. **The daemon redeploy is a consequential production action on a live deployment. Do NOT perform it unilaterally.** Prepare the exact redeploy + rollback procedure, post it to the maintainer inbox, and wait for explicit authorization. Only then execute.
4. After the redeploy, re-run `provision-guest-reminders.sh` against a fresh throwaway guest with the shim REMOVED, and confirm the reminder fires and lands in both the recipient inbox mount and the guest's @self mailbox, as the shimmed run did (2000ms reminder, observed 44x).
5. On success, delete `store-deployed-daemon-shim.js`, drop the shim wiring from the provisioning script, and update the design's findings section to record the blocker as cleared and the pin it was cleared at. Clean up test guests and staged files; leave `/opt/endo` pristine as the prior run did.
6. If authorization is not granted, land steps 1–2's verification as an update to the design doc (recording whether the byte-identical claim still holds at the current pin) and report the redeploy as pending maintainer decision.

Definition of done: either the shim is gone and reminder provisioning works against the deployed daemon unaided, or the design records a verified, authorization-blocked unblock plan with the rollback path spelled out.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-04T06:19:23Z
