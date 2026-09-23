---
title: '@endo/check-bundle: index.js + lite.js + src/json.js'
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/check-bundle
source_paths:
  - packages/check-bundle/index.js
  - packages/check-bundle/lite.js
  - packages/check-bundle/src/json.js
authors:
  - Kris Kowal (prompted)
ingested: 2026-06-03
ingested_by: scholar
topics:
  - capability-security
  - bundles
  - hardened-javascript
sections:
  - endo--packages-check-bundle-js--powered-and-powerless-symmetric-pair-with-frozen-bundle-assertion-and-design-boundary-migration.md
genre: §endo-source-comment-fragment §canonical-powered-powerless-pair
cycle: 185
lane: chat
---

# @endo/check-bundle: powered + powerless bundle hash verification

## Files

| File | Lines | Role |
|------|-------|------|
| `packages/check-bundle/index.js`    | 43 | Powered shim (fs + crypto + encodeHex) |
| `packages/check-bundle/lite.js`     | 93 | Powerless core (computeSha512 as parameter) |
| `packages/check-bundle/src/json.js` | 22 | parseLocatedJson helper |

## §Abstract

`@endo/check-bundle` verifies that an Endo bundle (a JSON
object with `moduleFormat`/`endoZipBase64`/`endoZipBase64Sha512`
fields) is hash-consistent with its declared sha512. The
package is split into two layers:

- **Powerless core** (`lite.js`, 93 lines) — takes
  `(bundle, computeSha512, bundleName)`; runs in any SES
  realm; no `fs` or `crypto` imports.
- **Powered shim** (`index.js`, 43 lines) — provides
  `computeSha512` via Node's `crypto.createHash('sha512')` +
  `encodeHex` from `@endo/hex`; provides `checkBundleBytes`
  (adds TextDecoder + JSON.parse + harden) and
  `checkBundleFile` (adds fs.readFile).

§The-canonical-§ocap-discipline-via-explicit-power-injection
pattern in distilled form: the powerful affordances (filesystem
+ cryptography) are explicit parameters to the powerless core.

The powerless `checkBundle` enforces a §record-of-strings shape
on the bundle (frozen + no getters + no non-string values), then
dispatches by `moduleFormat`:

- `endoZipBase64`: decode base64 → parseArchive (from
  @endo/compartment-mapper) with `{ computeSha512,
  expectedSha512 }` → assert hash matched.
- `getExport` / `nestedEvaluate`: explicitly reject with named
  reason ("not necessarily consistent" across toolchain
  versions).
- Unknown: reject as unrecognized.

§The-`parseLocatedJson` helper (22 lines) wraps `JSON.parse`
with `SyntaxError`-rewrapping that adds file location to the
diagnostic.

## §Files and identifiers

| File | Lines | Role |
|------|-------|------|
| `packages/check-bundle/index.js`    | 43 | Powered shim |
| `packages/check-bundle/lite.js`     | 93 | Powerless core |
| `packages/check-bundle/src/json.js` | 22 | parseLocatedJson helper |

## §Provenance and dependencies

- §Built-on `@endo/base64/decode.js` (cycle 181) — decodes
  `endoZipBase64` field.
- §Built-on `@endo/hex` (cycle 180 design + post-migration
  implementation) — `encodeHex` for sha512 digest stringification.
- §Built-on `@endo/compartment-mapper/import-archive.js` —
  `parseArchive` performs the hash-of-hashes verification.
- §Built-on `@endo/errors` — `Fail`, `X`, `q` template tags.
- §Built-on `@endo/harden` — `harden(bundle)` in
  checkBundleBytes path.

## §Related sources in the library

- §Cycle 180 (`endo-but-for-bots--llm-designs-hex-package.md`)
  — design's §audit-table predicted check-bundle/index.js
  line 14 would be §retained-at-boundary; the actual source
  migrated to use `encodeHex(hash.digest())` — a §gap-between-
  design-and-implementation worth recording.
- §Cycle 181 (`endo--packages-base64-src-encode-decode-js.md`)
  — `decodeBase64` is the entry point for the endoZipBase64
  field; the §pre-lockdown-shim-discipline named there
  cascades to this consumer.
- §Cycle 183 (`endo--packages-init-and-lockdown.md`) — the
  shim assembly that makes `Fail` / `q` / `assert` available
  in this file.
- §Cycle 87 (SES error/assert) — `Fail` template tag substrate.
- §Cycle 172 (`endo-but-for-bots--llm-designs-endo-bytes.md`)
  — §module-scoped-TextEncoder-and-TextDecoder discipline
  applied here for the TextDecoder used in checkBundleBytes.
- §Cycle 90 (`endo--packages-eventual-send-src-track-turns-js.md`)
  — §async-boundary-discipline sibling for the `await null`
  pattern at function start.

## §Comment fragments worth preserving

```
Verifies that a bundle passes its own integrity checks or
rejects the returned promise with an error.
Asserts that the bundle is frozen to guard against
inconsistent accessors or get traps.
```

§The-frozen-bundle-assertion's rationale named explicitly in
the JSDoc. §The-design-anchor for why freezing is required
before vouching.

```
checkBundle cannot determine hash of bundle with ${moduleFormat}
moduleFormat because it is not necessarily consistent
```

§The-§unstable-format rejection reason. §getExport-and-
nestedEvaluate produce JavaScript-source bundles whose hash
depends on whitespace, source-map encoding, ordering — §unstable-
across-toolchain-versions.

```
Cannot parse JSON from ${q(location)}, ${error}
```

§The-`parseLocatedJson` rewrap shape. §Always-include-file-
location in JSON parse errors. §Sibling-discipline to cycle 181-
base64's error-rewrapping-with-name.
