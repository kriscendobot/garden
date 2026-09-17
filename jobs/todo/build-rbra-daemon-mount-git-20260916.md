---
tier: mentor
handler-timeout: 10800
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-17T01:55:08Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 10800
---
Adopt ReadableBlob range attenuation (`range`/`textRange`) in the DAEMON, MOUNT,
and GIT blobs, on endojs/endo-but-for-bots, continuing the design
`designs/readableblob-range-attenuation.md`. This is step 1's remaining
producers (the platform in-process blobs `LocalBlob`/`BlobRef` are already done
in draft PR endojs/endo-but-for-bots#1301).

STACK ON THE EXISTING PR. Get the isolated project checkout with
`ensure-project-worktree.sh <base> endojs/endo-but-for-bots build/readableblob-range-attenuation`
then `git reset --hard kriscendobot/build/readableblob-range-attenuation` to
resume from #1301's head; commit and push back to
`kriscendobot:build/readableblob-range-attenuation` (base `llm-387ea66`).
Re-adopt the PR with `ensure-pr.sh <base> endojs/endo-but-for-bots kriscendobot:build/readableblob-range-attenuation llm-387ea66`
(it finds #1301 by the job marker — do not open a new PR).

This stage stays ADDITIVE (keep `fetch`/`rangeRead`/`rangeReadText`; the clean
break is the next child). The shared helpers already exist and are exported from
`@endo/platform/fs/lite`: `assertByteRange`, `assertLineRange`,
`composeByteInterval`, `lineRangeToByteSlice` (see
`packages/platform/src/fs/range-attenuation.js`, and the platform pattern in
`local-blob.js` / `fs/extended/shared/blob-ref.js`).

Add `range(start,end)`/`textRange(startLine,endLine)` to:
- `packages/daemon/src/manager.js` — `makeReadableBlob` (content-store backed,
  `readRange(offset,length)`+`size()`) and `makeBytesBlob` (captured bytes).
- `packages/daemon/src/mount.js` — `makeMountFileExo` (live file via
  `filePowers.readFileRange`) and `makeReadableBlobView`. Live semantics: each
  op observes the source subject to the fixed interval.
- `packages/git/src/native-git-backend.js` — `makeGitBlob` (whole-object bytes
  via `readBlobBytes`).

Extend the guards those exos use so makeExo accepts the two methods: the daemon
`BlobInterface` in `packages/daemon/src/interfaces.js` (add
`rangeAttenuationMethodGuards`, imported from `@endo/platform/fs/lite`), and the
shared `ReadableBlobRangeInterface` in `packages/platform/src/fs/interfaces.js`
(used by mount + git). NB: adding to `ReadableBlobRangeInterface` forces EVERY
exo using it to implement `range`/`textRange` — enumerate them first (mount
`makeReadableBlobView`, git `makeGitBlob`, and check `agent-tools` type-only
use) so none breaks. Keep the type side additive (do not widen the shared
`ReadableBlobRange` type in a way that breaks the daemon `@satisfies`; mirror the
`ReadableBlobRangeRead` approach already used).

`range` resolves synchronously (returns the derived exo remotable; guard
`.returns(M.remotable('ReadableBlob'))`); `textRange` is async (`.returns(M.promise())`).
For the daemon/git/mount, the derived range exo can re-invoke the same factory
with a composed absolute interval — retain only the source cap + interval, no
formula/name/persistence entry for derived ranges.

Tests (required): daemon `packages/daemon/test/{endo,mount,git}.test.js` and the
mount conformance tests — nested byte ranges, byte-after-text/text-after-byte,
terminal-LF, CRLF, EINVAL, `start===end`, EOF clamp, LIVE MOUNT changes, and
REVOCATION (a range of a revoked mount view revokes with it).

Verify per skills/local-verify and pre-push gates: at minimum
`packages/{daemon,git,platform}` lint + lint:types + relevant ava. Push and keep
the PR draft. Report what changed and whether the clean-break child can proceed.
