Inbox empty. Work is complete and landed on `main2` (`f2e6ef1212`).

## Completion report

**Job:** `build-cybernetics-ranked-promotion` — slice 5 (ranked promotion ordering) of `designs/cybernetics-economic-resilience.md § 5`, reconciled with `omega-task-rank-and-foreman-retirement.md` (Stage 4) and `cnf-backlog-triple.md`.

**What I built.** The deferred-plan promoter now admits the **lowest omega rank first** (leaf-first): a leaf is `R0`, a parent that has spawned children derives `1 + max(child rank)` capped at 2 (the realized floor), and rank stays **derived** from `role:` + realized children — never a declared field.

**Changes (all on `main2`, no PR, per repo convention):**
- `cnf-backlog-triple.py` — added a read-only `--ranks` mode emitting `<omega_rank>\t<base>` per job, reusing the one audited derivation so the promoter cannot drift from the ordinal measure.
- `common.sh` — added `omega_ranks_for_plan` (deterministic, no-LLM; returns nonzero → fail-open when python3/the deriver is absent) and `plan_deferred_ranked_omega`, which feeds `plan_deferred_ranked`'s existing priority+FIFO order through a **stable** numeric sort on the omega rank. Omega becomes the new primary key while every existing deterministic tie-break is preserved; absent rank input ⇒ rank 0 everywhere ⇒ current order unchanged.
- `foreman.sh` — its step-1 admitter (the live promoter today) now selects via `plan_deferred_ranked_omega`, keeping the `|| true` SIGPIPE guard, and threads the derived rank into `promote-plan.sh`.
- `promote-plan.sh` — new optional `--omega-rank N`, folded into the **existing** decision-ledger row (§4), so ranked promotions are auditable.
- Tests: new `ranked-promotion-test.sh` pins order, gate filter, priority tie-break, realized floor, and fail-open (8/8 pass); added to the deploy gate suite in `deploy-garden.sh`. Updated the foreman sigpipe test's reader-line assertion.

**Scope note.** I applied the omega ordering at the **existing** admission point (the foreman's deterministic step-1 promoter), which is exactly the omega design's "swap the ordering to `omega()`" behavior. I did not create/retire a standalone `garden-promoter` unit — that extraction requires a maintainer-attested sysop `unit` op and is out of an agent's bounds; when it's extracted it carries `plan_deferred_ranked_omega` with it.

**Verification.** `ranked-promotion-test`, `foreman-deferred-sigpipe-test`, `cnf-backlog-triple-test`, `foreman-decision-log-test`, `decision-ledger-test`, `retry-narrowing-test`, `triager-pacing-test`, `promote-plan-shepherd-budget-test`, `reaper-doom-park-test`, `awaiting-maintainer-gate-test` all pass. `promote-plan-doom-reset-test` has 2 pre-existing failures in the **reaper** doom/split path — confirmed identical to `origin/main2` (byte-for-byte on `reaper.sh` and that test) and unrelated to this change; its promotion-path subtests pass.

**Possible follow-up.** `bulletin.sh` still renders the deferred queue in `plan_deferred_ranked` (priority+FIFO) order; switching it to `plan_deferred_ranked_omega` would make the maintainer's view match the actual promotion order. Left out to keep this slice tight.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-cybernetics-ranked-promotion.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 114 tokens (7204031 cached reads)
- Output: 53405 tokens
- Cost: $6.5248945
- Wall-clock: 835s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
