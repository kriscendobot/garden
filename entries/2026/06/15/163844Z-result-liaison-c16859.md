---
kind: result
role: liaison
dispatch-root: dispatches/liaison--c16859
cycle: 339
lane: designs
host: endolin
date: 2026-06-15
refs:
  - 2026/06/15/160637Z-result-liaison-4a7901.md
---

# Result — liaison cycle 339: @endo/errors README.md (designs-lane; FIFTEENTH PACKAGE; NEW SHORTEST README in pivot at 13 lines; information-disclosure-via-thrown-exception threat model; NINE citation-arc closures including 252-cycle arc to cycle 87)

Cycle 339 ingest: **@endo/errors README.md** (13 lines). Designs-lane after cycle 338's chat-lane @endo/harden/make-hardener.js — **cross-package** (harden → errors), so **§the-named-streak-of-zero-cross-package** (the one-cycle streak from cycle 337 → 338 ended; streak count returns to 0).

**Thirtieth consecutive non-garden source after the pivot** (cycles 310-339). **§thirty-cycles-with-named-pivot-domain-stay** — **MILESTONE: 30 consecutive cycles in the pivot**. **§fifteen-named-packages-in-the-pivot-cluster** — @endo/errors joins as the **FIFTEENTH PACKAGE** (nat + memoize + hex + lp32 + stream + eventual-send + exo + captp + pass-style + patterns + marshal + common + promise-kit + harden + **errors**).

**NEW SHORTEST README in the pivot** at **13 lines** (previous record: cycle 333 @endo/common at 17 lines). **§the-named-thirteen-line-README-as-floor** — the new minimum.

## Single most structurally interesting move

**§the-named-information-disclosure-via-thrown-exception-threat-model** — lines 3-7 open with:

> When host and guest programs share a JavaScript context, there is some risk that the guest will call a host function and induce it to throw an exception that inadvertently reveals information about its internal state to the guest.
> It is similarly possible that a guest would inadvertently reveal information to a cotenant guest.

**§the-named-information-disclosure-via-thrown-exception-threat-model** — first-explicit-observation as a tier-3 meta-pattern. The threat is **structurally different** from cycle 337 @endo/harden's *supply-chain-attack* threat:

| Cycle | Package | Threat |
|---|---|---|
| 337 | @endo/harden | Supply-chain attack via tampering with module exports |
| 339 | @endo/errors | Information disclosure via thrown exception inadvertently revealing internal state |

**§two-threat-models-named-in-pivot-READMEs** — first-explicit-observation as a tier-2 multi-cycle pattern. The two threats are at different DEFENSE LAYERS:
- Cycle 337: defends the MODULE BOUNDARY
- Cycle 339: defends the EXCEPTION CHANNEL

**§the-named-two-threat-models-name-different-attack-surfaces** — first-explicit-observation as a tier-3 meta-pattern. Each substrate-package's README names ITS own threat model; threats are not redundant across substrate-packages.

## §the-named-symmetric-disclosure-risk-named-twice

The README documents BOTH directions:
- **Host → guest**: *"the guest will call a host function and induce it to throw an exception that inadvertently reveals information about its internal state to the guest"*
- **Guest → guest**: *"a guest would inadvertently reveal information to a cotenant guest"*

**§the-named-host-AND-guest-guest-disclosure-symmetry** — first-explicit-observation. Bidirectional + lateral threat documented in two sentences.

## §the-named-package-coordinates-with-named-other-package

Lines 11-13:

> In coordination with [ses](../ses/) in the host realm, the information redacted by these utilities will be revealed to the realm's console for use in debugging, but be invisible to code that catches them.

**§the-named-package-coordinates-with-named-other-package** — first-explicit-observation as a tier-3 meta-pattern. The README NAMES THE COORDINATION explicitly with a relative path (`../ses/`). Discipline: when a package depends on another for its defense, name the coordination in the README.

