---
role: designer-exo-captp-api
status: seed
authored: 2026-05-15
---

# Designer landing: Exo and CapTP API engineering

## When this landing is your starting point

You are designing an Exo class or class kit, choosing between
`makeExo` / `defineExoClass` / `defineExoClassKit`, writing or
revising an interface guard, picking the persistence zone for a
piece of state (heap / virtual / durable), or designing a CapTP-
addressable API surface that other peers will call into via
eventual-send. If the question is *"what shape does this object
present to callers — local or remote — and how is its state
managed?"*, the material below is your corner of the library.

## Start here (read first, in this order)

1. **[`exo`](../topics/exo.md)** topic page — the Exo class API: `makeExo`, `defineExoClass`, `defineExoClassKit`. The three forms and when to use each is the load-bearing decision (40 sections).
2. **[`patterns`](../topics/patterns.md)** topic page — the `M` namespace; how interface guards are written; `matches` / `mustMatch` (29 sections).
3. **[`eventual-send`](../topics/eventual-send.md)** topic page — `E()` and `E.when`; turn model; pipelining (49 sections).
4. **[`captp`](../topics/captp.md)** topic page — the wire protocol that carries eventual-send across process boundaries (42 sections).
5. **[`marshal`](../topics/marshal.md)** + **[`pass-style`](../topics/pass-style.md)** — how values cross a serialization boundary; pass-style classification; smallcaps wire format.

## Topics in scope

- **[`exo`](../topics/exo.md)** — Exo class taxonomy; heap / virtual / durable; make-vs-prepare; state management.
- **[`patterns`](../topics/patterns.md)** — interface guards; method shape matching; `M` namespace.
- **[`eventual-send`](../topics/eventual-send.md)** — `E()`, `E.when`, turn model, pipelining; the substrate every API call rides.
- **[`captp`](../topics/captp.md)** — `op:start-session`, `op:deliver`, `op:gc-export`; the wire protocol.
- **[`marshal`](../topics/marshal.md)** — `@endo/marshal`; smallcaps encoding; `makeTagged`; `CopyTagged`.
- **[`pass-style`](../topics/pass-style.md)** — passable classification; copy-array / copy-record / remotable; pass-style guarantees.
- **[`compartments`](../topics/compartments.md)** — Exo classes always live in some compartment; the compartment boundary is the harden boundary.
- **[`async-flow`](../topics/async-flow.md)** — durable-replay async functions; closed-function discipline; relevant when an Exo's methods do multi-step async work.

## Concepts in scope

- [producer-typed-shape-consumer-rendering](../concepts/producer-typed-shape-consumer-rendering.md) — *the producer owns the typed shape; each consumer owns its rendering*. The single most important convention when designing a method that returns structured data.
- [caretaker-pattern](../concepts/caretaker-pattern.md) — Handle / HandleControl + identity / action facet splits. The pattern Exo class kits often express through paired facets.
- [dehydrate-hydrate](../concepts/dehydrate-hydrate.md) — separate the durable typed key from ephemeral metadata; pet stores hold the typed shape, not the rendering.
- [pass-invariant-handle-equality](../concepts/pass-invariant-handle-equality.md) — connector guarantee: same backing identity → same formula identifier. Relied on by every caller that de-duplicates references.
- [delegates-and-epithets](../concepts/delegates-and-epithets.md) — Handle's `epithets()` / `verify()` methods are an example of an interface extension that ships *additive*, not breaking, on `HandleInterface`.

## Cluster overviews

### Exo class taxonomy (topic page anchor)

Three forms — `makeExo`, `defineExoClass`, `defineExoClassKit` — distinguished along three axes:

1. **Single vs. multi-facet** — `defineExoClassKit` is the multi-facet form; `makeExo` and `defineExoClass` are single-facet.
2. **Stateless vs. stateful** — `makeExo` has no state; `defineExoClass` and `defineExoClassKit` provide state through `init`.
3. **Heap vs. virtual vs. durable** — the zone determines whether state lives on the JS heap (lost on vat restart), in a heap-managed virtual store, or in durable storage that survives vat / daemon restart.

The exo-taxonomy section explains the cross-product; pick the cell, then the API name follows.

### CapTP wire model

- **`op:start-session`** — handshake exchanges per-session keypairs, captp-version, `acceptable-location`, and a signature. Crossed-hellos resolution by bytewise compare of public-identifier hashes.
- **`op:deliver`** — the eventual-send-over-the-wire message.
- **`op:gc-export`** — drop notification for distributed garbage collection.
- **netlayer / CapTP contract** — netlayer provides a bidirectional `Uint8Array` byte stream; CapTP runs framing (netstring) + Syrup decoding + op-loop on top.

### Marshal / pass-style

- **Smallcaps wire format** — JSON-compatible with sigil prefixes (`#`, `+`/`-`, `%`, `$`, `&`, `!`) for typed values.
- **Pass-style classification** — copyArray, copyRecord, copyBag, copySet, copyMap, remotable, tagged, error, promise, primitive types.
- **`makeTagged(tag, payload)`** — the standard way to introduce a typed wrapper for a new domain shape.

### Interface guards (patterns)

- **`M.interface(name, methodGuards)`** — declarative shape for an Exo class's method signatures.
- **`M.call(...argShapes).returns(returnShape)`** — per-method guard.
- **`M.string()`, `M.number()`, `M.recordOf({...})`, `M.arrayOf(...)`, `M.remotable('Tag')`, `M.promise(...)`** — the building blocks.

## Conventions and constraints

- **Producer typed-shape, consumer rendering**: when a new method returns structured data, return a typed Passable (`CopyRecord`, `CopyTagged(tag, payload)`); do *not* return a pre-rendered string. Each consumer renders for its surface. See the concept page and `rpn/alternatives-and-decisions` for the worked example (the daemon-side `describeRetentionPaths` that was rejected for this reason).
- **Interface guards on every public method**: `defineExoClass(zone, tag, M.interface(...), methods)` — the interface guard is not optional; it documents and validates the method shape at every call.
- **Pick the zone deliberately**: heap is the default but loses state on vat restart; virtual is heap-managed durable; durable survives vat / daemon restart. Mismatched zones are a common source of silent state loss on upgrade.
- **Pass-invariant equality**: when a method returns a remotable, the same backing identity must produce the same formula identifier; callers de-duplicate by identity comparison and break if equality is unstable.
- **No `globalThis` mutation post-lockdown**: any state your API closes over at module load must be captured before lockdown. The vetted-shim pattern (`hurl`, `htcs`, `b64nf`) is the canonical example of doing this right.

## Adjacent landings

- **[designer-protocol](designer-protocol.md)** — the wire side of any cross-process API; if your Exo class is reached via eventual-send across CapTP, the protocol landing is its other half.
- **[designer-security](designer-security.md)** — the caretaker pattern is expressed through Exo classes; many security properties (revocation, attenuation, deniability) are shaped at the Exo boundary.
- *(pending)* `designer-language` — language design intersects when an API surface includes a DSL or macro layer.
