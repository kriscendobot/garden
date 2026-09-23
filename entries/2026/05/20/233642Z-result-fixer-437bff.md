---
ts: 2026-05-20T23:36:42Z
kind: result
role: fixer
worktree: dispatches/fixer--437bff/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - journal/jobs/claimed/endolinbot--20260520T231910Z--98bd14--summary-fix-323.md
---

# Summary-fix bundle landed on PR #323 (G14 LICENSE aggregation)

Claimed `summary-fix-323` (job 98bd14). All four items addressed and pushed to `feat/familiar-license-aggregation`.

## Per-item disposition

1. **Dead branch in `aggregate-licenses.mjs`** (lines 436-439): removed. The `if (!verify && !writeFile)` block was unreachable per the argv parser. Script exits 0 naturally on remaining paths. Commit `72317da5a` (pre-rebase) / `72317da5a` → final.
2. **CI-step invocation normalization**: added `step:licenses:write-and-verify` alias to `packages/familiar/package.json`; workflow now calls the named alias. Drops the `yarn workspace ... step:licenses -- --verify` mixed convention. Commit `eb601b205`.
3. **Silent no-op when `packages/chat/package.json` is absent**: added an `else` branch with `console.warn` so a future repo refactor that moves the chat package cannot silently truncate attribution. Commit `72317da5a`.
4. **Fail-closed in `make-distributables.mjs`** when `bundles/LICENSE.third-party.txt` is missing: changed warning-and-continue to `process.exit(1)` with a clear error message. CI behavior preserved (workflow still runs aggregator with `--verify` before make). Commit `fe0ee312c`.

## Commit shape

Three commits, grouped by concern:

- `72317da5a` `fix(familiar): remove dead branch and warn on missing chat package` (items 1 + 3; same file)
- `fe0ee312c` `fix(familiar): make distributables fails closed on missing LICENSE` (item 4)
- `eb601b205` `fix(familiar): name the write-and-verify license step` (item 2; workflow + package.json)

## Rebase

Initial push rejected (non-fast-forward). Remote had advanced to `7c0f82261` `chore(familiar): refactor aggregate-licenses to drop no-continue lint errors` (lint-cleanup commit that landed between the judge's terminating round and this fixer claim). Rebased the three fixer commits onto `7c0f82261` cleanly with no conflicts; verified the post-rebase tree retains all four behavioral changes.

## Pre-push gates

- `corepack yarn install --immutable`: completed.
- `cd packages/familiar && corepack yarn lint`: 0 errors, 1 preexisting warning in `src/daemon-manager.js:293` (unrelated to changed files).
- `node packages/familiar/scripts/aggregate-licenses.mjs --verify`: exits 2 (metafile dir absent in dispatch worktree; expected — no prior bundle step).
- `node packages/familiar/scripts/make-distributables.mjs` (without aggregated LICENSE present): exits 1 with the new error message; confirms fail-closed behavior.
- `corepack yarn prettier --check` on the four modified paths: all conform.

## Push

```
To github.com:endojs/endo-but-for-bots.git
   7c0f82261..eb601b205  HEAD -> feat/familiar-license-aggregation
```

New head: `eb601b205`.

## CI

Per the dispatch brief, CI was 23/23 SUCCESS at the prior head. The fixer changes are small (one dead block deleted, one warn added, one exit-1 added, one yaml string + one new package.json script). No regression expected; the steward's per-cycle CI watch will pick up the new head.

## Out of scope

The five `follow-up`-disposition items remain parked per the dispatch brief; not touched.

Self-improvement: nothing this time.
