Both hosts are now clean. garden2's sysop returned `outcome: accepted-and-applied`. The job is complete.

## Completion report — `retire-local-qwen-hermit-lane`

**Decision: inert-at-zero (kind kept registered, count pinned to 0), not outright removal.**

Rationale: removing the `hermit` worker kind would churn the worker spine (the `worker_kinds()` enumeration, `canonical_worker_kind` decoder, the scaler's ollama-gating, and the spine/routing tests) **and** entangle three *live* neighbors that share the `local` provider and on-box Ollama serving — the qwen3.6 mentor-shaped trial (jobs `provider: local` that only a hermit can claim), the sysop `local-model` provisioning op, and the friar (ollama-cloud) lane's shared-handler scaffolding. Keeping the kind registered lets all of those (and old journal records) still resolve; pinning it inert drops the lane operationally with no spine churn.

**Inventory of references found (reported before changing):** `common.sh` (the `GARDEN_LOCAL_OLLAMA_URL` local-inference block, the `hermit)` worker-kind case, `worker_kinds`/`canonical_worker_kind`, `role_default_model`/tier tables for provider `local`, the whole qwen3.6-mentor-trial block); `install-units.sh` (`reconcile_ollama_unit`, `scale()`); `set-hermits.sh`; systemd (`garden-ollama.service`, `garden-local-model-pull.service`, and `garden-hermit@` rendered from the generic `garden-worker@.service.in` — no dedicated template file); the `local qwen3.6` row in `model-tier-inventory.tsv`; `skills/model-selection/SKILL.md`; docs (`starting.md`, `local-inference-amd/*`, `qwen-mentor-trial.md`); ~10 test files; and the ollama infra scripts (`ollama-serve.sh`, `pull-local-model.sh`, `hermit-capability-probe.sh`) shared with the sysop `local-model` op. CLAUDE.md and `roles/`/`skills/` directory names contain no `hermit` reference, so no inventory-list edit was needed.

**Changes applied (pushed to main2 as `93b5a5a573`):**
- `install-units.sh` `scale()`: clamps a hermit count to 0 at the single scaler choke point → no host can arm a hermit pool regardless of a stale `hermits: N`, and `reconcile_ollama_unit(0)` keeps `garden-ollama` down.
- `set-hermits.sh`: refuses a nonzero count (0 still allowed for withdrawal).
- `common.sh` `worker_kind_field hermit` case: annotated RETIRED.
- `skills/model-selection/SKILL.md`: minion-row annotation + a "Local Qwen (`hermit`) — RETIRED" note; `updated:` bumped.
- Docs: retirement banners in `starting.md`, `local-inference-amd/README.md`, and `qwen-mentor-trial.md` (trial marked on-hold — its `provider: local` jobs can no longer be claimed).
- Tests `worker-spine-kinds-test` and `enable-services-test`: updated to the clamped contract.

**Verification:** all edited scripts `bash -n` clean; test suites green — worker-spine-kinds (290/0), enable-services (40/0), hermit-capability-probe (22/0), hermit-ollama-self-heal (28/0), sysop (56/0), qwen-mentor-trial (26/0), model-routing (32/0), tier-vocabulary-routing, monk-worker-kind-compat (25/0).

**Per-host state afterward (task step 4):**
- `endolin-garden-ece02cb4` (this host): `hermits: 0` already; `garden-hermit@` and `garden-ollama` both `disabled`, no active instances — clean, no action needed.
- `endolin-garden2-5bcdff64`: was `hermits: 1` with a live `garden-hermit@1`. Zeroed via the sysop `set-workers` op (auditable, runs on garden2 past its own cross-host guard). Fresh `origin/journal2` read confirms `hermits: 0` (updated 14:28:44Z by garden2) and a sysop ack `outcome: accepted-and-applied, detail: set-workers hermit=0`; garden2's scaler reconciles `garden-hermit@1`/`garden-ollama` down on its next tick.

**Follow-ups / notes:** The `local qwen3.6` inventory row, the on-box Ollama serving scripts, and the sysop `local-model` op are intentionally retained (the op is still live and the friar minion row references the local row). The qwen3.6 mentor-shaped trial is now effectively on hold; if the maintainer wants it fully wound down (or the `local` provider row/infra removed too), that's a separate decision. No new hermit worker can be armed unless the maintainer un-retires the lane (revert the `scale()` clamp + `set-hermits.sh` guard).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/retire-local-qwen-hermit-lane.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (3665531 cached reads)
- Output: 37988 tokens
- Cost: $3.8025514999999994
- Wall-clock: 827s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
