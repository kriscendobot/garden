---
title: Connection to the wider library
source: packages/patterns/src/keys/checkKey.js
source_repo: endojs/endo
source_branch: master
source_commit: beab78998642c19d9420ec5bc819a6545327fa5e
source_date: 2026-04-22
source_authors: [Turadg Aleahmad]
source_lines: "105-481 (CopySet + CopyBag + CopyMap sections including makeCopyBagFromElements, makeCopyMap, getCopyMapEntries Far iterator, copyMapKeySet shortcut)"
topics: [hardened-javascript, patterns]
status: current
notes: |
  The three-collection extension surface of @endo/patterns/keys.
  Three structural ideas: (1) the §Confirm/Is/Assert trio pattern
  (introduced in the previous section) is *uniformly applied* to
  CopySet, CopyBag, and CopyMap — each gets its own memo WeakSet,
  confirm/is/assert trio, and structural-payload validation; (2) the
  §makeCopyBagFromElements algorithm is a worked example of
  *sort-then-adjacent-counting* (sortByRank + while-equal-advance),
  with explicit *history-dependent state ... does not survive*
  warning for the fullCompare; (3) the §makeCopyMap algorithm uses
  *reverse rank sorting* via compareAntiRank to colocate keys with
  values, including an honest TODO about the *copyMap cover issue
  in patternMatchers.js* that depends on additional validation.
  The §`getCopyMapEntries` returning a `Far(iterable)` exotic
  rather than an array is the *lazy-iteration-with-immutability*
  discipline. The §`copyMapKeySet` is the *internal-form-shortcut*
  — a copyMap's keys are *already* in copySet's internal form, so
  the conversion is a tag-wrap-only operation with no
  re-validation.
parent: endo--packages-patterns-src-keys-checkKey-js--copyset-copybag-copymap-extensions-and-special-case-algorithms
---

This section is the **canonical *one-pattern-three-uniform-applications* worked example**. Four threads:

1. **The uniform Confirm/Is/Assert + memo + structural-payload-validation across CopySet/CopyBag/CopyMap** is reusable for any *tagged-collection-family* validation surface. Each collection adds its own structural-payload check while sharing the trio + memo discipline.

2. **The sort-then-adjacent-counting algorithm** (`makeCopyBagFromElements`) is reusable for any *multiplicity-counting from unsorted input* problem. The §history-dependent-state-call-local discipline is the safe form when the sort needs ordering beyond rank.

3. **The Far iterator (`getCopyMapEntries`) vs hardened array (`getCopyMapEntryArray`) dual-API** is the canonical *offer-both-eager-and-lazy-shapes* discipline. The consumer picks based on access pattern.

4. **The internal-form-shortcut (`copyMapKeySet`)** is the *shared-representation-tag-rewrite* idiom. When two related types share an internal form, the conversion is a tag-rewrite rather than a structural copy.

The §five-layer copyMap validation (tag + payload-is-record + only-keys-and-values + keys-validity + values-shape-and-length) is a worked example of the *layered-invariant-check with most-specific-diagnostic-first* discipline.
