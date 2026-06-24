---
title: Translation block (comment idiom → contemporary practice)
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

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| `Moved to here so they can check that the copySet contains only keys without creating an import cycle` | The *break-import-cycle-by-relocation* discipline; place the cross-cutting predicate where neither sibling needs to import the other. |
| Uniform Confirm/Is/Assert trio across three collections | The *one-pattern-uniformly-applied* discipline. |
| `This fullOrder contains history dependent state. It is specific to this one call and does not survive it.` | The *transient-state-call-local* discipline; build it fresh, discard after use. |
| `sort + adjacent-equality count` in makeCopyBagFromElements | The *multiplicity-counting via sort* algorithm. |
| `BigInt(j - i)` count | The *bigint-multiplicities* discipline; arbitrarily-large counts without floating-point precision loss. |
| `ownKeys(rest).length === 0` after destructuring | The *strict-record-no-extra-properties* invariant. |
| `Far('CopyMap entries iterable', ...)` exotic iterator | The *capability-conformant iterator* discipline; iterators are Far-exotics not plain objects. |
| `harden({ done, value })` per-step | The *every-yielded-value-hardened* discipline. |
| `getCopyMapEntryArray` (eager) vs `getCopyMapEntries` (lazy) dual API | The *offer-both-shapes* dual-API discipline. |
| `reverse rank sorting ... is a good first step` (`makeCopyMap`) | The *colocate-rank-tied-with-sub-sort* algorithm. |
| `TODO ... if we include this criteria in our validation of copyMaps, which we currently do not` | The *honest-known-limit-with-dependency-named* TODO discipline. |
| `A copyMap's keys are already in the internal form used by copySets` (`copyMapKeySet`) | The *shared-internal-form-tag-rewrite* shortcut. |
