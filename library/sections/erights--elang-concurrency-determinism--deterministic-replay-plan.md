---
title: "Plans for Determinism (future-plans outline)"
source_kind: web
source_url: http://erights.org/elang/concurrency/determinism/index.html
source_effective_url: https://erights.github.io/erights-org-website/elang/concurrency/determinism/index.html
source_fetched_via: mirror
source_content_sha256: 970036f40fbe43a4d618982e9b738b8364a439fc41dd52335ab099bc89c5c961
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [eventual-send, e-language]
status: current
notes: >
  Primary erights.org "Future Plans" page (child of the concurrency hub). This page
  is a thin OUTLINE with no prose body — only a heading list (Overview, Challenges,
  and five named Benefits). Captured as a single outline-stub section so the named
  Determinism entry point resolves; if erights.org ever fleshes the page out a
  re-ingest can expand it. Reachable via the erights.org GitHub Pages mirror.
  source_date is an era approximation matching the sibling concurrency chapters.
---

## Abstract

The E tutorial's **Plans for Determinism** page, a *Future Plans* entry under the
concurrency hub. It is an **outline stub**: the page carries no prose body, only a
heading list naming the topic and its motivating benefits. Determinism here means
**deterministic replay** of an event-loop computation — re-running a vat's turn
sequence and getting bit-identical results — which the page motivates by five
benefits: **cheaper commitment**, **cheaper fault tolerance**, **inward bit
confinement**, **debugging**, and **contract verification**. This is the
intellectual ancestor of the deterministic-replay property Agoric's vat model and
orthogonal-persistence systems rely on (replay a transcript of deliveries to
reconstruct state; verify a contract by re-execution). Captured so the named
Determinism entry point resolves; treat it as a pointer, not a body, because the
upstream page was never written out beyond its outline.

## The outline (as published)

The page's full content is its heading structure:

- **Overview**
- **Challenges in achieving determinism**
- **Benefits:**
  - **Cheaper Commitment** — committing state is cheaper when the computation can
    be replayed deterministically rather than snapshotting every intermediate
    state.
  - **Cheaper Fault Tolerance** — a replica can be reconstructed by replaying the
    delivery transcript instead of continuously mirroring memory.
  - **Inward Bit Confinement** — determinism bounds covert channels: a
    deterministic computation cannot leak bits inward through timing or scheduling
    nondeterminism.
  - **Debugging** — a deterministic computation can be replayed exactly to
    reproduce a bug.
  - **Contract Verification** — a smart contract's outcome can be checked by
    independently re-executing its deterministic transcript.

No further prose accompanies these headings on the upstream page.

## Why this matters for Endo

Deterministic replay of an event-loop turn sequence is the property Endo's and
Agoric's persistence and fault-tolerance stories rest on: a vat (compartment /
event-loop domain) records the deliveries it processes, and its state at any point
is a pure function of that transcript replayed from the last snapshot. The five
benefits the page names map directly onto why orthogonal persistence, upgrade, and
contract verification want determinism — replay-to-reconstruct (fault tolerance,
cheaper commitment), replay-to-reproduce (debugging), and replay-to-check
(contract verification), with confinement as the security bonus.

## See also

- [erights--elang-concurrency-index--event-loop-concurrency-map](erights--elang-concurrency-index--event-loop-concurrency-map.md): the concurrency hub that lists this Future-Plans page.
- [erights--elib-concurrency-index--event-loop-reference-map](erights--elib-concurrency-index--event-loop-reference-map.md): the deeper Event-Loop Concurrency reference whose vat-turn model determinism would make replayable.
- [papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model](papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model.md): the vat / turn model whose deterministic replay this page plans.

Source: [elang/concurrency/determinism/index.html](https://erights.org/elang/concurrency/determinism/index.html), fetched 2026-06-28 via the erights.org GitHub Pages mirror ([erights.github.io/erights-org-website/elang/concurrency/determinism/index.html](https://erights.github.io/erights-org-website/elang/concurrency/determinism/index.html)), content SHA-256 `970036f40fbe`.
