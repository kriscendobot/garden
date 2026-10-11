---
title: "ADR 0005: Exact diamond invalidation example"
source: docs/decisions/0005-executable-component-semantics.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: A four-node `invoice-cli` diamond demonstrates that private changes regenerate only the changed provider but rebuild and retest artifact consumers, public-interface changes propagate along direct generation edges and intentional re-exports, and asset changes skip regeneration while invalidating downstream builds and tests.

`invoice-cli` generates against the direct public interfaces of `pricing` and
`reporting`. Both depend directly on `money`. `pricing` intentionally re-exports the
`money` interface; `reporting` does not.

```mermaid
flowchart TD
    I["invoice-cli"] -->|generation + build| P["pricing"]
    I -->|generation + build| R["reporting"]
    P -->|generation + build| M["money"]
    R -->|generation + build| M
    M -. "intentional public re-export" .-> P

    classDef root fill:#17324d,color:#fff,stroke:#6ec5ff
    classDef middle fill:#f5efe0,color:#2f2a20,stroke:#c69538
    classDef leaf fill:#e4f2e7,color:#18351f,stroke:#58a56b
    class I root
    class P,R middle
    class M leaf
```

For this exact graph, build changes propagate through build edges and interface changes
propagate through direct generation edges. The re-export makes the `money` public
interface part of `pricing`'s public identity. A private `money` revision changes its
`ComponentInterfaceBinding`, but the bound interface identity remains unchanged.

| Change | Regenerate | Rebuild | Retest |
| --- | --- | --- | --- |
| `invoice-cli` local authority | `invoice-cli` | `invoice-cli` | `invoice-cli` |
| `pricing` private/local authority | `pricing` | `pricing`, `invoice-cli` | `pricing`, `invoice-cli` |
| `reporting` private/local authority | `reporting` | `reporting`, `invoice-cli` | `reporting`, `invoice-cli` |
| `money` private/local authority | `money` | `money`, `pricing`, `reporting`, `invoice-cli` | `money`, `pricing`, `reporting`, `invoice-cli` |
| `money` public interface, with the shown re-export | all four | all four | all four |
| `money` target or Flavor selection | `money` | all four | all four |
| `money` authored binary asset | none | all four | all four |

If neither direct consumer intentionally re-exported `money`, a `money` interface change
would regenerate `money`, `pricing`, and `reporting`, but not `invoice-cli`. The root
still rebuilds and retests because its dependency artifacts changed. The exact table is
also represented by the versioned `ComponentInvalidationTable` contract and enforced by
the diamond fixture test; it is not merely explanatory prose.

Source: [docs/decisions/0005-executable-component-semantics.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0005-executable-component-semantics.md) at commit `fcc40bc` (source lines 118–159).
