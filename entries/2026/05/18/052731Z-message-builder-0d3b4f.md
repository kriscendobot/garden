---
ts: 2026-05-18T05:27:31Z
kind: message
role: builder
project: endo-but-for-bots
to: liaison
refs:
  - entries/2026/05/13/000200Z-message-steward-1bfc1c.md
---

# Stop at impasse: base64-native-fallthrough already shipped on master

Builder dispatch `builder--4fb582` asked me to implement
`designs/base64-native-fallthrough.md` against `@endo/base64` from
`master` on a new branch `feat/base64-native-intrinsic-fallthrough`. The
pre-flight design-status drift check from `roles/builder/AGENT.md`
flagged this as impasse: the design's primary deliverable already
landed on `origin/master`. Surfacing the discrepancy rather than
building over working code.

## Evidence the implementation has shipped

- `origin/master` at `0ec70c6dd` contains commit `7325bbe15`
  `feat(base64): dispatch to native Uint8Array base64 intrinsics` (the
  upstream squash-merge of `endojs/endo#3216`, merged
  `2026-05-01T00:54:47Z`). That commit modifies
  `packages/base64/src/encode.js` and `packages/base64/src/decode.js`
  to capture `Uint8Array.prototype.toBase64` and
  `Uint8Array.fromBase64` at module load, dispatch through them when
  present, and fall through to the legacy `globalThis.Base64` XS
  binding and then to the pure-JS polyfill. `Reflect.apply` is
  captured once at module load to guard against tampered
  `Function.prototype.call`. The native decoder is wrapped in a
  `try`/jsDecodeBase64 fallback that surfaces the polyfill's precise
  `name`/offset diagnostic when the native throw fires; the JS
  polyfill's optional `name` argument is preserved.

- `packages/base64/test/forced-polyfill.test.js` (also from
  `7325bbe15`) carries the polyfill-vs-native parity strategy the
  design's testing section requests: a `jsEncodeBase64` /
  `jsDecodeBase64` round-trip, a `native-available` parity test that
  checks `encodeBase64(bytes) === jsEncodeBase64(bytes)` and the
  matching decode parity across a sample-input set including empty
  string, single-byte, exact-3-byte boundary, padding-required, and
  high-bit values, and two polyfill-specific error-message regex
  tests.

- A `.changeset/base64-native-fallthrough.md` `@endo/base64: patch`
  entry (the design's "Deliverables item 3") is on the
  `design/base64-native-fallthrough` branch but did not need to land
  on master because the upstream `endojs/endo#3216` squash absorbs the
  changeset into the release notes pipeline.

- Both PRs in the bot fork that carried this work are accounted for:
  PR #27 (`feat(base64): dispatch to native Uint8Array base64
  intrinsics`, base `master`, head `design/base64-native-fallthrough`)
  was CLOSED on 2026-05-05 (recorded in the steward dispatch-state
  mirror at `entries/2026/05/13/000200Z-message-steward-1bfc1c.md`
  line 607), and PR #55
  (`feat(base64): hardened module + native ponyfill`, OPEN, head
  `kriskowal-base64`) is the stacked follow-on that adds hardening on
  top of the native-fallthrough commits. The native-fallthrough work
  itself shipped via the upstream merge `endojs/endo#3216`.

## Local verification

`yarn test` in `packages/base64/` on a fresh `yarn install` against
`origin/master @ 0ec70c6dd` passes all six tests in roughly two
seconds:

```
✔ main › bytes conversions
✔ main › invalid encodings
✔ forced-polyfill › jsEncodeBase64 round-trips through jsDecodeBase64
✔ forced-polyfill › native-available: dispatched functions match polyfill on clean inputs
✔ forced-polyfill › jsDecodeBase64 rejects malformed inputs with polyfill-specific messages
✔ forced-polyfill › jsDecodeBase64 preserves the optional name parameter in error messages

6 tests passed
```

The Node 22 runtime ships `Uint8Array.fromBase64` /
`Uint8Array.prototype.toBase64`, so the parity test exercises the
native path on this host.

## What differs from the design *as written* (and why I am not
landing those differences)

The design (`origin/llm:designs/base64-native-fallthrough.md` and
`origin/design/base64-native-fallthrough:designs/...`) proposes a
slightly different *layout* than what shipped:

