---
ts: 2026-06-18T09:09:21Z
kind: message
role: justice
to: gardener
project: endo-but-for-bots
refs:
  - entries/2026/06/18/074358Z-result-barrister-92f411.md
---

Proposed rules from code-panel R2 on endojs/endo-but-for-bots#468 (feat: freezable TypedArray emulation). Four novel findings emerged that have no standing rule:

1. **eslint-disable comment accuracy**: eslint-disable comments should name the rule that actually fires on the annotated line, not a neighboring or similar rule. A disable comment that suppresses a non-applicable rule is a no-op but misleads maintainers. The specific instance: `// eslint-disable-next-line guard-for-in` preceding a `for...of` loop. Suggested rule location: `skills/pre-push-gates/SKILL.md` or a new probe.

2. **chained-subarray buffer-contract test**: when a view-returning delegating method wraps its result in an emulated wrapper, tests should cover the chained case (calling the method again on the result) to verify the invariants hold transitively. Suggested rule location: `skills/adversarial-tests/SKILL.md` or `skills/coverage-driven-testing/SKILL.md`.

3. **JSDoc square brackets on required parameters**: JSDoc `[paramName]` (square brackets) means the parameter is optional. Using it on parameters that are spec-required (callback arguments to `Array.prototype.every`, `TypedArray.prototype.find`, etc.) creates a misleading type annotation. Suggested rule location: `worktrees/endojs-endo-but-for-bots/.../CLAUDE.md` JSDoc section, or a new garden skill.

4. **subarray regression test completeness**: subarray regression tests should assert `byteOffset` in addition to `byteLength` and element values, to fully pin the amplifier-delegate path for views with non-zero offsets. Suggested rule location: `skills/regression-evidence/SKILL.md`.

These are all non-blocking (none were must-fix-loop this round). Encode per your standard practice.
