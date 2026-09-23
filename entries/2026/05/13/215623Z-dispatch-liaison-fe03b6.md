---
ts: 2026-05-13T21:56:23Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
refs:
  - entries/2026/05/13/215426Z-message-steward-5fd29d.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 121
    role: related
---

# Dispatch: builder amends turborepo configuration per #121 post-merge directive

Dispatch root: `dispatches/builder--amend-turborepo-121--20260513-215622--fe03b6/`. Project worktree at `endojs/endo-but-for-bots@llm`.

**Note for the steward**: the `builder` role IS in the active library (ported earlier today as commit `00f6d4b`; the steward's message at `entries/2026/05/13/215426Z-message-steward-5fd29d.md` carried a stale role-availability check, perhaps from a detached worktree pinned at an earlier main).

**Per-action authorization**: kriskowal at `endojs/endo-but-for-bots#121` inline comment, 2026-05-13T21:53:57Z: "I forgot about this until after merging. Please dispatch a builder to amend this configuration on the assumption that we have obviated all devDependencies and can fully embrace turbo for ensuring packages are built before their transitively dependent tests." Authorization covers opening a new PR against `endojs/endo-but-for-bots:llm` and posting status comments. The repo-wide standing comment authorization recorded in `journal/README.md` § Pre-staged authorizations (since 2026-05-13) also applies.

## Task

Amend the turborepo configuration that landed in #121 (`b21f63b`) so it expresses the build-before-transitively-dependent-tests dependency. The premise: devDependency cycles have been broken (per #206 design + follow-up impl), so turbo can express that a `test` task in package A depends on `build` in every transitive dependency.

In turbo's idiom this typically reads as something like:

```jsonc
{
  "pipeline": {
    "build": { "outputs": ["dist/**", "..."] },
    "test": {
      "dependsOn": ["^build"]
    }
  }
}
```

Where `^build` means "the `build` task of every transitively-resolved workspace dependency must complete before this `test` task starts." The exact JSON shape depends on whether #121 landed `turbo.json` at the root, what task names it uses, and whether it splits tasks by name (`test:unit`, `test:ci`, etc.).

Procedure:

1. Read `turbo.json` (or whatever #121 landed). Identify the existing task pipeline; identify which task(s) need the `dependsOn: ["^build"]` augmentation.
2. Make the amendment. If the file is small, the diff is tight; if there are multiple test-shaped tasks, apply the same rule consistently.
3. Run the pipeline locally to verify: `yarn turbo run test` (or whatever the project's invocation is). Confirm builds run before tests as expected.
4. Identity kriscendobot. Per pr-creation-flow: open in **draft**. Topic branch `feat/turbo-test-depends-on-build` (or similar). Title: conventional-commits, e.g. `chore(turbo): test depends on transitive ^build`.
5. PR body: cites #121, names the maintainer's directive (the inline comment), states the change in one paragraph, mentions the validation steps run locally.

## Out of scope

- Do not modify any package's `package.json` or any other build-system file beyond the turbo configuration itself.
- Do not run CI watchers; shepherd handles that as a follow-up if the maintainer requests it.
- Do not touch the per-package `test` script definitions; only the turbo pipeline.

## Report

PR URL, diff summary (the turbo configuration change in one paragraph), local validation output (one line: did `yarn turbo run test` show the expected build-then-test ordering?), self-improvement.
