---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr282-review-336f6623
verdict: not-a-miss
category: new-direction
review_at: 2026-08-17T12:00:36Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/282#pullrequestreview-4951258411
identity: endojs/endo-but-for-bots#282:review:4951258411
---

Empty-body CHANGES_REQUESTED review on PR #282 (endor-run-expanded Phase 5, the
dependency-walk build) carrying two inline comments. Comment 1 (bin/endor.rs, the
`--registry` help): asks to post a follow-up job to verify the registry URL
participates in the registry cache key. Comment 2 (entry_walk.rs, the bespoke
`scan_static_imports` byte-scanner): the hand-rolled partial JS lexer should be
replaced by reusing an existing lexer — IronHorse's, or a Rust port of Node's
cjs-module-lexer — keeping the no-token-retention allocation constraint and sharing
a test corpus with the cjs-module-lexer fork for compartment-mapper parity.

Grounds: both asks are forward-directed new work, not an indictment of the #282
review. The full 16-seat code panel demonstrably RAN on this PR (review 4307471252,
2026-05-18, all seats reporting) — there is no skipped-evaluator avoidance shape.
Comment 1 literally asks to "post a follow-up job" and asserts no defect. Comment 2
is a maintainer implementation-strategy steer: the design (endor-run-expanded.md)
sanctioned Option A (a Rust-native, scan-only import frontend), the scanner works and
is well-tested (35 cases, documented as a deliberate minimal subset), and the panel
even surfaced its known limits (saboteur: nested-template brace-tracking) as an
out-of-scope note rather than a defect. The maintainer choosing to instead fork/reuse
cjs-module-lexer for parity is a new architectural direction on a known trade-off —
he himself notes a valid reason to keep a bespoke version (avoiding allocations). The
parity-with-cjs-module-lexer-fixtures requirement is first stated here and across the
adjacent 08-16/08-19 reviews, an evolving design conversation. No seat carries a
demonstrable convention that a scan-only frontend must reuse a specific
endo-internal lexer, and none of the seats holds knowledge of IronHorse's lexer or
the cjs-module-lexer fork; the reuse call rests on maintainer-specific codebase
intent, not a standing rule that failed to bind. The primary correctly treated the
review as directives and routed each to an owned board job — registry-url-cache-key
(fixer) and entry-walk-lexer (designer) — both of which exist in journal/jobs/tada/,
so the directive was genuinely executed, not falsely claimed.