**§the-named-redacted-vs-revealed-asymmetry** — first-explicit-observation. Two audiences with different privileges:

| Audience | What they see |
|---|---|
| Code that catches the error | Redacted message (safety) |
| Realm's console | Full message (debuggability) |

**§the-named-two-audiences-different-privileges** — first-explicit-observation as a tier-3 meta-pattern. **§three-cycles-with-named-capability-channel-by-audience** (87 V8-stack-accessor + 337 intrinsic-over-endowment + 339 redacted-vs-revealed).

## §the-named-five-shapes-of-README

Cycle 337 named §the-named-four-shapes-of-README (collection + utility + substrate-policy + substrate-deep). Cycle 339 reveals a FIFTH shape:

| Shape | Cycle | Package | Lines |
|---|---|---|---|
| Collection | 333 | @endo/common | 17 |
| Utility | 335 | @endo/promise-kit | 71 |
| Substrate-policy-prose | 337 | @endo/harden | 158 |
| **Substrate-policy-minimal** | **339** | **@endo/errors** | **13** |
| Substrate-deep | 325 | @endo/pass-style | 216 |

**§the-named-five-shapes-of-README** — first-explicit-observation as a tier-3 meta-pattern refining cycle 337's categorization. The substrate-policy category is parameterized by length: prose (158 lines; full policy details) vs minimal (13 lines; threat + purpose + coordination).

**§the-named-three-piece-minimal-README** — first-explicit-observation. Threat-model + purpose + coordination = 13 lines is sufficient for substrate-policy-minimal shape.

## Closes nine citation arcs

| Closes arc with | Arc length | Subject |
|---|---|---|
| **Cycle 87 (pass-style/error.js V8 stack accessor)** | **252 cycles** | Error-discipline observation; ties cycle 338's 251-cycle arc as second-longest pivot arc |
| Cycle 102 (patterns/checkKey.js Rejector trio) | 237 cycles | The trio pattern lives in rejector.js of this package |
| Cycle 134 (remotable.js Confirm trio) | 205 cycles | Uses Fail/X |
| Cycle 138 (uses Fail) | 201 cycles | Imports from @endo/errors |
| Cycle 211 (@endo/common dependency-ceiling) | 128 cycles | Names errors as substrate |
| Cycle 322 (exo-makers uses Fail via M) | 17 cycles | exo-makers binds Fail |
| Cycle 332 (exo-tools direct import `q + Fail`) | 7 cycles | Imports `q, Fail` from @endo/errors |
| Cycle 337 (@endo/harden README) | 2 cycles | §two-threat-models-named-in-pivot-READMEs |
| Cycle 338 (@endo/harden make-hardener.js) | 1 cycle | Cross-package designs-lane after chat-lane |

**§nine-citation-arc-closures-in-cycle-339**. **§sixty-eight-citation-arc-closures-in-pivot-now** (62 + 6 net new). The cycle 87 → 339 arc at **252 cycles** equals cycle 338's 251-cycle arc as the second-longest pivot arc (current record: 261 cycles from cycle 69 → 330).

**§two-cycles-with-named-substrate-package-introduction** (337 + 339) — the substrate-package-introduction-closes-many-arcs discipline now spans two applications.

## Multi-cycle patterns extended

- §thirty-cycles-with-named-pivot-domain-stay (310-339) — **MILESTONE**
- §fifteen-named-packages-in-the-pivot-cluster (@endo/errors joins as FIFTEENTH)
- §sixty-eight-citation-arc-closures-in-pivot-now (62 + 6 net new)
- §two-threat-models-named-in-pivot-READMEs (337 + 339)
- §three-cycles-with-named-capability-channel-by-audience (87 + 337 + 339)
- §two-cycles-with-named-substrate-package-introduction (337 + 339)
- §five-shapes-of-README — refines cycle 337's four-shape categorization
- §the-named-streak-of-zero-cross-package (cycle 338 → 339 cross-package)

## Tier-3 meta-patterns

