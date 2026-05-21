---
ts: 2026-05-21T05:43:00Z
kind: result
role: liaison
project: endo-but-for-bots
to: maintainer
dispatch: 052128Z-dispatch-liaison-70fb1e
---

# Result: fixer 70fb1e — turadg review on endojs/endo#3263 addressed via mirror endo-but-for-bots#244

Fixer dispatch `70fb1e` (dispatch root `dispatches/fixer--7583e2/`) complete. Branch `chore/eslint-numeric-separators-style-master` pushed at `292322fac`. Self-report at `journal/entries/2026/05/21/053626Z-result-fixer-70fb1e.md`.

## Confirmed: hex grouping is configurable to 4

`eslint-plugin-unicorn@56.0.1`'s `numeric-separators-style` rule schema declares `groupLength: { type: 'integer', minimum: 1 }` per radix. The maintainer's two-byte-grouping request is supported.

## Commits landed (3, on `chore/eslint-numeric-separators-style-master`)

- `4b23bb2b1` chore(eslint-plugin): group hex digits by two bytes (preset flipped to `hexadecimal.groupLength: 4`; ESLint+Prettier autofix across 25 files; eslint-plugin's own wiring test updated in lockstep)
- `bd2b040b1` chore(hex): exempt mnemonic seed literals from numeric-separators rule (line-scope `eslint-disable-next-line` on `packages/hex/test/{decode,encode}.bench.js`; literals restored to `0xb0b5c0ff, 0xeefacade, 0xb0b5c0ff, 0xeefacade` — the "BOBSCOFF EEFACADE" mnemonic intact)
- `292322fac` chore(marshal,cli): exempt comparison literals from numeric-separators rule (line-scope on `packages/cli/test/number-parse.test.js` and `packages/marshal/tools/marshal-test-data.js`; bigint literals restored to no-separator form so they visually match the adjacent decimal-string arguments)

## Validation

`yarn lint`: 0 errors, 0 warnings (the only Node-level noise is the pre-existing `[DEP0128]` for `@endo/ses` `package.json`'s `main` field — present on master). `@endo/eslint-plugin`'s own 67-test integration suite still passes; the wiring test that previously pinned `groupLength: 2` was refreshed to the new shape in commit `4b23bb2b1`.

## What we did NOT do (and why)

- **Did not blanket-disable on test files.** Turadg's top-level review suggested *"omitting the rule for test files"*. Most test files benefit from the rule; only the four legibility-degrading sites were exempted (line-scope, not file-scope).
- **Did not drop the hex requirement entirely.** Turadg also suggested *"removing the hex requirement"*. The maintainer's directive (2026-05-21T05:18Z) was a tighter response: reconfigure hex grouping rather than remove it.
- **Did not change `number.minimumDigits`.** Turadg flagged `5000` (a revert of `5_000` per the rule's default `minimumDigits: 5`). That threshold is out of scope per the dispatch.

## Next step

Maintainer authorization for either:
- A reply comment on endojs/endo#3263 summarizing the response (the bot's comment authority on `endojs/endo` is unclear, so the liaison has not posted on the upstream PR; this is consistent with task #142's posture on PR #3258).
- A ferry of the updated mirror branch upstream (boatman dispatch); requires the credentialed host (currently `kmkmbp2021`), not this `endolinbot` session.

## Teardown

Dispatch root `/home/kris/dispatches/fixer--7583e2/` torn down by the liaison after this entry lands.
