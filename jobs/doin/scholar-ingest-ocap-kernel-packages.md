<!-- garden-promoted-from-plan: gate=deferred priority=low at=2026-06-27T14:19:30Z -->

# PLAN: scholar — ingest MetaMask/ocap-kernel packages + code-comment fragments

Follow-on from `ingest-ocap-kernel` (sixth ocap-kernel ingest, 2026-06-27). Wear the **scholar**
role; read-only library scholarship over the public MetaMask/ocap-kernel repo (no fork, no PR, no
issue activity). Sizable — a future gardener may split this further.

## Source

`MetaMask/ocap-kernel` — the cross-comparable packages and substantive source files named in the
cycle-161 overview's queued-for-future-cycles plan.

## What to curate

- **Per-package READMEs**: `ocap-kernel`, `kernel-store`, `streams`, `remote-iterables`,
  `kernel-utils/exo`, `kernel-rpc-methods`.
- **Code-comment fragments** (per the comment-fragment source kind in conventions.md) for the
  kernel internals: `Kernel.ts`, `VatHandle.ts`, `VatSupervisor.ts`, `KernelQueue.ts`,
  `KernelRouter.ts`, `KernelServiceManager.ts`, `BaseDuplexStream.ts`.

Cross-link to the [[ocap-kernel]] concept and the existing kernel-guide / glossary /
ken-protocol-assessment sections. Honest external-lineage flags throughout. Respect the per-cycle
budget (3–5 repo doc sources, or one comment-fragment file per cycle) and post a further deferred
plan for whatever a single cycle leaves.

## Definition of done

A solid first pass over a subset (e.g. the `ocap-kernel` + `kernel-store` package READMEs, or one
internals comment-fragment file), cross-linked and indexed, with a result entry and a deferred
plan naming exactly the remainder.

---
claim:
  host: endolinbot
  gardener: 53
  claimed_at: 2026-06-27T14:19:35Z
