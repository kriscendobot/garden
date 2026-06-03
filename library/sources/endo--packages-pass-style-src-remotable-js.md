---
source: packages/pass-style/src/remotable.js
source_repo: endojs/endo
source_branch: master
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
source_date: 2026-02-24
source_authors: [Kris Kowal]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Twenty-sixth comment-fragment ingest. 305-line file by Kris
  Kowal in commit `e56bf00f` — the *what-counts-as-a-remotable*
  predicate layer. Same coordinated-update commit as cycles 108,
  110, 115, 118, 123, 125, 132.

  Connects three previously-ingested layers: cycle 71's
  passStyleOf.js dispatches to this file's RemotableHelper for
  pass-style === 'remotable'; cycle 132's local.js provides
  getMethodNames (re-exported here as getRemotableMethodNames);
  cycle 130's message-breakpoints.js strips the 'Alleged: ' /
  'DebugName: ' prefixes this file *requires*.

  Single most structurally interesting move: the §two-distinct-
  shapes discipline (object remotables vs function remotables).
  Object remotables: bag of methods + @@toStringTag; *Methods
  don't carry PASS_STYLE*. Function remotables (Far functions):
  single callable + metadata (.name, .length, optional
  @@toStringTag); *Far functions cannot be methods, and cannot
  have methods*. The two shapes are mutually exclusive — an
  object remotable is not callable; a Far function is not a bag
  of properties.

  §canBeMethod predicate: *function-not-passable* invariant —
  `typeof func === 'function' && !(PASS_STYLE in func)`. A method
  is an inert function value living *on* a remotable; if the
  function carries PASS_STYLE, it's already a Far function (itself
  a remotable). §TODO HAZARD acknowledgement: this predicate is
  called during harden; can't yet check func is hardened — its
  prototype chain may mutate after the PASS_STYLE check.

  §canBeMethodName: accepts string|symbol|number. TODO #2884
  links to abstracting this so later PRs agree on method-name
  restrictions. The number-as-method-name allowance is open today.

  §getRemotableMethodNames: re-exports cycle 132's
  `@endo/eventual-send/utils.js`'s getMethodNames. Currently a
  pure alias; *the abstraction exists so a future PR can enforce
  restrictions on method names of remotables*. The §layering-
  stepwise discipline: eventual-send doesn't know about remotables,
  pass-style doesn't know about eventual-send dispatch; they
  compose at the introspection-helper boundary.

  §confirmIface accepts 'Remotable' literal OR 'Alleged: ' prefix
  OR 'DebugName: ' prefix. Source-of-truth for the prefix
  conventions cycle 130's simplifyTag strips. The §pair-discipline:
  *prefix-required-when-producing / prefix-stripped-when-matching*.
  §iface-must-be-pure JSDoc: today must be a string; future may
  admit PureData (pass-by-copy superstructure ending in primitives
  or empty composites; no remotables, promises, or errors).

  §confirmRemotableProtoOf recursive proto walk: the remotable's
  prototype chain must end in a *tag record* (plain-object
  prototype with PASS_STYLE='remotable' + @@toStringTag). Two
  cases: direct tag-record parent OR inherited remotable parent
  (recursive). The §never-direct-inheritance-from-Object.prototype
  invariant: *Remotables must be explicitly declared* — if proto
  is objectPrototype, null, or Function.prototype, reject. Forces
  intentional remotability.

  §confirmedRemotables WeakSet cache: §cache-positive-not-negative
  discipline. *We don't remember rejections because they are
  possible to correct with e.g. harden*. The cache is forward-only
  — once true, always true (frozen-ness + structure are permanent);
  rejections are about *the value at this moment*. WeakSet lets GC
  reclaim entries — no leak.

  §getInterfaceOf with overloaded TypeScript type — given
  PassStyled<any, T>, return T-narrowed; given anything else,
  return InterfaceSpec | undefined. Lets typed callers recover
  the literal interface tag without an explicit cast.

  §RemotableHelper.confirmCanBeValid branches:
    - typeof 'object': all own properties must be function values;
      no accessors (*cannot serialize Remotables with accessors*);
      no non-method properties (*cannot serialize Remotables with
      non-methods*); no PASS_STYLE shadowing (*A pass-by-remote
      cannot shadow PASS_STYLE*); @@toStringTag exempt (validated
      via confirmIface).
    - typeof 'function' (Far functions): only .name + .length +
      optional @@toStringTag allowed; restKeys.length === 0
      enforces *exactly these three* properties; *Far functions
      cannot be methods, and cannot have methods*.

  §every: (_passable, _fn) => true — remotables are leaves in
  the pass-style tree; no internal pass-style structure to
  enumerate. The §leaf-no-iteration discipline.

  Cycle 134 was nominally chat-lane (cycle 133 was designs).
  Chat-lane exhausted at 20/20. Cycle 134 pivoted to comments-lane,
  exploring @endo/pass-style for variety (existing pass-style
  ingests: cycle 71 passStyleOf.js + cycle ??? error.js + 4 docs).
  Papers-lane has been blocked for 28+ consecutive cycles.
