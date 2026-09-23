---
section: weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
source: endo--packages-captp-src-finalize-js
topics: [captp, hardened-javascript, capability-security]
status: current
title: The §single most structurally interesting move — §gc-as-side-channel warning
parent: endo--packages-captp-src-finalize-js--weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
---

The JSDoc explicitly warns about the security hazard:

> *Unlike a WeakMap, a weak-value-map unavoidably exposes the
> non-determinism of gc to its clients. Thus, both the ability
> to create one, as well as each created one, must be treated
> as dangerous capabilities that must be closely held. A
> program with access to these can read side channels though
> gc that do not rely on the ability to measure duration. This
> is a separate, and bad, timing-independent side channel.*

The §timing-independent-side-channel observation: most side
channels need a clock (you measure *how long* something takes;
that reveals state). The §gc-side-channel is different — you
just *observe whether an entry still exists*; gc decisions
flow into program state without a clock at all.

The §closely-held-capability discipline: both the *factory*
(`makeFinalizingMap`) and each *map instance* are dangerous
capabilities. Distribute access narrowly.

The §blockchain-replay hazard escalation:

> *This non-determinism also enables code to escape
> deterministic replay. In a blockchain context, this could
> cause validators to differ from each other, preventing
> consensus, and thus preventing chain progress.*

The §nondeterminism-breaks-consensus observation: blockchain
validators *must* compute identical state transitions. If
their gc fires differently, their weak-value-maps differ, and
their state transitions diverge. The §gc-as-consensus-blocker
warning. The §deterministic-replay-as-consensus-requirement
property.

This warning is *load-bearing for the whole @endo/captp
package*: CapTP needs this primitive but the Agoric blockchain
context cannot afford it. The §primitive-exists-but-must-not-
be-used-in-some-contexts discipline: the file *provides* the
mechanism but *warns away* one class of consumer.
