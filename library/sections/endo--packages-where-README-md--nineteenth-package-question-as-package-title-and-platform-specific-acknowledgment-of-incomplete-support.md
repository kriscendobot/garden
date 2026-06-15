---
title: "@endo/where README.md — nineteenth package; question-as-package-title; platform-specific-acknowledgment-of-incomplete-support; XDG-with-named-where-the-spec-breaks; third substrate-policy-minimal README confirms the shape"
source: endo--packages-where-README-md
url: https://github.com/endojs/endo/blob/master/packages/where/README.md
authors: [Kris Kowal, Endo project (collective)]
repo: endojs/endo
path: packages/where/README.md
total-lines: 15
ingest-cycle: 347
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-question-as-package-title
  - the-named-package-title-as-question-form
  - the-named-platform-specific-acknowledgment-of-incomplete-support
  - the-named-XDG-with-named-where-the-spec-breaks
  - the-named-named-external-spec-with-named-limitations
  - the-named-fall-back-to-native-conventions-when-spec-doesnt-fit
  - the-named-not-yet-named-aspiration
  - the-named-where-as-user-files-and-socket-locator
  - the-named-per-user-runtime-data
  - the-named-nineteenth-package-in-the-pivot-cluster
  - the-named-fifteen-line-substrate-policy-minimal-README
  - three-substrate-policy-minimal-READMEs-confirms-the-shape
  - four-cycles-with-named-explicit-acknowledgment-of-limits
  - the-named-streak-of-zero-cross-package
  - thirty-eight-cycles-with-named-pivot-domain-stay
  - one-hundred-twenty-five-citation-arc-closures-in-pivot-now
---

# `@endo/where README.md` — nineteenth package; question as package title

The 15-line README of @endo/where — the utility that locates user files and the Endo daemon's Unix domain socket / Windows named pipe. Cycle 347 is **designs-lane after cycle 346's chat-lane @endo/ses entry-point cluster** — cross-package (ses → where). **§the-named-streak-of-zero-cross-package** — streak count returns to 0.

**Thirty-eighth consecutive non-garden source after the pivot** (cycles 310-347). **§thirty-eight-cycles-with-named-pivot-domain-stay**. **§nineteen-named-packages-in-the-pivot-cluster** — @endo/where joins as the **NINETEENTH PACKAGE** (after the eighteen named in cycle 345).

Cycle 167 already ingested `where/index.js` as a comment-fragment (named the §named-TODO observation). Cycle 347 introduces the README — the documentation-side closure for the where-package observations.

## The single most structurally interesting move

**§the-named-question-as-package-title** — line 1: *"# Where is Endo?"*

The TITLE is a QUESTION. The package's purpose is literally to ANSWER the question. The README title and the package name (@endo/where) work together to FRAME the package's purpose as a question-answering utility.

**§the-named-package-title-as-question-form** — first-explicit-observation as a tier-3 meta-pattern. Compare to:
- Cycle 333 @endo/common: `# @endo/common` (package name as title)
- Cycle 335 @endo/promise-kit: `# @endo/promise-kit` (package name as title)
- Cycle 339 @endo/errors: `# @endo/errors` (package name as title)
- Cycle 341 @endo/lockdown: `# @endo/lockdown` (package name as title)
- Cycle 343 @endo/init: `# @endo/init` (package name as title)
- Cycle 345 @endo/ses: `# SES` (acronym as title)
- **Cycle 347 @endo/where: `# Where is Endo?`** (QUESTION as title)

§the-named-package-title-as-question-form — first-explicit-observation. The package's name (@endo/where) is a WHERE question; the README title makes the question explicit (*"Where is Endo?"*). The package's API answers the question.

**§the-named-package-name-as-implicit-question** — first-explicit-observation as a tier-3 meta-pattern. Tier-3 framing: when a package's name is itself a question word (where + when + how + what), the README can make the question form explicit in the title.

## §the-named-platform-specific-acknowledgment-of-incomplete-support

Lines 8-13:

> Endo attempts to use or infer [Cross-desktop XDG conventions][XDG] paths in every meaningful way.
> Windows named pipes do not appear to fit this model.
> Otherwise falls back to the native conventions on Windows and Mac/Darwin.
> On Windows, Endo does not use separate state and cache directories and does not yet sync state between home directories.

**§the-named-platform-specific-acknowledgment-of-incomplete-support** — first-explicit-observation as a tier-3 meta-pattern. The README documents **four states** of platform support:

| Statement | Type |
|---|---|
| *"Endo attempts to use or infer XDG conventions"* | What we DO |
| *"Windows named pipes do not appear to fit this model"* | Where the SPEC BREAKS |
| *"Otherwise falls back to the native conventions"* | The FALLBACK |
| *"On Windows... does not yet sync state between home directories"* | What's NOT YET DONE |

