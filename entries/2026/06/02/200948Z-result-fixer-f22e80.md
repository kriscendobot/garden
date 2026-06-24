---
ts: 2026-06-02T20:09:48Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: liaison
dispatch_root: /home/kris/dispatches/fixer--f22e80
prs:
  - repo: endojs/endo-but-for-bots
    pr: 387
    role: target
refs:
  - entries/2026/06/02/200700Z-dispatch-liaison-f22e80.md
  - https://github.com/endojs/endo-but-for-bots/pull/387
---

# result: fixer — renamed `.engines` -> `.bench-engines` per kriskowal #387

Addressed kriskowal's file-level inline review comment on
`packages/benchmark/install-engines.sh` (02:39Z): "Please rename `.engines`.
Nothing limits us from using engines for other workflows."

## What landed

New head: `9e3cde0f2` on `fix-benchmark-wget-engines-master` (regular append
on top of `dda872eb0`).

Commit:

```
fix(benchmark): rename .engines -> .bench-engines per kriskowal #387

Per kriskowal review on #387: `.engines` is too generic, since other endo
workflows might want their own engines dir. Specialize to `.bench-engines`.
```

Applied `sed -i 's#\.engines#\.bench-engines#g' file` to exactly the three
files named in the dispatch. Diff: 3 files changed, 23 insertions(+),
23 deletions(-).

Per-file rename counts (occurrences of `.bench-engines` after sed):

| File | Renames |
| --- | ---: |
| `packages/benchmark/install-engines.sh` | 20 |
| `packages/benchmark/run-tests.sh` | 2 |
| `packages/benchmark/README.md` | 1 |
| **Total** | **23** |

The 23 matches what `grep -cn '\.engines' ...` reported on the pre-sed
files, so every leading `.engines` directory reference flipped and nothing
else did.

## Verification

Post-sed grep for `\.engines`:

```
$ grep -n '\.engines' packages/benchmark/install-engines.sh \
    packages/benchmark/run-tests.sh packages/benchmark/README.md
$ echo $?
1
```

Zero matches (grep exit 1 = no match), as expected.

Internal `/engines/` segment preserved. Spot check of the
`.engines/engines/xs|v8/...` paths now reads `.bench-engines/engines/xs|v8/...`,
e.g. lines 47-53 and 71-83 in `install-engines.sh` show the new
`$HOME/.bench-engines/engines/xs/xst` and `$HOME/.bench-engines/engines/v8/d8`
forms with the inner `engines/` segment intact.

POSIX-sh syntax check:

```
$ sh -n packages/benchmark/install-engines.sh
$ echo $?
0
```

## Push

```
To github.com:endojs/endo-but-for-bots.git
   dda872eb0..9e3cde0f2  HEAD -> fix-benchmark-wget-engines-master
```

Regular append, no force, no lease. Confirmed.

## Deviations

None. Did not edit other files, did not force-push, did not un-draft, did
not merge, did not post PR comments, did not add shellcheck (#401's lane).

Self-improvement: nothing this time.
