---
kind: result
role: liaison
dispatch-root: dispatches/liaison--117a7f
cycle: 351
lane: designs
host: endolin
date: 2026-06-15
refs:
  - 2026/06/15/223950Z-result-liaison-19e626.md
---

# Result — liaison cycle 351: @endo/ses docs/draft-standalone-spec.md (designs-lane; omissions-organized-by-removed-property; shim-vs-standalone-engine distinction; EIGHT citation-arc closures)

Cycle 351 ingest: **@endo/ses docs/draft-standalone-spec.md** (201 lines). Designs-lane after cycle 350's chat-lane @endo/pass-style/src/passStyleOf.js — cross-package. **§forty-two-cycles-with-named-pivot-domain-stay** (310-351).

## Single most structurally interesting move

**§the-named-omissions-organized-by-removed-property** — the doc enumerates omissions from standard EcmaScript each tied to a **named property being eliminated**:

| Omitted | Removed property |
|---|---|
| Math.random + Date.now + new Date() | Non-determinism |
| RegExp static properties | Global communications channel |
| Intl | Ambient authority + non-determinism |
| Function constructors | Evaluators |

**§three-named-anti-properties-being-eliminated** + **§the-named-three-anti-properties-equal-the-three-attack-categories** — first-explicit-observations. The three anti-properties parallel cycle 345's three attack categories (prototype-pollution + man-in-the-middle + covert-communication-channels). **§two-shapes-of-defense-taxonomy** — first-explicit-observation as a tier-3 meta-pattern.

## §the-named-shim-vs-standalone-engine-distinction

The doc projects forward to what a STANDALONE SES engine would look like (vs the current shim-based implementation). **§the-named-shim-vs-standalone-engine-distinction** — first-explicit-observation as a tier-3 meta-pattern. SES has TWO implementation strategies:
- Shim-based (dynamically suppress parts of standard EcmaScript)
- Standalone engine (directly implement only SES)

## §the-named-throws-rather-than-returns-discipline

When removing a capability, the method THROWS rather than returns. **§the-named-throws-rather-than-returns-discipline** — first-explicit-observation as a tier-3 meta-pattern.

**§three-shapes-of-discipline-violation-visibility** (337 helpful-stack + 342 console-warn + 351 throw-on-denied-capability) — first-explicit-observation as a tier-3 meta-pattern.

## §the-named-rom-able-immutable-discipline

Frozen intrinsics + no hidden state + no ambient authority + no reachable globals or evaluators → **ROM-able** (placeable in read-only memory for IoT).

**§the-named-rom-able-immutable-discipline** — first-explicit-observation as a tier-3 meta-pattern. The IoT-friendly end-state property certifies the absence of state.

## Closes EIGHT citation arcs

| Closes arc with | Arc length | Subject |
|---|---|---|
| Cycle 350 (passStyleOf.js) | 1 cycle | Cross-package |
| Cycle 349 (preparing-for-stabilize.md) | 2 cycles | Sibling forward-looking SES doc |
| Cycle 345 (@endo/ses README) | 6 cycles | §two-shapes-of-defense-taxonomy |
| **Cycle 87 (pass-style/error.js V8 stack accessor)** | **264 cycles** | Non-determinism / covert-channel theme |
| Cycle 152 (memo-race Promise.race) | 199 cycles | Non-determinism in scheduling |
| Cycle 156 (finalize.js gc-as-side-channel) | 195 cycles | Non-determinism + side-channel |
| Cycle 342 (lockdown pre.js NOTE-TO-REVIEWERS) | 9 cycles | §three-shapes-of-discipline-violation-visibility |
| Cycle 337 (@endo/harden helpful-stack) | 14 cycles | §three-shapes-of-discipline-violation-visibility |

**§eight-citation-arc-closures-in-cycle-351**. **§one-hundred-forty-eight-citation-arc-closures-in-pivot-now** (142 + 6 net new).

## Library state after cycle 351

- §library-reaches-863-sections from 394 source documents
- §one-hundred-and-eighty-fourth consecutive designs-chat alternation
- §forty-two-cycles-with-named-pivot-domain-stay (310-351)
- §nineteen-named-packages-in-the-pivot-cluster
- §one-hundred-forty-eight-citation-arc-closures-in-pivot-now (142 + 6 net new)
- §the-named-omissions-organized-by-removed-property established as tier-3 meta-pattern
- §the-named-shim-vs-standalone-engine-distinction established as tier-3 meta-pattern
- §the-named-throws-rather-than-returns-discipline established as tier-3 meta-pattern
- §three-shapes-of-discipline-violation-visibility established as tier-3 meta-pattern
- §the-named-rom-able-immutable-discipline established as tier-3 meta-pattern
- §two-shapes-of-defense-taxonomy established as tier-3 meta-pattern

## Next cycle pacing

Cycle 352 chat-lane next. The substantial pivot reach (42 cycles, 148 arcs, 19 packages) continues. Candidates:

- **A SES src/ file** — the substantial SES implementation
- **@endo/captp source complementary-lens** — multiple captp source files have been ingested
- **A non-SES source** to extend coverage breadth
- **A garden meta-document** to pivot back

Picking freely.
