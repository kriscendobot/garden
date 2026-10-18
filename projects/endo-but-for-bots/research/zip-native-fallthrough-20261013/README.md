# Finding: `@endo/zip` falling through to Node.js's native ZIP implementation

Job `endo-zip-native-node-fallthrough-investigation-20261013` (researcher, 2026-10-18).
Repo: endojs/endo-but-for-bots @ `llm`, package `packages/zip` (v1.1.0).
**Recommendation: do not proceed.** Revisit only when (a) the `node:zlib` ZIP API
reaches Stability 2 (Stable) and (b) the oldest Node line the repo supports ships it.
Even then, use it only as an explicit opt-in, never as a silent fall-through,
because parity cannot be achieved by construction (see § 2).

## 1. What Node.js provides (measured, not assumed)

Root `engines`: `"node": "^20.17.0 || >=22.9.0"`, which is open-ended, so 26 is in range.

| Node line | Archive API in `node:zlib` | Deflate layer |
| --- | --- | --- |
| 20.x | none | `zlib.*RawSync`, `CompressionStream('deflate-raw')` |
| 22.x (probed v22.23.2) | none | the same, plus `zlib.crc32` |
| 24.x (probed v24.21.0) | none | the same, plus zstd |
| 26.x (probed v26.12.0) | `ZipBuffer`, `ZipFile`, `ZipEntry`, `createZipArchive[Sync]`, `zipFiles`, `get/setMaxZipContentSize`; **added v26.8.0 (2026-08-26, nodejs/node#64339), "Stability: 1.0 Early development"**, and the first use emits an `ExperimentalWarning` to stderr | the same |

The 26 API covers in-memory read (zero-copy `ZipBuffer`), file-backed
read/write (`ZipFile`), and streaming read and write. Its methods are store,
deflate, and zstd (93). It writes Zip64 automatically and reads it. Encryption
is rejected at read time. It handles data descriptors, directory and symlink
entries, and Unix mode with the setuid, setgid, and sticky bits. Timestamps
come from the NTFS, UT, or Ux extra fields, falling back to DOS time. Names are
decoded from the Unicode Path field, or as UTF-8 when the bytes are valid UTF-8,
otherwise as CP437. A 256 MiB content ceiling guards against zip bombs. The API
saw several hardening fixes in 26.8 through 26.12, such as rejecting ambiguous
archive ends and local/central header mismatches, so its behavior is still
changing across minor versions.

The deflate layer **already** falls through to native code today:
`@endo/zip/deflate.js` and `inflate.js` use `CompressionStream` and
`DecompressionStream`, which Node implements on zlib. Measured on 22, 24, and
26, `deflate()` output is byte-identical to `zlib.deflateRawSync`
(`cstream.mjs`). The only gap left at that layer is a synchronous
`inflateNow`/`deflateNow`. A caller already fills it by passing
`zlib.inflateRawSync`/`deflateRawSync` as options, and the harness does exactly
that.

## 2. Parity: differential harness results (`parity.mjs`, `results-node26.jsonl`)

Run with: `node26 parity.mjs <endo-checkout>/packages/zip`. The harness has 9
write cases, 2 determinism checks, and 25 read cases. It covers success,
malformed, and hostile inputs.

**Write: byte parity 0/9.** Every archive differs starting at byte 4. That is
the version-needed field: Endo writes 0 and Node writes a real version. Node
also adds a UT extra field when the timestamp is an odd second, changing the
length from 114 to 132 bytes. It silently falls back to *store* when deflate
would not shrink the data (369 vs 364 bytes). It defaults `modified` to *now*,
so two otherwise identical archives differ; Endo defaults to DOS time 0 and is
deterministic. Cross-reading works both ways for every case: each side reads the
other's output correctly.

**Read: 4 SAME, 9 BOTH-REJECT (with different error shapes), 7 BOTH-OK-DIFFER, 5 NATIVE-ACCEPTS-ENDO-REJECTS, 0 the reverse.**

- Native accepts what Endo rejects **on purpose**:
  - an archive comment, and trailing bytes after the end-of-central-directory
    record. Endo seeks the record at a fixed `length - 22` offset to avoid
    attackable ambiguity (`format-reader.js` comment).
  - a *local/central name mismatch*. Node treats the central directory as
    authoritative; Endo refuses the archive outright.
  - the *encrypted* flag. Endo fails at open; Node fails only when the entry is
    read.

  Each case loosens a security stance Agoric chose deliberately.
- The same input gives different successful results:
  - DOS time 0 decodes to `1979-11-30` (Endo) vs `1980-01-01` (Node).
  - The repo's own `_fixture.zip` reads 7 hours apart, because Node uses the UT
    extra field in UTC while Endo reads DOS time as UTC.
  - A non-UTF-8 name decodes to U+FFFD (Endo) vs CP437 `é` (Node).
  - A symlink comes back as a regular file with mode 777 (Endo) vs a typed
    symlink (Node).
  - A directory entry is dropped (Endo) vs typed (Node).
  - Zstd entries decode only on Node.
  - A declared 2 GiB size is accepted at open and served (Endo) vs
    `ERR_ZIP_ENTRY_TOO_LARGE` (Node).
- Error shapes always differ. Endo throws plain `Error`s with prose messages,
  some of which callers and tests match on. Node throws coded errors such as
  `ERR_ZIP_INVALID_ARCHIVE`, `ERR_ZIP_UNSUPPORTED_FEATURE`,
  `ERR_ZIP_ENTRY_CORRUPT`, and `ERR_ZIP_ENTRY_TOO_LARGE`.
- Zip64: Endo throws `Cannot read Zip64`; Node reads and writes it.

Conclusion: a fall-through cannot keep "the exact behavior it has today." It
would need a shim that re-imposes Endo's rejections, re-derives Endo's
timestamps, re-maps errors, and re-serializes output. That is a second ZIP
implementation on top of the native one, which defeats the purpose.

## 3. Engine baseline recognition

- **Feature detection** (`typeof zlib.ZipBuffer === 'function'` in a module that
  only the `node` export condition selects) is cheap and reliable. It fails
  open: on Node 20, 22, and 24 the property is undefined and the pure-JS path is
  used. Importing `node:zlib` does not trigger the experimental warning; using
  the API does. It works under SES `lockdown()` (`lockdown.mjs`: round-trip ok,
  frozen intrinsics). Detection alone cannot tell a "correct" minor from an
  early one: 26.8 lacks the 26.9–26.12 hardening, so a correctness gate would
  need a version floor as well.
- **`engines`-conditioned optional-dependency split: does not work.** Measured
  with Yarn 4.13.0 and `nodeLinker: pnpm`, the repo's configuration
  (`yarn-engines-probe.*`):
  - A `cpu`-gated optional dependency gets a lockfile `conditions: cpu=s390x`
    line, so Yarn can skip it.
  - An `engines`-gated optional dependency (`node >=99`) gets **no condition**
    and is resolved, fetched, and linked anyway. Yarn Berry does not enforce
    `engines`.
  - npm only warns by default (`engine-strict=false`).

  More basically, `engines` describes the *install-time* Node, not the runtime.
  A lockfile shared across Node versions, an in-place Node upgrade, bundlers,
  and vendored or no-install consumers all break that link. Any split fails
  *open to the native variant being present*, so it needs runtime detection
  anyway.
- **Conditional `exports`** (`node` vs `default`) is the correct seam for
  keeping `node:zlib` out of browser, XS, and other bundles. But `node` matches
  20, 22, and 24 as well, so it only works together with runtime feature
  detection. A custom condition such as `endo-native-zip` would serve as an
  opt-in flag.

So the only reliable recognizer is **`node` export condition plus runtime
feature and version check**, and it fails open to pure JS.

## 4. Risks

- **Stability.** The API is experimental, gained hardening in four
  consecutive minor releases, and emits a process warning. Behavior drift across
  minors is already observed.
- **Security.** On untrusted archives the native reader is *more permissive*
  than `@endo/zip` in the ways the Endo reader deliberately forbids (comments,
  trailing data, header mismatch). For `@endo/compartment-mapper` archives,
  which are content-addressed bundles that may come from untrusted sources,
  this loosens the parser's attack surface. The native side does offer
  zip-bomb ceilings and a C++ fast path.
- **Supply chain.** A same-package conditional module adds no new package. An
  optional-dependency split would add a published package, plus lockfile churn
  across every consumer.
- **SES/hardened.** Usable after lockdown in the probe. Returned `Buffer`s are
  not hardened and are subclassed `Uint8Array`s, which changes the identity
  that callers of `ZipReader` observe today.
- **Bundle size and compartment-mapper.** No gain for browsers or XS, which
  still need the pure-JS path. Node bundles would grow by the shim, and
  compartment-mapper's archive determinism (archive hashes) would break if the
  writer fell through.

## Possible follow-up (not posted)

A small, behavior-preserving improvement remains: an opt-in `@endo/zip/node.js`
(`node` export condition) that exports `inflateNow`/`deflateNow` bound to
`zlib.inflateRawSync`/`deflateRawSync`. Today every Node caller hand-wires these.
It does not touch the archive parser or writer, so it keeps parity by
construction.
