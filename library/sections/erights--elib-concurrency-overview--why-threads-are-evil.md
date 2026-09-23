---
title: "Concurrency Overview: Why threads are evil"
source_kind: web
source_url: http://erights.org/elib/concurrency/overview.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/overview.html
source_fetched_via: mirror
source_content_sha256: 0c1fea572c8fc22cc42b474a2b7fde80d205280fffc40615874c9447efb47be1
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, eventual-send]
status: current
notes: >
  Reference-level child chapter of the ELib Event Loop Concurrency hub
  (erights--elib-concurrency-index). The motivating essay for E's event-loop
  model: preemptive shared-state threads are an unmastered disaster, event loops
  are the better alternative few respect. source_date is an era approximation
  matching the sibling concurrency chapters.
---

## Abstract

The opening chapter of E's reference-level concurrency treatment, arguing that
the conventional **shared-state preemptive-thread** paradigm is "a largely
unexamined disaster": correct concurrent programs must both preserve consistency
and avoid deadlock, and almost no one can do both at once with threads. The
already-familiar alternative is **event-loop programming** (the model UI
programmers use without naming it), which E elevates with linguistic support
derived from the massively-concurrent languages (Actors, Concurrent Logic /
Constraint Programming, Joule) while keeping a sequential subsystem those
languages lack. This is the framing essay behind the vat / turn / eventual-send
model that became `@endo/eventual-send` and Agoric's vat model.

## Why threads are evil

To programmers schooled in the C / Java / Python / Scheme traditions, the most
unfamiliar part of E is its handling of concurrency. The conventional concurrency
style (multiple preemptive threads operating on shared data) has been an
unmitigated disaster. Many people have learned this paradigm, but very few have
learned, or could learn, how to write complex correct programs in it. A correct
program must maintain consistency while avoiding deadlock. Extended to distributed
systems, threads usually lead to horribly inefficient communication patterns and
consistency-recovery mechanisms (synchronous RPC and distributed transactions,
respectively).

Threads are a largely unexamined disaster, because few realize any alternative is
possible. Ironically, many people (especially UI programmers) already have lots of
experience with a better alternative, **event-loop programming**, without
realizing it. The common prejudice views event-loop programming as less
respectable than thread-based programming: event loops are seen as disreputable
hacks used only until one can build "the proper solution" of threads ("real
computer scientists use threads").

Classic event loops may feel dirty and hard to program in, but that is because
they have not received a fraction of the investment in tools and abstraction
design thrown at threads. Meanwhile a different school of programming (**Actors,
Concurrent Logic Programming, Concurrent Constraint Programming, and Joule**) did
all its control flow with nothing but communicating event loops, and showed how to
provide high-quality linguistic support for the style. Those languages are so
successful at taming concurrency that they are massively concurrent while still
being stateful. But they are *only* concurrent: they contain no sequential
programming subsystem, so they remain inaccessible to most programmers.

**E reconciles these tensions.** It supports event-loop programming with
linguistic abstractions derived from the massively concurrent languages, and at
the same time combines event loops with sequential programming in essentially the
way familiar to UI programmers. The E programmer can easily, reliably, and
efficiently maintain consistency without deadlock in the face of both concurrency
and distribution.

## Why this matters for Endo

This is the rationale chapter for everything Endo inherits from E's concurrency
model. The "consistency without deadlock" goal is exactly what the
`@endo/eventual-send` discipline delivers in JavaScript: because a turn runs to
completion and inter-agent communication is only ever a non-blocking
eventual-send, there is no lock to deadlock on. The "event loops are the
already-familiar better alternative" framing is the same argument JavaScript's own
single-threaded event loop embodies; Endo's contribution is the *secure*,
*distributed* form (`E()` over `HandledPromise`, promise pipelining, OCapN
transport) that the massively-concurrent ancestor languages reached for and that
plain JavaScript lacks.

## Translation (E to Endo)

| E concurrency term | Endo / Hardened JavaScript equivalent |
|---|---|
| event-loop programming | the JavaScript event loop / microtask queue, made secure and distributed |
| preemptive shared-state thread (the disaster) | (no equivalent; Endo has no shared-memory threads by design) |
| consistency without deadlock | run-to-completion turns + non-blocking eventual-send |
| massively-concurrent ancestor languages (Actors, Joule, ...) | the lineage behind `@endo/eventual-send` and CapTP / OCapN |

## Cross-references

- Parent hub: [erights--elib-concurrency-index--event-loop-reference-map](erights--elib-concurrency-index--event-loop-reference-map.md).
- The deadlock-vs-consistency argument is developed in detail in the sibling
  [erights--elib-concurrency-event-loop--plan-interference-and-deadlock-freedom](erights--elib-concurrency-event-loop--plan-interference-and-deadlock-freedom.md).
- Formalized in the already-ingested
  [Concurrency Among Strangers](papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model.md)
  paper section.

## Source

Source: [elib/concurrency/overview.html](https://erights.github.io/erights-org-website/elib/concurrency/overview.html) (mirror of `http://erights.org/elib/concurrency/overview.html`), last modified 1998-10-03 (era approximation), content SHA-256 `0c1fea572c8fc22cc42b474a2b7fde80d205280fffc40615874c9447efb47be1`, fetched via the erights.org GitHub Pages mirror.
