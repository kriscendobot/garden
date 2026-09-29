---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
---

# Open the draft PR for the Ironhorse resource-limit policy (already built and pushed)

Named successor of `endojs-endo-but-for-bots-ironhorse-panic-configurable-hardened262-20260929`. That job finished all engineering, tests, and diagnostics and pushed the branch. It could not open the PR because the `kriscendobot` PAT on host `oros-studio-garden-ce242c49` gets `GraphQL: Resource not accessible by personal access token (createPullRequest)` on endojs. This job is pinned to `endolin-garden-ece02cb4`, whose PAT has opened endojs PRs. **The only remaining work is opening the PR.** Do not rebuild or re-run the sweeps.

- Repo: `endojs/endo-but-for-bots`
- Head: `feat/ironhorse-resource-limit-policy` at `716cbf2029` (verify with `git ls-remote origin feat/ironhorse-resource-limit-policy`; if the tip differs, stop and report).
- Frozen base (already pushed): `llm-3aa902d` = `3aa902d003702cd70dda6b3ebe2aeb0288dfd61d`, the `llm` tip at build time.

Steps:
1. Write the PR body below (between the `~~~markdown` fence lines, exclusive) to a file.
2. Run `scripts/jobs/gardening/ensure-pr.sh <THIS job base> endojs/endo-but-for-bots feat/ironhorse-resource-limit-policy llm-3aa902d --title "feat(ironhorse): make resource-limit aborts configurable; ratchet hardened262 under both policies" --body-file <file>`. It is draft by default; leave the PR as a draft, since the maintainer owns the gauntlet trigger. If it finds an existing PR for this head, adopt it.
3. Report the PR URL. Do not message `activate-ironhorse-ratchet-autopilot-20260929`; it was already told about this branch. Do not touch https://github.com/endojs/endo-but-for-bots/pull/1359 or `jobs/plan/ironhorse-test262-ratchet-round3-floor-resolution-20260928.md`.

PR body:

~~~markdown
<!-- garden-job: endojs-endo-but-for-bots-ironhorse-panic-configurable-hardened262-20260929 -->

## Summary

Ironhorse's resource-limit behavior is now configurable. Previously, every resource ceiling ended the crank with an uncatchable halt. That forecloses classifying what a program does past the limit: the round-3 test262 ratchet found 443 positive cases that end as the non-gating `ironhorse-aborted-limit` skip.

- **`ResourceLimitPolicy::Panic`** (default, unchanged): the native re-entry budget (`Halt::ReentryLimit`), the value-stack geometry (`Halt::StackOverflow`), and the storage and matcher caps that return `Halt::HeapExhausted` stop the crank uncatchably, as XS's `fxAbort` does. `Halt::is_panic` is unchanged.
- **`ResourceLimitPolicy::Throw`**: the same halts become a guest `RangeError` (`resource limit: heap exhausted` / `native recursion depth exceeded` / `stack overflow`). It is raised through `raise_js` at the dispatch loop that observes the halt, via the one `dispatch_halt!` chokepoint. Guest `try`/`catch` sees it, and an escaping one is an ordinary uncaught throw, so the harness classifies the case as a pass or a failure.
- **Stops the crank under both policies**: the meter, the harness step ceiling, profile refusals, and engine invariants. Arena refusals that unwind the Rust stack mid-operation (`value::heap_exhausted()`) also stop it, because the heap they interrupt is not quiescent and no guest handler may resume on it. So does a `RangeError` whose own allocation is refused.

It is a runtime setting (`Interp::set_resource_limit_policy`), not a Cargo feature, so a single binary can run both configurations in one matrix. Like the arena ceilings, it is host configuration and is not snapshotted (it is classified `HOST_WIRING` in the snapshot ledger).

### Harness

