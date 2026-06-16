---
section: legacy-guard-tolerance-and-payload-extraction-at-three-granularities-with-method-key-introspection
source: endo--packages-patterns-src-patterns-getGuardPayloads-js
topics: [patterns, exo]
status: current
title: The §nine *TODO manually maintain correspondence* markers
parent: endo--packages-patterns-src-patterns-getGuardPayloads-js--legacy-guard-tolerance-and-payload-extraction-at-three-granularities-with-method-key-introspection
---

The file carries *seven* explicit `TODO manually maintain
correspondence with ...` markers, one per Legacy shape:

- `LegacyAwaitArgGuardShape` ↔ `AwaitArgGuardPayloadShape`
- `LegacySyncMethodGuardShape` ↔ `SyncMethodGuardPayloadShape`
- `LegacyArgGuardShape` ↔ `ArgGuardShape`
- `LegacyArgGuardListShape` ↔ `ArgGuardListShape`
- `LegacyAsyncMethodGuardShape` ↔ `AsyncMethodGuardPayloadShape`
- `LegacyMethodGuardShape` ↔ `MethodGuardPayloadShape`
- `LegacyInterfaceGuardShape` ↔ `InterfaceGuardPayloadShape`

Each TODO is *the canonical abstraction-debt-marker idiom* — the
correspondence must be maintained by hand because the legacy
shapes are frozen (callers may emit them); changes to the current
shapes don't automatically propagate. The *one-direction-frozen-
the-other-evolves* discipline.

The §one-place-the-correspondence-is-natural exception:
`LegacyRawGuardShape` doesn't exist. The §opening comment explains:

> *Unlike LegacyAwaitArgGuardShape, LegacyMethodGuardShape, and
> LegacyInterfaceGuardShape, there is no need for a
> LegacyRawGuardShape, because raw guards were introduced at PR
> #1831, which was merged well after PR #1712. Thus, there was
> never a `klass:` form of the raw guard.*

The *raw-guards-postdate-the-transition* observation. Cycle 118's
exo-tools.js section 1 covers the three sentinels including
`RawMethodGuard`; cycle 118 sees post-1712 raw guards directly,
without legacy translation.
