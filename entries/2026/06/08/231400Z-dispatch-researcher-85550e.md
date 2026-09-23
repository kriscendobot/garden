---
ts: 2026-06-08T23:14:00Z
kind: dispatch
role: steward
host: endolinbot
project: endo-but-for-bots
to: researcher
dispatch_root: /home/kris/dispatches/researcher--85550e
---

# dispatch: researcher — refs for eslint-warnings-cleanup builder

User directive (2026-06-08T23:10Z):

> Please dispatch a subagent to build a pull request that
> addresses every eslint warning, with a commit for each
> category of warning that befits an equivalent solution,
> based on master.

The downstream is a **builder** dispatch. Researcher precedence
applies.

## What you should look for

- **Inventory of eslint warning classes** on bot master at
  `4a04d078`. Run `corepack yarn lint --workspaces 2>&1 | grep
  warning` or equivalent on master (or read recent lint output
  from a CI run) to enumerate the warning categories. Common
  ones surfaced by prior dispatches:
  - `jsdoc/reject-any-type` (use specific types instead of `any`)
  - `@jessie.js/safe-await-separator` (first await not nested)
  - `unicorn/numeric-separators-style` (already addressed at
    error level by #426; only warnings remain if any)
  - `unicorn/prevent-abbreviations` (if enabled)
  - `jsdoc/require-param` (already known to be destructive on
    autofix per a prior shepherd lesson)
  - Others.
- **The 2607 warnings count** mentioned in the prior fixer
  `a538e1` autofix dispatch — that was the pre-existing warning
  count on PR #426. Use as the starting estimate; the actual
  count on current master may differ.
- **Destructive-autofix rules to AVOID** (per fixer `a538e1`'s
  self-improvement on PR #426):
  - `jsdoc/require-param` injects empty `@param` lines
  - `@endo/harden-exports` deletes `harden(...)` calls
  - These are why the prior dispatch ran with `--no-eslintrc`
    + isolated unicorn rule. The builder needs the same
    discipline.
- **Categorization scheme**: the user wants "a commit for each
  category of warning that befits an equivalent solution". So
  the builder groups warnings by the SOLUTION shape (autofix-
  safe vs hand-fix; per-rule; per-package). Surface categorization
  precedents from prior fixer/cleaner dispatches.
- **Commit-shape conventions** for cleanup PRs (per
  `roles/cleaner/AGENT.md` and `roles/builder/AGENT.md`):
  conventional-commit messages, one commit per category;
  test/lint verifications inline.
- **Frozen-base convention**: PR opens against `master-<short-
  sha>` per `skills/frozen-base-branch/SKILL.md`. Current bot
  master is `4a04d078`.
- **Coverage discipline**: the user's "befits an equivalent
  solution" phrasing suggests warnings that group naturally
  (same rule, same fix pattern) get one commit; warnings that
  need per-call-site judgment get separate commits per call
  site OR per package.
- **PR-shape**: opens DRAFT per `skills/pr-creation-flow/
  SKILL.md`. The chain (cleaner / judge / fixer-loop /
  un-draft) follows on the per-cycle scan.

## Deliverable

Per `roles/researcher/AGENT.md`: a `result` entry with the
standard `## Library and project references` section the steward
will inline.

Five-minute wall time target.
