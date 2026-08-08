---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-08T07:22:35Z
---
---
dispatch: panel seat `prover` — endojs/endo-but-for-bots#969 (gauntlet panel round 4)
pr: endojs/endo-but-for-bots#969
seat: prover
---

Reviewed the PR diff at `65959a5d5..5ef855a02` (12 files) in worktree
`scratch/project-wt-ironhorse-full-test262-automation-gauntlet-panel-4-98bb3aed`.
Note: the local `llm` ref is 472 commits stale, so `git diff llm...HEAD` shows an
unrelated 187 KB superset; the true PR range is the 5 head commits, matching
`gh pr view 969 --json files` (12 files). `cargo` is absent from this container,
so findings are static-analysis-based; no mutation experiment was executed.

### prover (regression evidence)

**Verdict:** request-changes

**Findings:**

- (must-fix) `rust/engine/ironhorse-262/src/bin/ironhorse_262_report.rs:186-198`
  and `:238-249` — the PR's central new trust gates (`validate --expected-count`,
  `aggregate --expected-total`, and the `warnings → fail` refusal at `:232-237`)
  live only in the binary, which has no `#[cfg(test)]` module, and no file under
  `rust/engine/ironhorse-262/tests/` exercises them. Deleting
  `if _cases.len() != expected_count { fail(...) }` leaves the whole suite green.
  These are exactly the properties commits `91577009a` / `2c96f5a8d` exist to
  establish ("make full sweep completion trustworthy", "close sweep trust gaps"),
  and the module doc at `:1-7` asserts the opposite — "every subcommand is pure
  filesystem work, unit-tested in `ironhorse_262::report`". Move the two count
  comparisons into `report.rs` as testable predicates and pin both the accept and
  the reject arm. [rule: skills/regression-evidence/SKILL.md § Equivalence claims
  need a backing test]

- (should-fix) `rust/engine/ironhorse-262/src/xst.rs:442` — the new
  `shared-test262-failure` branch is placed *before* the `error_agrees` check, so
  it also captures the disagreeing abort that previously returned
  `RunSkip("abort-value-differs")`. Those two reasons classify differently:
  `abort-value-differs` → `Category::Unsupported` (`report.rs:184`, the actionable
  backlog), `shared-test262-failure` → the unknown-reason fallback
  `Category::Infrastructure` (`report.rs:197`, "not an Ironhorse gap"). The only
  new test, `xst.rs:1183 positive_shared_test262_error_is_not_covered`, sets
  `error_agrees = true`, so moving the check inside the `error_agrees` arm keeps
  every test green while silently shifting the published report's
  Unsupported/Infrastructure split. Add an `error_agrees = false` case pinning the
  precedence, and an explicit
  `assert_eq!(classify(Outcome::RunSkip, "shared-test262-failure"), Category::Infrastructure)`
  so a new family's category is asserted, not incidental.
  [rule: skills/regression-evidence/SKILL.md § Procedure]

- (should-fix) `rust/engine/ironhorse-262/src/test262.rs:258-310` — the two new
  public functions `collect_js_direct` and `collect_js_batch` gained no tests in
  `test262.rs`. `collect_js_direct`'s `_FIXTURE.js` exclusion must agree exactly
  with `discover_into`'s duplicated predicate (`report.rs:892-899`) because
  `full-run.sh:255,280` compares the two counts per batch; a drift quarantines
  every directory holding a fixture and silently drops it from a published
  report. That agreement is pinned only by `report.rs:1915
  discovery_partitions_the_whole_tree`, which `return`s silently when
  `locate_test262()` finds nothing. `report.rs:1710
  batch_case_count_uses_the_runner_selection_boundary` writes no `_FIXTURE.js`, so
  it does not pin it either; adding one file there is a one-line fix.
  `collect_js_batch`'s `size == 0` and index-overflow guards are unreached by any
  test. [rule: skills/coverage-driven-testing/SKILL.md]

**Notes (out of scope but worth flagging):**

- `report.rs:168-178` — `INFRASTRUCTURE_REASONS` reads as load-bearing but only
  `negative-oracle-unexpected` is: every other entry (`oracle-machine-error`,
  `oracle-shim-unsafe`, `oracle-gate-off`, `quarantine:`) already reaches
  `Infrastructure` via the fallback at `:197`, so the assertion at `:1300-1303`
  passes identically with that entry deleted. Pinning `quarantine:` — the reason
  the new `quarantine` subcommand writes — would at least make one more entry
  observable. [rule: skills/regression-evidence/SKILL.md § Why]

- `full-run.sh:262-275` (the watchdog reap, commit `5ef855a02`) has no automated
  evidence; the crate carries no shell-level test harness, so this is noted rather
  than charged. [proposed-rule: a shell orchestrator that acquires a new
  process-lifecycle invariant should carry at least one scripted smoke assertion,
  or say in the PR body why it cannot]

Self-improvement: the dispatch prompt's worktree path was missing its `-98bb3aed`
hash suffix and its named diff base (`llm`) was 472 commits stale — both cost a
round trip before any review happened. Worth teaching the panel dispatcher to pass
the PR's actual base OID (`gh pr view --json baseRefOid`) rather than a branch
name a per-job worktree may not have fetched, and to verify the worktree path
exists before fanning out the seats.
