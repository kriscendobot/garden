---
ts: 2026-06-06T04:55:39Z
kind: result
role: weaver
worktree: dispatches/weaver--baa56b/project
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/06/045000Z-dispatch-weaver-baa56b.md
---

Re-synced `endo-but-for-bots#75` with upstream `endojs/endo#3232`
(branch `kriskowal-random-chacha20`) and rebased onto current bot
`master`. Push landed; summary comment posted on PR #75.

## SHAs

- Pre-rebase mirror HEAD (and verified `git ls-remote` lease anchor):
  `77f4e0526acbbb8e323c17d90c0b7f8c5bc058ff`. The dispatch brief named
  `77f4e052ed1f6ad8d09f50ab90ca27f0d716fbf2` but that SHA does not
  exist on the remote; the true lease anchor was the SHA the project
  worktree held at dispatch start, which matched `git ls-remote
  origin refs/heads/kriskowal-random-chacha12`.
- Upstream tip ingested: `71055ef17` (`endo-upstream/kriskowal-random-chacha20`).
- Rebase base: `5865ff10228464a161a942ff3500abb2c44e5a7a` (current
  `origin/master`).
- Post-rebase mirror HEAD: `675c2d77bd0b4b485592f9583344f5f216ac9b6f`.
- Commit count on branch: 10 (one upstream commit dropped as
  already-on-master; see *Dropped commit* below).

## Procedure

1. Used existing `endo-upstream` remote (already pointed at
   `ssh://git@github.com/endojs/endo.git`); skipped adding a duplicate
   `upstream`.
2. `git fetch endo-upstream kriskowal-random-chacha20`.
3. `git reset --hard endo-upstream/kriskowal-random-chacha20`
   (HEAD became `71055ef17`).
4. `git fetch origin master` (already in sync at `5865ff102`).
5. `git rebase origin/master` — conflicted on three commits; resolved
   per the no-`--ours`/`--theirs` skill (see *Conflicts* below).
6. Syntax-checked all resolved files with `node --check`.
7. `git push --force-with-lease=kriskowal-random-chacha12:77f4e0526a...
   origin HEAD:kriskowal-random-chacha12` — succeeded after correcting
   the lease anchor to the actual remote SHA.
8. Posted top-level summary comment on PR #75:
   <https://github.com/endojs/endo-but-for-bots/pull/75#issuecomment-4637446268>

## Conflicts

Three non-trivial conflict sites; one dropped commit. All resolutions
weave both intents rather than choosing one side.

### `packages/hex/test/{decode,encode}.bench.js` + `_xorshift.js`

- Upstream commit: `ce8c3370e refactor(hex): use @endo/chacha12 keystream + @endo/random/seeds for bench inputs`.
- Master commit: `c423ed37b chore(eslint-plugin): require underscore-delimited groups in numeric literals` applied underscore style to `_xorshift.js`, `decode.bench.js`, and `encode.bench.js`.
- Conflict: `_xorshift.js` was modify/delete (master modified; upstream deleted). `decode.bench.js` / `encode.bench.js` content conflict on the `defaultSeed` block.
- Resolution: honored upstream's intent (delete `_xorshift.js`; rewrite makeBytes to use `makeChaCha12(bobsCoffee32).fillRandomBytes`). The `defaultSeed` array and its eslint-disable mnemonic-seed comment vanished with the rewrite, so master's underscore-style tweaks on those literals are moot. Master's underscore-style refactor on the *surviving* literals (`200_000`, `50_000`, `1_000_000`) was already absorbed by the non-conflicted hunks; verified by grep post-rebase.

### `packages/ocapn/test/{codecs/passable-fuzz,syrup/fuzz}.test.js` + `_xorshift.js`

- Upstream commit: `5b9c35ee7 refactor(ocapn): use @endo/chacha12 + @endo/random for fuzz drivers`.
- Same shape as the hex conflict. Master underscore-styled the
  original xorshift seeds; this commit replaces the PRNG with
  `makeChaCha12(bobsCoffee32).fillRandomBytes` + `randomFloat`.
- Resolution: honored upstream's intent. The `defaultSeed` arrays and
  the Chris-Hibbert / Bob's-Coffee-Façade flavor comment are gone; the
  imports for `makeChaCha12`, `bobsCoffee32`, and `randomFloat` (`random
  as randomFloat`) are already present in the top-of-file region.
  Verified no stray `XorShift` references remain.

### `packages/ses/src/compartment.js`

- Upstream commit: `91cda2581 fix(ses): tuple-typed args restores Parameters<typeof compartmentOptions> overlap`.
- Master commit: `5065e7215 fix(ses): Consolidate Compartment jsdoc comments` (54 minutes old at dispatch time).
- Both commits independently address the same JSDoc-block-with-typing
  issue. Master collapsed two JSDoc blocks into one and chose `@param
  {...any} args` as a workaround. Upstream's branch collapsed the same
  blocks and chose `@param {CompartmentOptionsArgs|LegacyCompartmentOptionsArgs} args`
  (the typed restoration; commit message argues the typing is what
  makes `Parameters<typeof compartmentOptions>` overlap).
- Resolution: wove both. Kept master's consolidated single-block
  structure with `@this {Compartment}` first; kept upstream's *typed*
  `@param` second. Preserves master's consolidation intent (one block,
  no duplicates) AND upstream's typing intent (the real type, not
  `any`). The judgment call here is "master's `...any` was a
  side-effect of the consolidation, not the typing choice"; the
  upstream branch's typing fix is the more accurate type signature
  and now survives.

### Dropped commit

`15bfaee23 style(evasive-transform): align customVisitor JSDoc
continuation indent` was dropped by `git rebase` as already upstream.
Verified the message: "dropping 15bfaee230... -- patch contents
already upstream". Spot-check confirms `packages/evasive-transform/`
on `origin/master` already carries the alignment. Safe drop.

## Verification

- `node --check` on every resolved file: clean.
- `git diff endo-upstream/kriskowal-random-chacha20 HEAD --stat` on
  the five conflict-resolved files: deltas are exactly the
  underscore-style additions on surviving literals plus the
  compartment.js JSDoc-order weave; nothing else. The remaining 200+
  files in the diffstat are the natural divergence between upstream's
  branch tip and current master, not artifacts of conflict
  resolution.
- `git ls-remote origin refs/heads/kriskowal-random-chacha12` after
  push reports `675c2d77b...`.

## Lease-anchor correction

The dispatch brief named lease anchor
`77f4e052ed1f6ad8d09f50ab90ca27f0d716fbf2`. The actual remote SHA was
`77f4e0526acbbb8e323c17d90c0b7f8c5bc058ff`. The first six hex chars
match (`77f4e0`) but they diverge at the seventh, so the lease check
rejected the first push attempt with "stale info". The second attempt
used the SHA the project worktree itself held at dispatch start
(matched against `git ls-remote`) and succeeded. The orchestrator
that authored the brief likely truncated the SHA from a partial
display somewhere; recording so a future weaver does not stumble on
the same typo.

Self-improvement: when a dispatch brief names a lease anchor, the
weaver should cross-check it against `git rev-parse HEAD` (the
project worktree's starting SHA) and `git ls-remote origin
refs/heads/<branch>` before the first push attempt, and use the
verified SHA. Force-with-lease is supposed to be the safety net, not
a transcription contest. Worth a one-line note in
`skills/conflict-resolution/SKILL.md` § Pitfalls or in
`skills/rebase-before-followup/SKILL.md`, alongside the
"`--force-with-lease`, never plain `--force`" line: name the
lease-anchor verification step explicitly so it does not get lost.
