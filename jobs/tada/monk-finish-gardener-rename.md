Everything is verified: 16-line forwarder + 316-line real handler, registry lists `monk,gardener,cleric,hermit,mystic,fireworker`, and all four commits are on `origin/main2`. The core deliverable — the compatibility-first release and the per-host cutover path — is complete, tested, and landed.

---

## Completion report: `monk-finish-gardener-rename`

**What I did.** Executed the accepted-but-unimplemented gardener→monk worker-kind rename (`designs/anthropic-worker-kind-monk.md`) to its two named deliverables — the compatibility-first release (stage 0) and the per-host cutover path (stage 1) — landing four commits on `main2`. `gardener` stays the generic spine (`gardener.sh`) and role (`roles/gardener/`); `monk` is now the canonical Anthropic worker kind. **This release changes zero runtime behavior**: no host declares `monks:` yet, no `garden-monk@` unit is enabled, and every writer still emits `gardener`, so the live `garden-gardener@` pool runs byte-for-byte as before until a maintainer deliberately cuts a host over.

**What changed (all on `main2`):**
- **`common.sh`** — `monk` registry row beside the retained legacy `gardener` alias; `worker_kinds()` enumerates both; `canonical_worker_kind(raw,schema,provider)` (the sole decoder: v1 `gardener`→monk, known v2 unchanged, unknown/contradictory rejected with no silent fallback); `anthropic_active_kind()` (scaler's monk-xor-gardener selector, monks-first never summed); `role_default_model`/`role_default_effort` fold `monk` into the Anthropic branch.
- **Spine/handlers/counts** — `GARDEN_WORKER_CLONE` honoring legacy `GARDEN_GARDENER_CLONE` (`gardener.sh`/`claim-job.sh`/`complete-job.sh`); `handlers/monk-claude.sh` is the real handler with `handlers/gardener-claude.sh` a 16-line warning-free forwarder; `set-monks.sh` + `set-workers.sh monk`, with the Anthropic provider (both spellings) exempt from the backend probe and sharing the zero-worker floor.
- **Scaler exclusivity** — the two Anthropic pools never both arm (`gardener-scaler.sh`).
- **Reducer dual projection** (`reputation-reduce.sh`) — `gardener` + `monk` events pool into one arm and are written under both `reputation/arms/monk/…` and `reputation/arms/gardener/…`, byte-equivalent except the kind field/path, so a rollback never cold-starts the auction.
- **`migrate-host-to-monk.sh {cutover|rollback|status}`** — the drained, reversible, idempotent per-host transaction that refuses on a busy worker / both-pools slot / undecodable claim / count mismatch (drain stays on).

**Test results (all green):** new `monk-worker-kind-compat-test` (25/0 — decoder, byte-equivalent dual projection, count/exclusivity, set-monks) and `monk-host-cutover-test` (20/0 — cutover, never-both-pools, idempotence, busy-worker refusal, rollback); extended `worker-spine-kinds-test` (174/0 — a monk claims+completes an Anthropic-pinned job through the shared spine, stamping `worker_kind: monk`). Broad regression sweep across scaler/deploy/reaper/handler/health suites all green. The 2 pre-existing failures in `auction-reputation-test` (stale `gpt-5.6-terra` expectation) and the 9 in `kimi-opus-fallback-test` and 1 in `run-test`'s issue-inbox subtest were confirmed identical on the pristine tree — **not introduced by this work**; I updated the handler-copying tests (`gardener-worktree`, `kimi-opus-fallback`, `tier-serving`) for the `monk-claude.sh` move.

**Cutover procedure for the maintainer/liaison** (this job touched no deployed checkout or live unit, per the brief):
1. Deliberate drained deploy of the compatibility release to every host.
2. **Followers first, leader last**, run *on each host*: `scripts/jobs/migrate-host-to-monk.sh cutover` — it drains, waits for busy markers, writes `monks: N` (retaining the `gardeners: N` mirror), disables `garden-gardener@1..N`, enables `garden-monk@1..N`, asserts N monk + 0 legacy active, lifts the drain. Rerunnable; refuses safely on a busy worker.
3. Inspect with `migrate-host-to-monk.sh status`; roll a host back with `migrate-host-to-monk.sh rollback`.

**Follow-ups (later, separately-sequenced per the design — not part of this deliverable):** stage-2 writer-default flip (emit `monk` + `worker_kind_schema: 2`); breaking out `monks` in the bulletin/proxy/metrics *display* (correctness holds today via the mirror + dual projection); the broad terminology-only prose sweep; and the observed staged deployment (the liaison's). Alias/mirror retirement is a still-later, separately-reviewed cleanup. I recorded all of this in the design's new "Implementation status" section.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/monk-finish-gardener-rename.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s)
- Input: 292 tokens (28586453 cached reads)
- Output: 156261 tokens
- Cost: $23.9090895
- Wall-clock: 2779s
- Model(s): claude-opus-4-8 ×5

<!-- garden-usage-end -->
