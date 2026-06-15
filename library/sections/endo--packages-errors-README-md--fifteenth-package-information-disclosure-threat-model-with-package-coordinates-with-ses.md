---
title: "@endo/errors README.md — fifteenth package; NEW SHORTEST README in pivot (13 lines); information-disclosure-via-thrown-exception threat model; package-coordinates-with-named-other-package; redacted-vs-revealed asymmetry"
source: endo--packages-errors-README-md
url: https://github.com/endojs/endo/blob/master/packages/errors/README.md
authors: [Kris Kowal, Mark S. Miller, Endo project (collective)]
repo: endojs/endo
path: packages/errors/README.md
total-lines: 13
ingest-cycle: 339
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-information-disclosure-via-thrown-exception-threat-model
  - the-named-host-vs-guest-information-disclosure
  - the-named-symmetric-disclosure-risk-named-twice
  - the-named-host-AND-guest-guest-disclosure-symmetry
  - the-named-redacted-messages-as-package-purpose
  - the-named-package-coordinates-with-named-other-package
  - the-named-coordination-with-ses-for-console-reveal
  - the-named-redacted-vs-revealed-asymmetry
  - the-named-two-audiences-different-privileges
  - the-named-NEW-SHORTEST-README-in-pivot
  - the-named-thirteen-line-README-as-floor
  - the-named-fifteenth-package-in-the-pivot-cluster
  - the-named-collection-package-and-substrate-policy-third-shape-emerges
  - the-named-streak-of-zero-cross-package
  - two-threat-models-named-in-pivot-READMEs
  - thirty-cycles-with-named-pivot-domain-stay
  - sixty-eight-citation-arc-closures-in-pivot-now
---

# `@endo/errors README.md` — fifteenth package; NEW shortest README in pivot

The 13-line README of @endo/errors — the smallest README ingested in the pivot to date (previous record: cycle 333 @endo/common at 17 lines). Cycle 339 is **designs-lane after cycle 338's chat-lane @endo/harden/make-hardener.js** (cross-package; not same-package). **§the-named-streak-of-zero-cross-package** — the cycle 337 → 338 same-package adjacent forward pair was a one-cycle resumption; cycle 338 → 339 is cross-package, so the streak count returns to 0.

**Thirtieth consecutive non-garden source after the pivot** (cycles 310-339). **§thirty-cycles-with-named-pivot-domain-stay**. **§fifteen-named-packages-in-the-pivot-cluster** — @endo/errors joins as the **FIFTEENTH PACKAGE** (nat + memoize + hex + lp32 + stream + eventual-send + exo + captp + pass-style + patterns + marshal + common + promise-kit + harden + **errors**).

The @endo/errors package has been **referenced from seven-plus prior cycles** as the source of `q`, `Fail`, `X`, and the Rejector pattern. Cycle 339 closes a cluster of arcs at the documentation-side, mirroring cycle 337's substrate-package-introduction-closes-many-arcs discipline.

## The single most structurally interesting move

**§the-named-information-disclosure-via-thrown-exception-threat-model** — lines 3-7 open with a threat model:

> When host and guest programs share a JavaScript context, there is some risk that the guest will call a host function and induce it to throw an exception that inadvertently reveals information about its internal state to the guest.
> It is similarly possible that a guest would inadvertently reveal information to a cotenant guest.

**§the-named-information-disclosure-via-thrown-exception-threat-model** — first-explicit-observation as a tier-3 meta-pattern. The README opens with a threat model that is **structurally different** from cycle 337 @endo/harden's *supply-chain-attack* threat model. **§two-threat-models-named-in-pivot-READMEs**:

| Cycle | Package | Threat |
|---|---|---|
| 337 | @endo/harden | Supply-chain attack via tampering with module exports |
| 339 | @endo/errors | Information disclosure via thrown exception inadvertently revealing internal state |

