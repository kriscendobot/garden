---
gate: deferred
priority: normal
posted_by: builder
posted_at: 2026-08-17T12:24:43Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build: consolidate the Rust module lexer per designs/rust-module-lexer-consolidation.md

Implements the accepted design `designs/rust-module-lexer-consolidation.md`
(design PR endojs/endo-but-for-bots#1019), which responds to the
CHANGES_REQUESTED review of endojs/endo-but-for-bots#282 (discussion
r3796110862) flagging `scan_static_imports` as a partial JS lexer.

- Repo: endojs/endo-but-for-bots
- Target branch: `feat/endor-run-entry-point-deps` (PR #282 head — where
  `rust/endo/src/entry_walk.rs` currently lives; it is not yet on `llm`).
- Design: `designs/rust-module-lexer-consolidation.md`

Scope (design Phases 1 + 3 are the minimum to satisfy the review; Phase 2
extends the win; Phase 4 is deferred):

1. Extract one allocation-light, cursor-driven scanning core (no retained
   `Vec<Token>`) modeled on `@endo/cjs-module-analyzer`'s `pos`-cursor
   algorithm; re-express `scan_static_imports` on it; delete entry_walk's
   duplicate skip logic.
2. Refactor `rust/endo/src/cjs_lexer.rs` (`detect_esm_syntax`,
   `detect_named_exports`) onto the shared core, removing the `tokenize()`
   `Vec<Token>` retention; keep behavior byte-identical (guard with existing
   `cjs_lexer`/`execute.rs` tests).
3. Build the shared cross-language test corpus (JSON) consumed by both the
   `@endo/cjs-module-analyzer` `ava` suite and Rust `#[test]`s, drift-guarded,
   seeded from the existing `cjs-module-analyzer` and `entry_walk` tests.

Definition of done: review-comment r3796110862 addressed; the bespoke partial
lexer is gone; allocation invariant documented and guarded; cross-language
corpus green in both languages; `compartment_mapper_fixture_parity.rs` stays
green.

BLOCKED (parked): promote only after design PR #1019 is reviewed/accepted by
the maintainer. Do not start ahead of design acceptance.
