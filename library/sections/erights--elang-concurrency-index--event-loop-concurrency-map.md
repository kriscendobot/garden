---
title: "Concurrency in E: the event-loop / eventual-send chapter map"
source_kind: web
source_url: http://erights.org/elang/concurrency/index.html
source_effective_url: https://erights.github.io/erights-org-website/elang/concurrency/index.html
source_fetched_via: mirror
source_content_sha256: 333af952f80e51af607b7cfb3b0665550fc7420442053a388d5899fb8e7e5484
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, eventual-send]
status: current
notes: >
  Primary-source HTML via the erights.org GitHub Pages mirror. This is a thin
  navigation HUB ("Concurrency in E — An Informal Introduction"): its own body is
  only a reading map to the child chapters, not prose. Captured as a map section
  so the named concurrency entry point resolves; the child chapters
  (Concurrency Races, Epimenides Paradox, Determinism) and the deeper
  `elib/concurrency` event-loop reference are queued in scholar-ingest-erights-3.
  The already-ingested Introducing Remote Objects chapter is cross-linked below.
---

## Abstract

The **Concurrency in E** chapter is the informal-introduction hub for E's
concurrency model — the event-loop / vat / eventual-send model that is the direct
ancestor of `@endo/eventual-send` and Agoric's vat model. The hub page itself
carries no prose body; it is a reading map to three introductory chapters
(Introducing Remote Objects, Concurrency Races, the Epimenides Paradox), a
future-plans chapter (Determinism), and a "See Also" pointer to the deeper *Event
Loop Concurrency* reference under `elib/`. This section captures that map and the
Endo translation; the substantive child chapters are queued.

## The chapter map

**An Informal Introduction:**

- **Introducing Remote Objects** (`concurrency/introducer.html`) — **ingested**
  as [erights--elang-concurrency-introducer--remote-objects](erights--elang-concurrency-introducer--remote-objects.md):
  live vs sturdy references, capability URIs, the eventual-send `<-` operator,
  and bootstrapping the first off-machine reference via the introducer.
- **Concurrency Races** (`concurrency/race.html`) — how E's event-loop turn
  discipline tames the data races that thread-based concurrency suffers. (queued)
- **Epimenides Paradox** (`concurrency/epimenides.html`) — the self-referential
  "this statement is false" paradox used to motivate E's handling of
  reentrancy / circular promise resolution. (queued)

**Future Plans:**

- **Determinism** (`concurrency/determinism/index.html`) — deterministic replay
  of an event-loop computation. (queued)

**See Also:**

- **Event Loop Concurrency** (`elib/concurrency/index.html`) — the deeper
  reference for the vat / turn / pending-delivery-queue model. (queued)

## Why this matters for Endo (the model in one paragraph)

E's concurrency unit is the **vat**: a heap plus a single thread plus a queue of
pending deliveries. Within a vat, message delivery is run-to-completion per
*turn*, so there are no interleaving data races; between vats, the only
communication is **eventual-send** (`<-`), which never blocks and immediately
returns a **promise** that resolves in a later turn. This is exactly the model
Endo carries forward: `E(target).method(args)` is the eventual-send, the promise
is a `HandledPromise`, and a compartment/agent event-loop domain plays the vat's
role. The deeper development of vats, the three reference states (near, eventual,
broken), and promise pipelining lives in the already-ingested
[Concurrency Among Strangers](papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model.md)
paper section; this chapter is the tutorial-level entry point that paper formalizes.

## Translation (E to Endo)

| E concurrency term | Endo / Hardened JavaScript equivalent |
|---|---|
| vat | compartment / per-agent event-loop domain |
| eventual-send (`<-`) | `E(target).method(args)` |
| promise / vow | `HandledPromise` / `makePromiseKit()` |
| turn (run-to-completion delivery) | a single resolved-callback job on the microtask queue |
| sturdy reference + capability URI | OCapN locator / sturdyref |

## Source

Source: [elang/concurrency/index.html](https://erights.github.io/erights-org-website/elang/concurrency/index.html) (mirror of `http://erights.org/elang/concurrency/index.html`), last modified 1998-10-03, content SHA-256 `333af952f80e51af607b7cfb3b0665550fc7420442053a388d5899fb8e7e5484`, fetched via the erights.org GitHub Pages mirror.
