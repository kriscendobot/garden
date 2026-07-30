---
order: serial
children: monk-finish-gardener-rename lama-rename-hermit
on-child-failure: halt
state: running
created_by: liaison
created_at: 2026-07-30T05:40:05Z
---

# Orchestration: holistic worker-kind renames (gardener->monk, hermit->lama)

Two serial worker-kind renames that share the same registry, canonicalizer, reducer
dual-projection, and deployment surfaces, so they must not run in parallel.

## Children (serial)

1. `monk-finish-gardener-rename` — finish the accepted-but-unimplemented
   gardener->monk rename per `designs/anthropic-worker-kind-monk.md`. Lands the
   compatibility layer (canonicalizer, both registry spellings, v1/v2 readers,
   dual reputation projection, handler wrapper, tests) first, then the per-host
   cutover procedure handed back to the liaison.
2. `lama-rename-hermit` — rename hermit->lama on the same shape and discipline,
   extending the monk rename's compatibility machinery rather than parallel-rewriting
   the shared registry. Runs only after child 1 reaches tada.

## Failure policy

halt on child failure (serial): if the monk rename fails, do not start the lama
rename — they share the registry and a half-migrated canonicalizer would corrupt
the second rename.

## Why an orchestration

Both renames touch `worker_kind_field`, `canonical_worker_kind`, the reputation
reducer, systemd unit rendering, host-count config, and state directories. Running
them as loose jobs risks a conflicting parallel edit of the shared registry; running
them serially under one orchestration ensures the second builds on the first's
compatibility layer and the follow-up is not forgotten.

## Deploy note

Neither child changes a deployed checkout or a live unit. Each hands its cutover
procedure back to the liaison for a deliberate drained deploy per host.
