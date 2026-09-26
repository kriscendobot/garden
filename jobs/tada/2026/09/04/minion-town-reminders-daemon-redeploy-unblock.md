Inbox empty — no immediate reply. The core deliverable's authorization-gated branch is now satisfied: steps 1–2 verified, the plan + rollback recorded in the design doc, and the authorization request posted. I'll complete under the design's second definition-of-done branch.

## Completion report

**Job:** `minion-town-reminders-daemon-redeploy-unblock` — unblock `@endo/reminder` provisioning by redeploying the minion.town daemon at llm `0eb88836` (retiring the `store-deployed-daemon-shim.js` stopgap).

**Outcome: authorization-blocked plan recorded (DoD branch 2).** The redeploy is a consequential production action and was **not** executed unilaterally; it is held for explicit maintainer authorization, which was requested.

### What I did
1. **Recovered the experiment's provisioning path** — read the design findings (§7), `provision-guest-reminders.sh`, `store-deployed-daemon-shim.js`, `reminder-recipient.js`, `deploy-endo-daemon.sh`, and both pins (`ENDO_REMINDER_SOURCE_COMMIT` = `0eb88836`, deploy `ENDO_COMMIT`/`captp-client.ts` `PINNED_ENDO_COMMIT` = `f6650503`).
2. **Verified the premise live (SSM):**
   - Live daemon pin `/opt/endo/ENDO_COMMIT` = `f6650503`, `endo-daemon` **active**, socket present.
   - **Byte-identical claim HOLDS:** `client.js` (`0859aeab…`) and `mail.js` (`6ef7c33b…`) are identical at `f6650503` and `0eb88836` and match the box; `0eb88836` is a forward move on `origin/llm` (1317 commits ahead). §7's abort condition is **not** triggered.
3. **Surfaced a risk the design's §7 did not weigh:** `client.js` byte-identity covers only the *wire* protocol. The daemon's *persistence* layer changed heavily across the gap (+7733/−1090 over 60 files — `manager-database.js`, `manager.js`, `formula-record.js`, `mount.js` reconciliation, new `registry.js`/`secret-manager.js`), and the live daemon revives a **~12 MB sqlite state (723 files) of real production guest formulas** that the deploy preserves across the `/opt/endo` swap. Reviving that state at `0eb88836` — and whether it migrates the schema in place — is **unvalidated** and is the dominant risk, not the app protocol.
4. **Recorded the verified premise + exact redeploy/rollback plan** as design **§8** (state snapshot for rollback, staging state-revival dry-run before the live swap, dual-pin bump, post-deploy gates). Pushed to `kriscendobot/minion.town` main as `89904a9` (direct-to-main, matching the prior experiment commit; unrelated `package-lock.json` churn deliberately excluded).
5. **Posted the authorization request** to the maintainer inbox (`20260904T063018Z-6a1c2e`) with the verified facts, the state-revival risk, the procedure, and three decision options.

### What changed
- `designs/endo-reminder-minion-town.md` — new §8 (verification + authorization-blocked redeploy/rollback plan). Shim, provisioning script, and pins are **untouched** (their removal is post-authorization, post-redeploy work).

### Follow-ups / not done (correctly gated)
- Steps 3–5 of the job (execute redeploy, re-provision shim-free, delete the shim + drop its wiring, mark blocker cleared) require maintainer authorization and were intentionally not performed.
- **Recommendation to maintainer:** do the staging state-revival dry-run before any live swap; a bare §7 redeploy risks the live sqlite state.
- A reply to the posted message dead-letters into a fresh job that resumes execution, or the job can be re-posted once authorized.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-reminders-daemon-redeploy-unblock.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (1744834 cached reads)
- Output: 26675 tokens
- Cost: $2.0562347500000002
- Wall-clock: 642s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
