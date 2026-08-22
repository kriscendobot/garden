---
gate: go-ahead
priority: normal
posted_by: producer
posted_at: 2026-08-22T15:27:19Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
tier: mentor
---
# Fix: `endo make` / `endo archive` TypeScript support is broken (endojs/endo-but-for-bots#909)

Root-caused during the pr909 gauntlet (mentor job pr909-5e6ae075). The PR's changeset
claims "endo run, endo make, and endo archive now accept TypeScript sources," but only
`endo run` actually works. `endo make` (and by extension `endo archive` -> `endo run
--archive`) with a TypeScript source produces a module that LOSES its exports/methods.

## Reproduction (CI, PR #909 head 625294058b)
- `demo/index › typescript-confined-script` (endo run typescript-runlet.ts) → PASS
- `demo/index › counter-example` (endo make counter.js + E(counter).incr()) → PASS
- `demo/index › doubler-agent` (endo make doubler.js + incr) → PASS
- `demo/index › typescript-confined-artifacts` (endo make typescript-counter.ts, then
  `endo eval E(ts-counter).incr() ts-counter`) → FAIL:
  `RemoteTypeError: target has no method "incr", has []`
  (the made Counter exo exists as `Object [Alleged: Counter] {}` but has NO methods).

So it is specifically the `.ts` + daemon-`make` path. JS make works; TS run works; TS make fails.

## What is NOT the cause (verified locally)
- The strip-only transform is correct: amaro strips `demo/typescript-counter.ts` to valid
  JS preserving `incr()`.
- The archive `makeCliArchive` builds is correct: it stores the STRIPPED source tagged
  `"parser": "mjs"` in compartment-map.json, and an IN-PROCESS
  `parseArchive(bytes, {parserForLanguage: defaultParserForLanguage}).import()` then
  `namespace.make()` returns a Counter whose `incr()` returns 1. (This is byte-for-byte the
  same import path `endo run --archive` uses, which is why `run` works.)
- `import-archive-all-parsers.js` has NO mts/cts parser (only mjs/cjs/pre-*), and BOTH the
  CLI `run` path and the daemon worker (packages/daemon/src/worker.js makeArchive) use that
  SAME set — so it is not a parser-set difference either.

## Where the bug lives
Exclusively in the daemon confined-worker instantiation path
(`packages/daemon/src/worker.js` `makeArchive`: parseArchive + application.import({globals:
endowments}) + `namespace.make(powers, context, {env})`). The identical call succeeds
in-process but the daemon yields a methodless Counter for the stripped-TS module while
succeeding for the equivalent hand-written JS module. Needs daemon-level debugging (this
could not be reproduced in the gardener sandbox, which has no linked `endo` daemon binary;
CI is the daemon environment — iterate by pushing candidate fixes and reading the
`test (NN.x, ...)` demo jobs).

Candidate angles: (a) does the daemon worker re-derive a language from the `.ts` file
EXTENSION and re-handle the module differently than its `mjs` compartment-map tag; (b) a
compartment-mapper version/precompile skew between the CLI-built archive and the daemon's
parseArchive; (c) hardening/Far differences in the daemon confined realm for the stripped
source's shape.

## Scope decision for the maintainer/author (dckc) — pick ONE
1. FIX the daemon `make`/`archive` TS path so `typescript-confined-artifacts` passes
   (honors the changeset claim). Preferred if the daemon bug is tractable.
2. NARROW the changeset claim to `endo run` only, drop the `typescript-confined-artifacts`
   make/archive assertions (keep the run coverage), and file the make/archive gap as a
   follow-up. This is the corner-prober's explicitly-offered alternative in panel-1
   must-fix #1.

Do NOT un-draft until one of these lands and CI is green.

## Prereqs already done by pr909-5e6ae075
- Head rebased onto current origin/llm (tsconfig `exclude` conflict resolved), amaro
  aligned `^1.1.9` -> `^1.1.11` to match llm, yarn.lock regenerated, pushed as 625294058b.
- Separately, the TypeDoc `test` (docs) check is red on TS type errors in
  `packages/cli/test/typescript-archive.test.js` (TS2556 line 32; TS2322 lines 77,132) —
  the `...rest`/spy-parser types need tightening (local `lint:types` misses them because
  cli tsconfig sets `checkJs:false`; TypeDoc's config checks them). Fix these too.
