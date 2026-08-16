---
role: builder
tier: minion
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-16T15:38:45Z cleared=deadline-overrun=1 -->

---
role: builder
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-30T05:43:03Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Finish the gardener -> monk worker-kind rename

Repository: kriskowal/garden (this repo). The design is accepted and unimplemented:
[`designs/anthropic-worker-kind-monk.md`](../../designs/anthropic-worker-kind-monk.md).
Read it in full first; it is the authoritative scope, boundary, and rollout plan.

## Goal

`gardener` is the generic job-doing agent (the shared spine `scripts/jobs/gardener.sh`
and `roles/gardener/` stay generic). `monk` is the Anthropic provider-specific worker
kind. The rename is accepted but not executed: `gardener` is still the live Anthropic
discriminator (87 refs in `scripts/jobs/gardener.sh`, 105 in `scripts/jobs/common.sh`).
Finish it.

## Scope (from the design's two-change boundary)

1. **Terminology-only edits:** role briefs, CLAUDE.md, README, context pages, skill
   prose, comments, design references, test descriptions — say every consumer is a
   gardener and name `monk` only for Anthropic. No journal artifact, env value, unit
   name, state dir, or protocol result changes here.
2. **Persisted-state migration:** every surface in the design's inventory table —
   registry/defaults (`worker_kind_field`, `worker_kinds`, `role_default_model`),
   handlers (`handlers/monk-claude.sh` + a warning-free forwarding wrapper for the
   old handler; `GARDEN_WORKER_CLONE` honoring `GARDEN_GARDENER_CLONE` when unset),
   systemd + self-heal (render `garden-monk@N`, the scaler), host counts
   (`monks: N`, `set-monks.sh`, `set-workers.sh monk`; read `monks` first then legacy
   `gardeners`, never sum), local state (`state/monks`; legacy lookup for recovery;
   never move/delete a live clone/worktree), claim/work metadata
   (`worker_kind: monk`, `worker_kind_schema: 2`, `provider: anthropic`,
   `runtime: claude`; v1 absent-schema accepts `gardener` as the Anthropic alias),
   tada/usage/reputation/journal history (append-only; readers canonicalize legacy
   `gardener` -> `monk`; reducer dual-publishes `.../gardener/...` and `.../monk/...`
   arm projections during compatibility so a rollback does not cold-start the
   auction), routing/auction, metrics/bulletin/proxy/reaper, scripts/tests/docs.

## Hard constraints (from the design)

- `canonical_worker_kind(raw, schema, provider)` is the only decoder: `monk` for v1
  `gardener`, known v2 kind unchanged, no silent fallback for unknown. Use it in claim
  ownership, complete, auction, reputation reducer, bulletin, proxy, reaper, metrics,
  migration tools. Keep `raw_worker_kind` in forensic output.
- Never enable both `garden-gardener@` and `garden-monk@` pools for one capacity slot.
- Never rewrite journal history or filenames; events/tada/bids/usage/git history are
  append-only.
- The reducer dual-projection must be byte-equivalent except the kind field and path,
  with a test that proves it.
- Run a repository-wide literal inventory first (`scripts/jobs/`, `scripts/systemd/`,
  `scripts/jobs/test/`, `tests/checks/`, roles, skills, context, Docker/startup
  assets, current `journal2` files + history). The table names known hot paths, not
  permission to skip a newly discovered reader.
- Follow the staged reversible rollout (0 prepare/gate, 1 per-host cutover followers
  first, 2 ...). Confirm the naming-collision check (no existing `monk` token/path/
  unit/role collision — the design says this was pre-checked, re-verify).

## Deliverable

A compatibility-first release: canonicalizer, both registry spellings, v1/v2 readers,
dual reputation projection, unit/count inspection commands, handler wrapper, and
tests land first; existing active units still run as `garden-gardener@` with no host
count/unit/state/claim-writer change in that stage. Then the per-host cutover path.
Report what changed, the test results, and the cutover procedure for the maintainer to
run on each host. This job changes neither a deployed checkout nor a live unit —
hand the deploy/cutover back to the liaison.