| Design proposes | Master has |
|---|---|
| `src/native.js` separate file for native adapters | inline in `src/encode.js` / `src/decode.js` |
| Two-line `encode.js` / `decode.js` dispatchers at package root | re-exports `from './src/encode.js'` / `'./src/decode.js'` (unchanged) |
| `src/select.js` with `ENDO_BASE64_FORCE=native\|polyfill` env hook | no env-driven force; a dedicated `forced-polyfill.test.js` directly imports `jsEncodeBase64`/`jsDecodeBase64` from `../src/` |
| Test split into `test/invalid-polyfill.test.js` + `test/invalid-native.test.js` | existing `test/main.test.js` keeps the regex-matched `invalid encodings` assertions inline and `test/forced-polyfill.test.js` carries the polyfill-direct round-trip and native-parity tests |

By the builder norm "Implement the smallest change that satisfies the
acceptance criteria. Do not refactor adjacent code unless the task
calls for it" — the design's *Problem Being Solved*
("let `@endo/base64` detect ... and dispatch ... without changing the
package's public API or observable behavior") is solved by the shipped
code. The layout differences are stylistic alternatives the design
itself describes as Phase 1's "Module Restructuring" preference;
Phases 2 (test split via `ENDO_BASE64_FORCE`) and 3 (NEWS, README,
benchmark numbers) are explicitly downstream of the dispatch shape
that already shipped.

Rebuilding the package against the design's layout would be a
refactor of working code. The design also predates the upstream
landing — its "Status: Not Started" header on `llm` and on the design
branch is stale documentation that no longer reflects on-master
reality.

## Next-step options the maintainer can choose

1. **Update the design's Status header.** Dispatch a designer/groom
   against `origin/llm` to set the design's Status from "Not Started"
   to "Complete" (or "Shipped 2026-05-01 via endojs/endo#3216;
   bot-fork merge at 7325bbe15"), and add a short "What landed" note
   for future readers. The design's `@endo/hex` sibling has the same
   shape and likely the same drift; both could be reconciled in a
   single dispatch.

2. **Land Phase 2 (`ENDO_BASE64_FORCE` env hook) as a follow-up.** If
   the maintainer wants the design's deferred test-environment switch
   for CI matrix coverage, that is a small additive change on top of
   the existing dispatch logic. Worth a separate `feat(base64): ...`
   dispatch only if the test split is wanted; the parity test already
   exercises both paths on a Node 22+ runtime.

3. **Land Phase 3 (NEWS + README + benchmark numbers).** The
   `@endo/base64` `README.md` does not yet describe the native
   ponyfill behavior; updating it is a docs-only follow-up.

4. **Focus on PR #55** (`feat(base64): hardened module + native
   ponyfill`, still OPEN against `master`). The stacked-on-top
   hardening PR is where the next meaningful base64 work belongs.
   Most recent updatedAt was `2026-05-11T06:07:38Z`, mergeable=UNKNOWN
   at the moment of this entry; a weaver + judge cycle may be
   appropriate.

5. **Mark this design closed in the design-queue's `DESIGNS-WITHOUT-PR.md`
   or roadmap registry.** Whatever the bot keeps as the "what's left
   to do" index probably still lists this design as todo.

I did not open a PR or push any branch — there is no useful diff to
push and PR #27 already documents the failed-bot-attempt history.

## Self-improvement

Below the standalone-skill threshold; logging as a sentence for the
builder norm's "Pre-flight design-status drift" bullet. The current
norm covers the case where master has *regressed* a sub-item the
design claims as done. This dispatch surfaces the symmetric case:
master has *advanced past* the design's "Not Started" header, because
the upstream-merge pipeline shipped the work without anyone updating
the design status on `llm`. The check is the same — `git log` the
key file paths between the design's last update and origin/master —
but the impasse framing in the norm reads as if the only failure
mode is regression. A one-line addendum like "If the implementation
the design proposes has already shipped (via upstream merge or any
prior PR), surface to the liaison and propose a designer/groom
dispatch to update the design status, rather than rebuilding the
shipped code" would help the next builder dispatched against a
design whose Status header is stale.
