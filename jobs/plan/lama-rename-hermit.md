---
gate: orchestrated
orchestrated_by: worker-kind-rename
priority: normal
posted_by: liaison
posted_at: 2026-07-30T05:39:53Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Rename the hermit worker kind to lama

Repository: kriskowal/garden (this repo). This is a holistic worker-kind rename of
the local/Ollama provider kind `hermit` -> `lama`, following the same shape and
discipline as the `gardener` -> `monk` rename (see
[`designs/anthropic-worker-kind-monk.md`](../../designs/anthropic-worker-kind-monk.md)
for the boundary, persisted-state-migration table, and staged reversible rollout that
this job must mirror). There is no separate design doc for `lama`; adopt the monk
design's structure as the template.

## Goal

`hermit` is the local-model worker kind (provider `local`, runtime `codex` against an
on-box Ollama `/v1` endpoint, handler `handlers/cleric-codex.sh` provider-parameterized,
registry `worker_kind_field hermit`). Rename the kind to `lama` across the whole
fleet surface, with a legacy `hermit -> lama` compatibility alias so a running fleet
and historical journal state keep decoding correctly.

## Scope (mirror the monk design's two-change boundary)

1. **Terminology-only edits:** role briefs, CLAUDE.md, README, context pages (notably
   `context/operations/local-inference-amd.md` and `starting.md`), skill prose,
   comments, design references (`designs/hermit-failure-capability-demerit.md`,
   `provider-model-catalog.md`, `gnome-backend-verified-autotune.md`,
   `opencode-alternate-harness.md`, `root-repo-guard.md`, `job-board.md`,
   `ai-sdk-garden-integration.md`), test descriptions.
2. **Persisted-state migration:** registry/defaults (`worker_kind_field`,
   `worker_kinds`), handlers, systemd + self-heal (render `garden-lama@N`, the
   scaler's hermit reconciliation), host counts (`lamas: N`, `set-lamas.sh`,
   `set-workers.sh lama`; read `lamas` first then legacy `hermits`, never sum),
   local state (`state/lamas`; legacy `state/hermits` lookup for recovery; never
   move/delete a live clone/worktree), claim/work metadata
   (`worker_kind: lama`, `worker_kind_schema: 2`, `provider: local`,
   `runtime: codex`), tada/usage/reputation/journal history (append-only; readers
   canonicalize legacy `hermit` -> `lama`; reducer dual-publishes
   `.../hermit/...` and `.../lama/...` arm projections during compatibility),
   routing/auction, metrics/bulletin/proxy/reaper, scripts/tests/docs.

Known `hermit` hot paths to start from (not exhaustive — run the repo-wide literal
inventory the monk design requires): `scripts/jobs/hermit-capability-probe.sh`,
`scripts/jobs/set-hermits.sh`, `scripts/jobs/ollama-serve.sh`,
`scripts/jobs/common.sh` (~13), `scripts/jobs/gardener.sh`, `scripts/jobs/install-units.sh`,
`scripts/jobs/reputation.sh`, `scripts/jobs/claim-job.sh`, `scripts/jobs/comment-provenance.sh`,
`scripts/jobs/model-routing-defaults.tsv`, `scripts/jobs/handlers/codex-provider-common.sh`,
`scripts/jobs/handlers/cleric-codex.sh`, `scripts/jobs/handlers/foreman-claude.sh`,
`scripts/jobs/handlers/mentor-claude.sh`, and the test files
(`hermit-heal-fake-curl.sh`, `hermit-capability-probe-test.sh`,
`hermit-ollama-self-heal-test.sh`, `worker-spine-kinds-test.sh`,
`enable-services-test.sh`, `worker-health-gate-test.sh`, `model-routing-test.sh`).

## Hard constraints (mirror the monk design)

- Add `canonical_worker_kind` support for `hermit -> lama` (v1 alias) alongside the
  existing `gardener -> monk` alias. No silent fallback for unknown kinds.
- Never enable both `garden-hermit@` and `garden-lama@` pools for one capacity slot.
- Never rewrite journal history or filenames; append-only events/tada/bids/usage/git.
- Reducer dual-projection byte-equivalent except kind field and path, with a proving test.
- Naming-collision check first: confirm no existing `lama` token, path, unit, role, or
  external collision (the repo currently has none — re-verify before implementing).
- Compatibility-first release, then per-host cutover followers first. This job changes
  neither a deployed checkout nor a live unit — hand the deploy/cutover back to the
  liaison.

## Sequencing

This job runs AFTER `monk-finish-gardener-rename` because both touch the same
`worker_kind_field` registry, the same `canonical_worker_kind` decoder, the same
reducer dual-projection, and the same deployment surfaces. Land the monk rename's
canonicalizer/registry/v1-v2-reader/dual-projection first, then extend it for `lama`
on the same pattern rather than risk a conflicting parallel rewrite of the shared
registry.
