---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1412
panel_kind: code
base_ref: dc960427fe6734d96748cf68c7ccfc6455f3aeec
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 2467b3a2deeba11ef311f4509a814037f507d774
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: aea5fcfffd2c
recorded_by: endolin-garden-ece02cb4
---

# Panel run — endojs/endo-but-for-bots #1412 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `2467b3a2`

seat verdicts (34): archivist=must-fix assessor=pass benchmarker=pass breaker=comment changeset-auditor=pass corner-prober=comment coverage-auditor=pass curator=must-fix decomplector=comment duality-auditor=comment engine-realist=comment fast-checker=comment gateway=comment integrator=comment locksmith=comment migrator=comment orthographer=comment packager=comment procurer=pass prover=pass pruner=must-fix purist=comment reexport-auditor=pass releaser=comment saboteur=comment scribe=comment spec-keeper=comment stylist=comment surfacer=comment thesaurus=pass transplanter=comment typist=pass warden=comment wire-watcher=must-fix
must-fix items (20):
- archivist: ## Findings
- curator: **should-fix: the new makers are reachable only through subpath exports with no `types` condition.**
- curator: `package.json:36-42` adds seven subpaths such as `"./cli-backend.js": "./src/cli-backend.js"`.
- curator: The only `types` mapping is the root `"."` entry (`package.json:33`), which points at `claude.types.d.ts`.
- curator: TS consumers resolving `@endo/claude/cli-backend.js` get `.js` only. Types come from JSDoc, and the option types that...
- curator: The repo's own convention is thunk modules at the package top level, not `exports` entries pointing into `src/`. See ...
- curator: Fix: give each subpath a `{ types, default }` pair. Or justify the direct `src/` mapping, since `files` includes `src...
- curator: [rule: AGENTS.md § The `types-index` convention / Thunk modules]
- curator: **should-fix: the two flagship makers are not exported from the entry point.**
- curator: `index.js` is the documented public entry and re-exports its "building blocks". It does not re-export `makeClaudeCliB...
- curator: It also leaves out `buildConfinementFlags`, `CLAUDE_CODE_RESPONSE_SHAPES`, and `makeClaudeStreamReducer`.
- curator: The package therefore has two disjoint public surfaces: root exports and subpath exports. The README lists them (`246...
- curator: Either re-export the two makers from `index.js`, or state in `index.js` that the backends are subpath-only and why.
- curator: [proposed-rule: every maker named in a changeset is importable from the package root, or the entry file documents why...
- curator: **should-fix: `src/*` modules export more than the declared surface.**
- curator: Examples: `acquireAdmission`, `runBoundedCleanups`, `errorCategory`, `CLEANUP_GRACE_MS` (`turn-guard.js`), `unavailab...
- curator: Because `./response-shapes.js` and `./stream-reducer.js` are public subpaths, all of these are now semver-bound.
- curator: Several look like internals. `turn-guard.js` is correctly not a subpath, but `response-shapes.js` exposes its interna...
- curator: Filter to the intended public subset with a documented thunk, or trim the exports. The PR also leaves the public inve...
- curator: **comment-only: the bump level `minor` is correct for added surface.**
