## Completion report: `endo-zip-native-node-fallthrough-investigation-20261013`

**Recommendation: do not proceed.** `@endo/zip` cannot hand off to Node's native ZIP code and keep its current behavior. The finding is negative, so as the job specified I posted it as a journal message to the maintainer and opened no PR.

### What Node.js actually provides
I installed and probed each release line:
- **Node 22.23.2 and 24.21.0:** no ZIP archive API at all.
- **Node 20:** not probed directly. Node 22 already has no archive API, so 20 has none either.
- **Node 26:** a native ZIP API (`zlib.ZipBuffer`, `ZipFile`, `ZipEntry`, `createZipArchive*`) first appeared in **Node 26.8.0 (2026-08-26)**. Its docs label it "Stability: 1.0 – Early development", the first use prints an `ExperimentalWarning`, and it has had hardening fixes in every release from 26.9 to 26.12.
- The compression layer is already native on Node. `@endo/zip`'s `deflate.js` uses `CompressionStream`, which Node runs on zlib, and its output was byte-identical to `zlib.deflateRawSync` on 22, 24 and 26.

### Parity harness results (Node 26.12.0)
- **Writing: 0 of 9 cases byte-identical.** Every archive differs from byte 4 (the "version needed" field). Native also:
  - adds an extra timestamp field for odd-second dates;
  - silently stores a file uncompressed when compression wouldn't shrink it;
  - stamps entries with the current time by default, so its output is not repeatable.
- **Reading, 25 cases:**
  - 4 give the same result.
  - 9 are rejected by both, with different error shapes: Endo throws plain errors with prose messages, native throws `ERR_ZIP_*` codes.
  - 7 are read by both but with different results: timestamps, non-UTF-8 names, symlinks, directories, zstd, and size limits.
  - 5 are accepted by native but deliberately rejected by Endo: archive comments, trailing bytes, a mismatch between the two copies of a file's name, and the encrypted flag at open. Each of these is a security choice Endo made on purpose.
  - None go the other way.
- Matching Endo's behavior would mean wrapping the native code in a second ZIP implementation, which defeats the point.

### Choosing when to use native
- **Package split by `engines`: doesn't work.** In a test with Yarn 4.13 (the repo's version and linker setting), a `cpu`-restricted optional dependency got a skip condition in the lockfile. An `engines`-restricted one got none and was installed anyway. Separately, `engines` describes the Node used at install time, not the one the code later runs on.
- **What would work:** the `node` export condition plus a runtime check for the API and a minimum version. Anywhere the check fails, it falls back to the pure-JS path, which is the safe direction.
- The native API also worked after SES `lockdown()` in my test.

### Where everything is
All files are on journal2 under `projects/endo-but-for-bots/research/zip-native-fallthrough-20261013/`:
- `README.md`: the full report, including risks: supply chain, drift across Node minor versions, a looser parser on untrusted archives, `Buffer` identity, and breaking the reproducible archives `@endo/compartment-mapper` produces.
- `parity.mjs`: the harness, run as `node <node26> parity.mjs <endo>/packages/zip`. `lockdown.mjs` and `cstream.mjs` are the SES and compression checks.
- `results-node26.jsonl` and `results-v22.23.2.jsonl`: harness output.
- `yarn-engines-probe.lock` and `yarn-engines-probe.package.json`: the Yarn test.

The maintainer message (sent to the maintainer inbox) summarizes the finding and points to these files.

### Follow-ups
- **Revisit when** the native API is marked stable and the oldest Node version the repo supports includes it. Even then, offer it only as something callers opt into.
- **Optional small improvement (not posted as a job):** an opt-in `@endo/zip/node.js` that exports synchronous compress/decompress functions built on `zlib.*RawSync`. It leaves the archive reader and writer untouched, so behavior can't change.
- No garden or project code changed. The project checkout was used only to read and run the code.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-zip-native-node-fallthrough-investigation-20261013.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2448540 cached reads)
- Output: 26512 tokens
- Cost: $1.808172
- Wall-clock: 581s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
