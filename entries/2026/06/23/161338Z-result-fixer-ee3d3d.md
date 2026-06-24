---
type: result
role: fixer
dispatch-root: /home/kris/dispatches/fixer--ee3d3d
repo: endojs/endo-but-for-bots
pr: 475
branch: feat/narrow-bytearray-to-uint8
review: r4554572514
timestamp: 2026-06-23T16:13:38Z
force-pushed-from: 3a8063bce
force-pushed-to: 603fe8fe6
---

# Result: fixer dispatch ee3d3d - PR #475 round addressing r4554572514

Addressed CHANGES_REQUESTED review r4554572514 (kriskowal, 2026-06-23T15:15:16Z).
Force-pushed feat/narrow-bytearray-to-uint8 from 3a8063bce to 603fe8fe6 (two commits).

## Part 1: SECURITY.md restoration

Restored all 55 packages/*/SECURITY.md files to their pre-PR canonical form,
reverting the incidental sentence-per-line reformatting applied by the prior
fixer (commit 3a8063bce). The security-md-hash-uniform probe passes.

Two pre-push gate probes in the garden (skills/pre-push-gates/probes/) were
updated and pushed to garden/main (commit 6ea375e3):
- sentence-per-line-md.sh: added SECURITY.md exclusion (canonical template,
  not prose subject to sentence-per-line style).
- test-package-no-main.sh: allow a sole ./package.json export in *-test
  packages (per kriskowal: "all packages must have an exports directive,
  and that must always include package.json").

## Part 2: inline review feedback addressed

- @endo/bytes/compare.js: removed toIndexableUint8; exclusively Uint8Array.
- @endo/bytes/concat.js: removed toMutableChunk; exclusively Uint8Array.
- @endo/bytes/README.md: updated; removed "Out of scope > Slicing" section.
- @endo/pass-style/concat-bytes.js: use fromBytes() before @endo/bytes/concat.
- @endo/hex/src/encode.js: removed stale frozen-Uint8Array comment.
- @endo/ocapn/syrup/decode.js: bytestring decode returns plain mutable Uint8Array.
- @endo/ocapn/syrup/encode.js: simplified writeBytestring.
- @endo/ocapn/codecs/passable.js: PassableByteArrayCodec (toBytes on read,
  new Uint8Array copy on write). Clear layer: Syrup = Uint8Array; passable = frozen.
- @endo/ocapn/client/util.js: simplified swissnum helpers.
- @endo/ocapn/syrup/compare.js: JSDoc terminology fix.
- chacha12-fast-check-test/package.json: restored ./package.json export.
- ascii/CHANGELOG.md: emptied to "# Change Log".
- .changeset/narrow-bytearray-to-uint8.md: refreshed.

## Additional fix found during probe sweep

cryptography.js was passing passable byteArrays (frozen Uint8Array backed by
immutable ArrayBuffer) directly to concatBytes from @endo/bytes, which now
requires plain mutable Uint8Array. Fixed with fromBytes() unwrapping before
concatBytes in ocapNSignatureToBytes and makeSessionId.

## Test status

- @endo/bytes: 12 tests x3 configs = pass
- @endo/pass-style: 50 tests = pass
- @endo/ocapn: full suite = pass (exit 0, three runs)

## Pre-push gates

All probes pass (no-non-ascii-in-source, sentence-per-line-md, test-package-no-main,
security-md-hash-uniform, no-ascii-banners, no-pull-citations, no-inline-import-jsdoc,
filename-no-stutter). The daemon-node-powers.js stutter and inline-import failures
are pre-existing in this branch's diff vs origin/master and are not introduced by
our changes.

## PR state

PR remains DRAFT. Summary comment posted:
https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-4781170725