---

> Abstract: `packages/pass-style/src/remotable.js` (305 lines,
> Kris Kowal, commit `e56bf00f`) is the *what-counts-as-a-
> remotable* predicate layer. Connects three layers: cycle 71's
> passStyleOf.js (dispatches to this file's RemotableHelper),
> cycle 132's local.js (provides getMethodNames), cycle 130's
> message-breakpoints.js (strips prefix conventions this file
> requires).
>
> **The single most structurally interesting move**: the §two-
> distinct-shapes discipline. Object remotables are *bags of
> methods + @@toStringTag*; methods don't carry PASS_STYLE.
> Function remotables (Far functions) are *single callables +
> metadata* (.name, .length, optional @@toStringTag); *Far
> functions cannot be methods, and cannot have methods*. The two
> shapes are mutually exclusive.
>
> §canBeMethod = function-not-passable invariant. §canBeMethodName
> = string|symbol|number (TODO #2884 to abstract restrictions).
> §getRemotableMethodNames aliases cycle 132's getMethodNames
> (abstraction-anticipating-restriction).
>
> §confirmIface accepts 'Remotable' literal or 'Alleged: '/
> 'DebugName: ' prefix — source of truth for the prefix
> conventions cycle 130 strips (prefix-required-when-producing /
> prefix-stripped-when-matching pair).
>
> §confirmRemotableProtoOf recursive proto walk: chain must end
> in a *tag record* (PASS_STYLE='remotable' + @@toStringTag);
> remotables can inherit from other remotables; *Remotables must
> be explicitly declared* — no direct inheritance from
> Object.prototype.
>
> §confirmedRemotables WeakSet cache: §cache-positive-not-negative
> discipline — *we don't remember rejections because they are
> possible to correct with e.g. harden*.
>
> §getInterfaceOf has overloaded type for narrowed-T recovery
> from PassStyled<any, T>. §RemotableHelper.confirmCanBeValid
> branches by typeof for the two-shapes distinction. §every:
> always-true short-circuit — remotables are leaves in the
> pass-style tree.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes](../sections/endo--packages-pass-style-src-remotable-js--what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes.md) | pass-style, marshal | current |

Tight 305-line file. The predicates + RemotableHelper form one
mechanism: *define what counts as a remotable*. One cohesion-
honest section.

## Provenance

- Fetched 2026-06-03 from `endojs/endo@e56bf00f` (`master`) via
  the local bare-clone. Same commit as cycles 108, 110, 115, 118,
  123, 125, 132 (the `e56bf00f` coordinated-update cluster).
- Last touched 2026-02-24 by Kris Kowal in commit `e56bf00f`.
- Verified file existence and structure via the local bare-clone:
  305 lines + 5 exports (canBeMethod, getRemotableMethodNames,
  assertIface, getInterfaceOf, RemotableHelper) + 4 private
  helpers (canBeMethodName, confirmIface, confirmRemotableProtoOf,
  confirmRemotable) + 1 confirmedRemotables WeakSet cache.
- **Twenty-sixth comment-fragment ingest.** Connects three
  previously-ingested layers: cycle 71 (passStyleOf.js
  dispatch), cycle 132 (local.js getMethodNames source), cycle
  130 (message-breakpoints.js prefix conventions).
- Cycle 134 was nominally **chat-lane** (cycle 133 was designs).
  Chat-lane is exhausted (20/20 upstream designs ingested).
  Papers-lane has been blocked for **28+ consecutive cycles** due
  to lack of PDF-fetching infrastructure. Cycle 134 pivoted to
  comments-lane.
- One cohesion-honest section.
