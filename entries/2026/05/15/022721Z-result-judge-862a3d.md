---
ts: 2026-05-15T02:27:21Z
kind: result
role: judge
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 240
    role: target
refs:
  - entries/2026/05/15/022238Z-dispatch-liaison-862a3d.md
---

# Result: judge code-panel on #240 (in-band-fallback)

**Panel kind:** code-panel (12 seats: assessor, typist, stylist, packager, archivist, prover, curator, migrator, locksmith, warden, saboteur, breaker).

**Panel execution:** in-band-fallback. `ToolSearch` for "Agent / task spawn / subagent dispatch" surfaced only `TaskStop` and `EnterWorktree`; no spawning tool. Ran each seat as a single block bound to the role file's primary surface, one at a time, aggregated only after all twelve completed.

**Verdict:** COMMENT (formal `gh pr review --comment` submitted at 02:27:13Z). GitHub blocks `--request-changes` on self-authored PRs (kriscendobot authored the PR and ran the panel); per `skills/panel-review/SKILL.md` § Pitfalls the body carries the explicit "Must-fix before merge" heading so the orchestrator's dispatch matrix keys on it. PR remains in draft per dispatch instruction; no un-draft this round.

**Counts:** 0 code must-fix, 1 doc must-fix-clarification, 3 should-fix, 3 out-of-scope.

**Must-fix (doc):**
- `turbo.json.md` framing of the current cycle-fatality contradicts the prior doc's note that turbo 2.9 demoted the cycle check to a warning. Repo pins `turbo: ^2.9.10`. The new doc says the cycle was "fatal under turbo's cycle check" and the PR body says the dry-run "refuses to compute a task graph". Resolve the contradiction (either re-cite the demoted-to-warning sentence and explain why this case still exits non-zero, or update the framing to admit the cycle is fatal in our case with one sentence on why).

**Top-3 must-fix and should-fix items (combined, ranked by signal):**
1. Doc must-fix above (cycle-fatality framing).
2. Should-fix: credit `build`'s new `^build` edge for the invariant; the doc currently frames `test`'s explicit `^build` as load-bearing when in fact the transitive cascade is carried by `build`'s edge.
3. Should-fix: name the CI consumer (`.github/workflows/ci.yml` `test` job at line 169 invokes `yarn turbo run test`; the new task graph applies there but not to the `lint` job).

**Fourth should-fix (out of top-3 framing):** commit subject `feat(turbo): test depends on transitive ^build` enumerates only the `test` edge, omitting the `build` task's new `^build` edge.

**`@copilot` requested:** `gh pr edit 240 --add-reviewer @copilot` ran successfully at dispatch start.

**Next step (liaison decision):** must-fix is doc-only and small. Dispatch a fixer to (a) resolve the doc framing on cycle fatality, (b) credit the right edge, (c) name the CI consumer, and optionally (d) reword the commit subject. After fixer returns, the orchestrator re-dispatches the judge for re-review and (if clean) un-draft.

Self-improvement: nothing this time.
