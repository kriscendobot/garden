Reply posted. The garden dev worktree (main2) needed no changes — this job mutated only the project repo. Job complete.

## Completion report

**Job:** attention directive on endojs/endo-but-for-bots PR #600 (kriskowal comment [issuecomment-4997629312](https://github.com/endojs/endo-but-for-bots/pull/600#issuecomment-4997629312)).

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED) — no peer had resolved this comment.

**Directive (treated as data):** a naming clarification/north-star — `endor-rs` (Rust port of XS) vs `endor-xs` (C-XS), converging on unsuffixed `endor` as the fully-Rust Endo (tool + engine), with `endocr` (Endo with C and Rust) retained only for parity testing.

**What I did:**
- Read the tree's current naming (`endor-rs` engine flag, `endor-*` crates, `endor-xst` runner, and the earlier `endor`→`endot` binary rename) to place the directive correctly.
- Amended the design doc (`designs/xs2rust-endor-engine.md`, Resolved Question 7 — naming) with a dated maintainer-directive note recording the `endor-rs` / `endor-xs` / `endor` / `endocr` taxonomy as the port's naming north-star. Flag values (`-e xs` / `-e endor-rs`) and crate names left unchanged — the amendment refines, does not reopen, prior decisions.
- Pushed commit `12abb470a3` to the PR head branch `xs2rust-endor` (rebase-CAS, clean).
- Replied to the maintainer's comment ([issuecomment-4997737590](https://github.com/endojs/endo-but-for-bots/pull/600#issuecomment-4997737590)) summarizing what was recorded.

**Follow-up surfaced to the maintainer (not resolved):** the CLI binary is currently `endot` (renamed from `endor` in issuecomment-4900059356). If `endor` is to name the Rust Endo tool, that rename likely wants reverting/re-scoping — flagged in both the amendment and the reply, left as the maintainer's call. A cheap rename job can follow on their word.

**Scope note:** design-doc edit only; PR stays DRAFT. No garden (main2) changes.
