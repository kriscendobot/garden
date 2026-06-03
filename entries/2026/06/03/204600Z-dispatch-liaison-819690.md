---
ts: 2026-06-03T20:46:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--819690
prs:
  - repo: endojs/endo-but-for-bots
    pr: 411
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/411
  - https://github.com/endojs/endo-but-for-bots/pull/411#issuecomment-4616278308
  - https://github.com/endojs/endo/pull/3296
---

# dispatch: fixer — #411 bump browser-test job timeout (upstream #3296 still timing out)

User explicit ask:

> Please respond to
> https://github.com/endojs/endo-but-for-bots/pull/411#issuecomment-4616278308

Maintainer comment on #411 (2026-06-03T20:06:45Z):

> endojs/endo#3296 is not passing CI due to a timeout in the
> browser test this change we hope fixes. We may need a longer
> timeout for the job. Please address. I will dispatch a
> boatman when ready.

Context: #411 (this bot-side PR) landed three changes:
actions/cache for ~/.cache/ms-playwright, exact Playwright
version pin, and nick-fields/retry around the install step.
The mirror upstream is endojs/endo#3296. Upstream CI is still
timing out on the browser-test job — the cache helps once
populated, but the cold-cache run still hits the 30-min
ceiling.

## Target

- PR: endojs/endo-but-for-bots#411
- Branch: `ci/cache-playwright-browsers`
- Head: `fca14cd14` (the gauntlet may have advanced it since
  the original `b82249e1c`; check via `gh pr view`).
- Base: `master-ba26f4c` (frozen base per earlier builder).
- State: DRAFT.

## Concrete change

`.github/workflows/browser-test.yml` currently has
`timeout-minutes: 30` on the `browser-tests` job. Bump to a
generous value to handle the cold-cache + retry budget. The
maintainer didn't name a specific number; reasonable picks
based on observed runtime:

- **45 minutes**: comfortable headroom over the current 30.
- **60 minutes**: doubles the budget; aligns with several
  other long-running jobs in the GHA ecosystem.

Use judgment. The retry-with-3-attempts × 10-min-per-attempt
implies a worst-case 30-min just for install, leaving
0 minutes for actual tests. Bumping to **60 minutes** is the
more defensive pick.

Sketch:

```diff
 jobs:
   browser-tests:
-    timeout-minutes: 30
+    timeout-minutes: 60
```

If the maintainer's "longer timeout" intent extends to the
retry step's per-attempt ceiling (10 minutes), consider bumping
that to 15-20 as well — the playwright install on a cold cache
+ slow CDN can take 8+ minutes alone. Use judgment.

## Procedure

1. Edit `.github/workflows/browser-test.yml` per above.
2. Commit (regular append):
   ```
   ci(browser-test): bump job timeout to 60 minutes for cold-cache install budget
   ```
3. Push: `git push origin HEAD:ci/cache-playwright-browsers`.
4. Reply on the issue-comment thread `4616278308` with a brief
   "Bumped to 60m at <new-SHA>; ready for boatman re-ferry."

## Per-action authorizations

- Edit `.github/workflows/browser-test.yml`. Authorized.
- One regular-append commit + push. Authorized.
- Issue-comment reply. Authorized.

## Not authorized

- Force-pushing.
- Touching upstream endojs/endo (boatman's job).
- Un-drafting / merging.
- Editing files outside the workflow.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--819690/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--819690/garden/roles/fixer/AGENT.md`
3. Other skills referenced just-in-time.

Project worktree at `project/` on `ci/cache-playwright-browsers`
(refetch — head may have advanced since `b82249e1c`).

## Report

A `result` journal entry. Include:

- Old timeout value(s) + new value(s).
- New head SHA + commit message.
- Issue-comment reply ID.
- Any judgment calls (e.g., whether retry per-attempt also
  bumped).
