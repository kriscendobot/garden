---
orchestration-failed: true
---
All verification complete. Here is my completion report.

---

## Completion report — `ironhorse-js-26-ca-regexp-closure-audit`

**Role:** final closure-audit child of orchestration `ironhorse-js-26-ca-regexp-unicode-closure` (serial, halt-on-failure). Repo `endojs/endo-but-for-bots`, PR **endojs/endo-but-for-bots#970** (OPEN, draft — left untouched).

### What I did
Ran the authoritative official-XS differential closure audit for the RegExp/Unicode cluster on the shared branch, at the exact pins (test262 `be13516fb644`, Moddable XS `23b4d6b0a65f`), oracle on, across all 10 required prefixes. Diagnosed each residual by causal reason, landed one **bounded genuine fix**, added a Rust regression, and verified before/after with zero regression.

**The fix** (commit, pushed head **`66353cce0`**): a program with a parse-phase early error (e.g. a RegExp literal whose backreference is out of range, `/(a)\2/`) is cleanly *rejected* by `ironhorse-compile`, which returns empty bytecode. The dual-run harness was then *running* that empty bytecode, halting with `Halt::Decode("pc 0 past end 0")` — a spurious `parse-or-decode` that masked a correct, oracle-agreeing rejection. Per the language a program with an early error throws its SyntaxError before evaluation (exactly as XS's lexer-owned throwing stub does); `dual_run_with` now presents an `IronhorseCompile::Rejected` outcome as the bare `SyntaxError` throw it is. Added `tests/regexp_literal_early_error.rs`.

### Authoritative before → after (cluster, 14,506 cases across the 10 prefixes)
- covered **3430 → 3435 (+5)**
- unsupported **4592 → 4587 (−5)**
- ironhorse-failure **1 → 1**, skipped **6483 → 6483**
- **Only changed reason:** 5× `unsupported/parse-or-decode → covered` (all RegExp Annex-B out-of-range-backreference literals). **Zero** covered-losses, **zero** new ironhorse-failures.

### Gates (all commands run)
- `ensure-project-worktree.sh … endojs/endo-but-for-bots feat/ironhorse-262-language-completion`; `git submodule update --init c/moddable` (@ `23b4d6b0`)
- `full-run.sh --subtree <PREFIX> --test262-dir <pinned> --jobs 16 --oracle on` for all 10 prefixes (before + after)
- `cargo test --workspace --release` → **69 suites, 0 failures**
- `ironhorse-xst --gate-meter-exact --oracle rust/engine/ironhorse-262/cases` → **1712/1661/51, byte-identical to baseline** (the 51 are pre-existing off-by-ones, unchanged)
- `git fetch/rebase/push` CAS onto `feat/ironhorse-262-language-completion` (rebased over a peer's TypedArray commit, clean)

### Why the orchestration gate is NOT met (honest handoff)
"Zero forbidden reasons within the cluster" is **not bounded-achievable** in this child. The RegExp/Unicode **matching + parsing** cluster the predecessor children owned **is closed** (0 ironhorse-failures; u/v, property escapes, unicodeSets, modifiers, named-groups covered; RegExp-file `parse-or-decode` now **zero**). But the 10 listed subtrees still carry `unsupported-opcode` 2330, `ironhorse-aborted` 1782, `abort-value-differs` 440, `parse-or-decode` 33, `over-acceptance` 1 — dominated by:
- **(a) General-engine gaps** merely living in RegExp/String/Array test files (`apply:non-user-function-receiver` 453, String.split/match/replace/search dispatch, defineProperty/getOwnPropertyDescriptor MOP, coercion) — owned by **sibling causal clusters**, not RegExp.
- **(b) Temporal/Iterator gaps** — all 33 remaining `parse-or-decode` are Temporal `Infinity`/missing-args + Iterator, **not RegExp**.
- **(c) Genuinely RegExp-cluster but unimplemented Annex-B legacy FEATURES**: `RegExp.prototype.compile` + legacy static accessors (`$1`–`$9`/`input`/`lastMatch`/`leftContext`/`rightContext`); the 1 remaining `over-acceptance` (`annexB/.../compile/this-subclass-instance.js`) needs the `compile` method. These are substantial features, not bounded fixes — per the residual-gap-closure decomposition they belong to their own children.

I did **not** skip/relabel/suppress anything. Surfaced the scope reality + a recommendation (a dedicated `ca-regexp-annexb-legacy-features` child) to the maintainer via `message-user`.

**Final head:** `66353cce0` · **PR:** https://github.com/endojs/endo-but-for-bots/pull/970 (open, draft) · **Follow-ups owned elsewhere:** (a)/(b) sibling clusters; (c) Annex-B legacy RegExp features.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-26-ca-regexp-closure-audit.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 278 tokens (22472709 cached reads)
- Output: 115137 tokens
- Cost: $16.570470500000003
- Wall-clock: 1723s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
