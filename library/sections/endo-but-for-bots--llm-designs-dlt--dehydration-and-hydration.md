---
title: Dehydration and hydration — stable formula keys vs ephemeral hints
source: designs/daemon-locator-terminology.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bccee2841e52eb5e42ec5b5be4fcbe1e66d60a42
source_date: 2026-03-17
source_authors: [Kris Kowal]
topics: [daemon, persistence, capability-security]
status: current
---

Locators bundle two things with different lifetimes: a stable formula
key (durable, content of pet store entries, references in formula
files) and ephemeral connection hints (current network addresses, may
change between sessions). The design *separates them at ingestion* and
*recombines them at presentation*.

## Dehydrate at ingestion

When a locator arrives — from another peer, from user paste, from a
chat message — its formula key and its hints are split apart:

```js
const { peerKey, formulaAddress, hints, formulaType } = parseLocator(locator);
const formulaKey = formatId({ number: formulaAddress, node: peerKey });

// Durable store: the stable reference
await petStore.write(petName, formulaKey);

// Separate update: refresh the peer's connection hints
await addPeerInfo({ node: peerKey, addresses: hints });
```

The pet store row holds the formula key, **never** a locator. Hints
land in a separate per-peer record where they can be replaced wholesale
on each fresh arrival.

## Hydrate at presentation

When a locator is needed — for display, for sharing, for an invitation
— it is rebuilt from the stored key plus the peer's *current* hints:

```js
const formulaKey = await petStore.read(petName);
const { node: peerKey } = parseId(formulaKey);
const { addresses: hints } = await getPeerInfo(peerKey);

const locator = formatLocatorWithHints(formulaKey, formulaType, hints);
```

## Round-trip invariant

If a locator is dehydrated and then hydrated with no intervening hint
change, the resulting locator is identical to the original. If hints
have changed in the interim, the hydrated locator reflects the **new**
hints; the formula key (and therefore the resource identity) is
unchanged.

## Why this matters

- **No state migration.** Pet stores already contained formula keys
  (then called formula identifiers); the locator format change is
  invisible to them.
- **Hints stay fresh.** Long-stored locators never become unreachable
  because their hints are looked up at presentation, not frozen at
  capture.
- **Identity is stable across hint changes.** A pet name continues to
  refer to the same formula even if the peer's transport address
  changes — the formula key did not change.

This is the same **typed-shape-in / typed-shape-out, formatting at the
edges** discipline as
[[endo-but-for-bots--llm-designs-rpn--rpn-string-notation]] (producers
own the typed shape, consumers own rendering): the formula key is the
typed shape, the locator is the rendered form, and dehydration is the
mirror of that — capture the typed shape, discard the rendering.

See also
[[endo-but-for-bots--llm-designs-dlt--locator-format-evolution]] for
the URL format that carries the hints, and
[[endo-but-for-bots--llm-designs-dlt--method-additions]] for the
`locate` / `locateWithHints` split that surfaces this discipline at
the API boundary.
