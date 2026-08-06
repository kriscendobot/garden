---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-06T06:29:33Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
pr: 909

## wire-watcher

**Verdict: request-changes**

Diff base `origin/llm`, head `89110084f`. Scope: `packages/cli/src/cli-archive.js`, the three command call sites, fixtures and tests.

Integrity mechanics check out: the parser returns the stripped bytes, `import-hook.js:474` hashes those same bytes, and the recorded `parser` is the delegate's output language (`mjs`/`cjs`), so archives stay self-consistent and readers need no TypeScript parser. `strip-only` is position-preserving, so no source map is owed. Good.

### 1. Non-fatal UTF-8 decode silently rewrites archived source (should-fix)

`packages/cli/src/cli-archive.js:16` builds `new TextDecoder()`, which defaults to `fatal: false`. Every byte that is not valid UTF-8 becomes U+FFFD, and line 62 re-encodes that lossy text as the archived module bytes. The sha512 is computed over the corrupted re-encoding, so nothing downstream can detect the substitution.

Verified by execution (latin-1 `.ts` source, bytes `ff fe 20 63 61 66 e9`):

```
archive built OK -> imported value "�� caf�"
```

The archive built and imported clean, reporting no problem. This is the first CLI path where archived bytes are not the file's bytes: `parse-mjs.js:27` returns its input bytes unchanged, so a `.js` file's bytes reach the archive verbatim. A truncated read or a latin-1 source is corrupted rather than rejected. Use `new TextDecoder('utf-8', { fatal: true })` and route the decode failure through the same `makeError`. [rule: skills/adversarial-tests/SKILL.md, parser-divergence category]

### 2. The documented `node_modules` boundary yields a broken archive, not an error (should-fix)

The changeset says TypeScript under `node_modules` must still be built. That boundary produces no archive-time failure. Verified:

```
makeCliArchive(app importing a dep whose main is ./index.ts)
  -> archive built, 1218 bytes, no error
  -> at import: Cannot parse module ./index.ts ... no parser configured for the language ts
```

`endo archive` therefore stores and names a blob on the agent that can never be imported, and `endo make` stores one whose failure surfaces only when the confined program reaches that module. Pre-existing behavior, but this PR is what makes developers walk into it. Pin it with a fixture and a test, and consider failing at archive time.

Also untested: invalid UTF-8 (finding 1) and a `.ts` whose stripped output differs from a sibling `.mts` of the same basename. Credit where due: `test/typescript-archive.test.js:66-68` already asserts the unsupported-syntax error names both the file and `enum`, which is the paranoid extra this seat usually has to ask for.

### 3. The parser table stopped being pinned (should-fix)

Before: `commands/archive.js` passed `{ ...archiveOptions, parserForLanguage: sourceParserForLanguage }`. The pin came after the spread, so no caller could substitute a parser. Now `cli-archive.js:96-99` spreads `options.parserForLanguage` over the defaults, so anything reaching `archiveOptions` can replace the `mjs`, `cjs`, or `json` parser, and a parser controls exactly the bytes that get archived and hashed. Today the only caller is `src/endo.js:694` passing `{ commonDependencies }`, so it is not reachable; but `archiveCommand` is exported and its JSDoc now advertises the full `ArchiveOptions` type. Either narrow the accepted overrides to the `mts`/`cts` slots, or say in the `cli-archive.js:73-75` docstring that a supplied JavaScript parser determines the archived bytes. The delegation test at `test/typescript-archive.test.js:25` depends on the wide form, so this is a deliberate choice that wants documenting rather than a slip.

### 4. Archive bytes are a function of an unpinned dependency (should-fix)

`packages/cli/package.json:50` takes `amaro: ^1.1.9`. The stripper's whitespace substitution is what lands in the archive, so the per-module sha512 and the archive's own hash now vary with whichever amaro a given install resolved. Two hosts building from identical sources can produce different archives. `packages/bundle-source/package.json:32` carries the same caret, so this is consistent with precedent rather than new, but the CLI is where archives become stored, named blobs. State the stability guarantee in the changeset, or pin exactly. [proposed-rule: when a build artifact's bytes are content-addressed, the tool that generates those bytes is pinned exactly, or the docstring states that the artifact is not byte-reproducible across tool versions]

### 5. Minor (comment-only)

- `cli-archive.js:47-52` flattens the amaro error to `q(message)` and drops the original. swc errors carry a multi-line code frame, which `q` renders as escaped `\n`. Prefer `makeError(X`Cannot strip types from ${q(moduleLocation)}`, { cause: error })`, matching `map-parser.js:144`.
- `cli-archive.js:96` uses `||` where `??` is meant; a falsy supplied parser falls back silently. The line is also redundant with the preceding spread.
- `commands/run.js:139` changed a static import to `await import('../cli-archive.js')` while `make.js` and `archive.js` import statically. If the intent is to defer amaro's wasm load off the run-an-existing-archive path, say so; as written the deferral is inconsistent and reads accidental.
- `transformSync` is synchronous, yet both parsers declare `synchronous: false`. Harmless here (the archive path has no `importNowHook`, so nothing turns on the sync narrowing at `map-parser.js:330`), and it matches bundle-source. Noted so a future reader does not assume the async wrapper is load-bearing.

Self-improvement: nothing this time.
