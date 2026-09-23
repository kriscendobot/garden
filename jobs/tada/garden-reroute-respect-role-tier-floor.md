The job is complete. Here is my report.

## Completion report

**Defect:** the reaper's one-hop model reroute demoted a job to a tier that cannot perform its role and burned a tier that was never actually served, converting one transient failure into a guaranteed doom (worked evidence: the `proposal-compartments-xs-source-phase-design` designer job).

**Fix landed on main2** (commit `072ccc0f02`, pushed):

- **Bug 1 — no canonical floor.** Added `role_tier_floor` (designer/builder and their web variants floor at **mentor**; every other role at **minion**) and `tier_rank` to `scripts/jobs/common.sh`. `reroute_job_model` now takes an optional floor and **refuses (rc 2)** any demotion whose resolved chain-head tier ranks below the floor, leaving the job unchanged at its floor tier. A concrete model-id chain head (e.g. `opus`) is unranked, so the legacy model-pinned path is never floor-blocked; passing no floor preserves the historical contract exactly.
- **Bug 2 — burning an unserved tier.** In `scripts/jobs/reaper.sh`, before rerouting, the reaper checks whether the failed claim was an **anthropic-served automatic mentor job** (provider anthropic + tier mentor + dispatch ≠ manual). Under monk-claude.sh's ceiling that ran at the *minion* model, so the failure is evidence about minion, not mentor. In that case it **suppresses the reroute entirely** — no `model-burned`, no demotion — and requeues at mentor so a true-mentor provider (cleric/mystic/fireworker) can take a genuine attempt.
- Guarded the command substitution (`&& rrc=0 || rrc=$?`) so a non-zero no-op/refusal exit does not abort the `set -e` reap loop (caught in testing — it initially regressed the existing B3 case).

**Regression test:** `scripts/jobs/test/reroute-role-floor-test.sh` — 17 checks (pure `reroute_job_model`/`role_tier_floor`/`tier_rank` + reaper-integration for floor-honoured, ceiling-suppress, and the control genuine-reroute). All pass. Existing `kimi-opus-fallback-test.sh` unchanged (17 pass; its 9 remaining failures are pre-existing — moonshot-quota interception of `model: kimi-k3` jobs and a missing part-D fixture, confirmed identical on pristine main2). Doc note added to `skills/model-selection/SKILL.md`.

**Audit result (which parked go-ahead jobs were mis-doomed by this mechanism):** Of the six suspects — `pr282-pin-rebase-reconcile`, `pr340-shepherd-20260816`, `pr856-weave`, `weave-base-update-and-pin-alias`, `pr1006-dependabot`, `pr897-weave` — **none were floor-mis-doomed.** All are roles whose floor is minion (weaver/shepherd/botanist/none) and all ended **at** minion, a valid tier for their work. Five carry a false `model-burned: mentor` (bug 2, cosmetic), but the minion demotion did not make their work impossible. Their dooms reflect genuine difficulty: deadline-overrun handler timeouts (pr340, pr897), requeue-exhausted at minion from real repeated failure such as conflicted DIRTY rebases (pr856, weave-alias, pr1006), and elapsed-constancy at mentor with chain intact/no burn (pr282 — never demoted). The **only** genuinely floor-mis-doomed job was the worked example designer job, already doomed and archived. So there is no cheap floor-recovery set beyond re-promoting that designer job; the rest need real work.

**Follow-ups:** none required. The audit surfaces that the parked suspects are genuine failures, not mechanism artifacts.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-reroute-respect-role-tier-floor.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 101 tokens (5323682 cached reads)
- Output: 59093 tokens
- Cost: $5.4832839999999985 (2 engagement(s) unpriced)
- Wall-clock: 865s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
