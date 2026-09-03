---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
project: minion-town

Build a garbage collector for `minion.town`'s clip content store, rooted in the daemon's own **formula graph**: a deleted formula unretains the content it was retaining, and content with no remaining retainer gets deleted. Maintainer directive (dckc), 2026-09-03, split out from the broader `minion-town-clip-formula-id-origin-gc` design job as its own build (that job now cites this one rather than owning the GC design/implementation).

## The confirmed gap

`src/endo/gateway/content-store.ts` implements the clip content-addressed store (CAS) as strictly **write-once**, sha-256-addressed, on-disk (`<root>/blobs/<ab>/<blobId>`; a manifest is itself a blob, per its own header comment). A grep across every file in `src/endo/gateway/` for `evict|delete|prune|ttl|expire` turns up **zero hits** outside `ttl-cache.ts` (an in-memory read-side lookup cache — not storage retention). `unregister` in `site-registry-exo.ts` only drops the `@sites` registry's `hash -> directoryId` edge and the `owner-<hash>` record; it does not touch the CAS, and does not touch the guest's own directory formula in the daemon's durable store. So every `publish`, every `upgrade`'s superseded `front` bytes, and every already-`unpublish`ed clip's blobs accumulate on disk **forever**, unbounded.

## The retention model to build

Root the GC in the **daemon's own formula graph**, not a separate bookkeeping structure bolted onto the gateway:

- **Retainers are formulas.** A registered clip's directory formula (holding `front`/`back`) is what retains the CAS blobs its `front` manifest names. When that directory formula is deleted (site unregistered, or any other daemon-side path that drops the formula), it stops retaining the blobs it referenced.
- **Content with no remaining retainer is collected.** Once no live formula's `front` manifest names a given blob or manifest-blob, that blob is eligible for reclamation and should be deleted from `<root>/blobs/`.
- This is standard mark-and-sweep / reference-counted GC semantics, applied with the formula graph as the root set rather than an ad hoc separate index — read `packages/daemon/src/directory.js` and whatever formula-lifecycle/deletion primitives the pinned daemon commit already exposes (see `journal/projects/minion-town/README.md` for the Endo direction and the pinned commit this deployment tracks) before inventing a parallel bookkeeping scheme; prefer reusing or extending the daemon's own formula-deletion hooks over duplicating retention logic gateway-side, if that seam already exists or is a small addition.
- Also determine and, if missing, close the sibling gap: when a site is unregistered today, does *anything* delete the guest's own directory formula, or does it just become an orphaned-but-still-alive formula that retains its blobs forever regardless of your new GC? If the directory formula itself is never deleted on unregister, the content-level GC alone won't reclaim anything — you may need to also wire deletion of the directory formula into `unregister` (or confirm it already happens) for the retention chain to actually break.

## Required properties

- **Race-safety against the write side.** A blob interned mid-`publish` (charged, written to CAS) but not yet linked into a manifest/formula (because the guest's `E(sites).register(...)` evaluate hasn't returned yet) must never be swept. State and justify the exact interlock — a grace period keyed on intern timestamp, a two-phase mark that only sweeps blobs older than some minimum age, or equivalent.
- **Dry-run / audit mode** that reports what *would* be reclaimed without deleting anything. Ship this first and treat it as the thing to validate live before any real deletion runs.
- **Trigger and cadence**, stated with rationale: a periodic sweep (a `deploy/aws/systemd/` timer, matching this project's existing deployment pattern) versus incremental reclaim triggered on `unregister`/`upgrade`, or both.
- **Unit tests with regression evidence** (this project's `assayer`/`regression-evidence` discipline: break the reference-computation logic, show the test fails, revert) proving: (a) a blob still referenced by a live formula survives a sweep; (b) a blob orphaned by `upgrade` rewriting `front` is collected; (c) a blob orphaned by `unregister` is collected; (d) an in-flight publish's freshly-interned, not-yet-linked blob survives a concurrent sweep.
- **Production ad hoc validation of the dry run**, since this touches the live accumulated store: run the dry-run/audit mode against the real production `minion.town` deployment's actual blob store, and record what it reports before proposing to enable real deletion. Do not enable real deletion in this job without that dry-run evidence in the PR.

## Relationship to the sibling design job

`minion-town-clip-formula-id-origin-gc` (design job, may already be in progress or landed by the time you claim this) was originally asked to also produce a GC design; it has since been told to defer the GC design/implementation to this job. If its design doc exists and covers this ground by the time you start, implement against it and note that in your PR; if not, implement directly from this job's spec (the maintainer's own explicit direction above) and say so.

## Deliverable

A draft PR against `main` (or the project's normal PR flow) implementing the dry-run GC, its tests, and — once the live dry-run evidence is in hand and clean — either real-deletion mode landed in the same PR or a clearly-scoped follow-up naming exactly what remains, per the builder role's normal draft-PR-then-gauntlet flow.

<!-- garden-transient-elapsed: kind=signature through=0 values=2 -->

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-03T21:30:53Z