**§the-named-XDG-with-named-where-the-spec-breaks** — first-explicit-observation. The README NAMES the spec (XDG) AND names where it fails to apply (Windows named pipes). This is the discipline: when adopting an external spec, name BOTH the spec AND its limitations.

**§the-named-named-external-spec-with-named-limitations** — first-explicit-observation as a tier-3 meta-pattern. Compare to cycle 345 @endo/ses's §the-named-override-mistake-as-named-JavaScript-anti-feature (named language wart with cite) — cycle 347's @endo/where names a positive spec but with named limitations.

**§the-named-fall-back-to-native-conventions-when-spec-doesnt-fit** — first-explicit-observation. The discipline: spec-as-primary + native-as-fallback. Named decision tree: try the spec; if it doesn't fit, use platform-native conventions.

**§the-named-not-yet-named-aspiration** — first-explicit-observation. The phrase *"does not yet"* (line 12-13) implies a future aspiration without naming a timeline. Compare to cycle 343 @endo/init's §the-named-unsafe-fast-with-named-regret-and-named-aspiration (*"we hope to obviate"*). Cycle 347's *"does not yet"* is the **softer aspiration** form.

**§four-cycles-with-named-explicit-acknowledgment-of-limits** — first-explicit-observation as a tier-2 multi-cycle pattern:

| Cycle | Package | Shape of acknowledgment |
|---|---|---|
| 337 | @endo/harden | §the-named-isFake-deprecated-with-named-regret (past design choice) |
| 343 | @endo/init | §the-named-existing-entry-point-with-named-aspiration-to-remove (existing entry point) |
| 345 | @endo/ses | §the-named-precise-claims-with-precise-caveats-discipline (full claims+caveats) |
| **347** | **@endo/where** | **§the-named-platform-specific-acknowledgment-of-incomplete-support** (platform-specific incomplete support) |

Four shapes of acknowledgment-of-limits across substrate cycles. **§the-named-honest-documentation-of-incomplete-features-discipline** — first-explicit-observation as a tier-3 meta-pattern.

## §three-substrate-policy-minimal-READMEs-confirms-the-shape

@endo/where joins cycles 339 (@endo/errors at 13 lines) and 341 (@endo/lockdown at 15 lines) in the substrate-policy-minimal category:

| Cycle | Package | Lines | Anchor |
|---|---|---|---|
| 339 | @endo/errors | 13 | Threat-model first |
| 341 | @endo/lockdown | 15 | Side-effect-import |
| **347** | **@endo/where** | **15** | **Question as title** |

**§three-substrate-policy-minimal-READMEs-confirms-the-shape** — first-explicit-observation as a tier-2 multi-cycle pattern. The shape:
- 13-15 lines
- Need-statement or purpose-statement first
- One external reference or coordination-target
- Closing limitation or aspiration

Each instance has a DIFFERENT anchor (threat-model + side-effect-import + question), but the structural shape is consistent.

**§the-named-substrate-policy-minimal-anchor-varies-but-shape-is-stable** — first-explicit-observation as a tier-3 meta-pattern.

## §the-named-where-as-user-files-and-socket-locator

Lines 3-6:

> This package provides a utility for finding the user files and Unix domain socket or Windows named pipe for the Endo daemon.
> The Endo user directory stores the per-user runtime data for Endo, including logs and other application storage.

**§the-named-where-as-user-files-and-socket-locator** — first-explicit-observation. The package's two-part purpose:
1. **Locate user files** (per-user runtime data)
2. **Locate the daemon's IPC endpoint** (Unix domain socket OR Windows named pipe)

**§the-named-per-user-runtime-data** — first-explicit-observation. The README names the SCOPE: per-user (not system-wide), runtime (not configuration), data (logs and storage).

## Closes citation arcs

| Closes arc with | Arc length | Subject |
|---|---|---|
| Cycle 346 (@endo/ses entry cluster) | 1 cycle | Cross-package |
| Cycle 345 (@endo/ses README) | 2 cycles | Substrate-introduction phase aftermath |
| Cycle 167 (where/index.js comment-fragment) | **180 cycles** | README documentation-side closure of cycle 167's source ingest |
| Cycle 187 (shim cluster — daemon discipline) | 160 cycles | Daemon-related package family |
| Cycle 211 (@endo/common dependency-ceiling) | 136 cycles | @endo/common's substrate ceiling |
| Cycle 339 (@endo/errors README) | 8 cycles | §three-substrate-policy-minimal-READMEs |
| Cycle 341 (@endo/lockdown README) | 6 cycles | §three-substrate-policy-minimal-READMEs |
| Cycle 343 (@endo/init README) | 4 cycles | §four-cycles-with-named-explicit-acknowledgment-of-limits |
| Cycle 345 (@endo/ses README) | 2 cycles | §four-cycles-with-named-explicit-acknowledgment-of-limits |

