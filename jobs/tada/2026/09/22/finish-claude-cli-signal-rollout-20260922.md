The rollout is finished. All success criteria are verified against the journal.

---

## Completion report: finish-claude-cli-signal-rollout-20260922

**Root cause of the stall.** The rolling deploy of `e43c28386fae` had passed its first canary (endolin-garden2-5bcdff64) and then released the release token to the *next* follower in sorted order, `oros-studio-garden-ce242c49` — which has been **offline since 2026-09-19** (no `fleet/health` publish for ~3 days; `hosts/` record last touched 2026-09-19T20:58Z). The current `rolling-deploy.sh` has no offline-skip: an unreachable follower never deploys the target, so after the deploy budget it becomes a *failed canary* → bounded retries → terminal HALT, and the leader never advances. That is exactly the wedge described in the job ("do not count offline oros as a canary"). oros had already halted an earlier roll on 2026-09-20 (recovered watchdog notice on record).

**Action taken (journal `journal2`, commit `1440d1d60a`).** Via an isolated producer clone (never the deployed root/journal worktree), atomically:
- `git mv hosts/oros-studio-garden-ce242c49 → hosts/.archived-oros-studio-garden-ce242c49` (mirrors the prior `.archived-ps23` precedent) — removes it from `follower_hosts()`, so it is no longer counted as a canary.
- `git rm deploy/roll/oros-studio-garden-ce242c49` — cleared its stale release token.

This left the follower set = {endolin-garden2-5bcdff64 (passed)} and an empty `deploy/roll/`, so the leader's next `rolling-deploy` tick reached "all required canaries passed → leader self-deploys LAST".

**Result — leader `endolin-garden-ece02cb4` deployed `e43c28386fae` at 2026-09-22T07:01:25Z. Exact journal/systemd evidence:**
- `deploy/leader-sha` = `e43c28386fae2cb7148c51d509c26f6cb78011d0`
- `fleet/deployed/endolin-garden-ece02cb4` = `e43c28386fae2cb7148c51d509c26f6cb78011d0`
- `fleet/health/endolin-garden-ece02cb4`: `deployed_sha: e43c28386fae…`, `roll_status: deployed`, **`unit_failures: 0`**, `unit_total: 266`, `first_bad_unit: -`, `at: 2026-09-22T07:01:25Z`
- Post-deploy reread broadcast emitted by the leader: `msg(broadcast) 20260922T070130Z-2ade59 from endolin-garden-ece02cb4` (07:01:32Z).

**Candidate gate succeeded without override.** The tree advanced (`deploy/leader-sha`/`fleet/deployed` flipped to the target with `roll_status: deployed`); deploy-garden's candidate gate is step 0, run before the drain/swap, and a rejection aborts *without* advancing and emits a `candidate gate kind:error` to the maintainer inbox. No such error exists for `e43c28386fae` (the only recent gate-red, `fix-deploy-candidate-gate-red-20260922`, was fixed and closed at 05:00:10Z, before this deploy). `GARDEN_DEPLOY_TEST_OVERRIDE` defaults to `0`; there is no journal evidence of a bypass.

**Fresh post-deploy claim on the new code.** Beyond abundant organic leader spine activity after 07:01:25Z (triager-pacing decisions, `budget-level:raise-workers`, budget-live records, cursor advances, host-ops — the quota machinery this commit touches), I posted a deterministic host-pinned round-trip probe to force definitive evidence:
- `claim(finish-rollout-leader-postdeploy-probe-e43c28386fae) endolin-garden-ece02cb4/monk-3` @ 2026-09-22T07:10:50Z
- `tada(finish-rollout-leader-postdeploy-probe-e43c28386fae) done endolin-garden-ece02cb4/gardener-3` @ 2026-09-22T07:14:27Z

i.e. claim → run → tada completed cleanly on the freshly deployed leader code.

**oros correctly excluded** (per the directive): archived, not counted as a canary; its offline state was never treated as a passing canary.

**Follow-up (not done here, out of scope).** The rolling deploy has no offline-follower handling: an unreachable follower halts the roll as a "failed canary" rather than being skipped, and archiving is the manual workaround. A durable fix — skip a follower whose `fleet/health` heartbeat is stale beyond a threshold as "not an available canary" (distinct from operator-drained) — would prevent recurrence. Worth a separate garden-development job against `main2` `rolling-deploy.sh`. No `main2` change was required for this operational job; my worktree is clean.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/finish-claude-cli-signal-rollout-20260922.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 90 tokens (3605952 cached reads)
- Output: 35908 tokens
- Cost: $3.749235
- Wall-clock: 1478s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
