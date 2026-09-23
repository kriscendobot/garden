---
title: The single most structurally interesting move
source: endo--packages-init-source-cluster
url: https://github.com/endojs/endo/tree/master/packages/init
authors: [Kris Kowal, Endo project (collective)]
repo: endojs/endo
path: packages/init/{index.js,debug.js,unsafe-fast.js,legacy.js,debug-async-hooks.js,pre.js,pre-remoting.js,pre-bundle-source.js}
total-lines: 66
ingest-cycle: 344
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-README-curates-subset-of-implementation-rungs
  - the-named-five-rungs-in-implementation-vs-three-in-README
  - the-named-two-shapes-of-tolerance-ladder-rung
  - the-named-re-export-from-variant-vs-direct-call-with-options
  - the-named-orchestration-via-import-graph
  - the-named-tiny-files-where-the-COMPOSITION-is-the-content
  - the-named-layered-shim-with-named-addition
  - the-named-pre-remoting-adds-eventual-send-to-pre
  - the-named-base64-and-promise-kit-as-canonical-pre-lockdown-shims
  - the-named-export-star-from-named-lockdown-variant
  - the-named-direct-import-and-call-when-custom-options
  - the-named-deprecated-with-named-replacement-in-source
  - the-named-async_hooks-patch-with-named-platform-limitation
  - the-named-doubled-underscores-as-internal-API-marker
  - the-named-complementary-lens-re-ingest
  - seven-cycles-with-named-complementary-lens-re-ingest
  - the-named-streak-resumes-with-twelfth-instance
  - thirty-five-cycles-with-named-pivot-domain-stay
  - one-hundred-five-citation-arc-closures-in-pivot-now
parent: endo--packages-init-source-cluster--seventh-complementary-lens-README-curates-subset-of-implementation-rungs
---

**§the-named-README-curates-subset-of-implementation-rungs** — cycle 343's README named **three rungs** of the tolerance ladder:

| README rung | Cycle 343 |
|---|---|
| `@endo/init` (default) | Lines 1-15 |
| `@endo/init/debug.js` | Lines 18-43 |
| `@endo/init/unsafe-fast.js` | Lines 47-52 |

Cycle 344's implementation reveals **FIVE actual rungs** plus three preamble files:

| File | Lines | Role | In README? |
|---|---|---|---|
| `index.js` | 6 | Default entry point | **YES** (named `@endo/init`) |
| `debug.js` | 6 | Less-safe + better debugging | **YES** |
| `unsafe-fast.js` | 8 | Extreme: `__hardenTaming__: 'unsafe'` | **YES** |
| `legacy.js` | 12 | Loosest: severe + verbose + unsafe-error | **NO** |
| `debug-async-hooks.js` | 12 | Debug + Node.js async_hooks patch | **NO** |
| `pre.js` | 7 | Shim preamble (lockdown + base64 + promise-kit) | Indirectly via `@endo/init/pre.js` |
| `pre-remoting.js` | 7 | pre.js + eventual-send/shim | Indirectly |
| `pre-bundle-source.js` | 8 | DEPRECATED — replaced by `@endo/init` | Not mentioned |

**§the-named-five-rungs-in-implementation-vs-three-in-README** — first-explicit-observation. The README's three rungs are a **curated user-facing subset**; the implementation has **five rungs** (adding `legacy.js` and `debug-async-hooks.js` for specific niches).

**§the-named-README-curates-subset-of-implementation-rungs** — first-explicit-observation as a tier-3 meta-pattern. The README simplifies the surface for the reader; the source reveals the full architecture. Tier-3 framing: README documentation can DELIBERATELY UNDERSTATE the implementation's complexity to keep the user-facing surface tractable; the full rungs are discoverable from the source.

Compare to:
- Cycle 326 @endo/patterns/index.js: deprecated re-exports kept for backward compatibility (canonical-path-vs-backward-compatibility-path)
- Cycle 337 @endo/harden's isFake-deprecated-with-named-regret (regret about an existing option)
- Cycle 343 @endo/init's three-rung documentation
- **Cycle 344's revelation: README documents three; implementation provides five**

**§the-named-curated-vs-full-API-distinction** — first-explicit-observation as a tier-3 meta-pattern. The README's *curated* API is what we want users to default to; the *full* API includes rungs that exist for specific niches (legacy migration + Node.js async_hooks debugging).
