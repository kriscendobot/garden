---
created: 2026-07-15
updated: 2026-07-28
author: designer
---

# Design: reserve gardener and rename the Anthropic worker kind to monk

| Status | Accepted — stages 0 & 1 implemented |
| Job | `design-anthropic-worker-kind-monk` |

## Implementation status (2026-08-16)

The **compatibility release (stage 0)** and the **per-host cutover path (stage 1)**
have landed on `main2`, changing no runtime behavior until a host is deliberately
cut over:

- `canonical_worker_kind(raw, schema, provider)` — the sole decoder — plus the
  `monk` registry row beside the retained legacy `gardener` alias, `worker_kinds`
  enumerating both, and `anthropic_active_kind` (the scaler's monk-xor-gardener
  selector); `role_default_model`/`role_default_effort` fold `monk` into the
  Anthropic branch (`scripts/jobs/common.sh`).
- `GARDEN_WORKER_CLONE` seam honoring legacy `GARDEN_GARDENER_CLONE`
  (`gardener.sh`, `claim-job.sh`, `complete-job.sh`); `handlers/monk-claude.sh`
  (the real handler) with `handlers/gardener-claude.sh` as a warning-free
  forwarding wrapper; `set-monks.sh` + `set-workers.sh monk` with the Anthropic
  provider exempt from the backend probe and sharing the zero-worker floor.
- Reducer **dual projection**: `gardener` and `monk` events pool into one arm and
  are written under both `reputation/arms/monk/…` and `reputation/arms/gardener/…`,
  byte-equivalent except the kind field/path (`reputation-reduce.sh`).
- The scaler never arms both Anthropic pools (`gardener-scaler.sh`).
- `migrate-host-to-monk.sh {cutover|rollback|status}` — the drained, reversible,
  idempotent per-host transaction (run ON the host, followers first, leader last).
- Tests: `monk-worker-kind-compat-test.sh`, `monk-host-cutover-test.sh`, and the
  extended `worker-spine-kinds-test.sh` (a monk claims + completes an Anthropic job
  through the shared spine).

