---
created: 2026-09-17
updated: 2026-09-17
author: builder (gardener, job review-improve-incomplete-sibling-transformation)
---

# Skill: sibling-family-sweep

When a change **generalizes an operation across a family of sibling call sites**,
enumerate every sibling of the operation and verify each one was converted before
pushing. This is the doing-side discipline for the `incomplete-sibling-transformation`
review-miss cluster (correctness-bug; grounding `endojs/endo-but-for-bots` #475 and
#1099): a commit that spreads one operation across N sibling sites converts some and
silently skips — or diverges on — others, and a skipped sibling carrying a live latent
bug reaches the maintainer.

It is the dual of [rename-discipline](../rename-discipline/SKILL.md): rename-discipline
keeps *gratuitous* edits out of a family; this skill keeps a *warranted* family edit
from being applied incompletely. Where rename-discipline says "do not touch the siblings
you were not asked to," this says "when you touch one sibling on purpose, touch — or
consciously clear — all of them."

## When it applies

The trigger is a change whose logic is **replicated across more than one site that
jointly maintains one invariant or shares one dispatch shape**. Concrete families,
each a worked example from the cluster:

- **Twin packages.** `packages/hex` and `packages/base64` are byte-codec twins with
  parallel `src/encode.js` / `src/decode.js`. On #1099, `hex/src/encode.js` gated its
  native `toHex` path on `bytes.buffer.immutable !== true` while the committed-correct
  twin `base64/src/encode.js` already dispatched on `ArrayBuffer.isView(bytes)` — the
  same operation, two different predicates, one of them wrong (issue #573; fixed by
  `331dfdfae2`).
- **Duplicated helper copies.** `packages/harden/make-hardener.js` and
  `packages/ses/src/make-hardener.js` are two copies of one hardener. On #1099, the
  harden copy was refactored to gate on `isMutableTypedArray` while the ses copy still
  gated `freezeTypedArray` on `isTypedArray` — the generalization landed in one copy
  only (reconciled by `c88c7e0f91`). This one was caught only by the maintainer asking
  "scan this PR for this kind of inconsistency."
- **Paired constructors maintaining one invariant.** In
  `packages/immutable-arraybuffer/src/lib.js`, the DataView and TypedArray emulation
  constructors both maintain the reverse buffer-map invariant. On #475 one constructor
  established the map and its sibling did not, until `4dbe5ffff` "pair buffer maps at
  creation" made both do it together.
- **Any N sites that share one dispatch shape or jointly hold one invariant** — a
  switch replicated across parsers, a guard replicated across facets, a codec pair,
  a shim installed twice.

## The rule

Before pushing a change that generalizes an operation across siblings:

1. **Enumerate the family.** Name every sibling site of the operation you touched —
   the other package in the twin, the other copy of the helper, every constructor or
   facet that maintains the same invariant. `git grep` the operation's identifiers and
   the old and new dispatch predicates across the whole repo, not just the file you
   started in.
2. **Verify each was converted, or consciously clear it.** For every sibling, confirm
   it now uses the same generalized shape, or record — in the commit message or the PR
   body — why it legitimately does not (the sibling is genuinely different, or its
   conversion is a separate PR). "I forgot it existed" is the failure this skill exists
   to prevent; "I decided not to touch it because X" is fine.
3. **Prefer to converge divergent siblings in the same PR.** When two twins diverge on
   the same operation, the reviewer should not have to hold both in their head to notice
   one is wrong. Land them consistent, or state the deferral explicitly.

## Relationship to the panel

The [breaker](../../roles/jurors/breaker/AGENT.md) jury seat carries the review-cycle
counterpart of this rule (its § Sibling-family enumeration finding), and the
`skills/panel-hints/probes/B-sibling-family.sh` probe fires the breaker whenever a diff
touches a member of a seeded sibling family, so the panel enumerates the family even
when the doer did not. This skill is the prevention; the probe-plus-seat is the sensing.
Both roles that author family-wide changes — the [builder](../../roles/builder/AGENT.md)
and the [fixer](../../roles/fixer/AGENT.md) — reference this skill from their operating
norms.

## Output

A change in which every sibling of a generalized operation is either converted or
explicitly, reasoned-out left alone — never silently skipped.
