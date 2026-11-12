---
title: Test262 runner: calibrated tiering, sampling, and history diffs
source: .
source_repo: Sharktheone/yavashark
source_commit: 2e159150b2e831440344b48320ac38785a2c460a
source_date: 2026-11-11
source_authors: [Shark (Sharktheone)]
ingested: 2026-11-12
ingested_by: scholar
topics: [testing, engine-implementation]
status: current
notes: "Repo-overview section (source_kind external-monorepo-overview; anchor is repo HEAD on main). Read from a git clone into a scratch dir, treated as untrusted data; foreign-content classifier not run (TYPESAFE_API_KEY absent; maintainer typesafe-bypass directive 2026-11-12). Iron Horse comparisons are against endojs/endo-but-for-bots origin/llm 48d6f3e08bcc (2026-11-02)."
---

## Abstract

Yavashark's Test262 tooling has two parts. A Rust host binary (`crates/yavashark_test262/src`) runs one test per process with a full `$262` (`createRealm`, `evalScript`, `detachArrayBuffer`, `gc`, `IsHTMLDDA`, `global`). A Go orchestrator (`crates/yavashark_test262/runner`, about 4.8k lines) measures each test's CPU, wall time, and peak RSS into a per-hardware calibration file. From those measurements it sorts tests into fast, medium, slow, and risky tiers, pins risky tests to dedicated CPUs under Linux affinity, takes deterministic sampled "quick" subsets, and diffs each run against a committed history to report new failures. The cost-aware scheduling and the sampling are the parts Iron Horse's `full-run.sh` and `endot-ih` sweep do not have.

## Verified mechanics (`runner/`, file commit `bf6dffef` 2026-11-09)

- **Calibration store (`calibration/calibration.go`).** The package comment says it "stores measured costs, never estimates from source size." The file is keyed by environment (for example `github-linux-4`). Each test records `samples`, `cpu_ns`, `wall_ns`, `memory_kb`, `last_status`, and `timeouts`, along with per-environment worker settings. The tiers come from `CostTier`: CPU above 5 s is **risky**, above 100 ms **slow**, above 10 ms **medium**, and anything else **fast**. A scheduled `calibrate-test262-full.yml` workflow refreshes the file.
- **Classification (`scheduler/scheduler.go` `Classify`).** The sources rank in this order: a measurement on this hardware first (a last status of TIMEOUT or CRASH makes the test risky), then the prior CI result's status and CPU time, then a hard-coded rule that `built-ins/RegExp/property-escapes/generated/` is slow, then a checked-in seed table, then fast for a known-completed test.
- **Deterministic sampling (`Make`).** With `selection: "quick"` and `coverage: N`, the runner sorts the fast, medium, and unknown tests by FNV-64a hash of their path and keeps the first N%. The comment calls this "stable, nested sampling across test families": a smaller coverage is always a subset of a larger one, so PR runs are cheap and repeatable. Slow and risky tests are left out of quick runs.
- **Isolation (`cpus/cpus_linux.go`, `run/executor.go`).** Normal and risky pools run with separate worker counts. Risky jobs get their own CPU set through `sched_setaffinity`, with "SMT siblings kept together," and run at low priority. That keeps a runaway test from perturbing the timing of the fast tier.
- **Resource accounting (`test/memory_unix.go`).** Peak RSS comes from the child's `rusage.Maxrss`, normalized for Darwin units. `results.PrintMemoryStats` reports the distribution.
- **History and diffs (`results/diff.go`, `ci/ci.go`).** `ComputeDiffPrev` and `ComputeDiffRoot` compare a run with the previous one. `NewTestFailures` counts regressions. `--diff-filter` limits the report to particular transitions. CI writes `history.json` and per-directory summaries into the separate data repo and prints the PR diff.
- **Profiles (`profiles.json`).** Named presets: `fast` (quick selection, 5 s timeout), `rf` (rebuild in release with LLVM), `interactive` (a 920-line terminal progress UI), and `ci`. A `bench` mode repeats samples for engine benchmarking against Test262 itself.
- **Host binary (`src/`).** It parses the full frontmatter (`negative.phase` and `type`, `includes`, `flags` as a bitflag set, `locale`, `features`), runs `assert.js` and `sta.js` (plus `doneprintHandle.js` for async tests) in the realm, and runs the strict and sloppy variants that the flags select.

## Not present

There is no differential oracle (results are pass or fail against Test262's own assertions), no meter or step-count comparison, and no SES or hardened axis.

Source: [Sharktheone/yavashark](https://github.com/Sharktheone/yavashark/tree/2e159150b2e831440344b48320ac38785a2c460a) at commit `2e159150`.