**Not yet done** (later, separately-sequenced work): stage 2 writer-default flip
(claims/bids/events emit `monk` + `worker_kind_schema: 2`); wiring
`canonical_worker_kind` into the remaining readers' *display* (bulletin breaks out
`monks`, proxy/metrics/auction labels) — correctness holds today because stage-0
writers still emit `gardener` and the dual projection covers a mixed/rolled-back
fleet; the broad terminology-only prose sweep; and the observed staged deployment
on every host (the liaison's, per the job brief). Alias/mirror retirement is a
still-later, separately-reviewed cleanup.

## Decision

`gardener` means the generic job-doing agent. Every fleet member is a gardener:
it claims a job, adopts the job's task role, and completes it through the shared
worker spine. It is not a provider or runtime name.

The orthogonal worker taxonomy is:

| Worker kind | Provider | Runtime | Meaning |
| --- | --- | --- | --- |
| `monk` | `anthropic` | Claude | Anthropic-backed gardener |
| `cleric` | `openai` | Codex | OpenAI-backed gardener |
| `hermit` | `local` | Ollama | Local-model gardener |

`role:` remains a job's task posture, such as `designer`, `builder`, or
`fixer`. It is independent of all three fields above. A human-facing report may
say "a monk gardener wearing the designer role". Code must not use `gardener`
as an Anthropic discriminator after the compatibility period.

`monk` is suitable: the repository has no existing `monk` token, path, unit, or
role collision, and the existing `cleric` and `hermit` names establish the same
worker-kind vocabulary. The name must be rejected before implementation if a
fleet host, external deployment system, or maintainer vocabulary has an
unreported `monk` collision. This design deliberately does not rename the
generic `gardener.sh` spine or the `roles/gardener/` role.

## Boundary and inventory

This is two changes with different risk profiles.

**Terminology-only edits** update role briefs, `CLAUDE.md`, README and context
pages, skill prose, comments, design references, and test descriptions so they
say that every consumer is a gardener and name `monk` only for Anthropic. They
do not alter a journal artifact, environment value, unit name, state directory,
or protocol result. Do them in the compatibility release, not as a search and
replace of historical journal history.

**Persisted-state migration** changes the current-value identity of Anthropic
workers. The implementation inventory is below. Every listed reader must
canonicalize on input until retirement.

| Surface | Current Anthropic form | Target and compatibility requirement |
| --- | --- | --- |
| Registry and defaults | `worker_kind_field gardener`, `worker_kinds`, `role_default_model` and effort defaults | canonical `monk`; map legacy `gardener -> monk` before provider, model, or count lookup; default bare calls become `monk` only after all callers have migrated. |
| Shared spine and handlers | `gardener.sh`, `handlers/gardener-claude.sh`, `GARDEN_WORKER_KIND=gardener`, `GARDEN_GARDENER_CLONE` | retain `gardener.sh` as the generic spine; introduce `handlers/monk-claude.sh` and leave the old handler as a warning-free forwarding wrapper; introduce `GARDEN_WORKER_CLONE`, honoring the old variable only when the new one is unset. |
| Systemd and self-heal | rendered `garden-gardener@N.service`, `garden-gardener-scaler`, labels | render `garden-monk@N.service` with `GARDEN_WORKER_KIND=monk`; migrate the scaler to an explicitly generic `garden-worker-scaler` only if its unit references are all updated, otherwise retain its generic historical name. Keep legacy rendered units only during the flip and never enable both pools for one capacity slot. |
| Host count configuration | `hosts/<host>: gardeners: N`; `set-gardeners.sh` | `monks: N`, `set-monks.sh`, and `set-workers.sh monk`; read `monks` first, then the legacy count. During rollout preserve `gardeners: N` as an old-fleet mirror, never sum the two. |
| Local state and worktrees | `state/gardeners/<id>`, busy and identity markers, session and clone paths, `gardener-wt-<base>` | new monk-specific state uses `state/monks`; lookup checks legacy state for recovery and the migration does not move or delete a live clone/worktree. `gardener-wt-<base>` is generic historical worktree naming and may remain until a separately designed filesystem migration. |
| Claim and work metadata | claim and `work/<base>` have `worker_kind: gardener` | new writes use `worker_kind: monk`, `worker_kind_schema: 2`, `provider: anthropic`, `runtime: claude`; v1 means absent schema and accepts `gardener` as the Anthropic alias. Preserve raw historical values. |
| Tada, usage, reputation, and journal history | historical claim commits, tada reports, CostRecords, events and arm paths include `gardener` | append only. Readers canonicalize legacy `gardener` to `monk`; reducer dual-publishes equivalent legacy and canonical arm projections during compatibility so rollback does not cold-start the auction. Do not rewrite journal history or filenames. |
| Routing and auction | provider eligibility, bidder ids `gardener-...`, bid and reputation arm lookup | classify legacy kinds before eligibility, treat existing `gardener-...` bids as Anthropic, and accept both arm path spellings. New bids and claims emit `monk`. A stranded legacy winning bid follows the existing staged widening, so it cannot block a monk forever. |
| Metrics, bulletin, proxy, reaper | host display reads only `gardeners`; operational messages and worktree checks use gardener names | show `monks` and label the generic total as gardeners. Proxy, reaper, deploy, restart, clone keeper, transcript capture, quota/metering and bulletin must use registry helpers and compatibility lookups, never literal Anthropic `gardener` paths. Reaper must recognize both state namespaces before declaring a claim abandoned. |
| Scripts, tests, documentation | `set-gardeners`, direct environment users, fixtures, integration scripts | add precise aliases for old command and environment interfaces; test canonical writes, legacy reads, unit exclusivity, rollback, and unchanged cleric/hermit behavior. Update shell comments and operator guides. |
| Fleet deployment | leader and follower hosts, root deployed checkout, rendered user units | use the deliberate drained deploy and migrate every host. This job changes neither a deployed checkout nor a live unit. |

The initial implementation pass must run a repository-wide literal inventory,
including `scripts/jobs/`, `scripts/systemd/`, `scripts/jobs/test/`,
`tests/checks/`, roles, skills, context, Docker/startup assets, and current
`journal2` files plus history. The table names known hot paths, not permission to
skip a newly discovered reader.

## Journal contract

There is no branch-wide journal schema migration. Instead, version the worker
identity envelope wherever a new record is written. A v1 record has no
`worker_kind_schema`; `worker_kind: gardener` means canonical kind `monk` only
when paired with the Anthropic mapping implied by v1. A v2 record carries the
four explicit fields above. Reject an unknown v2 kind or a contradictory
kind/provider/runtime tuple from claim eligibility, while preserving the raw
artifact for diagnosis.

`canonical_worker_kind(raw, schema, provider)` is the only decoder. It returns
`monk` for v1 `gardener`, returns the known v2 kind unchanged, and has no silent
fallback for an unknown value. Use it in claim ownership checks, complete,
auction, reputation reducer, bulletin, proxy, reaper, metrics, and migration
tools. Keep `raw_worker_kind` available in forensic output.

The reducer is special because its projections are derived state. It recomputes
canonical `reputation/arms/monk/...` from both legacy and new events and, while
the alias exists, writes the equivalent `.../gardener/...` projection. Events,
tada reports, bids, usage records, and git history remain append-only. This
preserves auditability and lets an old binary read meaningful reputation after a
rollback. The dual projection must be byte-equivalent except for the kind field
and path, with a test that proves it.

## Staged, reversible rollout

### 0. Prepare and gate

Land a compatibility-only release first. It adds the canonicalizer, both
registry spellings, v1/v2 record readers, dual reputation projection, unit and
count inspection commands, handler wrapper, and tests. Existing active service
units still run as `garden-gardener@`; no host count, unit, state namespace, or
claim writer changes in this stage. Confirm the naming-collision check and take
a journal snapshot of active `doin/`, `work/`, host counts, enabled worker
units, busy markers, and outstanding bids.

Gate to proceed: compatibility tests pass, v1 historical fixtures decode to
`monk/anthropic/claude`, old units remain the only enabled Anthropic units, and
the snapshot has no unrecognized worker identity. Failure means revert this
release or leave it deployed with old writers. It is read-compatible and has no
data migration to undo.

### 1. Per-host cutover, followers first

Deploy the compatibility release deliberately to every host, beginning with
followers. On each host, use a migration command that records its pre-state and
does this transaction:

1. turn on the local drain and wait for every legacy `garden-gardener@N` busy
   marker and active handler to clear;
2. verify no live `doin/` claim refers to that host and instance, or leave it
   running until the ordinary handler/reaper ownership rules resolve it;
3. write `monks: N` while retaining `gardeners: N` as the old-binary mirror;
4. disable and stop every `garden-gardener@1..N`, verify none is active, render
   the monk unit, then enable `garden-monk@1..N` with the same indices;
5. verify exactly N Anthropic worker units and zero legacy units are active,
   then lift the drain and append an auditable host-migration record.

The migration command must refuse to continue on a busy worker, duplicate unit,
unknown claim schema, failed unit action, or mismatched count. It may be rerun:
the recorded state makes each completed step a no-op and never removes a
`gardeners:` mirror prematurely. It does not rename a worktree, clone, or live
state directory. Monk recovery probes the legacy namespace for a claim resumed
after the switch.

Move the leader last. The normal leader/follower marker and singleton handshake
remain unchanged: first make every follower capable of the new worker shape,
then drain and cut over the leader's local consumer pool. The worker migration
does not move the `leader` marker or start a second singleton. A fleet-wide
drain before the leader cutover is acceptable when operationally preferable,
but is not a substitute for the per-unit zero-overlap assertion.

Rollback gate: before the old unit is removed, and during the alias window, a
host can drain, stop `garden-monk@N`, re-enable `garden-gardener@N`, retain both
count keys, and lift the drain. Old readers accept completed monk claims because
claim ownership is not altered; an old worker must never take a currently owned
claim. The dual projection avoids losing auction history. If a new monk is busy,
rollback waits for it rather than killing it. A rollback is blocked, not forced,
if the old deployed binary lacks a required reader for a v2 artifact; retain the
compatibility release as the rollback floor until that is proven.

### 2. Canonical writes and cleanup

After every host reports the stage-1 postconditions, flip the writer defaults:
new claims, work records, bids, usage records, reputation events, labels and
unit descriptions emit `monk`; `set-gardeners` stays an alias to `set-monks`.
The generic consumer remains a gardener in prose and in the shared spine.

Keep input aliases, the legacy handler wrapper, `gardeners:` mirror, old unit
cleanup detection, and dual projection for at least one full maximum of claim
TTL, handler timeout plus kill grace, reaper sweep, deploy window, and the
operator's declared rollback window, measured after the final host cutover.
Retire them only with all of these recorded facts: all fleet inventory reports
zero legacy units and state markers; no `doin`, `work`, inbox, active worktree,
or recent bid has a live legacy owner; all hosts have deployed the canonical
release; no supported external script calls an alias; and a rollback drill is no
longer promised. Removing aliases is a later, separately reviewed cleanup,
never part of the fleet migration command.

## Required validation

Add a hermetic fleet acceptance test using a throwaway journal and mocked
systemd. Seed one Anthropic-pinned `model: opus`, one OpenAI-pinned `model:
terra`, and one local-pinned `model: qwen3.6` job. Start a monk, cleric, and
hermit through the same worker spine with stub handlers. Assert that the monk
alone claims and completes the Anthropic job with a v2
`monk/anthropic/claude` claim; cleric alone claims the OpenAI job; hermit alone
claims the local job; and each foreign-pinned job remains unclaimed by the
wrong kinds. Repeat an unpinned race to prove the shared CAS still admits one
claim only.

The suite also must prove: a v1 `worker_kind: gardener` claim/event/bid is read
as monk; v1 reputation contributes to both projection aliases; old count input
starts exactly one monk pool after cutover; no `garden-gardener@N` and
`garden-monk@N` pair is active for the same host/index; an interrupted cutover
preserves the claim and worktree; scaler, deploy/restart, reaper, bulletin,
proxy, and metrics enumerate monk, cleric, and hermit; and rollback from an idle
monk host restores exactly its legacy pool. Run the existing worker-spine,
auction/reputation, scaler, deploy, reaper, and full job-system tests as
regressions.

Success is not a documentation grep. It is the fleet acceptance test above plus
an observed staged deployment on every host, with the recorded postconditions.
Failure at any gate leaves the fleet drained or on the previous complete stage;
it never starts a parallel Anthropic pool, rewrites historical journal data, or
deletes a claim/worktree to make progress.