**§nine-citation-arc-closures-in-cycle-347**. **§one-hundred-twenty-five-citation-arc-closures-in-pivot-now** (120 + 5 net new).

## Patterns the cycle extends

- §thirty-eight-cycles-with-named-pivot-domain-stay (310-347)
- §nineteen-named-packages-in-the-pivot-cluster (@endo/where as NINETEENTH)
- §one-hundred-twenty-five-citation-arc-closures-in-pivot-now (120 + 5 net new)
- §three-substrate-policy-minimal-READMEs-confirms-the-shape (339 + 341 + 347)
- §four-cycles-with-named-explicit-acknowledgment-of-limits (337 + 343 + 345 + 347)
- §the-named-streak-of-zero-cross-package (cycle 346 → 347 cross-package)

## Tier-1 borrowing (twelve-plus first-explicit-observations from a 15-line README)

- **§the-named-question-as-package-title** — *"# Where is Endo?"*
- **§the-named-package-title-as-question-form**
- **§the-named-package-name-as-implicit-question**
- **§the-named-where-as-user-files-and-socket-locator**
- **§the-named-per-user-runtime-data**
- **§the-named-XDG-with-named-where-the-spec-breaks**
- **§the-named-named-external-spec-with-named-limitations**
- **§the-named-fall-back-to-native-conventions-when-spec-doesnt-fit**
- **§the-named-platform-specific-acknowledgment-of-incomplete-support**
- **§the-named-not-yet-named-aspiration**
- **§the-named-honest-documentation-of-incomplete-features-discipline**
- **§the-named-substrate-policy-minimal-anchor-varies-but-shape-is-stable**
- **§three-substrate-policy-minimal-READMEs-confirms-the-shape**

## Tier-2 borrowing (multi-cycle patterns extended)

- §thirty-eight-cycles-with-named-pivot-domain-stay
- §nineteen-named-packages-in-the-pivot-cluster
- §one-hundred-twenty-five-citation-arc-closures-in-pivot-now
- §three-substrate-policy-minimal-READMEs-confirms-the-shape (339 + 341 + 347)
- §four-cycles-with-named-explicit-acknowledgment-of-limits (337 + 343 + 345 + 347)
- §the-named-streak-of-zero-cross-package

## Tier-3 borrowing (meta-patterns)

- **§the-named-package-title-as-question-form** — when package name is a question word, README can make question form explicit
- **§the-named-package-name-as-implicit-question**
- **§the-named-named-external-spec-with-named-limitations** — name the spec AND where it fails to apply
- **§the-named-fall-back-to-native-conventions-when-spec-doesnt-fit** — spec-as-primary + native-as-fallback
- **§the-named-platform-specific-acknowledgment-of-incomplete-support** — name what platforms/features are NOT YET fully supported
- **§the-named-honest-documentation-of-incomplete-features-discipline**
- **§the-named-substrate-policy-minimal-anchor-varies-but-shape-is-stable** — same shape, different anchor concepts

## Synthesis-target

Slot machine library **§`@game/where/README.md`** — substrate-policy-minimal README for a locator utility:

1. **Question as package title** — if package answers a question, title it as the question
2. **Named external spec with named limitations** — when adopting a cross-platform spec, name both the spec AND where it doesn't apply
3. **Fall back to native conventions** when the spec doesn't fit
4. **Platform-specific acknowledgment of incomplete support** — *"does not yet"* language for soft aspirations
5. **15-line substrate-policy-minimal shape** with question-as-title anchor

## Library state after cycle 347

- §library-reaches-859-sections from 392 source documents
- §one-hundred-and-eightieth consecutive designs-chat alternation
- §thirty-eight-cycles-with-named-pivot-domain-stay
- §nineteen-named-packages-in-the-pivot-cluster (@endo/where as NINETEENTH)
- §one-hundred-twenty-five-citation-arc-closures-in-pivot-now (120 + 5 net new)
- §three-substrate-policy-minimal-READMEs-confirms-the-shape (339 + 341 + 347)
- §four-cycles-with-named-explicit-acknowledgment-of-limits (337 + 343 + 345 + 347)
- §the-named-package-title-as-question-form established as tier-3 meta-pattern
- §the-named-named-external-spec-with-named-limitations established as tier-3 meta-pattern
- §the-named-honest-documentation-of-incomplete-features-discipline established as tier-3 meta-pattern
- §the-named-substrate-policy-minimal-anchor-varies-but-shape-is-stable established as tier-3 meta-pattern
- §the-named-streak-of-zero-cross-package (cycle 346 → 347 cross-package)
