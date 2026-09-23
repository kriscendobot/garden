---
ts: 2026-06-15T06:05:40Z
kind: result
role: investigator
repo: kriscendobot/agoric-sdk
project: agoric-sdk
refs:
  - entries/2026/06/15/055900Z-dispatch-investigator-582439.md
---

# Investigator: PR #5 `any`-cast review questions

Maintainer kriskowal asked three inline review questions on kriscendobot/agoric-sdk PR #5
(`chore(deps): mirror Agoric/agoric-sdk#12527 (Endo sync) on current master`,
head `b0c0d727`, base `master-57c6564`), centered on whether the `any` widenings introduced
under `packages/async-flow/` can be replaced with hand-written specific types to break the
TS cycles, and whether the call-site mismatch at `endowments.js:233` reveals a defect. The
maintainer's last sentence ("answer this question for every applicable case in this change")
required an enumeration of all applicable cases, not just the three locations cited.

## Enumeration of cycle-breaking `@typedef {any}` additions

Sweep over `git diff origin/master-57c6564..HEAD` produced exactly two cycle-breaking
typedef changes:

1. `packages/async-flow/src/bijection.js:215`: `@typedef {any} Bijection` (replacing
   `ReturnType<ReturnType<typeof prepareBijection>>`).
2. `packages/async-flow/src/log-store.js:278`: `@typedef {any} LogStore` (replacing
   `ReturnType<ReturnType<typeof prepareLogStore>>`).

No other cycle-breaking `@typedef {any}` declarations are added by the PR. The many other
`@ts-expect-error` and `as any` additions across the diff (in `async-flow.js`, `endowments.js`,
`vat-bank.js`, `cosmic-swingset`, governance tests, smart-wallet, and others) are call-site
narrowings against stricter `@endo/exo` / `@endo/pass-style` / `@endo/eventual-send` guards
rather than circular-type-alias breaks. They are out of scope for the "duplicate the type vs
fall through to `any`" question, but I addressed them in the reply summary by recommending an
Endo-upgrade hygiene follow-up rather than per-call-site fixes.

## Per-case analysis

### `LogStore` (log-store.js:278)

- **Cycle:** `prepareLogStore`'s body annotates `Ephemera<LogStore, {…}>` on line 75, so
  `typeof prepareLogStore` recursively references `LogStore`. With stricter `@endo/exo` guard
  inference the recursion is load-bearing (TS2456) rather than collapsing through `any`.
- **Locally useful shape:** the consumer-side surface enumerated by `LogStoreI` (13 methods:
  `reset`, `dispose`, `getUnfilteredIndex`, `getIndex`, `getLength`, `isReplaying`,
  `peekEntry`, `nextEntry`, `nextUnfilteredEntry`, `pushEntry`, `dumpUnfiltered`, `dump`,
  `promiseReplayDone`). `LogEntry` is already imported on line 11.
- **Recommendation:** duplicate. The hand-written shape has no `typeof prepareLogStore`
  reference so the cycle breaks structurally. `LogStoreI` is the existing source of truth for
  the method enumeration so drift is straightforward to detect.

### `Bijection` (bijection.js:215)

- **Cycle:** `prepareBijection`'s body annotates `Ephemera<Bijection, VowishStore>` on lines
  116 and 118; same recursion shape as `LogStore`.
- **Locally useful shape:** the consumer-side surface enumerated by `BijectionI` (7 methods:
  `reset`, `unwrapInit`, `hasGuest`, `hasHost`, `has`, `guestToHost`, `hostToGuest`).
  `PassableCap` and `Vow` are already imported on lines 8 and 10.
- **Recommendation:** duplicate, same reasoning as `LogStore`. Replies recommend folding both
  into a single follow-up commit (on this PR or a small successor).

### Defect verdict on endowments.js:233

The `@ts-expect-error` at `endowments.js:233` (the `case 'state':` branch of
`prepareEndowment`) is **not a defect**. The runtime guard `StateAccessorI`'s shape
(`get: M.call(PropertyKeyShape).returns(M.any())`, `set: M.call(PropertyKeyShape, M.any()).returns()`)
exactly matches the implementation methods (`get(key) { return state[key]; }`,
`set(key, newValue) { state[key] = newValue; }`). The runtime guard will accept exactly the
keys the implementation accepts and the implementation operates on exactly the values the
guard advertises.

The TypeScript error is upstream-side: stricter `@endo/exo` `defineExo` / `exo` overloads
derive their methods-record parameter type from the `InterfaceGuard` more precisely than
before, and the inference walks through `Record<PropertyKey, unknown>` in a way that doesn't
satisfy the Endo guard's exact `(key: PropertyKey, value: any) => any` shape. The mismatch
is in what TypeScript synthesizes for the methods record, not in runtime behavior. The same
analysis applies to the other `stricter @endo/exo exoClass overload signatures` sites
(`async-flow.js` and the rest across the PR): all the same pattern, none a runtime defect.

## Recommendations

- **`LogStore` + `Bijection` typedef cycle-break:** worth landing as a small follow-up
  commit on PR #5 (or a tiny successor) that replaces both `@typedef {any}` with the
  hand-written `@typedef {object}` shapes. The shapes are stable and small; the runtime guard
  interfaces already enumerate them.
- **Other `@ts-expect-error` call-site narrowings:** track as Endo-upgrade hygiene, separate
  from PR #5. The right fix shape differs per call site (tightened Endo guard, explicit cast,
  runtime invariant) and the volume is too large for this PR.
- **`endowments.js:233`:** no fix warranted; keep `@ts-expect-error` as a paper trail.

## Posted replies

Three inline-thread replies on kriscendobot/agoric-sdk PR #5:

- log-store.js:278: <https://github.com/kriscendobot/agoric-sdk/pull/5#discussion_r3411327956>
  (reply to comment 3409241261).
- bijection.js:215: <https://github.com/kriscendobot/agoric-sdk/pull/5#discussion_r3411330424>
  (reply to comment 3409243653).
- endowments.js:233: <https://github.com/kriscendobot/agoric-sdk/pull/5#discussion_r3411330498>
  (reply to comment 3409242289).

Each reply names the locally useful shape (or, for endowments.js, the no-defect verdict),
explains the cycle, and ties the broader enumeration claim back into the answer so the
maintainer's "for every applicable case" sentence is honored without each thread repeating it
at length.

## Next stage

`next: maintainer`. The investigator's deliverable is the analysis; the follow-up
(landing the hand-written `LogStore` + `Bijection` shapes) is a judgment call the maintainer
should make before any fixer is dispatched, since the alternative (keep `any`, ship the PR,
follow up separately) is defensible and the maintainer's review still has a pending
disposition on PR #5.

Self-improvement: nothing this time.
