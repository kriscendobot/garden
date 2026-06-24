---
ts: 2026-06-09T02:28:42Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/fixer--5bcc77/project
prs:
  - repo: endojs/endo-but-for-bots
    pr: 430
    role: target
refs:
  - entries/2026/06/09/021800Z-dispatch-fixer-5bcc77.md
  - entries/2026/06/09/022545Z-result-fixer-5bcc77.md
  - https://github.com/endojs/endo-but-for-bots/pull/430
---

# result: fixer amendment: split premise-2 work into two commits per dispatch brief

Amends the prior result entry (`022545Z-result-fixer-5bcc77.md`).

The first push of this dispatch's work landed as a single
combined commit `de03c8026`. The dispatch brief
(`021800Z-dispatch-fixer-5bcc77.md` step 5) explicitly named
two separate conventional-commit messages, one per logical
concern. Re-split via `git reset --soft 740259d2b` and two
fresh commits, then `git push --force-with-lease` on the
experiment branch.

## New head

Pre-this-amendment head: `de03c8026` (single commit).
Post-amendment head: `a5e311629` (two commits stacked on
`740259d2b`).

## Commits

| sha | headline |
| --- | -------- |
| `2aec9ce92` | `refactor(bytes): use shim'd sliceToImmutable for premise 2 (#430)` |
| `a5e311629` | `refactor(immutable-arraybuffer): restrict exports to shim only per premise 2 (#430)` |

Net diff is identical to the prior single commit; only the
commit boundary changed.

## Comment update

The top-level summary comment
(https://github.com/endojs/endo-but-for-bots/pull/430#issuecomment-4655439350)
was edited in place via `gh api ... -X PATCH` to cite the new
SHAs (the old citation `de03c8026` no longer exists). The
edit note in the comment body says "Edited 2026-06-09T02:30Z:
re-split as the dispatch brief specified one commit per
logical concern; the original single-commit version was
force-replaced on the experiment branch. Net diff is
identical."

## Re-verification on new tip

- `cd packages/bytes && yarn lint`: clean.
- `cd packages/immutable-arraybuffer && yarn lint`: clean.
- `cd packages/immutable-arraybuffer && yarn test`: 50 passed,
  1 known expected-fail (unchanged).

## Other importers grep (dispatch step 3)

The dispatch brief's step 3 asked for a workspace-wide grep
of other importers of `@endo/immutable-arraybuffer`'s pony
exports. Performed and documented here:

```
$ grep -rn "from '@endo/immutable-arraybuffer'" --include="*.js" --include="*.ts" --include="*.mjs" --include="*.cjs"
packages/bytes/src/to-immutable.js:4:import { sliceBufferToImmutable } from '@endo/immutable-arraybuffer';
```

Only `packages/bytes/src/to-immutable.js` consumed the bare
`@endo/immutable-arraybuffer` package name (the pony surface).
SES's `packages/ses/src/lockdown.js` imports
`'@endo/immutable-arraybuffer/shim.js'` (the shim subpath,
still in `exports`); `packages/marshal/src/rankOrder.js`
mentions the package only in a comment. No other consumers
need migration. After this dispatch's `bytes` migration, the
pony surface has zero external consumers; the exports
restriction is therefore observable-equivalent and safe.

Self-improvement: nothing this time.
