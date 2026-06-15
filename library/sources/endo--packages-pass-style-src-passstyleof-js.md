---
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/pass-style/src/passStyleOf.js
source_line_range: "101-405"
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
comment_subject: "passStyleOf internals: the passStyleMemo cache (mutable static state with proxy-observability hazard), the PassStyleOfEndowmentSymbol liveslot delegation gate (with GC-determinism requirement), and the toPassableError/toThrowable coercion functions (diagnostic-preservation rule plus exo-boundary throwables-only contract)"
source_authors: [Kris Kowal, Mark S. Miller, Michael FIG, Turadg Aleahmad]
ingested: 2026-05-28
re-ingested: 2026-06-15
ingested_by: scholar (cycle 71) + liaison (cycle 350)
section_count: 4
status: current
notes: |
  Third comment-fragment ingest (cycle 71), following the
  `handled-promise.js` precedent from cycle 66 and the
  `encodeToSmallcaps.js` precedent from cycle 69. Three sections
  distilled from the longform commentary that brackets the three
  most security-loaded passages of the pass-style classifier:
  the `passStyleMemo` cache rationale (with its explicit "mutable
  static state... TODO need to assess whether this creates a
  static communications channel" hazard note), the
  `PassStyleOfEndowmentSymbol` liveslot-delegation export (with
  the GC-detection hazard the delegated implementation must
  avoid), and the `toPassableError` / `toThrowable` coercion
  functions (with the diagnostic-preservation rule and the
  exo-boundary throwables-only contract).

  The three cohesive arguments the comments make: (1) why a
  realm-lifetime memo is justified despite Table 1's "forbid
  mutable static state" prohibition (performance is unworkable
  without it; the hazard is recorded with a TODO); (2) why the
  install-on-global gate stands in for an authorization check
  on classifier substitution, and what determinism property the
  substitute must preserve to avoid exposing a GC oracle; (3)
  why pass-style exports coercion functions rather than just
  assertions (diagnostic preservation when errors fail
  passability; throwables-only at the exo boundary to ease
  security review).
---

## Abstract

`packages/pass-style/src/passStyleOf.js` is the canonical
classifier for marshal's pass-style discipline. It walks a value's
properties and returns one of seven labels (`copyArray`,
`byteArray`, `copyRecord`, `tagged`, `error`, `remotable`, plus
the primitive type names) or throws. Its longform commentary
documents three non-obvious mechanisms the implementation rests
on: the **passStyleMemo cache** (a realm-lifetime `WeakMap` whose
performance is essential but whose presence is recorded as a
deliberate breach of the "forbid mutable static state" capability
discipline, with a TODO marker reminding reviewers that the
proxy-observability question is unresolved), the
**PassStyleOfEndowmentSymbol delegation export** (the mechanism
by which liveslots and other virtualization layers swap in a
virtualization-aware classifier, with the install-on-global gate
serving as the implicit authorization check and the determinism
requirement that prevents a GC-detection oracle), and the
**toPassableError / toThrowable coercion functions** (which trade
strict validation for diagnostic preservation when errors are at
stake and enforce a stricter "throwables-only" contract at exo
boundaries to make code review more uniform).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [passstylememo-as-mutable-static-state](../sections/endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state.md) | pass-style, marshal, capability-security, hardened-javascript | current |
| [liveslots-endowment-and-gc-determinism](../sections/endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism.md) | pass-style, marshal, capability-security, persistence | current |
| [coercion-to-passable-and-throwable](../sections/endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable.md) | pass-style, errors, marshal, capability-security | current |

## Provenance

- File last modified 2025-10-09 by Kris Kowal (`feat: Adopt @endo/harden`).
- File-specific commit `e56bf00f` (captured 2026-05-28).
- Comments authored across the file's history by Kris Kowal,
  Mark S. Miller, Michael FIG, and Turadg Aleahmad. The
  classifier's invariants are referenced by the pass-style
  README, copyArray-guarantees, copyRecord-guarantees, and
  enumerating-properties docs; this source file is the
  canonical home of the three internal mechanisms those docs
  intentionally hide.

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js) at commit `e56bf00f`.
