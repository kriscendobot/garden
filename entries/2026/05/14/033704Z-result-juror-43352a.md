---
ts: 2026-05-14T03:37:04Z
kind: result
role: juror
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 243
    role: target
refs:
  - entries/2026/05/14/032940Z-dispatch-liaison-a9d01e.md
---

# Result: juror review on PR #243 (numeric-separators-style)

Review submitted as `COMMENTED` (the standard `--request-changes` is blocked because the authenticated kriscendobot identity is also the PR author; falling back per `skills/panel-review/SKILL.md` § Pitfalls).
The body carries the "Must-fix before merge" header so the orchestrator's matrix keys on it.

Review URL: <https://github.com/endojs/endo-but-for-bots/pull/243#pullrequestreview-2895081930> (PRR_kwDORRE4FM7_h17K).
Head SHA reviewed: `08d55650eea3ddde193441987e484a1b8eec9c6a`.

## In-scope findings

Must-fix:

- **Lint failing on head**: one `unicorn/numeric-separators-style` error at `packages/ocapn/test/_util.js:145:53` on a 4-digit literal `1000`, which contradicts `number.minimumDigits: 5`. Other `1000` literals in the tree are not flagged, so the rule's trigger is inconsistent on this site. Needs investigation, not a disable comment.
- **Conflated autofix commit**: the migration commit also contains JSDoc edits from `eslint-plugin-jsdoc` (spurious `@param value` lines added in `packages/daemon/src/bus-daemon-rust-xs.js`). The commit message claims to be `numeric-separators-style` autofix only.

Should-fix:

- **Hex `groupLength: 2` uglifies word-boundary constants** (`0x3_ff`, `0x1_00_00`, `0x7e_00`). Prefer `groupLength: 4` or a higher `minimumDigits`. Convergent with the saboteur's finding 1, which also names this as must-fix tied to the maintainer's "presumably groups of four" intent.
- **Below-threshold strip** removed deliberate readability separators (`1_000`, `5_000`).

Out-of-scope: peer-dep cascade to downstream consumers is correctly noted in the changeset.

## Lint-failure investigation summary

CI lint job 75921671900 reported exactly one error and 1761 warnings.
The single error is the `_util.js:145:53` case above; everything else is pre-existing JSDoc warnings unrelated to this PR.
Cause is genuinely from the new rule, not a pre-existing unrelated check.

## Cross-panel note

The saboteur's review (`PRR_kwDORRE4FM7_h1eL`, posted ~50 s earlier) reaches the same hex-grouping conclusion, frames it more strongly as a maintainer-intent mismatch, and adds two perspectives the juror did not cover: (a) `cjs-module-analyzer/index.js` is generated code and should be in an override; (b) eslint-plugin-unicorn v56 is end-of-line for ESLint 8, so a migration plan to v9/v64 is owed.
The two reviews are complementary, not contradictory.

Self-improvement: nothing this time.