- `endot-ih --resource-limits panic|throw` (`xst::Config::resource_limits`). The runner applies the policy to every harness interpreter a case constructs, including on the bounded case thread and the hang-attribution thread.
- `full-run.sh --resource-limits panic|throw`. A throw sweep records `resource-limits=throw` in its config, command line, and run id. The default adds nothing, so existing pins stay byte-comparable (the ratchet gate's run-parameter check does not change).

### hardened262: both configurations in the existing agent matrix

- New agent `ironhorseThrowOnLimit`: bare Ironhorse under `--resource-limits throw`, wired through the existing agent/scenario cross product and baseline mechanism. No new harness.
- New cases under `test/ironhorse/resource-limits/`: a matcher retained-state overflow and a native re-entry overflow (both of which XS completes), plus a just-inside-the-ceilings twin.
- Baselines: `ironhorse` records the two over-ceiling cases as **failed** (`ironhorse-aborted-limit`), and `ironhorseThrowOnLimit` records them as **passed**. Across the other 123 corpus files the two agents' baselines are identical, which pins that the policy changes nothing below the ceilings. The existing `ironhorse` baseline gains only the three new files, so nothing else drifted.
- `native_lockdown_corpora` (the Rust-side hardened262 gate) now accepts an `ironhorse-aborted-limit` under the default policy only when the baseline records a failure **and** the same case re-run under the throw policy executes its body to the outcome the `ironhorseThrowOnLimit` baseline records.

## Diagnostic: the 443 `ironhorse-aborted-limit` cases under `throw`

This is input for the parked round-3 floor-resolution successor. It does not change floor policy: no pin, `baseline/refresh-*` file, or classifier changes here, and https://github.com/endojs/endo-but-for-bots/pull/1359 is untouched.

The source is the 443 `ironhorse-aborted-limit` entries of `baseline/refresh-20260928/historical-losses.json` on https://github.com/endojs/endo-but-for-bots/pull/1359. They are all `built-ins/RegExp`: 435 in `property-escapes`, 4 in `unicodeSets`, 3 in `CharacterClassEscapes`, and `quantifier-integer-limit.js`. They ran at test262 `be13516fb6`, with the oracle on, `--case-timeout 60`, and `RUST_MIN_STACK=67108864`.

| policy | covered | fail | `ironhorse-aborted-limit` |
| --- | --- | --- | --- |
| `panic` (default, control) | 0 | 0 | 443 |
| `throw` | 0 | **439** | 4 |

- **439 become classifiable, all as failures, none as passes**: `ironhorse threw where the oracle completed: RangeError: resource limit: heap exhausted`. Every one is a returned `HeapExhausted` (a matcher state/payload cap or a storage admission refusal), not an arena unwind. That includes the generated `property-escapes/generated/ASCII.js` case the round-3 notes diagnosed. None of these tests catches the error, so they fail rather than pass. Making them pass needs a matcher that fits these inputs under its caps, not a policy change.
- **4 stay `ironhorse-aborted-limit` under `throw`**: `property-escapes/generated/{Grapheme_Extend,Case_Ignorable,General_Category_-_Mark,General_Category_-_Nonspacing_Mark}.js`. They still end in an uncaught `Halt::HeapExhausted`, so they took one of the paths the throw policy deliberately leaves as an abort: an arena refusal that unwinds, or a refused `RangeError` allocation. I did not determine which one.

## Test plan

- `cargo +1.88.0 fmt --all -- --check` and `cargo +1.88.0 clippy --locked --workspace --all-targets --no-deps -- -D warnings`: clean.
- `cargo +1.88.0 test --locked --release --workspace --no-fail-fast` (`RUST_MIN_STACK=33554432`): **3,511 passed, 0 failed, 43 ignored**. This local run had no `TEST262_DIR` or SES bundle, so the tests that need them skip, as they do in any local run.
- Pre-push gates pass. The typist probe checks whole touched files, so it also normalized three pre-existing characters in `rust/engine/README.md` (curly quotes, `→`, `…`).
- New `ironhorse-vm/tests/resource_limit_policy.rs` (10 tests). It covers each ceiling family (re-entry, value stack, matcher cap) under both policies, caught and uncaught. It also covers the within-limit twins, the unwinding arena refusal (stays `HeapExhausted` under `throw`), and the meter (never converted). **Regression evidence:** with the conversion disabled, exactly the three `…_throws_a_catchable_range_error_under_throw` tests fail.
- New `xst` unit test: the same raw case is `ironhorse-aborted-limit` under `panic`. Under `throw`, uncaught is `Fail` and caught is `Covered`, including through the bounded case thread.
- `packages/hardened262`: `node --test 'scripts/**/*.test.js'` (29 pass) and `yarn lint` pass. Running `node scripts/test.js --agent ironhorse --agent ironhorseThrowOnLimit --update-baseline …` produced the committed baselines. The `xs`/`sesXs`/`sesNode`/`sesIronhorse` baselines are unaffected because the new cases carry `noXs, noSesNode, noSesXs, noSesIronhorse`.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
~~~
