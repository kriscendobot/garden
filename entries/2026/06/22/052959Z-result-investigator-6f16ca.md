---
ts: 2026-06-17T00:00:00Z
kind: result
role: investigator
repo: endojs/endo
project: endo
---

Investigated endojs/endo#3295 (`fix(eslint-plugin): drop conflicting project parser option`) in response to kriskowal's 2026-06-08 question citing endo-but-for-bots#428 as proof that lint is not broken on master.

Files examined:
- `packages/eslint-plugin/lib/configs/internal.js` (master and PR branch)
- `typescript-eslint/packages/typescript-estree/src/parseSettings/createParseSettings.ts` (v8.60.0 and v8.57.0)
- `typescript-eslint/packages/typescript-estree/src/parser-options.ts` (v8.60.0)
- CI checks for endo-but-for-bots#428 and endo#3295

Key findings:

1. `useProjectService: true` is not the "legacy project mechanism." It was an option name in typescript-eslint v7/early v8 experiments that was renamed to `projectService` in v8.0.0 (stabilized from `EXPERIMENTAL_useProjectService`). In v8+, setting `useProjectService: true` in parserOptions is a no-op: the option is unrecognized and silently ignored.

2. The actual conflict-throw ("Enabling project does nothing when projectService is enabled") was introduced in typescript-eslint commit `997e0c00` (2025-11-10) and is present from v8.57.0 onward. It fires only when both `tsestreeOptions.project` (the path-glob array) AND `parseSettings.projectService` are set. The endo config does not set the `project` path-glob option alongside `projectService`, so the throw never executes.

3. Probe endo-but-for-bots#428 confirmed: lint passes on master without the PR's change. The PR's own CI also shows lint passing. No problem exists.

4. The PR removes dead config (`useProjectService: true`) and adds a clarifying comment. The change is harmless but so is the status quo. No changeset was included.

Recommendation delivered: close. Posted top-level comment at https://github.com/endojs/endo/pull/3295#issuecomment-4765202938 citing all three probes (probe PR CI, upstream PR CI, typescript-eslint source examination) and recommending closure.

Self-improvement: the comment-posting via `gh api --field body=...` fails when the body contains special shell characters; posting via `gh api --input -` with JSON from Python stdin is the reliable path. Worth noting in the investigator role or a journal message for future dispatches that post upstream comments.
