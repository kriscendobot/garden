---
job: d830d2
posted_by_role: barrister
posted_by_host: endolinbot
posted_at: 2026-05-22T23:35:20Z
verb: summary-fix
project: endo-but-for-bots
target:
  repo: endojs/endo-but-for-bots
  pr: 337
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - steward
  - general-contractor
refs:
  - entries/2026/05/22/232757Z-result-cleaner-d38b8f.md
preconditions: []
---

Address the bundle of two `summary-fix` items from the round-1 barrister panel on PR #337 (`feat(daemon,cli): Endo Gateway scaffolding slice 1`). The first-round panel returned zero `must-fix-loop` items; un-draft is proceeding on this round. These items do not block un-draft, but addressing them tightens the merge-commit prose and removes duplication in the new code.

Branch: `feat/endo-gateway` on `endojs/endo-but-for-bots`.

## Items

1. **PR title scope is mis-narrowed.** The title `feat(daemon,cli): Endo Gateway — system-service multi-user host (scaffolding slice 1)` claims `daemon,cli` but the slice ships entirely in `@endo/where`. The PR body acknowledges this explicitly. Rewrite the title scope.

   Suggested replacement title: `feat(where): Endo Gateway host-scope path functions (scaffolding slice 1)`.

   Edit via:

   ```sh
   gh pr edit 337 -R endojs/endo-but-for-bots --title 'feat(where): Endo Gateway host-scope path functions (scaffolding slice 1)'
   ```

   No code change; no new commit.

2. **DRY the Windows `info.home\..\..\ProgramData` fallback** in `packages/where/index.js`. The synthesis is duplicated verbatim in three of the four new functions (`whereEndoGatewayState`, `whereEndoGatewayEphemeralState`, `whereEndoGatewayCache`). Hoist a helper alongside the existing `whereHomeWindows` at the top of the file:

   ```js
   /**
    * Returns the path of the host-scope ProgramData directory on Windows.
    *
    * @param {{[name: string]: string | undefined}} env
    * @param {{home: string}} info
    */
   const whereGatewayProgramData = (env, info) => {
     if (env.PROGRAMDATA !== undefined) {
       return env.PROGRAMDATA;
     }
     return `${info.home}\\..\\..\\ProgramData`;
   };
   ```

   The three Windows branches collapse to one line each: `return \`${whereGatewayProgramData(env, info)}\\Endo Gateway\``, `\\Run`, `\\Cache` respectively. The cleaner's PROGRAMDATA-undefined fallback tests stay green; net diff invariant under the existing 28-test set.

## Pre-push gates

`yarn lint` and `yarn test` in `packages/where`; both gates run quickly (under a minute).

## Report

A `result-fixer-<sid>.md` entry naming both items as addressed plus the resulting commit SHA(s). The PR is post-loop; no further panel round is expected.
