Inbox empty. The work is complete, tests green, and the change is landed on `origin/main2`.

## Completion report

Built **child 1 of `orch-cleric-worker-system`** (design `cleric-worker-bid-auction-reputation.md` §1–§2): the **cleric** codex-backed worker plus the **factored worker spine**. The bid-auction/reputation (sibling child) was deliberately left out; the existing claim mechanism is intact apart from a small deterministic backend-fit filter. Landed on `main2` as `54722cb696` (direct push, no PR).

**What I factored (deliverable 1 — the shared spine, no duplicated loop/scaler logic)**
- `common.sh`: a **worker-kind registry** (`worker_kind_field`/`worker_kinds`) — the single point a new backend touches (handler, provider, unit prefix, count-key, state namespace, label). Kind-aware `worker_busy_marker`/`worker_busy` (the `gardener_*` forms are now back-compat wrappers).
- `gardener.sh` stays the **one spine**: `GARDEN_WORKER_KIND` (default `gardener`) derives the handler, the clone+marker namespace, and the bus labels from the registry. Every existing invocation is unchanged.
- `handlers/worker-common.sh` (new): the shared per-job worktree lifecycle + the prompt/worktree-note text, sourced by **both** handlers so injection hygiene and the completion contract cannot drift. `gardener-claude.sh` was refactored onto it with no behavior change.
- Single systemd source `garden-worker@.service.in` rendered per kind into `garden-gardener@.service`/`garden-cleric@.service` (old per-kind source removed). `install-units.sh scale [<kind>]`, `reconcile-identity` over both kinds; `gardener-scaler.sh` reconciles every pool from `hosts/<host>`; `set-workers.sh <kind>` (+ `set-gardeners.sh` wrapper, `set-clerics.sh`) preserving a sibling kind's count. Deploy quiesce + deploy-restart now enumerate both kinds' busy markers.

**Deliverable 2 — the codex handler**: `handlers/cleric-codex.sh` mirrors `gardener-claude.sh`'s contract/hygiene — `codex exec` invocation per design, provider-scoped model + per-model-normalized reasoning-effort, per-boot `codex login status` preflight, session-sidecar resume with fresh-session fallback, same sentinel/marker completion gate.

**Deliverable 3 — service + scaling + model map**: cleric units/scaling wired into the leader/pool model; `resolve_model_tier` is now provider-scoped (`anthropic` default + `openai` codex tiers terra/luna/frontier/mini), plus per-kind `role_default_model`/`role_default_effort`; `skills/model-selection/SKILL.md` extended with the codex section.

**Deliverable 4 — tests**: new `worker-spine-kinds-test.sh` (45 assertions) proves the spine runs both kinds and differs only by handler/labels/namespace, covers registry, model selection, one-spine claim+complete, the §1.3 eligibility filter, single-template render, and per-kind scale. Updated `enable-services`, `gardener-worktree`, `deploy-garden` tests for the render/format changes.

**Verification**: green — `worker-spine-kinds` (45), `enable-services` (31), `completion-signal` (17), `handler-budget` (12), `deploy-garden` (80), `gardener-worktree` (33), `gardener-identity` (9), `main-host` (38), `productive-cycle` (10), `project-worktree-isolation` (16), `outage-poison-pause` (10), `reaper-live-handler-guard` (3), and `run-test` (exit 0, 0 failures). The two failing `tests/checks` suites (`test_run_all`, `maintainer-inbox-information-hiding`) fail identically on the clean base — pre-existing, unrelated (they flag botanist/orchestrator roles and a claude-stub env issue I never touched).

**Seams the auction child (build child 2) will need**
- `worker_kind` is stamped into the claim metadata and the `work/<base>` record — reputation events can key the arm on it.
- The §1.3 filter in `claim-job.sh` (`job_eligible_for_kind`) is exactly where backend fit becomes a *priced bid* under the auction.
- The handler contract has room for the §2.3 `GARDEN_USAGE_OUT` normalized-usage output — **not wired here** (it depends on the token-cost-ledger and is auction/reputation scope); the `codex exec --json` stream is already captured in the cleric handler, positioning that adapter.

**Follow-ups / caveats for a codex-equipped host**
- `codex` was **not** installed in the build worktree (the Dockerfile installs it in future builds; `~/.codex/auth.json` is present). The handler's flag surface is transcribed from the live-verified catalog (codex-cli 0.144.3), but the **session-id parse** (`--json` field name) and the eventual usage-event field names must be re-verified live before the first real cleric job — flagged with an inline TODO in the handler.
- Recommended initial sizing per design: `clerics: 4` on the leader host (`set-clerics.sh 4`), tunable like any worker count — left for the maintainer to arm.
