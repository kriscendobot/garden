---
ts: 2026-06-05T04:29:58Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--0de86e
prs:
  - repo: endojs/endo-but-for-bots
    pr: 411
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/411
  - https://github.com/endojs/endo-but-for-bots/pull/411#discussion_r3360364191
---

# dispatch: fixer — #411 run browser-test on all PRs regardless of base

Maintainer review `4433356995` (CHANGES_REQUESTED,
2026-06-05T04:28:45Z), single inline at
`.github/workflows/browser-test.yml:6` (comment `3360364191`):

> This is why the test is not running in CI on
> endo-but-for-bots. We should run on all pull requests
> regardless of base branch.

The workflow's `pull_request` trigger has `branches: [master]`
filter. PRs against non-master bases (e.g., `llm`, frozen
bases like `master-07aff33`) are not triggering the workflow.

## Required change

Remove the `branches: [master]` filter on the `pull_request`
trigger so the workflow runs on PRs against ANY base.

Current shape (likely):
```yaml
on:
  push:
    branches: [master]
  pull_request:
    branches: [master]
```

Target:
```yaml
on:
  push:
    branches: [master]
  pull_request:
```

(Keep `push:` branch filter — only push-to-master runs the
gate, but PR previews should run on any PR.)

## Procedure

1. Edit `.github/workflows/browser-test.yml`.
2. Commit (regular append):
   ```
   ci(browser-test): run on all pull requests regardless of base branch
   ```
3. Push.
4. Reply on inline `3360364191`.

## Per-action authorizations

- Edit `.github/workflows/browser-test.yml`. Authorized.
- One regular-append commit + push. Authorized.
- Inline reply. Authorized.

## Not authorized

- Modifying other files.
- Force-pushing.
- Un-drafting / merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--0de86e/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--0de86e/garden/roles/fixer/AGENT.md`
3. `garden/skills/pr-review-thread-replies/SKILL.md`

Project worktree at `project/` on
`ci/cache-playwright-browsers` (refetch — head should be
the latest, possibly past 37440d0e2).

## Report

A `result` journal entry. Include:

- Old → new trigger config.
- New head SHA.
- Inline reply ID.
