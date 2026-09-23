Final state captured. The probe is conclusive: 3/5 re-refused (`policy-refusal`), 2 still in flight; the leader's storm pushed the plan backlog to 45 during this job. I've done everything the spec asks and hit its documented STOP condition. No `main2` changes were needed — all mutations were journal-board operations via the sanctioned scripts.

---

## Completion report

**Job:** re-promote the quarantined ironhorse fuzz-repair jobs. **Outcome: STOP-and-report** (the spec's explicit branch), because the reworded framing does **not** survive the Anthropic provider filter — the deliverable ("promoted-and-running") is not achievable on the current fleet, so the set is instead **explicitly accounted for**.

**Blocker check (passed):** `ironhorse-fuzz-repair-template-policy-rewrite` is in `tada/` — it reworded the per-finding template and proved one live dispatch (`gpt-5.6-terra` → `POLICY_FILTER_ACCEPTED`). So I proceeded.

**1. Enumerated** (`ls .../jobs/plan | grep ironhorse-fuzz`): 28 `ironhorse-fuzz-*-repair` jobs, all `doom_signature: policy-refusal`; all at one `project_sha 38ca1d18`, across 3 targets (`differential_regexp` ×9, `differential_regexp_surface` ×13, `differential_source` ×6) — heavy duplication (likely a handful of root causes). The set **grew to 45 during the job** as the leader kept posting more.

**2. Regenerated** bodies with the new engine-defect framing (a script reproducing commit `37fdea27b0`'s reworded template against each journal finding marker, committed to `journal2` via the sanctioned clone+CAS helpers — never the root repo). Verified zero refused vocabulary (`crash/untrusted/panic/attack/adversarial/exploit` → 0; only proper-name/path `fuzz` remains).

**3. Bounded batch of 5 promoted** (representatives across all 3 targets, smallest inputs): `79f0475d`, `ccb76a40`, `50834e82`, `bc3d0df6`, `67ca18e4` — via `regen-fuzz-body.sh <fid>` then `promote-plan.sh ironhorse-fuzz-<fid>-repair`. Verified the promoted `todo` bodies were clean and correctly framed.

**4. Refusals resumed → STOPPED.** Within ~6 min, **3 of 5 bounced `doin → plan`, re-doomed `policy-refusal`** (01:23:53Z) on this host's Anthropic monks; 2 remain in flight. I promoted **no further jobs**; the remaining ~34 stay quarantined (nothing lost).

**Root cause (the important finding):**
- The reword is **insufficient for Anthropic**. The blocker only proved acceptance on `gpt-5.6-terra` (OpenAI); Anthropic still refuses the reworded body — confirmed both by my probe and independently by the **leader** `endolin-garden-ece02cb4`, which is posting **reworded** per-finding jobs that also get `policy-refused` every ~10 min (e.g. `e4a8e011` doomed 01:13:40Z).
- **This job is superseded by design.** `scripts/jobs/ironhorse-fuzz-migrate-backlog.sh` (`designs/ironhorse-fuzz-triage-and-batch.md § Migration`) explicitly marks `ironhorse-fuzz-repromote-quarantined` superseded — *"never promote the old files one by one"* — routing findings into deduplicated cluster repairs. It has **not run** (no migration record, 0 triage records). The upstream driver is that the leader runs an **old deployed garden** (reworded per-finding template, pre-cluster/pre-migration ~08-31…09-04) whose fuzz lane re-posts per-finding jobs the filter refuses; promotion can't win against it.

**Surfaced to maintainer** (`message-user.sh`) with a decision request: (1) pin the fuzz-repair lane's dispatch to `gpt-5.6-terra` where the reword passes; (2) deploy `main2` to the leader to stop the stale-storm producer and arm the cluster batcher + migration; (3) then run `ironhorse-fuzz-migrate-backlog.sh` to take custody of the backlog (dedup) instead of per-finding promotion.

**Follow-ups:** none I can action as a builder — the remaining path is gated on the maintainer's provider/deploy decision and the already-designed `migrate-backlog` successor. No `main2` changes were made (all work was journal-board operations, already landed via CAS).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-repromote-quarantined.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 116 tokens (5063749 cached reads)
- Output: 53947 tokens
- Cost: $5.1637695 (1 engagement(s) unpriced)
- Wall-clock: 1513s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