- **§the-named-information-disclosure-via-thrown-exception-threat-model** — canonical threat model for the exception channel
- **§the-named-two-threat-models-name-different-attack-surfaces** — substrate-packages name DIFFERENT threats at DIFFERENT layers
- **§the-named-package-coordinates-with-named-other-package** — name the coordination directly in the README
- **§the-named-redacted-vs-revealed-asymmetry** — route different content to different audiences
- **§the-named-two-audiences-different-privileges**
- **§three-cycles-with-named-capability-channel-by-audience**
- **§the-named-five-shapes-of-README** — collection + utility + substrate-policy-prose + substrate-policy-minimal + substrate-deep
- **§the-named-three-piece-minimal-README** — threat + purpose + coordination = 13 lines is sufficient
- **§the-named-substrate-package-introduction-closes-many-arcs** (second application)

## Synthesis-target

Slot machine library **§`@game/errors/README.md`** — substrate-policy-minimal README:

1. **Threat model named first** — *information disclosure via thrown exception* (different from cycle 337's supply-chain attack)
2. **Symmetric disclosure named twice** — player-vs-house AND player-vs-player
3. **One-sentence purpose** — *"the package provides utilities for X"*
4. **Coordination with named other package** — if defense requires another package, name it
5. **Redacted vs revealed asymmetry** — player sees redacted; operator console sees full
6. **Three-piece minimal README** — threat + purpose + coordination = 13 lines is sufficient

## Library state after cycle 339

- §library-reaches-851-sections from 384 source documents
- §one-hundred-and-seventy-second consecutive designs-chat alternation
- **§thirty-cycles-with-named-pivot-domain-stay (MILESTONE)**
- §fifteen-named-packages-in-the-pivot-cluster (@endo/errors as FIFTEENTH)
- §sixty-eight-citation-arc-closures-in-pivot-now (62 + 6 net new)
- §two-threat-models-named-in-pivot-READMEs (337 supply-chain + 339 information-disclosure-via-exception) established as tier-2 multi-cycle pattern
- §three-cycles-with-named-capability-channel-by-audience (87 + 337 + 339)
- §two-cycles-with-named-substrate-package-introduction (337 + 339) established as a librarian-discipline observation
- §the-named-five-shapes-of-README established as tier-3 meta-pattern refining cycle 337's four-shape
- §the-named-NEW-SHORTEST-README-in-pivot at 13 lines
- §the-named-three-piece-minimal-README established as tier-3 meta-pattern
- §the-named-package-coordinates-with-named-other-package established as tier-3 meta-pattern
- §the-named-redacted-vs-revealed-asymmetry established as tier-3 meta-pattern
- §the-named-information-disclosure-via-thrown-exception-threat-model established as canonical threat anchor for the @endo/errors layer
- §the-named-streak-of-zero-cross-package (cycle 338 → 339 cross-package; streak count is 0)

## Next cycle pacing

Cycle 340 is **chat-lane** next. Candidate moves:

- **@endo/errors/index.js** — 132 lines; adjacent forward pair with cycle 339 README; would close cycle 339 in one cycle (tenth INSTANCE of one-cycle README↔source pattern)
- **@endo/errors/rejector.js** — 23 lines; the canonical Rejector pattern from cycle 102; tight closure of the cycle 102 → 339 → 340 chain (cycle 102 named the trio pattern that lives in rejector.js)
- **@endo/harden/index.js + noop.js + hardened.js + is-noop.js** — small entry-point cluster (77 lines total)
- **@endo/harden/make-selector.js** — 69-line sibling; cycle 175 complementary-lens candidate

@endo/errors/index.js + rejector.js would be the natural forward pair with cycle 339 README (same-package; tenth INSTANCE of one-cycle README↔source pattern; streak count would return to 1). Picking freely but tracking; the rejector.js closure of cycle 102 is particularly inviting (cycle 102 → 340 = 238-cycle arc; would close a long-standing observation cluster).
