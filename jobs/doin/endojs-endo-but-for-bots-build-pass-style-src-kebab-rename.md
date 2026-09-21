---
priority: normal
posted_by: producer
posted_at: 2026-09-21T21:00:00Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---

---
role: builder
---

# Build: regularize `@endo/pass-style` src file naming to kebab-case

**Origin.** Maintainer directive on the design PR
[endojs/endo-but-for-bots#1293](https://github.com/endojs/endo-but-for-bots/pull/1293)
(review [5271683202](https://github.com/endojs/endo-but-for-bots/pull/1293#pullrequestreview-5271683202)):
"Let's skip committing this design and move directly to building. Close this PR."
The design doc is deliberately **not** being landed; PR #1293 is being closed. This
job carries the full build spec so it does not depend on the uncommitted design.

**Repo:** `endojs/endo-but-for-bots`. **Base:** `llm`. Do the rename as its **own
draft PR against `llm`** — a reviewable pure rename plus import rewrites, with the two
byte-array test files reconciled into one. Under the manual-gauntlet regime the build
**stops at an open DRAFT PR**; do not stage a gauntlet.

## What to build

Rename every multi-word file under `packages/pass-style/src/` (and its `test/`) so the
base name is lowercase words joined by hyphens (kebab-case). Single-word files
(`error.js`, `remotable.js`, `string.js`, `symbol.js`, `tagged.js`, `types.js`) are
already conformant and unchanged. **No exported symbol changes** — `passStyleOf`,
`makeTagged`, `deeplyFulfilled`, `ByteArrayHelper`, etc. keep their names; only file
paths move. The package's public surface (`index.js`, `endow.js`, `tools.js`) is
unchanged for consumers.

### Source files (`packages/pass-style/src/`)

| From | To |
|------|-----|
| `byteArray.js` | `byte-array.js` |
| `copyArray.js` | `copy-array.js` |
| `copyRecord.js` | `copy-record.js` |
| `deeplyFulfilled.js` | `deeply-fulfilled.js` |
| `makeTagged.js` | `make-tagged.js` |
| `passStyleOf.js` | `pass-style-of.js` |
| `typeGuards.js` | `type-guards.js` |
| `passStyle-helpers.js` | `pass-style-helpers.js` |

### Test files (`packages/pass-style/test/`)

| From | To |
|------|-----|
| `deeplyFulfilled.test.js` | `deeply-fulfilled.test.js` |
| `passStyleOf.test.js` | `pass-style-of.test.js` |
| `byteArray.test.js` | `byte-array.test.js` (**merge target**) |

`byteArray.test.js` -> `byte-array.test.js` **collides** with the existing 23-line
`byte-array.test.js`. Reconcile by folding the smaller file's `passStyleOf` smoke test
into the 404-line brand-check file and keeping a single `byte-array.test.js`; delete
the redundant original. (`type-guards.test.js` already exists in kebab form.)

### Import / reference rewrites

Rewrite every import specifier that names a renamed file. Do a scripted
search-and-replace over the eight old base names, restricted to
`packages/pass-style/` — then **verify no stray hit** outside the intended set. Also
update the shipped-source **comment-only** references (not imports) in sibling
packages for accuracy: `packages/harden/make-hardener.js` and
`packages/ses/src/make-hardener.js` both cite `pass-style/src/passStyle-helpers.js`
(fix in this PR). `packages/ses/src/commons.js` cites `pass-style/src/error.js`
(unchanged — leave it).

### tsconfig

No tsconfig edit is expected: `tsconfig.json` includes `src/**/*.js` by glob and its
explicit entries (`src/types.d.ts`, `src/types.test-d.ts`) are not renamed;
`tsconfig.test-types.json` likewise. **Confirm** by running `yarn lint:types` after
the rename rather than trusting the glob.

## Procedure

1. `git mv` each source and test file per the tables (git records renames, keeps blame).
2. Rewrite every import specifier at the edit sites; verify no stray hits.
3. Merge `byte-array.test.js`'s smoke test into the renamed 404-line file; delete the
   redundant original.
4. Run the package's full CI-equivalent check locally before pushing: `yarn lint`
   (`lint:types` + `lint:eslint`), `yarn test`, and `yarn test:types`. A CI lint/test
   failure here would be an avoidable automation gap — run the CI-equivalent set first.

## Scope decisions (settled by the maintainer directive — do NOT re-open)

- **Kebab, not camel.** Build the kebab-case plan above.
- **Paths only, no symbol renames.**
- **`pass-style` only** for this PR (not marshal / patterns) — the deliberate first
  step. Do not widen scope.
- **Accept fork-local divergence** from upstream `endojs/endo`; do not attempt an
  upstream-first coordination in this build.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-21T21:13:06Z
