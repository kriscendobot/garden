---
source_kind: design-doc
source_repo: endojs/endo
source_path: packages/ses/docs/secure-coding-guide.md
source_line_range: 1-180
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: partial
notes: |
  Cycle 377 designs-lane ingest. 532-line SES secure-coding-
  guide; cycle 377 ingests the FIRST 180 lines (the intro and
  motivating examples through "harden recursively freezes
  surface"). Future cycles can re-ingest later sections with
  complementary lens. Twenty-fifth AUTHORED conformant single-
  body section doc in post-refactor era. Sixty-seven
  consecutive non-garden sources after the pivot (310-377).
  §sixty-seven-cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  defensive-consistency-as-core-discipline — lines 3-7 define
  the discipline the entire document and SES substrate exist
  to support: "a program... that provides correct service to
  its correctly-behaving customers, despite also being
  subjected to incorrectly-behaving customers." Defensive
  consistency is the named property; SES is the substrate
  that makes it achievable in JavaScript. §the-named-correct-
  service-to-correct-customers-despite-bad-customers as tier-
  3 meta-pattern. The discipline is asymmetric — the program
  is NOT required to give bad service to bad customers, but
  IS required to keep serving good customers correctly even
  when bad customers attack.

  §The-named-trusted-computing-base-must-be-explicit — lines
  8-12: "The defensively consistent program is allowed to
  rely upon some 'trusted computing base' ('TCB', like
  libraries and other services), which means it is allowed
  to provide incorrect service to correctly-behaving
  customers if the TCB misbehaves, but it must be clear about
  which code is in the TCB and which code is not being relied
  upon." Honest naming of trust boundaries; TCB is allowed
  but must be NAMED. §the-named-TCB-must-be-named-not-
  implicit as tier-3 meta-pattern.

  §The-named-mutually-suspicious-code-co-existing — lines
  15-16: "Two pieces of mutually-suspicious code can safely
  interact if both are written in a defensively-consistent
  style." Two parties, neither trusts the other, both safe
  via discipline. §the-named-bilateral-discipline-replaces-
  trust as tier-3 meta-pattern.

  §The-named-internet-vs-local-code-same-discipline — lines
  22-28: most programs trust co-resident code; defensive
  consistency applies the same internet-grade discipline to
  LOCAL code. "By applying the same defensive attitude
  towards co-resident code, we can improve safety against
  mistakes, misunderstandings, or partial compromise." §the-
  named-internet-discipline-applied-locally as tier-3 meta-
  pattern.

  §The-named-Principle-of-Least-Authority-POLA — line 26-28:
  "We apply the **Principle of Least Authority** (POLA) to
  these separate components, giving each one the barest
  minimum of power necessary to do its job. This limits the
  damage if/when a component becomes compromised or
  confused." POLA named explicitly with its acronym. §the-
  named-POLA-as-named-canonical-principle as tier-3 meta-
  pattern; the competitive-analysis-private.md identified
  this as the underlying axis of every competitor's pitch
  ("least privilege", "scoped access"); cycle 377 reaches
  the canonical text where the principle is named.

  §The-named-no-ambient-authority-and-connectivity-begets-
  connectivity-as-twin-principles — lines 142-146: "Two
  principles of object-capability security are **no ambient
  authority**, and **connectivity begets connectivity**.
  That means the *only* way for two objects to talk to each
  other or have any causal influence over each other is for
  there to be a path in the object graph that reaches both
  of them. Every object in that path gets to decide how much
  influence to allow." The OCAP discipline distilled into
  TWO PITHY PRINCIPLES. The first says nothing is available
  unless explicitly granted (no implicit globals, no implicit
  context). The second says causal influence requires an
  object-graph path. Together: the object graph IS the
  authority graph. §the-named-object-graph-IS-authority-
  graph as tier-3 meta-pattern.

  §The-named-non-SES-failure-modes-as-named-vulnerabilities
  — lines 38-77 give concrete vulnerability examples without
  SES: (1) mutable Array returned to "reader" lets reader
  delete entries (too much authority); (2) prototype
  pollution lets writer1 redefine `Array.prototype.push` to
  swallow writer2's messages. The document teaches by
  exhibiting the attacks SES prevents. §the-named-teach-by-
  exhibiting-attack as tier-3 meta-pattern.

  §The-named-same-source-different-meaning-pre-and-post-SES
  — lines 89-103: the IDENTICAL `makeLogger` source code
  produces a different security posture in SES (intrinsics
  frozen) versus non-SES (intrinsics mutable). The "in SES
  but not secure" version still has the reader-deletion
  vulnerability but no longer has prototype pollution. SES
  fixes the BACKGROUND vulnerabilities; the FOREGROUND
  application-logic vulnerabilities still require careful
  coding. §the-named-SES-fixes-background-not-foreground as
  tier-3 meta-pattern.

  §The-named-array-pop-still-works-after-SES (line 117-118)
  — SES freezes intrinsics but the application's local Array
  reference is still mutable from the holder's perspective.
  The discipline must extend beyond what SES gives you.

  §The-named-return-copy-not-the-mutable-original — lines
  126-138: the read API returns `[...log]` rather than `log`
  itself. The application enforces its own discipline within
  the SES substrate. §the-named-return-copy-as-application-
  discipline as tier-3 meta-pattern.

  §The-named-functions-are-callable-objects-channel — lines
  149-163: a `write` function shared between writer1 and
  writer2 is itself a communication channel because
  Functions are mutable Objects. writer1 can set
  `write.messageToWriter2 = "psst hey buddy"`. SES freezes
  intrinsics but not application-created Function instances.
  §the-named-function-as-mutable-channel-without-harden as
  tier-3 meta-pattern.

  §The-named-harden-recursively-freezes-surface — lines
  165-172: `harden` applies `Object.freeze` recursively to
  the enumerable properties and the prototype. Does NOT
  require immutability: hardened `Set` and `Map` can still
  be modified through their get/set/add methods. Hardened
  `Array`s ARE immutable. §the-named-harden-freezes-surface-
  not-state as tier-3 meta-pattern; the surface (the
  function/method bindings) is locked but internal state
  remains accessible through the surface API.

  §The-named-hardened-objects-can-close-over-mutable-state —
  lines 174-176: "extremely common for the hardened object
  to close over mutable state. This is a standard pattern
  for the construction of object-oriented behavior in SES."
  §the-named-closure-state-as-hardened-class-substitute as
  tier-3 meta-pattern; the OO pattern under SES is hardened
  exports + closure-captured private state.

  Closes seven citation arcs: cycle 376 (1, adjacent
  forward; both extend substrate primitive disciplines —
  cycle 376 module-source hidden identifiers + cycle 377 SES
  secure-coding) + cycle 339 (56, lockdown is the SES env
  this guide assumes) + cycle 337 (53, harden is named
  explicitly with semantic precision) + cycle 367 (5, exo's
  defensive-interface composes with defensive consistency)
  + cycle 325 (6, pass-style's Far makes hardened-defensive-
  remotables a primitive) + cycle 326 (51, pure-naming-as-
  discipline; POLA + no-ambient-authority + connectivity-
  begets-connectivity are pure-naming canonical principles)
  + cycle 322 (52, @endo/errors not in scope of partial
  ingest). Pushes citation-arc-closures-in-pivot to THREE-
  HUNDRED-EIGHTEEN (311 + 7 net new).
---

Partial ingest (first 180 of 532 lines) of SES secure-coding-guide. §the-named-defensive-consistency-as-core-discipline (single most structurally interesting move; correct service to correct customers despite bad customers). §the-named-trusted-computing-base-must-be-explicit. §the-named-mutually-suspicious-code-co-existing. §the-named-internet-discipline-applied-locally. §the-named-Principle-of-Least-Authority-POLA (canonical text for the principle every competitor's pitch echoes). §the-named-no-ambient-authority-and-connectivity-begets-connectivity-as-twin-principles (OCAP discipline distilled; object graph IS authority graph). §the-named-non-SES-failure-modes-as-named-vulnerabilities (teach by exhibiting attack). §the-named-same-source-different-meaning-pre-and-post-SES (SES fixes background not foreground). §the-named-functions-are-callable-objects-channel (surprising channel without harden). §the-named-harden-recursively-freezes-surface (surface not state). §the-named-hardened-objects-can-close-over-mutable-state (closure-state-as-hardened-class-substitute). Seven citation arcs closed.
