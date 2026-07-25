# Investigate intermittent parallel XS-execution test failures in rust/endo (endojs/endo-but-for-bots, base llm)

Standing follow-up from the npm-cas-registry press ticks of 2026-07-25 (jobs/tada/
endo-npm-cas-registry-press-20260725-{045004,105007}.md): at llm commit
`e2c6ff853c`, roughly 2 of 5 full `cargo test -p endo --lib` runs fail
intermittently on parallel XS-execution tests (observed:
`nested_module_relative_imports_resolve_against_referrer`; the failing pair
varies run to run). Each failing test always passes in isolation
(`cargo test <name>`). Suspected shared-XS-cluster contention under the parallel
test harness.

Task: reproduce (loop the lib test suite ~10x in an isolated worktree), diagnose
the contention (shared cluster state? port/socket reuse? tmpdir collision?), and
fix so the suite is reliably green in parallel. Real evidence bar: N consecutive
clean full-suite runs before/after comparison. Open a DRAFT PR against llm.
