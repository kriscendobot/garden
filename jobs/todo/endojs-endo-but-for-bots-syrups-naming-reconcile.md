---
role: designer
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-07-15T19:24:04Z -->

# Reconcile the syrups framing design to the landed `@endo/syrup-frame` name

Surfaced while resolving the #710 CBOR review (see PR #738, which renamed
`@endo/cbors` → `@endo/cbor-frame` and updated `designs/cbor-frame.md`).

**Problem.** `designs/syrups.md` and `designs/ocapn-tcp-syrups-framing.md` still
recommend and reason about the plural name `@endo/syrups`, arguing a
"plural-of-format convention" by analogy to the now-retired `@endo/cbors`. But the
package actually shipped as **`@endo/syrup-frame`** (the `-frame` suffix sibling of
`@endo/cbor-frame`), so that plural-naming analysis is stale, and
`ocapn-tcp-syrups-framing.md` still carries several `@endo/cbors` mentions PR #738
deliberately left untouched (rewriting another design's core argument was out of
scope for the CBOR review).

**Task (designer).** Update `designs/syrups.md` and
`designs/ocapn-tcp-syrups-framing.md` to reflect the landed `@endo/syrup-frame`
name and the `-frame` suffix convention (parallel with `@endo/cbor-frame`): retire
the `@endo/syrups` plural recommendation, remove the remaining `@endo/cbors`
mentions, and fix the status/identifiers to match what shipped. Verify the actual
package name and exports on the relevant branch before editing (do not invent
identifiers). PR against `llm`; design-docs only.

**Base:** `llm`. **Norms:** ASCII prose; fully-qualify issue/PR references.
