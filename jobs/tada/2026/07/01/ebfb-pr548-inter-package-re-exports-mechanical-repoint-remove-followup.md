All deliverables are complete, verified, and the remaining blocker honestly surfaced to the maintainer. Writing the completion report.

## Completion report

**Job:** Write the second (mechanical repoint-and-remove) PR for #548's inter-package plain re-exports, then confirm to erights that both PRs are written.

**What I delivered (endojs/endo-but-for-bots, bot identity):**
- **PR #590** (stage 1, non-breaking, base `llm`, ready): repoints every in-repository importer of `@endo/far`'s plain re-exports onto the originating packages (`E` → `@endo/eventual-send`; `Far`/`getInterfaceOf`/`passStyleOf` → `@endo/pass-style`; `FarRef`/`ERef`/`EOnly`/`EReturn`/`EResult` types → `@endo/eventual-send`), across all import forms (static `import`, JSDoc `@import`, `import(...)` type queries, dynamic `await import`) — 249 files across 25 packages — adds `@deprecated` JSDoc to each re-export, and adds the needed `@endo/eventual-send`/`@endo/pass-style` workspace deps (promoting devDep→dep where a source module imports). Separate `chore: Update yarn.lock` commit + a changeset.
- **PR #591** (stage 2, breaking, draft, stacked on #590): removes the now-unreferenced re-exports (leaving `@endo/far` empty), removes its redundant tests, majors `@endo/far`, and carries the "must not merge to `endojs/endo` until confident no outstanding importers" deferral note.
- **Scope:** the canonical `@endo/far` slice done end-to-end; the remaining inter-package re-exporters (`@endo/marshal`→pass-style, `@endo/captp`→marshal/nat, `@endo/patterns`→marshal) are enumerated in the PR/reply as sibling slices per the design's "a slice at a time."
- **Replied to erights on #548** (comment confirming both PRs) plus an honest CI follow-up.

**Verification (what I actually ran):** ESLint 0 errors on all 249 changed files and on `where`/`zip` in isolation; Prettier clean; `@endo/far` `tsc --build` clean; `@endo/exo` (3/3) and `@endo/exo-stream` (92/92) pass under real SES lockdown. On CI: the **full test matrix is green** (test/cover on 22.x+24.x × ubuntu+macos, sandbox-drivers, browser-tests, build, build-wasm, familiar-bundle — 23 checks pass).

**Open follow-up (surfaced to maintainer, needs decision):** the `lint` CI check is red — but not from this change. It fails on `packages/where`/`packages/zip` (untouched) with `none of those TSConfigs include this file`, a typescript-eslint `projectService` scaling ceiling on the 90+ package monorepo that a repo-wide repoint tips over (isolation-clean; memory-independent; `llm` baseline reproduces it locally; `ci.yml` never runs on `llm` pushes so trunk lint drifts uncaught). Two config fixes attempted and reverted (neither a clean drop-in). This is repo-wide lint-infra scope, deliberately not bundled into the refactor; I asked erights whether to open a separate lint-infra fix. Recorded the lesson to memory (`reference-endo-lint-projectservice-scaling-ceiling`).

<<<GARDEN-JOB-COMPLETE>>>
