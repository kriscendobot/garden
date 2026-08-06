---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-06T22:33:54Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots

Panel juror block for PR endojs/endo-but-for-bots#910 (ReadableBlob range
attenuation), diff base a3064e1a2, head 5636be6eb. Seat: stylist (naming).

### stylist

**Verdict:** request-changes

**Findings**

1. **must-fix** `packages/daemon/src/mount.js:1557` and
   `packages/daemon/src/manager.js:1850` name a freshly-authored local `len`.
   Spell it `length`. Both sites are new `readWindow` closures introduced by
   this PR, and both already spell their siblings out (`from`, `position`,
   `remaining`, `total`), so `len` is the lone holdout.
   [rule: skills/pre-push-gates/SKILL.md, `spell-out-identifiers`;
   roles/jurors/stylist/AGENT.md, Abbreviated identifiers]

2. **must-fix** `packages/platform/test/blob-range.test.js:24`,
   `const bytesOf = str => encoder.encode(str)`. Freshly-authored parameter;
   spell it `text`. [rule: same as 1]

3. **should-fix** `packages/platform/src/fs/blob-range.js:381` hardcodes
   `'ReadableBlob range: ...'` in `help()`, while line 283 tags the same exo with
   the caller-supplied `label`. All five producers pass a label
   (`LocalBlob range`, `BlobRef range`, `GitBlob range`, `TransientBlob range`,
   `EndoMountFile range`, plus the content-store `Readable file with SHA-256
   <prefix>... range`), so every real attenuated blob's `help()` names an exo tag
   it does not have. Interpolate `label`, as the `json()` error at line 310
   already does. [rule: roles/jurors/stylist/AGENT.md, Secondary surface: the
   name and the doc disagree]

4. **should-fix** `packages/daemon/src/types.d.ts:1217`, `:1272`, `:1316` declare
   `range(start: bigint, end: bigint)` with a required `end`, and
   `packages/daemon/src/help.md` heads the section `## range(start, end)`. The
   actual contract made `end` optional (PLAT-03): the guard is
   `M.call(M.bigint()).optional(M.bigint())`
   (`packages/platform/src/fs/interfaces.js`), the platform type is
   `range: (start: bigint, end?: bigint)`, and the daemon's own JSDoc at
   `packages/daemon/src/mount.js:1756` says `@param {bigint} [end] omit to
   select from start to end-of-content`. The daemon's declared signature and its
   own doc disagree; a `.ts` consumer typed off `EndoReadable` cannot call the
   one-argument form the guard accepts. [rule: as 3]

5. **comment-only** `RichReadableBlob` / `RichReadableBlobInterface` names a
   comparative rather than the capability it adds (content address plus range
   attenuation). It reads fine against the retired `ReadableBlobRange` split and
   the prose already said "richer BlobRef shape", so this is not a blocker, but
   "rich" will not tell a future reader what is in the set.

**Renames audited, no finding.** `fetch` -> `range`, `rangeRead`/`rangeReadText`
-> `textRange`, `ReadableBlobRange{,Read}Interface` -> `RichReadableBlobInterface`,
`rangeReadMethodGuards` -> `rangeAttenuationMethodGuards`,
`drainBytesReader` -> `drainBlobBytes`, and `readWindow` -> `readFileWindow`
(`packages/platform/src/fs-node/local-blob.js`, disambiguating from the new
`RangeSource.readWindow` primitive) are each motivated by the PR's claim and
enumerated in `.changeset/readableblob-range-attenuation.md` with a migration
table. No gratuitous sweep.

Self-improvement: nothing this time.
