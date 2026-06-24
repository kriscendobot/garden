---
title: Other key moves
source: endo--packages-pass-style-README-md
url: https://github.com/endojs/endo/blob/master/packages/pass-style/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/pass-style/README.md
total-lines: 216
ingest-cycle: 325
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-exhaustive-enumeration-via-table
  - the-named-thirteen-pass-styles-in-one-table-fixed-set
  - the-named-closed-set-IS-named-security-foundation
  - the-named-pass-by-copy-vs-pass-by-presence-distinction
  - the-named-binary-distinction-with-internal-substructure
  - the-named-Far-doesn-t-validate-with-pointer-to-exo
  - the-named-cross-package-pointer-when-functionality-is-here-not-elsewhere
  - the-named-makeTagged-IS-named-extension-point
  - the-named-extension-point-IS-named-API-shape
  - the-named-five-named-requirements-for-passability
  - the-named-tentatively-modal
  - the-named-hedge-word-in-canonical-rule
  - the-named-canonical-counterexamples-after-canonical-examples
  - the-named-counterexample-discipline
  - the-named-Use-for-and-Pass-styles-pair-rows-discipline
  - the-named-type-guards-section-with-canonical-imports
  - the-named-Deep-Dives-IS-named-implementation-detail-section
  - the-named-monorepo-docs-reference
  - the-named-Hardened-JS-mentioned-pervasively-but-no-section
  - sixteen-cycles-with-named-pivot-domain-stay
  - nine-named-packages-in-the-pivot-cluster
  - fourteen-citation-arc-closures-in-pivot-now
  - six-citation-arc-closures-in-one-cycle
  - two-cycles-with-named-role-label-before-package-name
  - two-cycles-with-named-Hardened-JS-discipline-streak-continues-broken
parent: endo--packages-pass-style-README-md--thirteen-pass-styles-table-and-six-arc-closures
---

- **§the-named-five-named-requirements-for-passability** (line 109-117) — numbered list: 1. Primitives always passable (except unregistered symbols); 2. Objects must be frozen; 3. No cyclic references; 4. Strings must be well-formed; 5. Symbols must tentatively use passableSymbolForName(). **§the-named-five-requirements-IS-named-substrate-rules**. First-explicit-observation.

- **§the-named-tentatively-modal** (line 116) — *"Symbols must **tentatively** be created using passableSymbolForName()"*. The word **tentatively** hedges the rule. **§the-named-hedge-word-in-canonical-rule** — first-explicit-observation. The hedge marks a rule as *currently-in-place but possibly-subject-to-change*; the reader is signaled to expect future revision. Compare to cycle 321's "what we call" meta-discourse and cycle 323's "not for mutually-suspicious parties" disclaimer — these are *related* but different shapes of meta-discourse. **§three-cycles-with-named-meta-discourse-in-pivot-READMEs** (321 + 323 + 325; "what we call" + "not for mutually-suspicious" + "tentatively").

- **§the-named-canonical-counterexamples-after-canonical-examples** (line 119-129) — passable example + two NOT-passable examples (not frozen + cyclic). **§the-named-counterexample-discipline** — show what's *not* covered to disambiguate the rule's edges. First-explicit-observation.

- **§the-named-makeTagged-IS-named-extension-point** (line 92-105) — *"CopyTagged object, the extension point for domain-specific data types"*. **§the-named-extension-point-IS-named-API-shape** — first-explicit-observation. The 'tagged' pass-style is the *only* row in the table marked as "Extension"; it's the forwards-compatibility hatch. §the-named-extension-via-named-axis.

- **§the-named-Use-for-and-Pass-styles-pair-rows-discipline** (line 138-140, 157-159) — each of Pass-by-Copy and Pass-by-presence sections includes a "Use for:" row and a "Pass styles:" row. The two rows together give the reader both the *when* (use for) and the *what* (pass styles). **§the-named-when-and-what-pair-rows** — first-explicit-observation.

- **§the-named-type-guards-section-with-canonical-imports** (line 170-190) — four predicate-assertion pairs destructured from `@endo/pass-style`: `{ isRecord, assertRecord, isCopyArray, assertCopyArray, isRemotable, assertRemotable, isAtom, assertAtom }`. **§the-named-four-predicate-assertion-pairs-cited-by-README** — closes citation arc with cycle 150 typeGuards.js (which had the same four pairs as §Four predicate-assertion pairs). §two-cycles-with-named-four-predicate-assertion-pairs (150 + 325; doc/impl boundary).

- **§the-named-Integration-with-Endo-Packages-with-role-labels** (line 192-201) — four packages cited with role labels: Validation (patterns) + Defensive Objects (exo) + Communication (eventual-send) + Serialization (marshal). **§two-cycles-with-named-role-label-before-package-name** (321 + 325) — first-explicit-observation as a recurring discipline.

- **§the-named-Deep-Dives-IS-named-implementation-detail-section** (line 207-216) — points to four documents *within* the package: copyRecord-guarantees.md + copyArray-guarantees.md + enumerating-properties.md + types.js. **§the-named-internal-docs-pointer-section**. First-explicit-observation. Contrasts with cycle 321 eventual-send's "Complete Tutorial" + See Also section (which pointed to *external* sources).

- **§the-named-monorepo-docs-reference** (line 203-205) — `[Message Passing](../../docs/message-passing.md)` — path goes *up two levels* from the package, into the monorepo's shared docs/. First-explicit-observation as a monorepo-specific reference pattern.

- **§the-named-Hardened-JS-mentioned-pervasively-but-no-section** — the README uses `harden()` in numerous examples (line 29, 30, 33, 47, 48, 66, 78, 112, 121, 127, 143, 162) but has **no dedicated Hardened-JavaScript section**. **§two-cycles-with-named-Hardened-JS-discipline-streak-continues-broken** (323 + 325). For pass-style, the reason is structural: pass-style *defines what hardening means in this context*; a Hardened-JS section would be circular. First-explicit-observation as a deeper kind of break than cycle 323's (which was absence-via-presupposition; cycle 325's is absence-via-foundational-status).

- **§the-named-Far-iface-IS-named-identity-string** (line 80) — `Far('Counter', { ... })` — the first argument names the remotable's identity. **§the-named-iface-name-IS-named-debug-handle**. Closes citation arc with cycle 134/136 (which examined Far / make-far).
