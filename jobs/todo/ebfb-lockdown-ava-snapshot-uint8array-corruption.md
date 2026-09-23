---
role: fixer
repo: endojs/endo-but-for-bots
branch: llm
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Fix: ava snapshots written under lockdown are corrupt (immutable-arraybuffer replaces global Uint8Array)

Found while running the clean stage of the PR #1100 gauntlet
(https://github.com/endojs/endo-but-for-bots/pull/1100, fix commit aeba1a3f81).

**Symptom.** On `llm` (seen at f9cbcfc), when a test file imports `@endo/init/debug.js`
and then calls `t.snapshot(...)`, a `--update-snapshots` run (or a first-time snapshot)
writes a `.snap` whose per-snapshot `data` is CBOR-encoded as a `{ "0": …, "1": … }` map
instead of a byte string. The file ends up ~15x larger, and every later read fails in ava with
`TypeError [ERR_INVALID_ARG_TYPE] … Received undefined at Function.from (node:buffer)`.
To reproduce, a two-line probe in packages/platform/test is enough:
`import '@endo/init/debug.js'; import test from 'ava'; test('p', t => t.snapshot([{a:1}]));`
It writes successfully on the first run and fails on the second.

**Root cause.** The immutable-arraybuffer view emulation (#475: 486b86afd8, 0114e790a1;
packages/immutable-arraybuffer/src/lib.js around the `{ name: 'Uint8Array', Constructor }`
table) replaces the global `Uint8Array` during lockdown. ava 8.0.1's snapshot-manager has
already done `types.registerEncoder(Uint8Array, writeUint8Array)` with cbor2 at module load,
using the ORIGINAL constructor. Inside the worker, `types.get(value.constructor)` now misses,
and cbor2 falls back to encoding the typed array as a plain object.

**Ask.** Fix this at the root so that updating snapshots on llm yields readable files again.
Options: keep constructor identity for the global typed-array constructors, or otherwise make
existing references to the original `Uint8Array` still match; failing that, a test-harness
workaround. Add a regression test that writes a snapshot under `@endo/init` and reads it back.
Any snapshot file regenerated since #475 landed may be corrupt. Sweep for them with
`git ls-files '*.snap'` plus a decode check, and fix any you find.
