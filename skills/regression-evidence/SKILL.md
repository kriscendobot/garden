---
created: 2026-05-13
updated: 2026-06-24
author: gardener
---

# Skill: regression-evidence

Adopted from `references/endo-but-for-bots/skills/regression-evidence.md`.

Every new test should be proven load-bearing by demonstrating that it fails when the code path it exercises is broken. A test that passes whether or not the implementation is correct is not a regression test.

The same discipline extends to any claim of equivalence the code, comments, or docs make; see *Equivalence claims need a backing test* below.

This discipline is **consumed by the `prover` jury seat** (the scripted code panel runs `roles/jurors/prover/AGENT.md` over the diff and expects each new test to carry regression evidence) and by the builder/assayer steps of the gardening state machine (`scripts/jobs/gardening/garden-pr.sh`), which run the evaluation suite and check that new tests are substantiated before the PR submits to CI. When a `build` job's tests lack regression evidence, the prover seat surfaces it as a panel finding and the panel's fixer loop (`../panel/SKILL.md`) regenerates the evidence.

## Procedure

After committing a new test:

1. Temporarily break the smallest unit of the code path the test covers. Examples:
   - For a new lint rule, comment out a branch and confirm an `invalid` fixture fires differently.
   - For a new visitor, mis-assign one intrinsic and confirm the test fails with a clear name.
   - For a new diagnostic, remove the new check and confirm the test fails with the old cryptic error.
2. Run the test. It must fail with a recognizable message.
3. Revert the temporary break (`git stash pop` is cleanest).
4. Run the test again. It must pass.
5. Cite the experiment in the PR body or summary as "regression-test note": describe the break, the observed failure, and the revert.

## Why

This catches three classes of mistake:

- A test asserting something already trivially true (e.g. reflexive identity) that never exercises the new code path.
- A test that depends on a side effect of another test, so removing the new code makes the *other* test fail first.
- A test that uses a fixture covering a pattern the new code doesn't actually handle.

## Pitfalls

- **Make the temporary break small and reversible.** `git stash` before the change makes revert mechanical.
- **Property-based tests** need a different demonstration: shrink the property to deterministically exercise the boundary, or seed the generator.
- **"Existing test already covers this area" is not regression-tested.** Async iterators have several teardown shapes (resolution-done, resolution-not-done from a sink intending to stay open, rejection mid-stream, upstream-driven `throw`). A test exercising one shape will not catch a regression on another. When borrowing an existing test as regression posture, name which shape it covers and confirm the fix's failure mode matches.

## Equivalence claims need a backing test

When a code comment, JSDoc, README, or commit message claims that one form is "equivalent to" another (`random()` returns `randomUint53(source) * 2 ** -53`; the IETF nonce convention is "equivalent to" the DJB 8-byte form at counter 0; the new helper produces the "same bytes" as the prior inlined version), that claim is a load-bearing contract whether the author intended it or not. A future contributor will read the claim and rely on it.

An equivalence claim with no backing assertion drifts. Either side can change in a refactor and the claim becomes silently false, with no test to fail.

The discipline:

1. State the equivalence as a test: pick a small input (or a deterministic seed if randomness is involved), compute both sides, assert they match by the strongest available comparator (`t.is` for primitives, `t.deepEqual` for byte arrays, a fixed golden vector for very large outputs).
2. Run it against the current implementation to confirm the equivalence actually holds. If it does not, the comment was wrong; correct the comment and the test together.
3. Run the regression check from the section above: break one side, confirm the equivalence test fails, revert.

The output of the equivalence test is the same kind of artifact as a regression test. Both prove a claim the prose alone could not.

## Output shape

A "regression-test note" line in the PR body (or in the builder's gardening-step summary), naming: the break introduced, the observed failure message, and the revert. The note is what the `prover` seat reads to confirm the evidence exists; absence of the note is itself a panel finding.

## Notes from the field

- _2026-05-13_: adopted from the reference. Per-PR session lore lives in the journal.
- _2026-05-14_: the *Equivalence claims* section was prompted by kriskowal's review of [endojs/endo#3232](https://github.com/endojs/endo/pull/3232), comment [3239085874](https://github.com/endojs/endo/pull/3232#discussion_r3239085874) on a JSDoc line claiming `random()` was equivalent to `readU53() * POW2_M53`: "Let's add an assertion to the test suite to make sure this equivalence sticks."
- _2026-06-24_: migrated into v2. The discipline is unchanged; the consumer changed from a dispatched judge's jury to the scripted code panel's `prover` seat and the builder/assayer gardening-script steps.
