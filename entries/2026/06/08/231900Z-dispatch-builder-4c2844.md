---
ts: 2026-06-08T23:19:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: builder
dispatch_root: /home/kris/dispatches/builder--4c2844
refs:
  - entries/2026/06/08/231400Z-dispatch-researcher-85550e.md
  - entries/2026/06/08/231548Z-result-researcher-85550e.md
  - entries/2026/06/07/050114Z-result-fixer-a538e1.md
---

# dispatch: builder — open eslint-warnings-cleanup PR on bot master, commit per category

User directive (2026-06-08T23:10Z):

> Please dispatch a subagent to build a pull request that
> addresses every eslint warning, with a commit for each
> category of warning that befits an equivalent solution,
> based on master.

## State at dispatch time

- **Bot master**: `4a04d078`.
- **Prior precedent**: fixer `a538e1` (2026-06-07,
  `entries/2026/06/07/050114Z-result-fixer-a538e1.md`) ran a
  workspace-wide `unicorn/numeric-separators-style` autofix and
  discovered that the workspace-wide `corepack yarn lint:eslint
  --fix` recipe cascades into **destructive non-numeric edits**
  via two rules:
  - **`@endo/harden-exports`**: deletes `harden(...)` calls on
    named exports, violating the project's `CLAUDE.md` SES
    mandate.
  - **`jsdoc/require-param`**: injects empty `@param` lines.
  The fixer recovered by running `eslint --fix --no-eslintrc
  --rule '{"<rule>":[...]}'` per-rule against an explicit file
  list. **The builder must adopt the same discipline.**

## Library and project references

(Inlined from researcher `85550e`'s section.)

### Load-bearing prior precedent
- [fixer `a538e1` result](../06/07/050114Z-result-fixer-a538e1.md):
  workspace-wide autofix cascade discovery. Two destructive
  rules to AVOID: `@endo/harden-exports` (deletes `harden()`
  calls — violates project SES mandate) and
  `jsdoc/require-param` (injects empty `@param` lines). The
  fixer's recipe: per-rule `eslint --fix --no-eslintrc --rule
  '{"<rule>":[...]}'` against an explicit file list.

### Skills
- [`frozen-base-branch`](../../../skills/frozen-base-branch/SKILL.md):
  open against `master-<short-sha>`, not bare `master`. Use
  `master-4a04d07`.
- [`pr-creation-flow`](../../../skills/pr-creation-flow/SKILL.md):
  opens DRAFT; the chain (cleaner / judge / fixer-loop /
  un-draft) follows on the per-cycle PR-creation-flow scan.
- [`pr-formation`](../../../skills/pr-formation/SKILL.md):
  conventional-commit messages, body-shape, no methodology
  leak.
- [`yarn-lock-separate-commit`](../../../skills/yarn-lock-separate-commit/SKILL.md):
  if any commit changes deps, lockfile lands as its own commit.
- [`changeset-discipline`](../../../skills/changeset-discipline/SKILL.md):
  no changeset (lint cleanup is internal hygiene; no consumer-
  visible change).

### Verification idiom (per steward `426-chain`'s lesson)
Verify each per-category commit by diff CONTENT (not `--stat`):
```
git diff -U0 | grep -E '^[+-]' | grep -vE '^[+-]{3}|^[+-][ \t]*<safe-pattern>'
```
Catches destructive cascades from other autofix rules.

### Project context
- [endo-but-for-bots README](../../projects/endo-but-for-bots/README.md):
  master is implementation branch; standing broad-comment
  authorization for the PR open + comments.

### Scope reminder
The warning count is large (the fixer `a538e1` observed
2167+ warnings persisting after the unicorn autofix). The
builder should:
1. Enumerate warning categories FIRST (`yarn lint
   --workspaces 2>&1 | grep warning | sort -u`).
2. Budget per category (number of occurrences, autofix
   availability, manual-fix cost).
3. Pick the autofix-safe categories first (one commit each).
4. For non-autofix categories, decide per the user's
   "befits an equivalent solution" phrasing: same-shape
   warnings get one commit; warnings needing per-call-site
   judgment get separate commits.
5. **If the total exceeds 8-10 commits**, the builder should
   surface to liaison rather than overrun. The user's
   directive says "every warning"; if the count is unwieldy,
   surface as scope question.

## Task

In your `project/` worktree on bot master:

1. **Mint frozen base** `master-4a04d07` (push if not
   already on origin from earlier this cycle).
2. **Create branch** `chore/eslint-warnings-cleanup` off the
   frozen base.
3. **Enumerate warning categories** via `corepack yarn lint
   --workspaces 2>&1 | grep ' warning ' | awk '{print $NF}'
   | sort -u` (or equivalent — pick the right invocation per
   the repo's lint scripts).
4. **For each category**:
   - If autofix-safe AND not in the destructive set (NOT
     `@endo/harden-exports` or `jsdoc/require-param`):
     - Run `npx eslint --fix --no-eslintrc --rule '{"<rule>":
       [...]}'` on the files that have the warning.
     - Verify diff content (not stat) per the idiom above.
     - Commit as `style: apply <rule> autofix
       (workspace-wide)`.
   - If autofix is in the destructive set OR autofix is N/A:
     - **Defer** with a `chore: defer <rule> warnings to
       per-call-site judgment` note OR skip with rationale in
       PR body. Do NOT auto-apply destructive rules.
   - If category has fewer than ~5 occurrences and a
     consistent hand-fix is obvious: hand-fix and commit as
     `fix(<scope>): address <rule> at <count> sites`.
5. **Push** the branch.
6. **Open the PR DRAFT**:
   `gh pr create -R endojs/endo-but-for-bots --base
   master-4a04d07 --head chore/eslint-warnings-cleanup
   --draft --title "chore: address eslint warnings across the
   workspace (per-category cleanup)" --body <body>`.
   Body should enumerate the categories addressed, the
   categories deferred (with rationale), and link to the
   destructive-cascade lesson from fixer `a538e1`.

## Authorizations (per-action, forwarded by steward)

- **Push** frozen-base + cleanup branch.
- **Open the DRAFT PR**.
- **Post the draft-PR body** (`endo-but-for-bots` standing
  broad-comment authorization).

## Out of scope

- Do NOT shepherd CI to green; if CI fails on the cleanup
  PR, surface to liaison.
- Do NOT trigger panel/judge chain (DRAFT; the per-cycle
  scan picks up the chain).
- Do NOT apply the two destructive autofix rules under any
  circumstances; surface them as "deferred to per-call-site
  judgment" with one-line rationale.

## Deliverable

A `result` entry under `journal/entries/2026/06/08/` naming:

- Frozen-base + cleanup branch + opened PR number/URL.
- Per-category commit SHA + description + verification result.
- Categories deferred (rationale per each).
- A `Self-improvement: ...` line.

If the scope is unwieldy (8+ commits with substantial per-site
judgment), surface to liaison via `message: builder → liaison`
and open the PR with the categories you DID address, plus a
list of deferred categories.

End your turn with a concise summary back to the orchestrator.
The orchestrator tears down your dispatch root on return.
