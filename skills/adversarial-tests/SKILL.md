---
created: 2026-05-13
updated: 2026-06-24
author: gardener
---

# Skill: adversarial-tests

The saboteur's canonical brainstorming list of invariant attacks. Walk it per
invariant the module claims; skip categories that genuinely do not apply;
default to "include" when uncertain. Consumed by the assayer and builder script
steps, and by the saboteur jury seat in the scripted code panel.

## When to use

- The saboteur seat runs this play on every code-panel pass (see
  [panel](../panel/SKILL.md)). Its
  findings ride in the panel's aggregated verdict.
- The test-writing variant (maintainer-requested "stress-test the invariants on
  `<module>`", routed as a `build`/`test` job a gardener claims) walks the same
  list and produces test files.
- A juror seat drawing on the security or correctness perspective (typically the
  locksmith or assessor) consults the list for adversarial inputs the regular
  review surface would miss.

## The brainstorming list

### Boundary

- Empty input (`""`, `[]`, `{}`, `new Map()`, `new Set()`).
- One element where the implementation might assume zero or many.
- Off-by-one at indexed limits (`length`, `length - 1`, `length + 1`).
- The exact bucket boundary in any range coverage (`2 ** 31`, `2 ** 31 + 1`,
  `2 ** 32`, `2 ** 53`, `Number.MAX_SAFE_INTEGER`).
- Sentinel values (`-0`, `+0`, `NaN`, `Infinity`, `-Infinity`).

### Type confusion

- A `BigInt` where a `Number` is expected (and vice versa).
- `undefined` vs missing argument vs explicit `null`.
- A `Symbol` as a key, value, or argument.
- A `Proxy` standing in for a "plain" object.
- A frozen object where the implementation assumes it can set a property.
- A class instance where `Object.create(null)` is expected, or vice versa.
- A passable that is also somehow callable (a function that has been hardened
  and given a non-function `passStyle`).

### Adversarial values

- A `Proxy` whose getter throws on property access.
- A `Proxy` whose getter returns a different value each time (non-idempotent).
- An iterator that throws on `next()` after the first call.
- A `document.all`-like value: `typeof x === 'undefined'` is true but
  `x !== undefined` is true.
- An object whose `toString`, `valueOf`, or `Symbol.toPrimitive` throws.
- A circular structure where the implementation walks recursively.
- A string that is not well-formed UTF-16 (`'\uD800'` alone).
- A value whose `constructor` property is an accessor whose getter throws.

### Reentrancy and ordering

- A callback that re-enters the function it was called from.
- A promise that resolves synchronously (which JS forbids, but a user-supplied
  `then` can simulate).
- An `async` callback that the implementation forgets to `await`.
- An init step that the caller skipped or reordered.
- Lookup before write, write after revocation, send after cancel: invariants
  that depend on ordering.

### SES-specific

- A hardened input that the implementation tries to mutate.
- An object created in a child compartment whose prototype the implementation
  expects to be the start compartment's prototype.
- A `passStyleOf` claim against a compartment-bound value.
- Behavior under `--feral-errors` versus default lockdown taming, when the test
  depends on stack visibility.

### Timing and state

- Two parallel invocations against shared state. Even if the module is
  single-threaded, async resolution order can reorder operations.
- Cancellation while an operation is in flight.
- A `Promise.race` that never settles, paired with a finalizer.

## How to write the test (test-writing variant)

Each adversarial test should:

1. **Name the invariant being attacked.** "rejects a Proxy whose getter throws
   on .length" beats "edge case 4".
2. **State the attack in a comment** in one sentence.
3. **Assert the specific failure mode** the module claims: throws a particular
   error class with a particular message, or rejects with a particular reason.
   Do not let `t.throws` catch any error; pin the class and message regex.
4. **Treat a non-failure as evidence.** If the module gracefully handles the
   gotcha, the test ships as defensive coverage that prevents future regression.
   If the module fails or behaves wrong, you have surfaced a bug, not a test;
   file it separately and do not silently fix it inside the test commit.

## How to surface the finding (review variant)

Each attack produces one finding line in the saboteur seat's slot of the panel
report:

- The invariant attacked, in one sentence.
- The attack (one sentence).
- The verdict: real concern (must-fix or should-fix), mitigated (defensive
  coverage worth pinning later), or out of scope (the module does not claim the
  invariant).
- If real concern: the `file:line` the attack targets.

The saboteur's lines fold into the aggregated panel verdict per
[panel](../panel/SKILL.md).

## Pitfalls

- **The category is endless.** Stop when the next gotcha would test a property
  the module does not claim. The goal is to cover the *invariants the module
  asserts*.
- **Tests that pass without exercising the code.** A `t.throwsAsync` against a
  non-existent method passes for the wrong reason. Confirm the exception came
  from the intended throw site by pinning the message regex.
- **Snapshot tests on adversarial output.** Pretty-printers in test runners can
  crash on iterator prototypes and the like. Use explicit identity or message
  checks rather than snapshots.
- **Tests written from the implementation, not the contract.** An adversarial
  test should be readable against the module's documented contract alone. If the
  test only makes sense to someone who has read the implementation, it is a unit
  test, not an invariant test.
- **Stuffing every gotcha in one file.** Group by invariant; one test file per
  invariant cluster keeps failure messages focused.

## Notes from the field

- _2026-05-13_: adopted from a reference garden. The brainstorming list itself
  is project-agnostic; the SES-specific subsection is opt-in.
- _2026-06-24_: migrated into v2. Rewired the saboteur consumption from "the
  judge-dispatched panel pass" to the scripted [panel] run a gardener
  supervises; the test-writing variant is a job a gardener claims, not a steward
  `Agent` dispatch.
