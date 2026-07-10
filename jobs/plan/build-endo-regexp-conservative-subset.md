---
gate: blocked
blocked_on: endojs/endo-but-for-bots#676
priority: normal
posted_by: producer
posted_at: 2026-07-10T21:13:28Z
---

---
role: builder
---

# Build: implement `@endo/regexp` — the conservative-regexp-subset linear matcher

**Repo:** `kriscendobot/endo-but-for-bots` fork of `endojs/endo-but-for-bots`.
Base per package availability (`master`/`llm`), a fresh package `@endo/regexp`.

**Gated on design PR [#676](https://github.com/endojs/endo-but-for-bots/pull/676)
(`design/conservative-regexp-subset`) being ACCEPTED.** This plan job is parked
`blocked_on: endojs/endo-but-for-bots#676`; the unblock watcher promotes it to
`todo/` when #676 merges or closes. **The builder MUST first confirm #676 was
merged (accepted), not merely closed/rejected** — if it was closed without
merging, do NOT build; report up that the design was rejected and stop.

## Why this exists (dependency picked up from a dead-lettered message)

This is the follow-up the endo-but-for-bots platform-search-pushdown work
(design PR #675, `designs/platform-search-pushdown.md`) depends on. #675 named a
Rust-native grep pushdown (**layer R**, promoting the #654 `rust/mount_parity`
mirror to a live `hostGrepFiles` host function) and left an open question about
pinning the conservative-regex grammar. That grammar is now designed at #676,
which defines: the `isConservativeRegex` grammar (EBNF), one normative
JS↔Rust match semantics (ASCII-pinned `\w \d \s \b`, per-line `^ $`,
case-sensitive), an **RE2-style linear-time matcher** shipped in this new
`@endo/regexp` package (so the JS floor on XS's backtracking engine is
ReDoS-immune), and the `regexp-subset-cases.json` parity corpus consumed by
PR #654's `rust/mount_parity` runner.

## What to implement (per the accepted #676 design — read it first)

1. The `@endo/regexp` package exporting `isConservativeRegex(pattern)` (the
   grammar classifier) and the RE2-style linear-time acceptor for in-subset
   patterns, targeting the design's one normative match semantics.
2. The `regexp-subset-cases.json` parity corpus (`classification` + `match`
   cases) wired so both the JS runner and PR #654's `rust/mount_parity`
   (`mount_grep_parity.rs` seam) execute it.
3. Whatever else the accepted #676 design scopes into the package. Do NOT build
   layer R (the native `hostGrepFiles` pushdown) here — that is a further
   follow-up gated on THIS package landing; note it in the tada report so a
   producer posts the layer-R build next.

## Norms

- Verify locally before handoff ([local-verify](../../skills/local-verify/SKILL.md),
  [pre-push-gates](../../skills/pre-push-gates/SKILL.md)); keep `yarn.lock` in a
  separate commit if touched
  ([yarn-lock-separate-commit](../../skills/yarn-lock-separate-commit/SKILL.md)).
- If the accepted design diverged from the two refinements fed onto #675
  (unbounded `* + {n,}` in-subset under a linear matcher; the subset as the whole
  grep language rather than a native-`RegExp` fallback), implement the ACCEPTED
  design, not this note.

## Skills

- [design-to-pr-pipeline](../../skills/design-to-pr-pipeline/SKILL.md),
  [stacked-pr-build](../../skills/stacked-pr-build/SKILL.md),
  [local-verify](../../skills/local-verify/SKILL.md),
  [pre-push-gates](../../skills/pre-push-gates/SKILL.md),
  [self-improvement](../../skills/self-improvement/SKILL.md).

## Done

`@endo/regexp` implements the accepted #676 design (`isConservativeRegex` +
linear matcher + parity corpus), is locally verified, and is ready for the
gauntlet. The tada report notes the downstream layer-R (native `hostGrepFiles`)
build that this package unblocks.
