---
role: designer
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repository: https://github.com/endojs/endo-but-for-bots

# Document the Justin subset of JavaScript in `docs/`, and lock down the dialect that expresses `pass-style`

**Maintainer directive (kriskowal, 2026-08-11):** write up a document in `docs/`
capturing the definition of the **Justin** subset of JavaScript, sourced mainly from
the grammar at https://github.com/agoric-labs/jessica#grammar. The pull request is
where we lock down the **exact Justin dialect that expresses `endo/pass-style`** —
so the PR discussion is part of the deliverable, not an afterthought.

## Base — upstream-destined, frozen snapshot

Branch from a **frozen `master-<sha>` snapshot**, NOT from `llm`. This is
upstream-`endojs/endo` material: `docs/` is upstream's tree, and per CLAUDE.md and
`roles/conductor/AGENT.md` this repo's `master` is **ferry-only — never merge into
`master` here.**

There is currently **no `master-*` branch in this repo** (verified 2026-08-11), so
cut one from the current upstream-tracking `master` tip and name it by its sha in the
established `<base>-<sha7>` convention. Record which sha you cut and why in the PR
body, so the ferry has an unambiguous provenance trail.

## THE CRITICAL CONSTRAINT — an implementation already exists

**Do not specify Justin from the grammar alone.** This repo already emits Justin:

    packages/marshal/src/marshal-justin.js        the renderer (decodeToJustin)
    packages/marshal/test/marshal-justin.test.js  its test suite

Read both **before** writing a line of the document. The deliverable is a
specification that is *reconciled with shipped behaviour*, not an idealized grammar
that silently disagrees with the code. Where the implementation and the jessica
grammar diverge, **say so explicitly** — name the construct, quote both, and mark it
as an open question for the PR rather than quietly picking a side. A divergence you
surface is worth far more than a tidy document that hides one.

## What the document must establish

1. **Where Justin sits.** The containment story — JSON ⊂ Justin ⊂ Jessie ⊂ JavaScript
   — stated precisely rather than gestured at. Justin is expression-only: no
   statements, no definitions. Be exact about what "expression-only" excludes.
2. **The grammar**, adapted from agoric-labs/jessica. Cite the upstream source and
   the commit/revision you read, since that grammar is not versioned in this repo and
   will drift.
3. **The pass-style correspondence — the point of the exercise.** For each
   `pass-style` category, give the Justin form that expresses it:
   - the passable atoms (undefined, null, boolean, number incl. `NaN`/`Infinity`/`-0`,
     bigint, string, symbol — the registered/well-known symbol handling matters)
   - `copyRecord`, `copyArray`, `tagged`
   - `remotable` and `promise` — these are the interesting ones, because they are
     *not* literal data; explain how a reference is denoted and what that means for
     round-tripping
   - `error`
   Cross-check every one against `packages/pass-style/src` and its `doc/`
   (`copyArray-guarantees.md`, `copyRecord-guarantees.md`,
   `enumerating-properties.md`), not just against intuition.
4. **What Justin deliberately cannot express**, and why that is a feature: no
   function definitions, no assignment, no side effects — the properties that make it
   safe to read a Justin expression as data.
5. **The evaluation story.** Justin is a *notation*; state plainly whether and how it
   is evaluated in this codebase, what authority an evaluator would need, and what
   the hazards are. If Justin text is ever evaluated, that is a capability question
   and belongs in the document.

## Scope discipline

- **Documentation only.** Do NOT change `marshal-justin.js` or any runtime code. If
  the reconciliation reveals an implementation bug, report it and propose a separate
  job — do not fix it in this PR.
- Place the document in `docs/` alongside `guide.md` / `reference.md`, and follow
  `docs/house-style`.
- Link it from wherever `docs/` indexes its pages, if such an index exists.
- Open the PR as a **DRAFT** against the frozen base and leave it draft. The whole
  point is that the maintainer locks the dialect in review; do not un-draft or merge.

## Report

Name the frozen base you cut and its sha, the document path, the PR URL, and — most
importantly — an explicit **list of every divergence you found between the jessica
grammar and `marshal-justin.js`**, plus any pass-style category whose Justin form you
could not determine from either source. Those are exactly the decisions the PR needs
from the maintainer.