The two threats are at different LAYERS of the defense:
- Cycle 337: defends the MODULE BOUNDARY (don't let imports tamper with you)
- Cycle 339: defends the EXCEPTION CHANNEL (don't let your exceptions leak state to catchers)

**§the-named-two-threat-models-name-different-attack-surfaces** — first-explicit-observation as a tier-3 meta-pattern. Each substrate-package's README names ITS own threat model; the threats are not redundant.

**§the-named-symmetric-disclosure-risk-named-twice** — lines 6-7 name the symmetric case:

> It is similarly possible that a guest would inadvertently reveal information to a cotenant guest.

The README does not stop at host→guest disclosure; it explicitly names guest→guest disclosure too. **§the-named-host-AND-guest-guest-disclosure-symmetry** — first-explicit-observation. The threat is bidirectional + lateral; the README documents all three directions in two sentences.

## §the-named-package-coordinates-with-named-other-package

Lines 11-13:

> In coordination with [ses](../ses/) in the host realm, the information redacted by these utilities will be revealed to the realm's console for use in debugging, but be invisible to code that catches them.

**§the-named-package-coordinates-with-named-other-package** — first-explicit-observation as a tier-3 meta-pattern. The README NAMES THE COORDINATION: @endo/errors does not work alone — it coordinates with `ses` in the host realm. The coordination provides:
- **Safety**: information invisible to code that catches the errors
- **Debuggability**: information revealed to the realm's console

**§the-named-redacted-vs-revealed-asymmetry** — first-explicit-observation. Two audiences with different privileges:

| Audience | What they see |
|---|---|
| Code that catches the error | Redacted message (no internal-state leak) |
| Realm's console | Full message (for debugging) |

**§the-named-two-audiences-different-privileges** — first-explicit-observation as a tier-3 meta-pattern. The discipline: when an artifact must serve both *defender* and *debugger*, route different content to each audience based on capability. Compare to:
- Cycle 87 pass-style/error.js: §V8-stack-accessor-channel — stack is a capability channel
- Cycle 337 @endo/harden: intrinsic-over-endowment for capability protection
- Cycle 339 @endo/errors: redaction channels by audience capability

**§three-cycles-with-named-capability-channel-by-audience** (87 + 337 + 339) — first-explicit-observation as a tier-3 meta-pattern. Three different shapes of routing capabilities/information by audience-capability.

**§the-named-coordination-with-ses-for-console-reveal** — first-explicit-observation. The README points to `../ses/` (relative path within the monorepo). The coordination is *named* and *located*. Compare to cycle 337 @endo/harden's *"prepare-* convention"* (named cross-package relationship via naming convention); cycle 339's coordination is a direct path-citation to the coordinating package.

## §the-named-NEW-SHORTEST-README-in-pivot

13 lines. The pivot's README-length distribution now spans:

| Lines | Package | Cycle | Category |
|---|---|---|---|
| **13** | **@endo/errors** | **339** | **NEW MINIMUM** |
| 17 | @endo/common | 333 | Collection-package |
| 60 | @endo/hex | 317 | Utility-package |
| 71 | @endo/promise-kit | 335 | Utility-package |
| 136 | @endo/lp32 | 315 | Utility-package |
| 140 | @endo/stream | 319 | Utility-package |
| 158 | @endo/harden | 337 | Substrate-policy |
| 188 | @endo/marshal | 329 | Substrate-deep |
| 216 | @endo/pass-style | 325 | Substrate-deep |
| 332 | @endo/eventual-send | 321 | Substrate-deep |
| 364 | @endo/exo | 331 | Substrate-deep |
| 415 | @endo/patterns | 327 | Substrate-deep |

**§the-named-NEW-SHORTEST-README-in-pivot** — first-explicit-observation. **§the-named-thirteen-line-README-as-floor** — first-explicit-observation. The minimum is now 13 lines.

**§the-named-substrate-policy-vs-collection-package-shape-distinct** — first-explicit-observation. Cycle 333 @endo/common is a *collection-package* (17 lines; no canonical sections; curation-policy README). Cycle 339 @endo/errors is a NEW shape: substrate-policy-package with a 13-line threat-model + purpose + coordination README. **§the-named-substrate-policy-README-can-be-13-lines** — first-explicit-observation. The minimum substrate-package README is shorter than the minimum collection-package README.

**§the-named-collection-package-and-substrate-policy-third-shape-emerges** — first-explicit-observation as a tier-3 meta-pattern. Cycle 337 named §the-named-four-shapes-of-README (collection + utility + substrate-policy + substrate-deep). Cycle 339 reveals a FIFTH SHAPE or a refinement of substrate-policy:

- Cycle 337 @endo/harden: substrate-policy with FULL prose (158 lines, six sections + policy details)
- Cycle 339 @endo/errors: substrate-policy with MINIMAL prose (13 lines, threat + purpose + coordination)

**§the-named-five-shapes-of-README** — collection (333) + utility (335) + substrate-policy-prose (337) + substrate-policy-minimal (339) + substrate-deep (325). First-explicit-observation as a refinement of cycle 337's four-shape categorization.

## §the-named-redacted-messages-as-package-purpose

Lines 9-10:

> For this reason, the `@endo/errors` package provides utilities for constructing errors with redacted messages.

**§the-named-redacted-messages-as-package-purpose** — first-explicit-observation. The purpose statement is direct: "the package provides utilities for X". No marketing-language; no enumeration of features; just the one-sentence purpose.

**§the-named-one-sentence-purpose-statement** — first-explicit-observation as a tier-3 meta-pattern. The README provides:
- 2-paragraph threat model (lines 3-7)
- 1-sentence purpose statement (lines 9-10)
- 1-paragraph coordination + safety-vs-debuggability (lines 11-13)

13 lines total; three structural pieces. **§the-named-three-piece-minimal-README** — first-explicit-observation. The discipline: threat-model + purpose + coordination = sufficient for a substrate-policy README at the minimum length.

## Closes citation arcs

Cycle 339 is the **documentation-side closure** of every prior cycle that imported `q`, `Fail`, `X`, or the Rejector pattern from @endo/errors. The arcs:

| Closes arc with | Arc length | Subject |
|---|---|---|
| Cycle 87 (pass-style/error.js V8 stack accessor) | 252 cycles | Error-discipline observation (passable-error validation surface) |
| Cycle 102 (patterns/checkKey.js Rejector trio) | 237 cycles | The trio pattern lives in rejector.js |
| Cycle 134 (remotable.js Confirm trio) | 205 cycles | Uses Fail/X |
| Cycle 138 (uses Fail from errors) | 201 cycles | Imports from @endo/errors |
| Cycle 211 (@endo/common dependency-ceiling) | 128 cycles | Names errors as substrate |
| Cycle 322 (exo-makers uses Fail via M) | 17 cycles | exo-makers binds Fail |
| Cycle 332 (exo-tools direct import q + Fail) | 7 cycles | Imports `q, Fail` from @endo/errors |
| Cycle 337 (@endo/harden README) | 2 cycles | §two-threat-models-named-in-pivot-READMEs |
| Cycle 338 (@endo/harden make-hardener.js) | 1 cycle | Cross-package designs-lane after chat-lane |

**§nine-citation-arc-closures-in-cycle-339**. **§sixty-eight-citation-arc-closures-in-pivot-now** (62 + 6 net new). The cycle 87 arc at **252 cycles** equals cycle 338's 251-cycle arc as the second-longest pivot arc (current record: 261 cycles from cycle 69 → 330).

**§the-named-substrate-package-introduction-closes-many-arcs** discipline applies for the SECOND TIME (cycle 337 + 339). **§two-cycles-with-named-substrate-package-introduction** — first-explicit-observation as a tier-2 multi-cycle pattern.

## Patterns the cycle extends

- §thirty-cycles-with-named-pivot-domain-stay (310-339)
- §fifteen-named-packages-in-the-pivot-cluster (@endo/errors joins as FIFTEENTH)
- §sixty-eight-citation-arc-closures-in-pivot-now (62 + 6 net new)
- §two-threat-models-named-in-pivot-READMEs (337 supply-chain + 339 information-disclosure-via-exception)
- §three-cycles-with-named-capability-channel-by-audience (87 + 337 + 339)
- §two-cycles-with-named-substrate-package-introduction (337 + 339)
- §five-shapes-of-README (collection + utility + substrate-policy-prose + substrate-policy-minimal + substrate-deep) — refines cycle 337's four-shape categorization
- §the-named-streak-of-zero-cross-package — cycle 337 → 338 same-package was a one-cycle resumption; cycle 338 → 339 is cross-package, so streak count is 0

## Tier-1 borrowing (twenty-plus first-explicit-observations from a 13-line README)

- **§the-named-information-disclosure-via-thrown-exception-threat-model**
- **§the-named-host-vs-guest-information-disclosure**
- **§the-named-symmetric-disclosure-risk-named-twice**
- **§the-named-host-AND-guest-guest-disclosure-symmetry**
- **§the-named-redacted-messages-as-package-purpose**
- **§the-named-package-coordinates-with-named-other-package** — substrate-coordination named explicitly
- **§the-named-coordination-with-ses-for-console-reveal** — named coordinated package + named purpose
- **§the-named-redacted-vs-revealed-asymmetry** — two audiences, different privileges
- **§the-named-two-audiences-different-privileges**
- **§the-named-NEW-SHORTEST-README-in-pivot** — 13 lines
- **§the-named-thirteen-line-README-as-floor**
- **§the-named-substrate-policy-vs-collection-package-shape-distinct**
- **§the-named-substrate-policy-README-can-be-13-lines**
- **§the-named-five-shapes-of-README** — refines cycle 337's four-shape categorization
- **§the-named-one-sentence-purpose-statement**
- **§the-named-three-piece-minimal-README** — threat-model + purpose + coordination

## Tier-2 borrowing (multi-cycle patterns extended)

- §thirty-cycles-with-named-pivot-domain-stay
- §fifteen-named-packages-in-the-pivot-cluster
- §sixty-eight-citation-arc-closures-in-pivot-now
- §two-threat-models-named-in-pivot-READMEs (337 + 339)
- §three-cycles-with-named-capability-channel-by-audience (87 + 337 + 339)
- §two-cycles-with-named-substrate-package-introduction (337 + 339)
- §five-shapes-of-README

## Tier-3 borrowing (meta-patterns)

- **§the-named-information-disclosure-via-thrown-exception-threat-model** — canonical threat model for the exception channel; complement to cycle 337's supply-chain-attack threat model
- **§the-named-two-threat-models-name-different-attack-surfaces** — substrate-packages name DIFFERENT threats at DIFFERENT layers; not redundant
- **§the-named-package-coordinates-with-named-other-package** — when a package depends on another for its defense, name the coordination directly in the README
- **§the-named-redacted-vs-revealed-asymmetry** — route different content to different audiences based on capability
- **§three-cycles-with-named-capability-channel-by-audience**
- **§the-named-five-shapes-of-README** — collection + utility + substrate-policy-prose + substrate-policy-minimal + substrate-deep
- **§the-named-three-piece-minimal-README** — threat-model + purpose + coordination = 13 lines

## Synthesis-target

Slot machine library **§`@game/errors/README.md`** — substrate-policy-minimal README:

1. **Threat model named first** — different from the framework-level threat (cycle 337's supply chain); this one is *information disclosure via thrown exception*
2. **Symmetric disclosure named twice** — host→guest AND guest→guest (player-vs-player as well as house-vs-player)
3. **One-sentence purpose** — *"the package provides utilities for constructing X"*
4. **Coordination with named other package** — if defense requires coordination with another package, name it directly
5. **Redacted vs revealed asymmetry** — different content for different audiences (player sees redacted; operator console sees full)
6. **Three-piece minimal README** — threat + purpose + coordination = 13 lines is sufficient

## Library state after cycle 339

- §library-reaches-851-sections from 384 source documents (new section + new source page)
- §one-hundred-and-seventy-second consecutive designs-chat alternation
- §thirty-cycles-with-named-pivot-domain-stay (milestone: 30 consecutive cycles in the pivot)
- §fifteen-named-packages-in-the-pivot-cluster (@endo/errors joins as FIFTEENTH)
- §sixty-eight-citation-arc-closures-in-pivot-now (62 + 6 net new)
- §two-threat-models-named-in-pivot-READMEs (337 + 339) established as tier-2 multi-cycle pattern
- §three-cycles-with-named-capability-channel-by-audience (87 + 337 + 339)
- §the-named-five-shapes-of-README established as tier-3 meta-pattern refining cycle 337
- §the-named-NEW-SHORTEST-README-in-pivot named as a discipline-floor observation
- §the-named-three-piece-minimal-README established as tier-3 meta-pattern
- §the-named-package-coordinates-with-named-other-package established as tier-3 meta-pattern
- §the-named-redacted-vs-revealed-asymmetry established as tier-3 meta-pattern
- §the-named-information-disclosure-via-thrown-exception-threat-model established as canonical threat anchor for the @endo/errors layer
- §two-cycles-with-named-substrate-package-introduction (337 + 339) — the substrate-package-introduction-closes-many-arcs librarian discipline now spans two applications
