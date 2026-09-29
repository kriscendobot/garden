I built the lint that stops commit-path code from matching raw `Halt` variants, wired it into CI, and opened it as draft PR https://github.com/endojs/endo-but-for-bots/pull/1373 (base `llm-1706e63`, body has `Refs: #1018`). On the PR, the CI job that runs the lint (`format-ironhorse`) passed, including the new "Check Halt classification discipline" step. When I checked, the other checks showed 16 passing, 18 still pending and none failed.

**Before starting:** the open-questions mentat job had already finished (answers on #1018, design amendment PR #1370). None of its answers change what this lint does. The earlier leg in the sequence (the end-to-end probe) is a draft that stays draft, so this PR is not stacked on it.

**What the lint catches:** the design asked for a Clippy lint, but Clippy's `disallowed_*` lints can't target patterns that name an enum's variants. So the lint is a new crate, `rust/halt-classification-lint`, that parses the source with `syn` and fails the build with exit 1. It flags:
- `Halt::X` in any pattern: `match` arms, `if let`, `let … else`, `while let`, and `matches!`, including inside `assert!` and other macros.
- `==`, `!=` and `assert_eq!`/`assert_ne!` against a `Halt` variant.
- Importing the variants with `use …::Halt::*` or `use …::Halt::{…}`.
- Fully qualified paths, and per-file aliases (`use … Halt as H`, `type H = Halt`).

Building a variant as a value is not flagged.

**Where it applies:** every Rust source under `rust/` except the engine workspace (`rust/engine`), and except test code. `#[cfg(not(test))]` code is still checked.

**Reviewed exceptions:** four existing functions are allowed to match variants, each with a written reason:
- `ExecutionOutcome::classify`
- `describe_halt`
- `ironhorse_engine::refuse`
- `js_machine::classify`

An exception that no longer suppresses anything is itself reported as an error.

**CI:** the `format-ironhorse` job now runs the crate's tests, lints the whole checkout, and checks the fixture pair. The raw `Halt::StackOverflow | Halt::Decode` commit-path match must exit exactly 1, and the same decision routed through `is_panic()` / `ExecutionOutcome` must pass. The new crate is also in the rustfmt check. `scripts/ci-changes.py` now selects that job for any `.rs` change under `rust/`, with a matching test in `scripts/test-ci-changes.py`. I also added a note to the `Halt` doc comment in `ironhorse-vm/src/interp.rs` naming the lint.

**Local checks:** the crate's 9 tests pass, Clippy with `-D warnings` and `cargo fmt --check` are clean, and the 36 change-selector tests pass. Running the CI step locally gave the expected exit codes: 0 for the checkout, 0 for the routed fixture, 1 for the raw fixture.

**Decisions for the reviewer (listed in the PR body):**
- **Scope:** "commit path" is read as the root-workspace crates outside `rust/engine`.
- **Two exceptions:** `refuse` and `js_machine::classify` are allowed because I read them as error reporting, not commit-or-discard decisions. If a future delivery path decides commits from `JsMachineErrorKind`, the `js_machine` exception should be revisited.
- **Name-based limit:** the lint matches the name `Halt` and doesn't resolve types. A re-export under a different name in another module would get past it; that doesn't occur in the tree today.
- **Clippy vs. `syn`:** the PR explains why this is a `syn` check rather than the Clippy lint the design names.

The panel review is next; it should be staged automatically now that this build is done.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-classification-lint.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 104 tokens (5404014 cached reads)
- Output: 42454 tokens
- Cost: $3.0267148000000006
- Wall-clock: 803s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
