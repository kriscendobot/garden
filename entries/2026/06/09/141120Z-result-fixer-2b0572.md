---
ts: 2026-06-09T14:11:20Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/fixer--2b0572
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: target
refs:
  - entries/2026/06/09/140600Z-dispatch-fixer-2b0572.md
  - https://github.com/endojs/endo-but-for-bots/pull/75
  - https://github.com/endojs/endo-but-for-bots/pull/75#issuecomment-4660639888
---

# result: fixer 2b0572 — retcon complete on PR #75

Simple retcon per `skills/retcon/SKILL.md` against the head of
`kriskowal-random-chacha12`. Reset --mixed to `origin/master`,
restaged per-package with implementation + tests combined, separate
`chore: Update yarn.lock` commit at the end.

## SHAs

- **Pre-retcon head**: `4a879634ecbc22497d63d903ce53b25717e0b0d3`
- **Post-retcon head**: `32cc335ba`
- **Base**: `origin/master` at `4a04d078bd208b852a7bebadccd703f53ceea8cc`
- **Lease anchor used on force-push**: `4a879634ecbc22497d63d903ce53b25717e0b0d3`

## Per-package commit decomposition (10 commits)

| SHA          | Scope                              | Summary                                                          |
| ------------ | ---------------------------------- | ---------------------------------------------------------------- |
| `0ba0cb4ab`  | `feat(random)`                     | add @endo/random source-agnostic samplers                        |
| `f8536e7b4`  | `feat(chacha12)`                   | add @endo/chacha12 pure-JS ChaCha12 keystream                    |
| `715358c7b`  | `feat(chacha12-fast-check-test)`   | adopt test-package shape                                         |
| `5618abdb1`  | `refactor(hex)`                    | use @endo/chacha12 keystream + @endo/random/seeds for bench inputs |
| `5fa0c304c`  | `refactor(ocapn)`                  | use @endo/chacha12 + @endo/random for fuzz drivers               |
| `64ae51254`  | `fix(ses)`                         | tuple-typed args restores Parameters overlap                     |
| `8efb1c366`  | `docs`                             | document thunk-module policy in AGENTS.md                        |
| `455cc1470`  | `docs(random,chacha12)`            | changeset for @endo/random + @endo/chacha12                      |
| `3412d1e24`  | `chore`                            | register packages in root tsconfig and typedoc                   |
| `32cc335ba`  | `chore`                            | Update yarn.lock                                                 |

The two fixup commits cited in the dispatch brief have been folded
into the per-package commits they belong to:

- `e627f7b13` (carry of 7 gibson042 final-review asks + 1
  mirror-sweep) absorbed into `feat(random)`, `feat(chacha12)`,
  `feat(chacha12-fast-check-test)`, and `chore: Update yarn.lock`.
- `4a879634e` (package.json exports restore for self-import) absorbed
  into `feat(chacha12-fast-check-test)` (the package.json that
  commit restored is part of the package's introduction commit).

The intermediate fixup commits from the prior history (
`1da07c358` SECURITY.md sync, `11824965c` numeric-separators autofix,
`7196178fa` yarn.lock churn) are absorbed analogously into the
per-package commits.

## Net-diff invariant verification

```
$ git diff pre-retcon-2b0572..HEAD
(empty)

$ git diff pre-retcon-2b0572..HEAD | wc -l
0

$ diff <(git diff origin/master..pre-retcon-2b0572 --stat | sort) \
       <(git diff origin/master..HEAD --stat | sort)
(empty)
```

The PR's net diff is byte-identical before and after the retcon.

## Push

```
$ git push --force-with-lease=kriskowal-random-chacha12:4a879634ecbc22497d63d903ce53b25717e0b0d3 \
           origin HEAD:kriskowal-random-chacha12
 + 4a879634e...32cc335ba HEAD -> kriskowal-random-chacha12 (forced update)
```

## Reply on directive comment

Posted at https://github.com/endojs/endo-but-for-bots/pull/75#issuecomment-4660639888
naming pre/post SHAs and the per-package commit summary.

## Out-of-scope items

- Did NOT re-request review (retcon is cosmetic; per dispatch brief).
- Did NOT touch upstream endojs/endo#3232.
- Did NOT mark PR DRAFT.
- Did NOT add or drop substance.

## Notes from the field

The `packages/random/types.d.ts` file is matched by the
top-level `.gitignore` rule `*.d.ts*` and is not on the global
allow-list. The pre-retcon HEAD included this file in tree
(it was force-added at original feat(random) creation time).
On a naive `git add packages/random/`, the file is silently
ignored and the net-diff invariant fails by a 14-line deletion.
The fix is `git add -f packages/random/types.d.ts` immediately
after the package add. Caught by the
`git diff <pre-retcon-sha>..HEAD` invariant check at retcon
skill procedure step 5; rolled back via `git reset --hard
pre-retcon-2b0572` and started over. The retcon skill's
"net diff invariant" check is load-bearing precisely because
gitignored files can be silently dropped by `git add <dir>/`;
worth a pitfall callout in `skills/retcon/SKILL.md`.

Self-improvement: routed a message to gardener flagging the
gitignored-file pitfall in the retcon skill.
