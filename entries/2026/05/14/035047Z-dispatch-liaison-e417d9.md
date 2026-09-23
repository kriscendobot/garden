---
ts: 2026-05-14T03:50:47Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
refs:
  - entries/2026/05/14/032940Z-dispatch-liaison-bc2964.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 243
    role: source
---

# Dispatch: builder mirrors the digit-grouping PR (#243) onto master for future upstream ferry

Dispatch root: `dispatches/builder--mirror-numeric-separators-on-master--20260514-035046--e417d9/`. Project worktree at `endojs/endo-but-for-bots@master`.

The maintainer's directive (this session): a sibling PR of #243 (the `numeric-separators-style` ESLint rule) is wanted on `endo-but-for-bots@master`, parallel to the existing `chore/eslint-numeric-separators-style` branch which is based on `llm`. The reason: the master-based version is a candidate for the boatman to ferry to `endojs/endo` upstream once the configuration settles.

**Standing authorization** on endo-but-for-bots; no per-action authorization needed for push or PR open.

## Task

Build the master-based mirror:

1. **Confirm the substantive change** from #243 by reading its diff: `gh pr diff 243 -R endojs/endo-but-for-bots --json files` and `gh pr view 243 --json files`. The substance is small (a few files):
   - `packages/eslint-plugin/lib/configs/internal.js` adds the `unicorn` plugin + `numeric-separators-style` rule.
   - `packages/eslint-plugin/package.json` adds `eslint-plugin-unicorn` as `peerDependencies`.
   - Root `package.json` adds `eslint-plugin-unicorn` as `devDependencies`.
   - A `.changeset/` entry naming `@endo/eslint-plugin@minor`.
2. **Apply the same substantive change** to your project worktree (which is checked out at `endo-but-for-bots@master`). Match the package versions chosen in #243 (`eslint-plugin-unicorn ^56.0.1`, the last ESLint-8-compatible line) and the same config wording.
3. **Run `yarn install`** to update yarn.lock; commit yarn.lock in a separate commit per the `yarn-lock-separate-commit` skill.
4. **Run the autofix** (`yarn lint --fix` or `yarn eslint --fix --ext .js,.cjs,.mjs .`). This will produce a DIFFERENT migration diff than #243 because master's codebase is structured differently than llm's. Commit the autofix migration as its own commit.

## Known issues to call out in the PR body (but do NOT pre-fix)

The jury reviews on #243 surfaced three issues that apply to this mirror too:

- **Must-fix #1**: lint failing on the head SHA (the rule's autofix may miss a site, leaving a lint error). Run `yarn lint` after autofix; if the same shape of error appears here, name it in the PR body so the fixer can address it.
- **Must-fix #2**: #243's autofix commit conflated unicorn's autofix with unrelated `eslint-plugin-jsdoc` autofixes. **Avoid this here**: when running autofix, restrict to the rule or revert any non-numeric edits before committing.
- **Should-fix**: hex `groupLength: 2` produces byte-grouped hex (`0xff_ff_ff_ff`) rather than the maintainer's intended "groups of four" (`0xFFFF_FFFF`). The mirror inherits this if you copy #243's config verbatim. The fixer will land the fix on both PRs; the mirror should not pre-empt the fix because the configuration is currently the agreed shape that #243 chose, and the mirror's parity with #243 is the load-bearing property right now.

Per the maintainer's framing: this is a mirror, not a corrected version. Match #243's config (hex grouping as-is). The sister fixer will address the must-fix items on both PRs once the steward's PR-creation-flow scan picks them up (the chaining repair landed in `c46477d`).

## Identity + flow

- Identity kriscendobot. Verify with `gh auth status`.
- Per pr-creation-flow: open in **draft**.
- Topic branch: `chore/eslint-numeric-separators-style-master` (or similar; conventional-commits style; name should signal "master-based").
- Per pr-formation: use the repo's PR template; no checklists; describe behavior over diff. Body cites #243 as the sibling and names the intended upstream ferry.

## Out of scope

- Do NOT pre-fix the jury-surfaced must-fix items (the sister fixer dispatch will do that on both PRs).
- Do NOT touch the existing `chore/eslint-numeric-separators-style` branch (#243's source).
- Do NOT ferry to upstream `endojs/endo` in this dispatch (that's a later boatman dispatch).
- Do NOT run CI watchers; the steward's PR-flow scan will pick the new PR up next cycle.

## Report

PR URL on `endo-but-for-bots` (the new sibling), commit SHAs (config + lockfile + migration), file-count diff between #243's migration and your master-based migration (since the codebase differs), local-validation outcome (`yarn lint` + `yarn lint:types` + relevant `yarn ava` — note any lint failure as expected), and a one-line confirmation that the mirror is in place and ready for the steward's chain to pick up.
