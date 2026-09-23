---
source_kind: source
source_repo: endojs/endo
source_path: packages/ses/src/tame-harden.js
source_line_range: 1-29
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 378 chat-lane ingest paired to cycle 377 designs-lane
  SES secure-coding-guide. 29-line implementation of the
  harden taming function — the substrate behind the cycle
  377 guide's `harden` discussion. Twenty-sixth AUTHORED
  conformant single-body section doc in post-refactor era.
  Sixty-eight consecutive non-garden sources after the pivot
  (310-378). §sixty-eight-cycles-with-named-pivot-domain-
  stay.

  Single most structurally interesting move: §the-named-
  unsafe-harden-as-identity-function-that-lies-about-freezing
  — when the user opts into `hardenTaming: 'unsafe'`, lines
  13-16 globally REPLACE four introspection APIs with
  functions that LIE: `Object.isExtensible = () => false`,
  `Object.isFrozen = () => true`, `Object.isSealed = () =>
  true`, `Reflect.isExtensible = () => false`. Line 25's
  `fakeHarden = arg => arg` is the identity function — does
  NOTHING — but the surrounding code that checks "is this
  frozen?" before relying on frozenness will get back `true`
  uniformly. §the-named-developer-mode-via-globally-
  coordinated-lie as tier-3 meta-pattern. The unsafe mode is
  for development where you want to be able to mutate
  objects in the debugger AND have hardened-frozen-checking
  code still pass.

  §The-named-honesty-via-shared-lie — line 12 carries the
  comment `// In on the joke`. The implementation is HONEST
  about being DISHONEST. The deception is named explicitly
  in source. Sibling shape to cycle 359's §the-named-honest-
  placeholder-not-hidden-gap, cycle 372's §the-named-
  exported-for-tests-as-honest-acknowledgment, cycle 375's
  §the-named-TODO-as-explicit-future-removal-candidate,
  cycle 377's §the-named-bikeshedding-acknowledged. The
  Endo project consistently surfaces incomplete-or-deceptive
  states in source. §the-named-deception-named-in-comment-
  as-honest-discipline as tier-3 meta-pattern.

  §The-named-fake-harden-is-real-frozen-itself — line 27:
  `return freeze(fakeHarden);`. The identity function used
  as fake-harden is itself real-frozen. The fake can't be
  tampered with even though it does nothing. §the-named-
  fake-tool-frozen-not-its-output as tier-3 meta-pattern:
  the TOOL is frozen so it can't be tampered with; what it
  RETURNS is unfrozen by design (it's the identity function;
  whatever you pass in is what you get back).

  §The-named-isFake-marker-property — lines 19-23: detects
  if safeHarden is already a fake hardener via `.isFake`
  property and reuses it if so. Idempotent application; the
  taming is safe to call twice. §the-named-marker-property-
  for-idempotent-application as tier-3 meta-pattern.

  §The-named-eslint-disable-as-recurring-carve-out-pattern-
  across-packages-THIRD-INSTANCE — line 1: `/* eslint-disable
  no-restricted-globals */`. The file deliberately mutates
  Object.isExtensible/isFrozen/isSealed and Reflect.
  isExtensible — globally restricted by lint. Carve-out
  required because the file's ENTIRE PURPOSE is global
  mutation. Sibling to cycle 362's ses-ava no-restricted-
  exports carve-out and cycle 364's benchmark no-await-in-
  loop carve-out. §the-named-eslint-disable-as-recurring-
  carve-out-pattern-across-packages-confirmed-by-third-
  instance — three instances establish the pattern as a
  cluster meta-discipline: deliberate rule violations are
  EXPLICIT in source via a disable comment, never silent.

  §The-named-freeze-as-named-import-not-Object-freeze-
  ambient — line 2: `import { freeze } from './commons.js';`.
  Even `freeze` (which most code calls as `Object.freeze`)
  is sourced from a local commons module, not from the
  language ambient. The OCAP-no-ambient-authority principle
  in action: the file refuses to assume the global Object is
  the trustworthy original. §the-named-freeze-via-commons-
  not-globalThis as tier-3 meta-pattern.

  §The-named-safeHarden-and-hardenTaming-as-typed-parameters
  — line 6 JSDoc names the function signature: `(safeHarden:
  Harden, hardenTaming: 'safe' | 'unsafe') => Harden`. Two
  parameters: the real harden (passed in, not imported) and
  a literal-union string. The factory is invariant in the
  return type but the runtime behavior bifurcates. §the-
  named-string-literal-union-as-mode-selector as tier-3
  meta-pattern.

  §The-named-twenty-nine-line-implementation-of-developer-
  mode — the entire developer-mode escape hatch fits in 29
  lines. The factory function is 22 lines (lines 7-28), one
  freeze of the factory itself on line 29. Sibling shape to
  cycle 364 benchmark (39 lines), cycle 370 daemon utility
  (23 lines), cycle 372 compartment-mapper extension (22
  lines), cycle 376 module-source hidden (20 lines).

  §The-named-secret-property-via-ts-expect-error — line 18:
  `// @ts-expect-error secret property`. The `.isFake`
  property is set without being in the type definition; the
  TypeScript error is explicitly suppressed with a comment
  naming the WHY ("secret property"). §the-named-named-
  expect-error-with-justification-comment as tier-3 meta-
  pattern.

  Closes seven citation arcs: cycle 377 (1, adjacent forward
  pair secure-coding-guide → tame-harden implementation;
  the guide named `harden`'s discipline, the source shows
  the unsafe-mode escape hatch) + cycle 337 (54, harden
  itself; tame-harden is the wrapping factory that gates
  access to the unsafe variant) + cycle 339 (57, lockdown
  invokes tameHarden during lockdown setup) + cycle 364 (1,
  eslint-disable-as-recurring-carve-out-pattern THIRD
  INSTANCE; pattern now established across three packages —
  ses-ava + benchmark + ses) + cycle 362 (1, sibling
  carve-out) + cycle 326 (52, pure-naming-as-discipline) +
  cycle 367 (6, exo composes with hardened defensive
  interfaces; cycle 378 reveals the developer-mode escape
  hatch that bypasses defense for debugging). Pushes
  citation-arc-closures-in-pivot to THREE-HUNDRED-TWENTY-
  FIVE (318 + 7 net new).
---

29-line implementation of the harden taming function in SES. §the-named-unsafe-harden-as-identity-function-that-lies-about-freezing (single most structurally interesting move — unsafe mode globally replaces Object.isExtensible/isFrozen/isSealed + Reflect.isExtensible with functions that uniformly return frozen=true while harden becomes a no-op identity function). §the-named-honesty-via-shared-lie (line 12 "In on the joke" — deception named explicitly in source; sibling honest-acknowledgment shape from cycles 359/372/375/377). §the-named-developer-mode-via-globally-coordinated-lie. §the-named-fake-harden-is-real-frozen-itself (the no-op tool is itself frozen so it can't be tampered with). §the-named-isFake-marker-property (idempotent application). §the-named-eslint-disable-as-recurring-carve-out-pattern-across-packages-THIRD-INSTANCE (now established across ses-ava + benchmark + ses; three instances). §the-named-freeze-as-named-import-not-Object-freeze-ambient (OCAP-no-ambient-authority principle in action). §the-named-string-literal-union-as-mode-selector. §the-named-named-expect-error-with-justification-comment (line 18). Seven citation arcs closed.
