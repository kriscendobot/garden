---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 615
created_at: 2026-07-06T22:28:28Z
last_appended_at: 2026-07-06T22:28:28Z
status: parked
---

# Follow-ups for endo-but-for-bots#615

PR #615 adds the Shell capability (`provideShell` + `makeShellTool`, daemon-agent-tools
Phase 2). The panel's must-fix and in-scope should-fix items were addressed in follow-up
commits before un-draft; the items below were dispositioned follow-up (out of scope for
this PR) and are recorded for revisit at merge time.

## Items

- [ ] Capability-type duplication. `ShellPolicy`, `ShellResult`, and `EndoShell` are
  declared independently in `@endo/exo-shell` and `@endo/daemon` (`src/types.d.ts`). This
  mirrors the existing exo-git/daemon precedent, but the daemon depends on
  `@endo/exo-shell` and could `import type` the shapes and re-export rather than
  redeclare them.
  **Source seat(s)**: curator, integrator, surfacer, typist
  **Recommended action**: Make `@endo/exo-shell` the canonical home; have the daemon import and re-export. Small structural refactor; open a follow-up PR.

- [ ] Safe-by-default child environment for `makeHostSpawner`. The exported default
  `defaultEnv = process.env` inherits the full host env for any caller that constructs the
  spawner with no/partial args. The daemon closes this by passing an explicit sanitized
  base env (and the JSDoc now warns about it), but the package default is unsafe-by-default;
  the safe default is `{}`.
  **Source seat(s)**: locksmith, assessor
  **Recommended action**: Change the default to `{}` in lockstep with updating genie's `command.js` caller (which relies on inheriting the host env for its dev-repl command tool). Coordinated change; do not do it piecemeal.

- [ ] Property-based tests. `drainBounded` over arbitrary chunk sequences x `maxOutputBytes`
  (assert kept bytes are exactly the first `min(total, cap)`, plus the `truncated` flag),
  and the narrow-only timeout math after extracting a pure `resolveTimeout(policy, requested)`
  helper. `fast-check` is already an in-repo test dependency.
  **Source seat(s)**: fast-checker, prover
  **Recommended action**: Add `fast-check` to `@endo/exo-shell` devDependencies and add the two properties; open a follow-up PR.

- [ ] `provideShell` provide-time validation asymmetry. The provide-time precheck rejects a
  read-only mount but not a non-mount backing, while the reincarnator rejects both, so a
  daemon-minted non-mount cap can persist a formula that only fails at incarnation.
  **Source seat(s)**: integrator
  **Recommended action**: Make the provide-time check reject everything the reincarnator does, or document that it is best-effort. Small change; fold into the next daemon-formula pass.

- [ ] Off-tree design references in code comments. `shell.js` and `shell-tool.js` cite
  "the design" (issue #611) with section numbers that a source reader cannot resolve
  in-tree; the README "honest boundary" section is the one that resolves.
  **Source seat(s)**: archivist
  **Recommended action**: Repoint the comments at the in-repo README section. Cosmetic; fold into a later docs pass.
