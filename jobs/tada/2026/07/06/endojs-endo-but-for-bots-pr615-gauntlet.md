The gauntlet is complete. PR #615 is un-drafted, CI green (24/24), panel review posted, follow-up ledger recorded.

---

## Completion report — gauntlet on endojs/endo-but-for-bots #615 (Shell capability)

**Outcome:** PR #615 driven through the full gauntlet (clean → panel → fix-loop → un-draft) and **un-drafted into the maintainer's review queue**, CI all-green (24/24 SUCCESS), `mergeStateStatus: CLEAN`.

**Panel (26-seat code panel).** Sensed via panel-hints, fanned as parallel seat-cluster reviewers over the diff (new `@endo/exo-shell` + `@endo/host-spawner` packages, daemon `provideShell`/`formulateShell`, `makeShellTool`, genie spawner). I supervised as foreperson, verifying each load-bearing finding against the source before dispositioning. Key adjudications:
- **Verified must-fix:** changesets were absent though `.changeset/config.json` sets `privatePackages.version:true` and the repo changesets private packages (packager/migrator/gateway's "private→exempt" was wrong; releaser was right).
- Confirmed the security boundary is honestly closed (daemon bakes a sanitized `{PATH,LC_ALL}` env; `shell:false` hard-coded; allowlist/env frozen).
- Corroborated findings: timeout not a guaranteed bound (SIGTERM-only), `inspect()` type/guard drift, `M.splitRecord` open-by-default with a false "closed" comment, `whichProgram` dir-as-executable, stale test-path ref.
- Dispositioned em-dashes in code comments as **acknowledge** (endo house style; sibling-consistency outweighs the garden convention there).

**Concurrency note (important).** Mid-job the reaper requeued me; a **peer gardener drove the same PR in parallel** and pushed the core fixes first — with a partly *stronger* approach (configurable `killGraceMs`, a genuinely closed splitRecord guard, and an opt-in `killProcessGroup` addressing the detached-grandchild residual I'd deferred). I reset onto their tip and contributed only the **non-duplicative delta** rather than clobbering their work.

**My delta (commits `9a73d0f22` + `c0f3e6b71`, on top of the peer's fixes):**
- 4 changesets: `@endo/exo-shell`, `@endo/host-spawner`, `@endo/daemon`, `@endo/agent-tools` (all minor).
- README: delegating-command (interpreter/`env`/`find -exec`/`git -c`) caveat + dropped the interpreter from the example.
- `whichProgram`: confirm a regular file before treating a PATH candidate as executable.
- `shell-tool.js`: fixed stale divergence-gate test path; noted reject patterns/flags default to empty.
- `host-spawner.js`: `defaultEnv` host-env warning; repointed stale `./command.js`/`./sandbox-spawner.js` refs to `@endo/genie`; removed a comment banner; Latin-shorthand + README em-dash prose.

**Verification (real execution):** exo-shell 12✓, host-spawner 5✓, agent-tools 56✓, daemon-shell 5✓ (ava, run directly); eslint 0 errors; prettier clean; then full CI **24/24 SUCCESS** on the final head `c0f3e6b71`.

**Artifacts:** panel review posted as a formal COMMENTED review; follow-up ledger written to `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--615.md` (pushed to journal2).

**Follow-ups deferred (in the ledger, revisit at merge):** capability-type de-duplication (daemon should import from `@endo/exo-shell`); safe-by-default `makeHostSpawner` env (needs coordinated genie change); `fast-check` property tests for `drainBounded`/timeout math; `provideShell` provide-time validation asymmetry; off-tree "design §" comment repointing.
