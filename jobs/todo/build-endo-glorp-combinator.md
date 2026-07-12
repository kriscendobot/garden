---
role: builder
---

# Build: `glorp` combinator (grep over glob results) — fresh stacked PR

**Repo:** `endojs/endo-but-for-bots`. **Base:** the roadmap branch (`llm`) via the
`#127` decomposition — this is a **fresh PR stacked on the decomposed stack**, NOT a
change to `endojs/endo-but-for-bots#127` (which stays CLOSED). Maintainer directive
(kriskowal, 2026-07-12).

## What `glorp` is

A convenience combinator equivalent to:

```
grep(grepPattern, { files: await glob(globPattern) })
```

i.e. grep a pattern across the files a glob matches. **Crucially, this is the
Array-case composition from the original `#127` design**: grep takes **`files`** — an
array (or promise-of-array) of paths produced by `glob` — it does **NOT** take glob as
an embedded option. glob is the independent path producer; grep consumes the paths;
`glorp` is the thin convenience that wires `await glob(globPattern)` into grep's
`files`. Keep glob and grep decoupled underneath (do not couple glob into grep to
implement this).

## Stacking

`glorp` needs both the glob and grep surfaces from the `#127` decomposition, so stack
it on **grep-atop-glob**:
- grep: `endojs/endo-but-for-bots#655` (C, open) + `endojs/endo-but-for-bots#680`
  (C-prime, MERGED)
- glob: `endojs/endo-but-for-bots#679` (B-prime, open)

Resolve the **actual correct base branch** from the current decomposition state before
opening the PR (per [pr-dependency-graph](../../skills/pr-dependency-graph/SKILL.md) /
[stacked-pr-build](../../skills/stacked-pr-build/SKILL.md)): if the grep/glob surfaces
`glorp` calls are already merged to `llm`, base on `llm`; otherwise stack on the frozen
base of the highest open predecessor that provides them ([frozen-base-branch](../../skills/frozen-base-branch/SKILL.md)).
State the base you chose and why in the PR body.

## Scope

- Implement `glorp` as the combinator above, wherever glob/grep live in the decomposed
  packages (platform-fs / agent-tools surface, matching where glob and grep landed).
  Expose it at the same layer/surface as glob and grep so it is discoverable alongside
  them.
- Load-bearing tests ([regression-evidence](../../skills/regression-evidence/SKILL.md)):
  a `glorp(globPattern, grepPattern)` produces exactly `grep(grepPattern, { files:
  await glob(globPattern) })` for representative inputs (matching set, empty glob,
  no-grep-match). Prove each test fails when the wiring is broken.
- **Do not** reopen, modify, or reference-close `endojs/endo-but-for-bots#127`; it stays
  closed. `glorp` is purely additive on the decomposition.
- Consider whether a **streaming** `glorp` belongs to the deliberately-separate
  `streamGlob`/`streamGrep` design (`endojs/endo-but-for-bots#647`) — if so, keep this
  PR to the **Array** case and note the streaming variant as out-of-scope follow-on.

## Norms
- Draft PR against the resolved base; the build auto-runs the gauntlet (clean → panel →
  fix-loop → un-draft) under the supervising gardener.
- [worktree-per-pr](../../skills/worktree-per-pr/SKILL.md),
  [local-verify](../../skills/local-verify/SKILL.md),
  [pre-push-gates](../../skills/pre-push-gates/SKILL.md),
  [yarn-lock-separate-commit](../../skills/yarn-lock-separate-commit/SKILL.md),
  [self-improvement](../../skills/self-improvement/SKILL.md).

## Done
A draft `feat` PR on `endojs/endo-but-for-bots`, stacked on the correct `#127`-decomposition
base, implements `glorp` as the Array-case grep-over-glob combinator (glob/grep kept
decoupled), with load-bearing tests, and does not touch the closed `#127`. The `tada`
report gives the PR number, the base chosen and why, and the test evidence.
