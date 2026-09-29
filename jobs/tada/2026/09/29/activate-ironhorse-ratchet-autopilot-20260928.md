---
handed-off: activate-ironhorse-ratchet-autopilot-20260929
deliverable-complete: false
---
# Activation report: `activate-ironhorse-ratchet-autopilot-20260928`

**Outcome:** the ratchet autopilot is **not live yet**. The deployed leader never reached the new code during this run. I handed all remaining work to a successor job, and the schedule is still deferred so it can't fire on the old code.

## What I checked (from freshly synced journal state via the ratchet helper's own clone)
- **Delegation:** `config/delegations/ironhorse-test262-ratchet` is `active`. It is bound to kriskowal's authorization `entries/2026/09/28/201230Z-message-gardener-aa49da.md` (sha256 `92cc11db…`), for `endojs/endo-but-for-bots`, base `llm`, and the arc marker. There is no revocation tombstone.
- **Ratchet state (`ironhorse-ratchet.sh status`):** crank 3. The floor is still `refresh-20260904` (sha256 `322ca2ba…`), the branch point is `47f6965d…`, and there are no actions or queue. Nothing was attested or merged.
- **No watcher tick was ever emitted.** No `ironhorse-ratchet-watch-*` job exists anywhere on the board, so there was nothing to reconcile.

## CI blocker: cleared
The failing test was `test_maintainer_inbox_information_hiding.sh`. Another job fixed it with `d659b3ffd61` ("restore maintainer-inbox information hiding"), and the `checks` workflow on main2 has been green since `4767705b28d`. I did not touch that role policy.

## Deploy: still in progress, not finished
- The leader's deployed checkout is still at **`e036bb8e065`**, which comes before `c3aae0b2c0c`. Its scheduler and claim scripts contain no ratchet code (checked with grep; I ran no git in the root).
- The rolling deploy is working normally but keeps restarting because main2 keeps moving (targets 509c6c9 → 4767705 → e3e285a → 894f267 → af18177):
  - Canary `endolin-garden2` passed for `894f2675` at about 23:25Z.
  - Canary `oros-studio` then waited behind a long monk job and was flagged STUCK.
  - main2 then advanced to `af1817773cd8`, and the roll started over from garden2, which is again waiting behind a long monk job.
- No canary or CI bypass was used.
- Possible fleet issue: each main2 push restarts the canary's release clock, and with it the 30-minute timer before a waiting canary is drained for deploy. On a busy main2 with long jobs, the leader can go hours without converging.

## Schedule deferral
- I pushed the first fire back twice with `snooze-schedule.sh`: to 00:55Z, then 02:55Z, and finally to **2026-09-29T08:55:00Z**.
- Cadence stays `2h`, occupancy `skip`, prefix `ironhorse-ratchet-watch`.
- **Deadline:** if the leader hasn't deployed `c3aae0b2c0c` by about 08:45Z, the schedule must be snoozed again. The successor job owns that.

## PR-side blocker (unchanged)
https://github.com/endojs/endo-but-for-bots/pull/1359 still targets `llm-47f6965`, has an incompatible historical floor (901 historical losses), and has no instrumented coverage. It must not merge or get an attestation. The parked `ironhorse-test262-ratchet-round3-floor-resolution-20260928` still owns the maintainer decision. I made no changes to the PR.

## Handoff
I posted **`activate-ironhorse-ratchet-autopilot-20260929`** (in `todo/`, builder role). It owns everything left:
1. Wait for the deploy.
2. Confirm the deployed scheduler, claim and handler code, and that the followers are current.
3. Keep the schedule deferred until then.
4. Admit the first tick and check the evidence: a `tier: mentat` / `dispatch: ratchet-delegated` claim, the actual mentat model at runtime, and exactly one step recorded (or a correctly evidenced halt) with no overlapping children.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/activate-ironhorse-ratchet-autopilot-20260928.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (3304870 cached reads)
- Output: 14883 tokens
- Cost: $1.6533140000000006
- Wall-clock: 11265s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
