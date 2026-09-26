Work complete. Final report:

---

## Completion report: `fix-local-verify-node24-eslint-parity`

**Diagnosis.** The garden's local verification harness (`scripts/jobs/gardening/local-verify.sh`, the `GARDEN_EVAL` gate) ran every check under whatever `node` sat on PATH — Node 22.23.2 on these hosts — with **no awareness of the project's `.node-version`**. Projects pin `.node-version=lts/*`, which CI's `actions/setup-node` resolves to Node 24.18.0. That runtime skew is exactly why `yarn lint:eslint` read green locally while the Node 24 CI leg flagged type-aware `@endo/restrict-comparison-operands` and `import/order` errors (endojs/endo-but-for-bots#1048): a silent local-pass/CI-fail, the class 2 environment divergence the skill exists to close.

**Fix.** Added a **Node runtime-parity guard** that runs before any verification step:
- Resolves the pinned major from `.node-version` (then `.nvmrc`) — explicit versions map directly; `lts/*`, `lts/-N`, `lts/<codename>` resolve from a static table + a documented `GARDEN_NODE_LTS_LATEST` constant (default 24), **no network**, deterministic and fail-safe offline.
- If the active node matches → proceed silently. Else **adopts** a matching runtime discovered under nvm/fnm/n/volta roots or an explicit `GARDEN_NODE` (PATH-prepend). Else **refuses to run** with one `NODE RUNTIME PARITY:` line and exit 3 — failing loud, because a silent green under the wrong Node is the defect.

**Changes** (committed `57d851dfaf` on `main2`):
- `scripts/jobs/common.sh` — helpers `required_node_major`, `node_version_spec`, `_node_lts_major_for_alias`, `active_node_major`, `find_node_bin_for_major`.
- `scripts/jobs/gardening/local-verify.sh` — the guard + escape hatches (`GARDEN_SKIP_NODE_PARITY`, `GARDEN_NODE`, `GARDEN_REQUIRED_NODE_MAJOR`, `GARDEN_NODE_LTS_LATEST`).
- `scripts/jobs/test/local-verify-test.sh` — new regression group (mismatch fails loud with steps proven not to run; match passes; bypass/override/`lts/*`/`.nvmrc`/adopt-a-runtime paths). **Suite: 55 passed, 0 failed.**
- `skills/local-verify/SKILL.md` + `field-notes.md` — documented the guard, the env knobs, and a dated field entry.

**Verification evidence.** Full suite green (55/55); end-to-end confirmed on this host: a `lts/*` project fails loud (exit 3, `NODE RUNTIME PARITY`) while `GARDEN_REQUIRED_NODE_MAJOR=22`/`GARDEN_SKIP_NODE_PARITY=1`/no-pin all pass; the adopt path exercised via a fake nvm runtime. `bash -n` clean on all three scripts. Did **not** touch PR #1048.

**Follow-ups.**
- Posted job `provision-node24-fleet-hosts-20260822`: current hosts ship only Node 22 with no version manager, so once this deploys the guard hard-fails every Node-24-pinned project's local verification until Node 24 is provisioned (bake into image / install into an nvm/n root / per-host `GARDEN_NODE`). The guard then *adopts* instead of *refuses*.
- Messaged the maintainer (via liaison) about the fix and the rollout impact, recommending they provision Node 24 (or hold the deploy / use `GARDEN_SKIP_NODE_PARITY=1`) before this lands fleet-wide.
- `GARDEN_NODE_LTS_LATEST` (default 24) is a maintenance surface — bump when a new even major enters LTS, tied to `node-lts-window-watch`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-local-verify-node24-eslint-parity.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 65 tokens (3481589 cached reads)
- Output: 46215 tokens
- Cost: $4.0488145
- Wall-clock: 626s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
