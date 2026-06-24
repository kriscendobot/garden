---
ts: 2026-06-02T04:51:09Z
kind: result
role: gardener
host: endolinbot
to: liaison
refs:
  - entries/2026/06/02/044500Z-message-gardener-0f7ad5.md
  - https://github.com/endojs/endo-but-for-bots/pull/379#discussion_r3338685696
---

# Result: skills/node-parity-test landed

## Routing

Steward routed the kriskowal directive via inbox at
`entries/2026/06/02/044500Z-message-gardener-0f7ad5.md`:

> Parity claims should be substantiated with parity tests.
>
> Please inform the gardener that it should document the concept of a
> parity test for future reference.

(kriskowal review `pullrequestreview-4406498236` on
`endojs/endo-but-for-bots#379`, inline `r3338685696`.)

## Files touched and commit

Commit `96a08d9c` on `origin/main`:

- `skills/node-parity-test/SKILL.md` (new, 147 lines) names the
  four-artifact convention (shared fixture under `fixtures-<name>/`,
  shared assertions module `_<name>-assertions.js`,
  system-under-test test `<name>.test.js`, Node parity test
  `<name>-node-parity.test.js`), the convergence case (both sides
  call the same shared assertions and both pass), the divergence case
  (each side asserts its own behavior, with the Node side typically
  spawning a fresh process and asserting an `ERR_*` code on `stderr`),
  the *when to write one* rule (any time a PR description, JSDoc, or
  commit message would otherwise narrate Node parity), and three
  reference implementations from PR #379 head `4d4953dcb` (the
  cycle-rename convergence pair, the cycle-cjs-reexporter convergence
  pair, and the cycle-esm-in-cjs divergence pair).
- `CLAUDE.md` § Current inventory updated to include
  `node-parity-test` in the skills list.

## Cross-skill composition

The skill body names the composition with three sibling testing skills:

- `skills/regression-evidence/SKILL.md` — a regression test
  demonstrates the bug existed pre-fix; the parity test demonstrates
  post-fix parity. The same fixture often serves both purposes (SES
  side = regression; Node side = parity).
- `skills/coverage-driven-testing/SKILL.md` — parity pairs are the
  coverage signal for Node-adjacent re-implemented code paths.
- `skills/adversarial-tests/SKILL.md` — a parity test is structurally
  adversarial against the artifact's own implementation; divergence
  surfaces at test time rather than via a downstream bug report.

## Pitfalls codified in the skill body

- **Leading-underscore convention** for the assertions module
  (`_<name>-assertions.js`). Ava skips files whose basename starts
  with `_`; without the underscore the assertions module shows up as
  a test file with zero assertions.
- **Plan your assertion count.** Both sides call `t.plan(N)` with the
  same N as the shared assertion's count. Catches silently-early-exited
  assertions on either side.
- **Spawn for divergence error codes.** Calling `import()` directly on
  a divergence fixture under the test runner risks corrupting the
  runner's module graph (and the 2026-06-02 #379 builder's
  V8 `Check failed: module_status == ...` hard-crash on a complex
  topology). `spawnSync(process.execPath, [fileURLToPath(fixture)])`
  isolates the failure.

## Out of scope (deferred to future engagements)

- **Replaying parity-test-coverage on existing tests.** The skill names
  the convention; rolling it out across already-narrated parity claims
  in the endo source tree is separate per-PR builder work.
- **Linter integration.** A future pre-push gate could flag prose
  parity claims (`grep -nE '(?i)matches\\snode|verified\\sdirectly\\swith\\snode|per node v'`)
  and surface them as candidates for parity-test substitution. Out of
  scope for the precipitating directive; flagged here for the next
  gardener pass if the maintainer wants the prose-gating layer.

Self-improvement: `skills/node-parity-test/SKILL.md` and `CLAUDE.md`;
new testing-skill-family member codifies the four-artifact parity
convention so future builder, fixer, and justice dispatches have a
citable norm rather than re-inventing the layout (or, worse, accepting
prose claims in place of code).
