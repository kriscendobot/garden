---
kind: result
role: liaison
dispatch-root: dispatches/liaison--a0214a
cycle: 332
lane: chat
host: endolin
date: 2026-06-15
---

# Result — liaison cycle 332: @endo/exo src/exo-tools.js (chat-lane; fourth complementary-lens re-ingest; deprecation-pointers-followed-in-practice)

Cycle 332 ingest: **@endo/exo src/exo-tools.js** (513 lines) — complementary-lens re-ingest of cycle 118's same file. **Twenty-third consecutive non-garden source after the pivot** (cycles 310-332). **§twenty-three-cycles-with-named-pivot-domain-stay**.

## Two milestones this cycle

**§four-cycles-with-named-complementary-lens-re-ingest** (322 exo-makers + 324 atomics + 330 smallcaps + 332 exo-tools) — the librarian discipline is now established across **four applications**.

**§five-cycles-with-named-one-cycle-README-source-arc** (323→324 + 325→326 + 326→327 + 328→329 + 331→332) — the dense pair-landing discipline now spans **five applications**. README/source pairs landing one cycle apart has become a recognizable rhythm in the pivot.

## Single most structurally interesting move

**§the-named-deprecation-pointers-followed-in-practice** — line 14-15 of exo-tools.js imports `listDifference` and `objectMap` *directly* from `@endo/common`, NOT from `@endo/patterns`:

```js
import { listDifference } from '@endo/common/list-difference.js';
import { objectMap } from '@endo/common/object-map.js';
```

Cycle 326's `@endo/patterns/index.js` had these exact exports marked `@deprecated` with canonical pointers (*"Import directly from @endo/common/list-difference.js instead"*). Cycle 332's exo-tools.js **follows the deprecation pointer in practice**.

**§the-named-deprecation-as-soft-contract-with-followed-pointer** — first-explicit-observation. The @deprecated tag isn't aspirational; sibling code in the same family honors it. **§the-named-internal-consumers-follow-deprecation-pointers** — INTERNAL consumers in @endo/* follow the canonical direct-import path; EXTERNAL consumers can still use the deprecated re-export for backward compatibility. **§the-named-canonical-path-vs-backward-compatibility-path-distinction**.

This is the **implementation-side closure** of cycle 326's deprecation discipline. Cycle 326 (designs-lane) said *"Import directly from @endo/common"*; cycle 332 (chat-lane) does exactly that, six cycles later.

## Import-graph cross-package substrate

Lines 1-17 of exo-tools.js import from **six @endo packages plus one local file**. Six citation arcs close:

| Closes arc with | Arc length |
|---|---|
| Cycle 118 self (via complementary-lens) | 214 cycles |
| Cycle 321 (eventual-send; E import) | 11 cycles |
| Cycle 325 (pass-style; Far + getRemotableMethodNames + toThrowable) | 7 cycles |
| Cycle 326 (patterns deprecation pointers) | 6 cycles (deprecation-followed) |
| Cycle 327 (patterns README) | 5 cycles |
| Cycle 331 (exo README) | 1 cycle (FIFTH one-cycle README↔source arc) |

**§forty-one-citation-arc-closures-in-pivot-now** (35 + 6).

## §the-named-three-sentinel-set-discipline

Three module-scope sentinels (lines 29-44):

| Sentinel | Type | Role |
|---|---|---|
| `RawMethodGuard` | MethodGuard | No enforcement; "anything goes" escape hatch |
| `REDACTED_RAW_ARG` | string | Redaction marker for raw-arg pattern-matching |
| `PassableMethodGuard` | MethodGuard | Least non-raw enforcement (implied by all other non-raw guards) |

**§the-named-string-sentinel-for-pattern-match-redaction** — REDACTED_RAW_ARG is `'<redacted raw arg>'`, a human-readable sentinel string visible in debug output. First-explicit-observation.

## Other notable observations

