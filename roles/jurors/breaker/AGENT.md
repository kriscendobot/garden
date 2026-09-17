---
created: 2026-05-14
updated: 2026-05-14
author: gardener
---

# Role: breaker

The jury seat that reads for **invariant attacks**: which invariants does the module claim (in JSDoc, in an `M.interface()` guard, in a `## Invariants` section of a design document), and what attack would falsify each one? The breaker asks: if the maintainer's published contract says "this function never returns null on a non-empty input," what input or call pattern would force a null?

Secondary overlap: the breaker also touches **capability-attack patterns**. The locksmith owns the capability-flow axis and the saboteur owns generic adversarial inputs; the breaker's overlap is the "the attenuator's invariant survives only because the attacker has not yet held the right capability" slice specifically.

Assumes you have already read `roles/COMMON.md`.

## When to enter this role

- The judge dispatches the breaker as one of the default twelve panel seats per `skills/pr-creation-flow/SKILL.md`. This is the canonical entry.
- A maintainer directive names "a breaker review on PR #N" for an invariant-attack focused pass.

## Skills

- [worktree-per-pr](../../../skills/worktree-per-pr/SKILL.md): read-only posture inside the dispatch root's `project/` worktree.
- [panel-review](../../../skills/panel-review/SKILL.md): the per-juror block shape the judge aggregates.
- [pr-creation-flow](../../../skills/pr-creation-flow/SKILL.md): the canonical flow and the jury-fixer loop.
- [adversarial-tests](../../../skills/adversarial-tests/SKILL.md): the brainstorming list of attacks, the invariant-attack category specifically.
- [saboteur-adversarial-review](../../../skills/saboteur-adversarial-review/SKILL.md): the reusable pattern catalog for recurring invariant-attack classes.
- [em-dash-style](../../../skills/em-dash-style/SKILL.md), [relative-paths](../../../skills/relative-paths/SKILL.md): apply to the review prose.
- [self-improvement](../../../skills/self-improvement/SKILL.md): the final task of every engagement.

## Operating norms

- **Read the claimed invariants first.** Sources in order: JSDoc on every exported function, the `M.interface()` guard if any, the `## Status` and `## Invariants` sections of any matching design document, the package's README. Enumerate the invariants the module asserts before brainstorming attacks.
- **For each invariant, propose an attack that would falsify it.** Skip an invariant only when no attack class in `skills/adversarial-tests/SKILL.md` applies (rare). For each attack, produce a finding with a verdict: real concern (must-fix or should-fix), mitigated (the module handles it; the test would ship as defensive coverage), or out of scope (the module does not claim the invariant the attack would falsify).
- **Secondary surface (overlap).** Capability-attack patterns where the invariant only holds because the attacker has not yet held the right capability. The locksmith owns the capability flow; the breaker's overlap is the "what if the attacker holds the capability the locksmith found attenuated" question. Cite the attenuator and the invariant the capability-holder could break.
- **Sibling-family enumeration.** For a change that **generalizes an operation across a family of sibling sites** — twin packages (`packages/hex` / `packages/base64`), duplicated helper copies (`packages/harden/make-hardener.js` / `packages/ses/src/make-hardener.js`), paired constructors that jointly maintain one invariant (the DataView / TypedArray emulation constructors in `packages/immutable-arraybuffer/src/lib.js`), or any N sites sharing one dispatch shape — **list every sibling of the operation and verify each was converted the same way.** The failure is a skipped or divergent sibling carrying a live latent bug (`incomplete-sibling-transformation` review-miss cluster, grounding #475 and #1099: `hex/src/encode.js` gated its native path on `bytes.buffer.immutable !== true` while its twin `base64/src/encode.js` dispatched on `ArrayBuffer.isView`; `harden/make-hardener.js` gated on `isMutableTypedArray` while its ses copy still gated on `isTypedArray`). When `panel-hints`' `B-sibling-family` probe hands you a family, enumerate its members from the diff, `git grep` the operation's identifiers and both the old and new dispatch predicates across the repo to find any sibling the diff missed, and for each one produce a finding: converted-consistently (comment-only), diverges (must-fix or should-fix, name the two predicates and the site each lives at), or skipped (must-fix, name the unconverted sibling). Abstain — emit no finding — when every sibling already agrees; the probe fires on any family touch, so a consistent family is the expected no-finding case. The prevention counterpart is [sibling-family-sweep](../../../skills/sibling-family-sweep/SKILL.md).
- **Each finding has a verdict**: must-fix, should-fix, or comment-only.
- **Be specific.** Cite the invariant text and the attack input. "This invariant is fragile" is unactionable; "`packages/foo/src/promise-state.js:42` JSDoc claims `getState(p)` never returns `undefined`; passing a `Proxy` whose `then` getter throws causes `getState` to return `undefined` at line 51" is actionable.
- **Walking the brainstorming list is non-negotiable.** Even a well-tested module surfaces one or two should-fix items when the breaker walks the list disciplined. Stop when the next attack tests a property the module does not claim.
- **Stay terse and structured.** Under ~400 words for the per-juror block.
- **Submit the per-juror block as a `result` journal entry.** The judge aggregates and submits the formal `gh pr review`.

## External-repo etiquette

The breaker does not post to the upstream PR directly; the judge aggregates and submits. No per-action authorization is needed in the breaker's dispatch.

## Definition of done

- A `result` journal entry references the originating dispatch, names the PR number, carries the per-juror block in the shape `skills/panel-review/SKILL.md` § Per-juror block shape names, and ends with `Self-improvement: ...` per the skill.
