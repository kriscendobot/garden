<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-06-27T07:34:29Z -->

# PLAN: scholar — ingest MetaMask/ocap-kernel into the library

Maintainer: ingest **ocap-kernel** (https://github.com/MetaMask/ocap-kernel) into the library.
Wear the **scholar** role (library curator; `journal/library/`). Deferred plan; when promoted,
ingest this public repository as library source material, following the library conventions
(`journal/library/{concepts,sources,sections,topics}`, `conventions.md`) and the scholar's
honesty discipline (ground every claim in a real source, cite it, flag external lineage).

## Source

`MetaMask/ocap-kernel` — MetaMask's **object-capability kernel** for JavaScript: a kernel/vat
runtime in the SES/ocap lineage (related to but distinct from Endo/Agoric's kernel + CapTP).
**Public repo, read-only ingestion** — this is library scholarship over public source, NOT any
action on the repo (no fork, no PR, no issue activity). Scope to reading: README, `docs/` and any
design notes, the package layout, and the kernel/vat/messaging implementation.

## What to curate

- **The kernel/vat model**: how ocap-kernel structures vats, the kernel, and inter-vat messaging;
  its capability-passing and lifecycle.
- **The ocap mechanisms**: capability confinement, message delivery, promise/eventual-send-like
  semantics, persistence — and **how each relates to the Endo/SES/Agoric lineage** already in the
  library (same ideas, different implementation; note divergences honestly).
- **Cross-link** heavily to the six ocap sections being ingested in parallel
  (`ingest-ocap-library-sections`): ocap-kernel is a concrete implementation source for
  **distributed confinement, three-party hand-off, eventual send, and sturdyrefs** especially.
  Add source pages + a concept/section for ocap-kernel and wire it into those topics.

## Approach & discipline

- Ingest as **source pages**, write a **concept/section** synthesizing ocap-kernel's design, and
  cross-link to adjacent library material and the six-sections topics.
- Honesty: it is **MetaMask's** kernel — flag its lineage as external/distinct from Endo's; never
  conflate the two or fabricate a claim. Where ocap-kernel and Endo solve the same problem
  differently, say so.
- Sizable repo: do a solid first pass, and **post follow-on `scholar-ingest-ocap-kernel-<area>`
  plans (deferred)** for deeper coverage (e.g. a specific subsystem). Surface a synthesis to the
  **bulletin** (`message-user`) when meaningful progress lands.

## Definition of done

ocap-kernel ingested as library source (source pages + concept/section), cross-linked to the
garden's ocap material and the six-sections topics, with honest external-lineage flags, and a
bulletin synthesis — or a solid first pass with deferred follow-on plans. Report what was curated
and how it maps to the existing ocap concepts.

---
claim:
  host: endolinbot
  gardener: 82
  claimed_at: 2026-06-27T07:34:33Z