- §the-named-zero-copy-when-possible-discipline — defendSyncArgs reuses original syncArgs if no redaction needed; only copies when necessary
- §the-named-redact-before-harden-discipline — redact slots with sentinels BEFORE harden() so original values stay unfrozen
- §the-named-Reflect-destructure-grows-with-adoption — cycle 314/318 had `{apply}` one name; cycle 332 has `{apply, ownKeys}` two names; §three-cycles-with-named-Reflect-destructure-at-module-load
- §the-named-fan-out-import-graph-recurs — cycle 322 exo-makers had 5 external imports; cycle 332 exo-tools has 6 external + 1 local; §two-cycles-with-named-fan-out-import-graph-from-exo
- §the-named-eight-named-imports-from-patterns — four functional categories (assertion + builder + predicates + extractors); §the-named-multi-categorical-import-from-one-package
- §the-named-only-one-local-import — exo-tools is the BOTTOM of the exo internal layer; §the-named-substrate-file-has-minimal-local-imports

## Multi-cycle patterns extended

- §twenty-three-cycles-with-named-pivot-domain-stay (310-332)
- §four-cycles-with-named-complementary-lens-re-ingest (322 + 324 + 330 + 332)
- §five-cycles-with-named-one-cycle-README-source-arc (323→324 + 325→326 + 326→327 + 328→329 + 331→332)
- §forty-one-citation-arc-closures-in-pivot-now
- §three-cycles-with-named-Reflect-destructure-at-module-load (314 + 318 + 332)
- §two-cycles-with-named-fan-out-import-graph-from-exo (322 + 332)
- §the-named-citation-arc-from-cycle-118-self-takes-214-cycles-to-close (matches cycle 322 exo-makers 214-cycle self-arc; second-equal-longest self-arc)

## Tier-3 meta-patterns

- **§the-named-deprecation-as-soft-contract-with-followed-pointer** — @deprecated tag is a soft contract honored by internal consumers
- **§the-named-canonical-path-vs-backward-compatibility-path-distinction** — deprecated re-export for external; canonical direct-import for internal; the two paths coexist
- **§the-named-three-sentinel-set-discipline** — three orthogonal sentinels at module scope for protocol vocabulary
- **§the-named-zero-copy-when-possible-discipline** + **§the-named-redact-before-harden-discipline**
- **§the-named-Reflect-destructure-grows-with-adoption** — substrate disciplines scale by adoption rate and aggressiveness
- **§the-named-substrate-file-has-minimal-local-imports** — bottom-most file imports almost nothing local
- **§the-named-fan-out-import-graph-recurs** — substrate files have wide import-graphs across many packages

## Synthesis-target

Slot machine library **§`@game/exo/src/exo-tools.js`** — method-defense substrate:

1. Follow deprecation pointers in practice
2. Three-sentinel set at module scope
3. Zero-copy-when-possible discipline
4. Redact before harden
5. Reflect destructure at module load
6. Multi-categorical import from one package
7. Substrate file has minimal local imports
8. Canonical-path-vs-backward-compatibility-path distinction

## Library state after cycle 332

- §library-reaches-844-sections from 378 source documents (source count unchanged because exo-tools was already counted from cycle 118)
- §one-hundred-and-sixty-fifth consecutive designs-chat alternation
- §twenty-three-cycles-with-named-pivot-domain-stay
- §eleven-named-packages-in-the-pivot-cluster
- §forty-one-citation-arc-closures-in-pivot-now (six in this cycle)
- §four-cycles-with-named-complementary-lens-re-ingest (librarian discipline confirmed across four applications)
- §five-cycles-with-named-one-cycle-README-source-arc (dense pair-landing across five applications)

## Next cycle pacing

Cycle 333 is designs-lane next. Candidate moves:

- **@endo/promise-kit README.md** — would introduce a twelfth package; cycle 152 ingested memo-race.js
- **@endo/common README.md** — would introduce a twelfth package; cycle 326 + 332 both cited @endo/common for canonical imports; closes those arcs explicitly
- **@endo/init README.md** — cycle 329 marshal README and cycle 331 exo README both cite @endo/init as the canonical harden installer
- **@endo/harden README.md** — could close arcs to every cycle that imports harden (essentially every pivot source)
- **@endo/errors README.md** — referenced in many source files for Fail + q + X

@endo/common README is the most productive (twelfth package; closes arcs with cycles 326 + 332 explicitly via the deprecation discipline; @endo/common is the canonical home for listDifference + objectMap; would close the deprecation-pointers-followed arc with documentation-side closure). Picking freely but tracking for future work.
