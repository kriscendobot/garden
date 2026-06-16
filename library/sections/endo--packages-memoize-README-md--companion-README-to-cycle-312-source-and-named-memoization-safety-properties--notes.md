---
title: Notes
section-slug: endo--packages-memoize-README-md--companion-README-to-cycle-312-source-and-named-memoization-safety-properties
source-slug: endo--packages-memoize-README-md
url: https://github.com/endojs/endo/blob/master/packages/memoize/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/memoize/README.md
total-lines: 77
ingest-cycle: 313
ingest-date: 2026-06-11
lane: designs
scope: full
parent: endo--packages-memoize-README-md--companion-README-to-cycle-312-source-and-named-memoization-safety-properties
---

- The named-throws-vs-rejected-promises-asymmetry IS structurally interesting: most caching libraries treat both as "the call didn't return a usable value," but `@endo/memoize` deliberately distinguishes the *non-completion* of a throw from the *completion* of a returned-rejected-promise. The asymmetry IS principled: a thrown call has no return value; a returned-rejected-promise IS a returned value that happens to be a promise. **§the-named-principled-asymmetry-discipline**.
- The named-three-named-memoization-safety-properties (defensiveness + unobservable-memoization + isolation-preservation) IS the kind of terminology that becomes vocabulary across the @endo project. Naming creates a shared shorthand that subsequent design discussions can reference without re-explanation. **§the-named-vocabulary-creation-by-naming**.
- The named-source-TODO-and-README-pointer-pair-across-cycles (312 + 313) IS a worked example of how a TODO comment IS resolved over time. Cycle 312's source had `(TODO turn into link once there's a URL)`; the URL now exists and the README has the link. The source itself still carries the TODO comment — a stale-comment opportunity for a future improvement cycle.
- The named-pivot-IS-named-productive-four-cycles-in: with cycles 310-313 all sourcing from @endo/*, the named-deliberate-pivot has produced fresh patterns across four cycles. The cluster pattern surface IS fully refreshed.
