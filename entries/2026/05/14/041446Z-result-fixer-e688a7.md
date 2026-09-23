---
ts: 2026-05-14T04:14:46Z
kind: result
role: fixer
project: endo-but-for-bots
worktree: dispatches/fixer--carry-3257-feedback-to-223--20260514-040131--cbd3ec/project
repo: endojs/endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 223
    role: target
  - repo: endojs/endo
    pr: 3257
    role: source-of-feedback
refs:
  - entries/2026/05/14/040132Z-dispatch-liaison-cbd3ec.md
---

# Result: fixer carried endojs/endo#3257 feedback to endo-but-for-bots#223

## Substantive comments processed

Five inline comments on #3257; one had a maintainer inline reply that overrides Copilot.

| #3257 comment ID | path | action | #223 edit |
| --- | --- | --- | --- |
| [3238960615](https://github.com/endojs/endo/pull/3257#discussion_r3238960615) | `packages/bytes/src/to-immutable.js:27` | NOT APPLIED | kriskowal [replied](https://github.com/endojs/endo/pull/3257#discussion_r3238971409): "For this, I am content discouraging this misuse with the type system." — overrides Copilot. |
| [3238960631](https://github.com/endojs/endo/pull/3257#discussion_r3238960631) | `packages/bytes/README.md:14` | APPLIED | Removed `designs/endo-bytes.md` link (file does not exist). |
| [3238960641](https://github.com/endojs/endo/pull/3257#discussion_r3238960641) | `packages/bytes/README.md:106` | APPLIED | Softened "captured and frozen" to "captured" — safety property is the capture, not a freeze that the code never applied. |
| [3238960651](https://github.com/endojs/endo/pull/3257#discussion_r3238960651) | `packages/bytes/CHANGELOG.md:7` | APPLIED | 0.1.0 entry now lists all seven exports (was missing `bytesFromImmutable`, `bytesToImmutable`, `concatImmutables`). |
| [3238960661](https://github.com/endojs/endo/pull/3257#discussion_r3238960661) | `packages/cli/package.json` | APPLIED | Dropped unused `@endo/compartment-mapper` dep; refreshed `yarn.lock`. |

## Commits on `feat/endo-bytes-upstream`

- `b42a52f37` `docs(bytes): correct README references and CHANGELOG export list (#223)`
- `8ccbdce29` `fix(cli): drop unused @endo/compartment-mapper dependency (#223)`
- `a39c99325` `chore: Update yarn.lock`

Pushed via `--force-with-lease=feat/endo-bytes-upstream:1baf237a2`. New head `a39c99325`.

## Local validation

- `yarn lint` (repo-wide): 0 errors, 2 pre-existing warnings (`evasive-transform/src/index.js`, `ses/src/compartment.js`).
- `yarn lint:types` in `packages/bytes`, `packages/cli`: clean.
- `yarn ava` (via `yarn test`):
  - `packages/bytes`: 32/32 pass.
  - `packages/cli`: 10/10 pass.
  - `packages/ocapn`: 257/257 pass.
- `packages/daemon`: `EADDRINUSE` on Unix-socket paths because the dispatch-root path is 150 chars, exceeding the 108-char Linux socket-path limit. Environmental, not a regression from these changes. The same daemon code passes on `bots-ssh` checkouts with shorter paths.
- `packages/goblin-chat`: not touched by PR #223; no tests run.

## Summary comment

Posted on #223: https://github.com/endojs/endo-but-for-bots/pull/223#issuecomment-4447451564

No comment on #3257 (no per-action auth, per dispatch contract).

## Self-improvement

`Self-improvement: nothing this time.` The dispatch and the fixer role / `review-feedback-followup-commits` skill covered the workflow cleanly. Two patterns from this engagement that the existing docs already cover: (a) "Copilot is a hint, kriskowal wins" was named in the dispatch and is consistent with the fixer role's "out-of-scope complaints are not the fixer's lane" framing; (b) the daemon Unix-socket-path-length flake is a property of the dispatch-root path, not of any role or skill, and does not generalize.
