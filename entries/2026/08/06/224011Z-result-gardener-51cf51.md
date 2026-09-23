---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-06T22:40:13Z
---
---
kind: result
role: warden
repo: endojs/endo-but-for-bots
project: endo
---

# Panel: warden -- endojs/endo-but-for-bots PR #910 (re-panel, diff base a3064e1a2)

**Verdict: request-changes**

## Findings

**1. must-fix -- unhardened named export.** `packages/platform/src/fs/blob-range.js:127`
`export async function* encodeBase64Chunks` has no `harden(encodeBase64Chunks)`.
AGENTS.md (Hardened JavaScript conventions): "Every named export MUST have a
corresponding `harden(exportName)` call immediately after the declaration." The
file's other two module functions are hardened (`:386`, `:410`), the code this PR
deletes was hardened (`harden(bytesFromRange)` in `mount.js`, `manager.js`), and
`blob-ref.js:82` imports and streams through this one. An unhardened
async-generator function is mutable by any importer in the realm, `.prototype`
included, which every generator object it mints inherits from. (Could not run
`@endo/harden-exports` here; the plugin is not installed in this worktree, so
whether CI catches it is unverified.) The unexported helpers `streamWindowBase64`,
`assertOffset`, `assertLineIndex`, `lineByteSpan`, `minBigInt` are outside the
rule but inconsistent with `makeAttenuatedBlob` right beside them.

**2. should-fix -- a stated attenuation invariant the codebase does not hold.**
`packages/git/src/native-git-backend.js:1908` asserts `slice` "not `subarray` ...
never a view onto the whole object's `ArrayBuffer`; the other four range producers
copy too, and a view would let the first method that hands bytes out leak past the
attenuation to the full object." False for the daemon on XS:
`bus-manager-rust-xs-powers.js:162` `readFileRange` returns
`bytes.subarray(offset, ...)` over the whole file's buffer, and `mount.js:1564` /
`manager.js:1857` route `readWindow` straight through it. Latent today (nothing
hands the array out), but the comment records an invariant a future zero-copy
method would inherit wrongly from an attenuated cap. Copy in the daemon
`readWindow` wrappers, or correct the claim.

**3. should-fix -- `getInfo()` on a derived range can mint a content address for
bytes it did not read.** `blob-range.js:296` hashes one `readWindow` result. The PR
establishes this hazard itself and fixes it only in `local-blob.js:41-52` (loop;
never derive length from `stat().size`, because a `/proc`/FIFO `size: 0` "would ...
let `getInfo`/`text` mint a false content address (the SHA-256 of the empty string)
for a file that has content"). Both daemon adopters call
`filePowers.readFileRange`, which at `manager-node-powers.js:294-300` clamps to
`stat().size` and issues a single `handle.read`. So on an `EndoMountFile` over a
zero-stat virtual file, `range(0n).getInfo()` reports sha256("") / `size: 0n` while
the base `text()` returns real content; and `streamWindowBase64:174` reads a
short-but-not-EOF result as end-of-content, silently truncating an attenuated
`streamBase64`. An attenuated blob is handed to a less-trusted holder and `getInfo`
is the identity that holder trusts, so a wrong hash is a boundary defect, not just a
read bug. The new mount tests exercise regular temp files only.

**4. should-fix -- the attenuation-identity fix landed at one adopter.**
`local-blob.js:120-128` moved `text`/`json` to `bytesToText` precisely so
`range(0n).text()` equals whole-value `text()` on a BOM'd file. `mount.js:1629`
still uses `filePowers.readFileText` (`manager-node-powers.js:248` =
`fs.readFile(path,'utf-8')`), and the stored blob's `text`/`json` come from
`content-store.js:85-88` on the same power, while their derived ranges decode via
`bytesToText`. Verified by execution: on a UTF-8 BOM file `readFileSync(p,'utf-8')`
gives `"﻿hi"` (3 units), `new TextDecoder().decode(...)` gives `"hi"` (2). So
`EndoMountFile.text() !== (await file.range(0n)).text()` -- the identity the
LocalBlob commit was written to restore.

**5. comment-only -- `json()` returns an unhardened parse result.**
`blob-range.js:279` returns raw `JSON.parse` from an exo guarded only by
`M.promise()`. Parity with `mount.js:1630` and `blob-ref.js:110`, so not a
regression, but this module is the new consolidation point: a non-frozen copyRecord
is unmarshallable over CapTP, and a `"__proto__"` key in holder-supplied JSON
becomes an own property that travels onward. Harden here even if the older sites
keep parity.

## Verified clean (warden surface)

- `intersectInterval` (`blob-range.js:243`) narrows monotonically: `composedStart >=
  absoluteStart`, `composedEnd <= absoluteEnd`, and the start is clamped to the
  parent end so no inverted interval is mintable. No derived range can regain
  authority outside its parent, including via `textRange` on a growing live file.
- `makeBlobRangeMethods:405` hardens a snapshot of the source record, so a producer
  retaining the record it passed cannot swap `readWindow`/`hashBytes` under an
  already-issued attenuated blob. The claim in the docstring holds.
- Mount `readWindow` (`mount.js:1546-1548`) re-asserts `assertLive()` and
  `assertConfined()` per read, so revocation and confinement bind every derived
  range, not just the base file. `makeReadableBlobView` delegates `range`/`textRange`
  without widening: `RichReadableBlobInterface` carries no write methods.
- `getInfo` returns `harden({...})` on every adopter. No `globalThis` writes, no
  prototype walking, no `eval`/`new Function`, and no unsafe sample in the docs diff
  (`help.md`, `designs/*`).

Self-improvement: the strongest findings here came from taking the PR's own
justificatory comments as assertions to test against the other adopters -- the
LocalBlob short-read/BOM comment and the GitBlob "the other four producers copy too"
comment each named an invariant that one sibling producer violates. Proposing to
`skills/panel-hints/SKILL.md`: when a PR consolidates N call sites onto one shared
maker, read each rationale comment as a claim quantified over all N and check the
other N-1; a fix applied at the site where the author noticed the hazard is the
common shape of an incomplete consolidation.
