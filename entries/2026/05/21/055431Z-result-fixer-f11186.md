---
ts: 2026-05-21T05:54:31Z
kind: result
role: fixer
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/fixer--f11186/
refs:
  - entries/2026/05/21/053500Z-result-weaver-556528.md
---

# Result: fixer f11186 — retcon feat/cbors-package + add ocapn-default-cbor commit (step 2 of #288)

Per kriskowal review on endojs/endo-but-for-bots#288 (2026-05-21T05:25:58Z) and the weaver's handoff in entry `053500Z-result-weaver-556528`, this dispatch performed the second half of the two-step kriskowal directive: (a) retcon the three replayed commits into the syrup-frame analog's single-feat-plus-yarn-lock shape, (b) add the new `feat(ocapn): default codec 'cbor', alternatives 'syrup' and 'none'` commit mirroring upstream `bdb9ddc50`.

## Heads

- Pre-retcon: `f7239bb9abfd194513ae73de8fc344421ddb394a` (weaver's post-rebase tip).
- Post-retcon: `9849ea5cf1a4af1e9764114d42b68c2db89e20d0`.
- Merge-base (with upstream): `bf951df346cfcf605a6709e6a5479f2fdd526113` (`endo-upstream/master`, carrying the just-merged syrup-frame PR #3256).

## Commit topology

| # | SHA         | Subject                                                                          |
| - | ----------- | -------------------------------------------------------------------------------- |
| 1 | `4b8627f62` | `feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing`    |
| 2 | `4066e7cfe` | `feat(ocapn): default codec 'cbor', alternatives 'syrup' and 'none'`             |
| 3 | `9849ea5cf` | `chore: Update yarn.lock`                                                        |

Three commits on `endo-upstream/master`. The shape mirrors the upstream syrup-frame PR's shape (single feat for the new framing package, single feat for the ocapn netlayer change, separate yarn.lock).

## Retcon mechanics

The weaver's tip carried four commits to fold or extend:

- `8910d7004 feat(cbor-frame): add @endo/cbor-frame package` (kept, became commit #1 base).
- `d403b7fea docs(netstring,lp32): cross-reference framing-package siblings` (folded into commit #1; the syrup-frame PR upstream landed without a separate docs commit, so the cross-reference content joined the cbor-frame add).
- `f7239bb9a chore: Update yarn.lock` (regenerated below; the new tip's lockfile commit is `9849ea5cf`).

Per `skills/retcon/SKILL.md`:

1. Tagged `pre-retcon-f11186` at `f7239bb9a`.
2. `git reset --mixed bf951df34` (the merge-base with upstream master).
3. Staged `.changeset/add-endo-cbor-frame.md`, `packages/cbor-frame/`, `packages/lp32/README.md`, `packages/netstring/README.md` together and committed as the combined `feat(cbor-frame)` commit; the message body adds a final paragraph noting the Related-packages cross-reference is updated in the same commit.
4. Authored the ocapn-default-cbor changes (see below); staged `packages/ocapn/` + `.changeset/ocapn-default-cbor-framing.md`; committed.
5. Ran `npx corepack yarn install` to refresh `yarn.lock` for the new ocapn dep on `@endo/cbor-frame`; staged `yarn.lock`; committed.
6. Net-diff invariant verified: `git diff pre-retcon-f11186..HEAD -- packages/cbor-frame/ packages/lp32/ packages/netstring/ .changeset/add-endo-cbor-frame.md` is empty. The cbor-frame and docs files are byte-identical to the pre-retcon state.

## The ocapn-default-cbor commit (mirroring `bdb9ddc50`)

Source-of-truth model: upstream commit `bdb9ddc50` (`feat(ocapn): add opt-in syrup framing to TCP-testing netlayer`). Substituted `cbor-frame` for `syrup-frame` in the equivalent places and added the third framing option.

Files changed in commit #2:

- `.changeset/ocapn-default-cbor-framing.md` — new minor changeset.
- `packages/ocapn/package.json` — adds `"@endo/cbor-frame": "workspace:^"` to dependencies (already had `@endo/syrup-frame` and `@endo/stream` from the upstream syrup-frame merge).
- `packages/ocapn/src/netlayers/tcp-test-only.js` — extends `TcpTestOnlyFraming` typedef from `'none' | 'syrup'` to `'none' | 'syrup' | 'cbor'`; updates the default from `'syrup'` to `'cbor'`; widens the validation predicate; adds `makeCborWritingSocketOperations` (sync writer mirroring the syrup analog, using `encodeByteStringHead` and `TAG_24_PREFIX` from `@endo/cbor-frame/src/head.js`) and `makeCborDeframer` (async pipe through `makeCborFrameReader`); selects writer + deframer per framing value in `setupSocketHandlers` and `makeFramedSocketOperations`.
- `packages/ocapn/test/netlayer-tcp-cbor.test.js` — new file mirroring `netlayer-tcp-syrup.test.js`: a sniffer-server test asserting the first three bytes are `0xd8 0x18 <major-2 head>` (tag-24 wrapper + byte-string head initial), a round-trip test through two cbor-framed netlayers, and a default-is-cbor round-trip test (no `framing` option passed).
- `packages/ocapn/test/python-test-suite/index.js` — comment updated to say "default `'cbor'` framing" instead of "default `'syrup'` framing"; the `framing: 'none'` value is unchanged.

The decision to use `bytes[3] * 0x100 + bytes[4]` instead of `(bytes[3] << 8) | bytes[4]` in the test's head-decode logic is per the project's `no-bitwise` eslint rule, surfaced by the lint pass on the first attempt.

## Verification

- `git diff pre-retcon-f11186..HEAD -- packages/cbor-frame/ packages/lp32/ packages/netstring/ .changeset/add-endo-cbor-frame.md`: empty.
- `packages/cbor-frame` tests: 32/32 pass.
- `packages/ocapn` tests: 263/263 pass under all three ses-ava configs (lockdown, unsafe, endo). The new three `netlayer-tcp-cbor` tests pass; the existing three `netlayer-tcp-syrup` tests still pass (they pass `framing: 'syrup'` explicitly).
- `yarn lint:types` on both packages: clean.
- `yarn lint:eslint` on both packages: clean.

## Pre-push gates (`skills/pre-push-gates`)

Ran `pre-push-gates.sh --summary`. Findings analysis:

- `no-inline-import-jsdoc` in `packages/cbor-frame/src/{decode,encode}.js`: pattern matches the just-merged `@endo/syrup-frame` sibling, which uses the same `{import('@endo/stream').Writer<...>}` shape on its `writer.js` / `reader.js`. The cbor-frame package was authored as a deliberate mirror of syrup-frame; the identical JSDoc shape is intentional.
- `no-inline-import-jsdoc` in `packages/ocapn/src/netlayers/tcp-test-only.js`: pre-existing on `endo-upstream/master` (line 179 there, now line 281 after my edits); not introduced by this PR.
- `no-pull-citations` + `sentence-per-line-md` in `packages/syrup-frame/*`: pre-existing on `endo-upstream/master`; this PR does not touch syrup-frame.
- `security-md-hash-uniform`: pre-existing divergence across `bytes`, `hex`, `panic`, `immutable-arraybuffer`. cbor-frame's `SECURITY.md` is byte-identical to syrup-frame, netstring, and lp32 (sha256 `071c74499d6d695e590ea3816ab579cb2e40639adcf7cf75e2702c732071f41d`); the divergent set predates this PR.
- `sentence-per-line-md` in `packages/netstring/README.md`: the multi-sentence line is "D. J. Bernstein, <djb@pobox.com> <br>", which was at line 16 on master before this PR's docs commit added the cross-reference paragraph and pushed it to line 23. Pre-existing line; not authored by this PR.

No probe finding is uniquely caused by this PR's diff.

## Push

`git push --force-with-lease=feat/cbors-package:f7239bb9abfd194513ae73de8fc344421ddb394a origin HEAD:feat/cbors-package`. Result:

```
+ f7239bb9a...9849ea5cf HEAD -> feat/cbors-package (forced update)
```

Remote `feat/cbors-package` is now `9849ea5cf`.

## Summary comment

Posted on PR #288: <https://github.com/endojs/endo-but-for-bots/pull/288#issuecomment-4505197944>. Documents the three-commit topology, the byte-identical cbor-frame retcon, the new ocapn-default-cbor commit's shape, the test and lint results, and the pre-push-gates analysis.

## What the next stage takes

The PR is now in shape kriskowal asked for: `feat(cbor-frame)` + `feat(ocapn)` + `chore: Update yarn.lock`, with the ocapn change defaulting the netlayer codec to `'cbor'` and keeping `'syrup'` and `'none'` as alternatives. The chain can continue per the orchestrator's discretion (shepherd to drive CI green; then conductor when ready to merge).

## Self-improvement

Nothing this time. The retcon + new-commit composition went as documented in `skills/retcon/SKILL.md` (step-by-step) and `skills/yarn-lock-separate-commit/SKILL.md` (regenerate after dep changes, ship in its own commit). The one moment of friction (the `no-bitwise` eslint rule rejecting `(bytes[3] << 8) | bytes[4]` in the new test) was caught by the pre-push gates' lint stage, which is the gates' intended class of catch; no new skill content needed.
