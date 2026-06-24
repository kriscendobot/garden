---
section: weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
source: endo--packages-captp-src-finalize-js
topics: [captp, hardened-javascript, capability-security]
status: current
title: The §Far-as-the-protective-wrapper
parent: endo--packages-captp-src-finalize-js--weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
---

Both branches wrap the returned map in `Far('finalizingMap',
...)` or `Far('fakeFinalizingMap', ...)`. The §remotable-not-
bare-object discipline. The map can be passed via @endo/captp
to remote peers; without `Far`, it would not be transferable.

The §RemotableBrand-typing: the JSDoc return type includes
`& import('@endo/eventual-send').RemotableBrand<{}, FinalizingMap<K, V>>`.
The §typed-as-remotable-brand makes TypeScript know this is
also passable via E().
