---
source: packages/pass-style/src/make-far.js
source_repo: endojs/endo
source_branch: master
source_commit: 57100aa08b210353454544577db1b8189aae698a
source_date: 2026-02-24
source_authors: [Kris Kowal]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Twenty-seventh comment-fragment ingest. 221-line file by Kris
  Kowal in commit `57100aa0` (cycles 108/110/115/118/123/125/132/
  134's `e56bf00f` is the broader coordinated-update cluster;
  this file's commit is the same wave, slightly different SHA).

  The *constructor* layer for remotables — direct companion to
  cycle 134's `remotable.js` (which *validates* what this file
  *constructs*). Three exports: Remotable / Far / ToFarFunction.
  Plus the GET_METHOD_NAMES = '__getMethodNames__' meta-method
  constant.

  Single most structurally interesting move: the §three-piece
  prefix-handling discipline. This file *produces* the
  `'Alleged: '` prefix in Far(); cycle 134's remotable.js
  *requires* it in confirmIface(); cycle 130's
  message-breakpoints.js *strips* it in simplifyTag(). The three
  files form a *prefix-produces / prefix-requires /
  prefix-strips* triad.

  §makeRemotableProto helper: creates a new prototype object
  with `PASS_STYLE = 'remotable'` and `@@toStringTag = iface` as
  own properties, inheriting from the *original* prototype.
  §strict-original-prototype invariant: object remotables must
  have originally inherited from objectPrototype; Far functions
  from functionPrototype (or one level above).

  §mutate-harden-check-twice fail-fast pattern: first call
  `mutateHardenAndCheck({})` with a *fresh empty object* (dry
  run) before mutating the real remotable. If the rules don't
  fit, the throwaway fails first — *the caller's remotable
  doesn't get mutated mid-failure*. The §dry-run-then-commit
  pattern.

  §already-frozen check uses §comparison-against-fresh discipline:
  `isFrozen(remotable) === isFrozen({})` not `!isFrozen(remotable)`
  — because *isFrozen always returns true when using lockdown
  with hardenTaming set to the deprecated 'unsafe' option*. The
  §pattern-for-detecting-environment-quirks: don't hard-code
  expected return values; compare against a fresh control sample.

  §Allegation-not-attestation discipline (the iface JSDoc):
  *currently, Alice can tell Bob about Carol, where VatA (on
  Alice's behalf) misrepresents Carol's `iface`. VatB and
  therefore Bob will then see Carol's `iface` as misrepresented
  by VatA*. The `'Alleged: '` prefix is the visible *reminder*
  that consumers must not over-trust the iface.

  §GET_METHOD_NAMES auto-method modeled on cycle 118's
  GET_INTERFACE_GUARD exo pattern. §HAZARD note: *Beware that an
  exo's interface can change across an upgrade, so remotes that
  cache it can become stale*. §getMethodNamesMethod is *thisful*
  — *must be so that it works as expected with far-object
  inheritance*. The thisful method calls cycle 132's
  getMethodNames(this) so subclass remotables get their full
  method set.

  §getMethodNamesDescriptor: enumerable: false (keeps
  __getMethodNames__ out of normal key enumeration);
  configurable: false; writable: false (unalterable once
  installed).

  §Far adds GET_METHOD_NAMES only for object remotables, not Far
  functions — *This test excludes far functions, since we
  currently consider them to only have a call-behavior, with no
  callable methods*. Echoes cycle 134's §two-distinct-shapes
  discipline.

  §Far mutates the input — *Beware: Mutates the input argument!
  But Remotable requires the object to be mutable, does further
  mutations, hardens the mutated object before returning it. So
  this mutation is not unprecedented. But it is surprising!*

  §ToFarFunction: §wrap-only-when-needed (if already a far
  function via getInterfaceOf, return it directly; no
  double-wrapping); §works-even-if-func-is-already-frozen (wraps
  in a fresh arrow function that's not yet remotable);
  §better-Far-when-you-can advice (*for functions you author in
  place, better to use Far on their function literal directly*).

  Cycle 136 was nominally chat-lane (cycle 135 was designs).
  Chat-lane exhausted at 20/20. Cycle 136 pivoted to comments-
  lane to complete the pass-style remotable surface — four files
  now in the library: cycle 71 (passStyleOf.js dispatcher),
  cycle 87 (error.js three sections), cycle 134 (remotable.js
  validator), cycle 136 (this file, make-far.js constructor).
---

> Abstract: `packages/pass-style/src/make-far.js` (221 lines,
> Kris Kowal, commit `57100aa0`) is the *constructor* layer for
> remotables — direct companion to cycle 134's `remotable.js`
> (which *validates* what this file *constructs*). Three
> exports: Remotable / Far / ToFarFunction. Plus GET_METHOD_NAMES
> = '__getMethodNames__' meta-method constant.
>
> **The single most structurally interesting move**: the
> §three-piece prefix-handling discipline. This file *produces*
> the `'Alleged: '` prefix in Far(); cycle 134's remotable.js
> *requires* it in confirmIface(); cycle 130's
> message-breakpoints.js *strips* it in simplifyTag(). The triad
> covers create / validate / match.
>
> §makeRemotableProto helper builds a tag-record-rooted prototype
> chain with the §strict-original-prototype invariant (object
> remotables must inherit from objectPrototype; Far functions
> from functionPrototype).
>
> §mutate-harden-check-twice fail-fast pattern: dry-run on a
> fresh `{}` before mutating the caller's remotable. §already-
> frozen check uses §comparison-against-fresh — accommodates
> the unsafe-hardenTaming-everything-frozen edge case.
>
> §Allegation-not-attestation discipline: the `'Alleged: '`
> prefix is the visible reminder that consumers must not
> over-trust the iface (Alice's vat may misrepresent Carol's
> iface to Bob's vat).
>
> §GET_METHOD_NAMES auto-method modeled on cycle 118's
> GET_INTERFACE_GUARD pattern. §thisful for far-object
> inheritance. §enumerable: false keeps the meta-method out of
> normal key enumeration.
>
> §Far adds GET_METHOD_NAMES only for object remotables (Far
> functions excluded per the *call-behavior-only* shape).
>
> §ToFarFunction: §wrap-only-when-needed + §works-even-if-func-
> is-already-frozen + §better-Far-when-you-can.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [Remotable-Far-and-ToFarFunction-with-Alleged-prefix-source-and-mutate-harden-check-twice-discipline](../sections/endo--packages-pass-style-src-make-far-js--Remotable-Far-and-ToFarFunction-with-Alleged-prefix-source-and-mutate-harden-check-twice-discipline.md) | pass-style, marshal | current |

Tight 221-line file. Three exports + GET_METHOD_NAMES form one
mechanism: *the constructor side of the remotable surface*.
Cohesion-honest one-section count.

## Provenance

- Fetched 2026-06-03 from `endojs/endo@57100aa0` (`master`) via
  the local bare-clone.
- Last touched 2026-02-24 by Kris Kowal in commit `57100aa0`.
  Same wave as the broader `e56bf00f` coordinated-update cluster
  (cycles 108/110/115/118/123/125/132/134).
- Verified file existence and structure via the local bare-clone:
  221 lines + 3 exports (Remotable, Far, ToFarFunction) + 1
  constant (GET_METHOD_NAMES) + 2 private helpers
  (makeRemotableProto, assertCanBeRemotable) + 2
  module-level objects (getMethodNamesMethod,
  getMethodNamesDescriptor).
- **Twenty-seventh comment-fragment ingest.** Completes the
  pass-style remotable surface alongside cycle 71 (passStyleOf
  dispatcher), cycle 87 (error.js three sections), cycle 134
  (remotable.js validator).
- Cycle 136 was nominally **chat-lane** (cycle 135 was designs).
  Chat-lane is exhausted (20/20 upstream designs ingested).
  Papers-lane has been blocked for **30+ consecutive cycles** due
  to lack of PDF-fetching infrastructure. Cycle 136 pivoted to
  comments-lane.
- One cohesion-honest section.
