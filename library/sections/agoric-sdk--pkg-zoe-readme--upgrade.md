---
title: Upgrade (prepare function + durability + kinds + crank rules)
source: packages/zoe/README.md
source_repo: agoric/agoric-sdk
source_commit: 940d3f0a993ca45a6bb0893bd59e6df1f22d9143
source_date: 2024-07-03
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [exo, bundles, capability-security, persistence]
status: current
notes: The upgrade-contract flow is structurally similar to SwingSet's vat-upgrade flow (per the doc's link to `packages/SwingSet/docs/vat-upgrade.md`). The single-crank rule for `prepare` in later incarnations is a SwingSet-kernel correctness invariant: it allows the kernel to deliver queued inbound messages safely without having to distinguish "needed for upgrade" from "new work". Cross-cuts with bundles (the new source code is identified by a bundleID), exo (the contract uses prepareExo / prepareExoClass for its remotables), and the "null upgrade" pattern (re-use the same bundle to clear accumulated state) is a legitimate use.
---

> Abstract: A contract instance can be upgraded to a new source-code bundle via `E(instanceAdminFacet).upgradeContract(newBundleID)`. "Null upgrade" (re-use the original bundle) is valid and is the canonical pattern for clearing accumulated state. **Four requirements** for upgradable contracts: (1) **Export**: replace `start` with `prepare` — called by `startInstance` for the first incarnation and `restartContract`/`upgradeContract` for subsequent ones; (2) **Durability**: anything that must survive a re-incarnation must live in durable storage; (3) **Kinds**: must be defined (via `prepareExoClass` etc.) before durable-storage deserialization; (4) **Crank**: in the first incarnation `prepare` may return a multi-crank promise; in later incarnations it must settle in **one crank** because the kernel can't distinguish messages needed for upgrade from messages that should be delayed. Includes a worked v1→v2 example with `codeVersion` baggage tracking and `prepareExoClass` for the upgraded `Counter` interface.

## Upgrade

A contract instance can be upgraded to use a new source code bundle in a process that is very similar to
[upgrading a vat](https://github.com/Agoric/agoric-sdk/blob/master/packages/SwingSet/docs/vat-upgrade.md).

The upgrade process is triggered through the "adminFacet" of the instance, and requires specifying the new source code. (Note that a "null upgrade" that re-uses the original bundle is valid, and a legitimate approach to deleting accumulated state).

```js
const results = E(instanceAdminFacet).upgradeContract(newBundleID);
```

This will replace the behavior of the existing instance with that defined in the new bundle. The new behavior is an additional _incarnation_ of the instance. Most state from the old incarnation is discarded, however "durable" collections are retained for use by its replacement.

There are a few requirements for the contract that differ from non-upgradable contracts:
1. Export
2. Durability
3. Kinds
4. Crank

### Export

The new bundle must export a `prepare` function in place of `start`. This is called by `startInstance` for the first incarnation and again by `restartContract` or `upgradeContract` for subsequent incarnations.

For example, suppose v1 code of a simple single-increment-counter contract anticipated extension of exported functionality and decided to track it by means of "codeVersion" data in baggage. v2 code could add multi-increment behavior like so:

```js
import { q, Fail } from '@endo/errors';
import { M } from '@endo/patterns';
import { prepareExo, prepareExoClass } from '@agoric/vat-data';

export const start = async (zcf, _privateArgs, instanceBaggage) => {
  const CODE_VERSION = 2;
  const isFirstIncarnation = !instanceBaggage.has('codeVersion');
  if (isFirstIncarnation) {
    // It is valid to instantiate from v2 code directly.
    instanceBaggage.init('codeVersion', CODE_VERSION);
  } else {
    const previousVersion = instanceBaggage.get('codeVersion');
    previousVersion <= CODE_VERSION ||
      Fail`Cannot downgrade to codeVersion ${q(CODE_VERSION)} from ${q(previousVersion)}`;
    instanceBaggage.set('codeVersion', CODE_VERSION);
  }

  const CounterI = M.interface('Counter', {
    // v1 code used `M.call().returns(M.bigint())`,
    // which v2 extends to include an optional `incrementBy` bigint argument.
    increment: M.call().optional(M.bigint()).returns(M.bigint()),
    read: M.call().returns(M.bigint()),
  });
  const initCounterState = () => ({ value: 0n });
  const makeCounter = prepareExoClass(
    instanceBaggage,
    'Counter',
    CounterI,
    initCounterState,
    {
      // v1 code used `increment() { return this.state.value += 1n; }`.
      increment(incrementBy = 1n) {
        incrementBy > 0n || Fail`increment must be positive`;
        return this.state.value += incrementBy;
      },
      read() { return this.state.value; },
    },
  );

  const CreatorI = M.interface('CounterExample', {
    makeCounter: M.call().returns(M.remotable('Counter')),
  });
  const creatorFacet = prepareExo(
    instanceBaggage,
    'creatorFacet',
    CreatorI,
    { makeCounter },
  );
  return harden({ creatorFacet });
};
harden(start);
```

For an example contract upgrade, see the test at https://github.com/Agoric/agoric-sdk/blob/master/packages/zoe/test/swingsetTests/upgradeCoveredCall/test-coveredCall-service-upgrade.js .

### Durability

The contract must retain in durable storage anything that must persist between incarnations. All other state will be lost.

### Kinds

The contract defines the kinds that are held in durable storage. Thus the function calls that define the kinds must be run before the objects are deserialized from durable storage.

# Crank

For the first incarnation, `prepare` is allowed to return a promise that takes more than one crank to settle
(e.g., because it depends upon the results of remote calls).
But in later incarnations, `prepare` must settle in one crank.
Therefore such necessary values should be stashed in the baggage by earlier incarnations.
The `provideAll` function in contract support is designed to support this.

The reason is that all vats must be able to finish their upgrade without
contacting other vats. There might be messages queued inbound to the vat being
upgraded, and the kernel safely deliver those messages until the upgrade is
complete. The kernel can't tell which external messages are needed for upgrade,
vs which are new work that need to be delayed until upgrade is finished, so the
rule is that buildRootObject() must be standalone.

Source: [packages/zoe/README.md](https://github.com/Agoric/agoric-sdk/blob/940d3f0a993ca45a6bb0893bd59e6df1f22d9143/packages/zoe/README.md) at commit `940d3f0a`.
