---
ts: 2026-06-04T04:35:01Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--ca5cd9
prs:
  - repo: endojs/endo-but-for-bots
    pr: 418
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/418
  - https://github.com/endojs/endo-but-for-bots/pull/418#discussion_r3353485138
---

# dispatch: fixer — #418 single follow-up: use @endo/bytes at worker-archive-parsers.js:50

Maintainer review `4424734833` (APPROVED, 2026-06-04T04:34:16Z):

> With one follow-up, please address that and pass to the
> conductor.

Single inline at `packages/daemon/src/worker-archive-parsers.js:50`
(comment `3353485138`):

> Use `@endo/bytes`.

## Target

- PR: endojs/endo-but-for-bots#418
- Branch: `fix/endo-make-node-evasive-runtime`
- Head: `195cc370a` (post tsconfig fix).
- Base: `llm-2bd9e0c`.

## Required change

Read the current code at `worker-archive-parsers.js:50` to
understand what byte handling is there (likely a manual
Buffer/Uint8Array operation). Replace with the equivalent
`@endo/bytes` call.

Use judgment on which @endo/bytes function fits.

## Procedure

1. Read `packages/daemon/src/worker-archive-parsers.js` line
   ~50 (plus surrounding context).
2. Identify what byte operation is there.
3. Replace with `@endo/bytes` equivalent. Add the dep to
   `packages/daemon/package.json` if not already present.
4. If `package.json` changed: regenerate composite tsconfig
   (`yarn build:types:gen`) to avoid the drift we just
   fixed.
5. Run gates: `yarn workspace @endo/daemon lint`,
   `lint:types`, `ava` on relevant tests.
6. Commit:
   ```
   refactor(daemon): use @endo/bytes in worker-archive-parsers
   ```
7. Push.
8. Reply on inline thread `3353485138` with new SHA.

## After fixer push

The liaison will dispatch the conductor per kriskowal's
"pass to the conductor" directive.

## Per-action authorizations

- Edit `packages/daemon/src/worker-archive-parsers.js` and
  `packages/daemon/package.json` (if dep add needed) and
  `packages/daemon/tsconfig.composite.json` (if regen
  needed). Authorized.
- One regular-append commit + push. Authorized.
- Inline reply on `3353485138`. Authorized.

## Not authorized

- Modifying files outside `packages/daemon/`.
- Force-pushing.
- Un-drafting / merging (conductor's job after this fixer).

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--ca5cd9/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--ca5cd9/garden/roles/fixer/AGENT.md`
3. `garden/skills/pr-review-thread-replies/SKILL.md`

Project worktree at `project/` on `fix/endo-make-node-evasive-runtime`
(head `195cc370a`).

## Report

A `result` journal entry. Include:

- Old code snippet around line 50.
- New code using @endo/bytes.
- New head SHA.
- Whether package.json/tsconfig.composite.json changed.
- Local gate exit codes.
- Inline reply ID.
- Judgment calls.
