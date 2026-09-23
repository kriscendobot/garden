---
ts: 2026-05-19T23:35:00Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: designer
---

# Dispatch: designer drafts improved pattern-mismatch diagnostics for @endo/patterns

Dispatch root: `dispatches/designer--3f4694/`. Project worktree on `endojs/endo-but-for-bots@llm` (head `68246ad92`).

Maintainer directive (2026-05-19): *"Please dispatch a designer to produce a design PR that will substantially improve the diagnostic feedback for pattern mismatches with @endo/patterns. That is, an error message that cites the line and column of the error, the path through the tree to the error, and human readable feedback on the reason for the match error. This may be a substantial alternate path for pattern matching since it will probably require its own JSON parse."*

## Why this needs a design

The current `@endo/patterns` (`packages/patterns/`) is the pattern-matching surface used pervasively across Endo + Agoric for `matches(specimen, pattern)` / `mustMatch(specimen, pattern, label?)` checks. Today's failure path produces a one-line error like:

```
something - Must be: M.string()
```

This is opaque when the specimen is a deeply-nested structure: you get the leaf reason but not *where* in the structure the mismatch occurred. The maintainer's three asks together:

1. **Line and column of the error** — implies the specimen has a source-text origin. Patterns today operate on **already-parsed** JavaScript values; there's no source map back to the JSON/Justin/JS that produced them. This is the "substantial alternate path with its own JSON parse" hinted at in the directive: a pattern-matcher that consumes source text + parses it itself, retaining line/column for every node.
2. **Path through the tree to the error** — implies the matcher walks the specimen-vs-pattern tree carrying a path accumulator (e.g., `result.foo[2].bar`). This is achievable on the *current* parsed-value path with no new parse, but produces no line/column without one.
3. **Human-readable feedback on the reason** — implies each pattern combinator carries (or derives) a prose-grade explanation of what it expected vs. what it received, beyond the existing `q()`-quoted-value form. Examples: "expected an array of length ≥ 3, got length 2", "expected a key from {a, b, c}, got 'd'", "expected the kind 'remotable', got the kind 'copyArray'".

## Task

Read `garden/roles/COMMON.md` + `garden/roles/designer/AGENT.md` + `garden/skills/process-documents/SKILL.md` first. Then read `designs/CLAUDE.md` from the project worktree — it carries the design-doc structural conventions (metadata table, Status field, prose Status section, etc.).

Then **inventory the current `@endo/patterns` failure-reporting surface**:

- `packages/patterns/src/patternMatchers.js` (or wherever `matches` / `mustMatch` live; verify the file layout on llm HEAD).
- The `q()` / `b()` quoting helpers in `@endo/errors`.
- Any existing path-accumulation helper (e.g., `M.containerHas` traversal patterns).
- Test fixtures that exercise mismatch messages (likely under `packages/patterns/test/`).

Then propose a design at `designs/patterns-diagnostic-feedback.md` (or a name the designer prefers; align with the existing `designs/` slug convention). The design should:

1. **Frame the problem** — three asks above; cite the maintainer directive; list 2-3 representative current-error-message exemplars (the more painful, the better) and the corresponding improved-error-message they should produce.
2. **Carve the design into the three axes** the asks correspond to:
   - **Axis A — tree-path accumulation** (cheap, no new parse, applies to existing API surface). The pattern walker carries a path string ("at `.foo[2].bar`") that the leaf-mismatch error embeds. Backwards-compatible; can roll out as a quality-of-life improvement without breaking callers.
   - **Axis B — human-readable reasons per combinator** (cheap-ish, library-only). Each `M.*` combinator authors its own "expected X, got Y" template. The library carries a registry of reason-renderers keyed by combinator. Backwards-compatible.
   - **Axis C — alternate path with source-aware parse** (substantial, new API). A new entry point (e.g., `matchesText(sourceText, pattern, { syntax: 'json' | 'justin' | … })` or `M.parseAndMatch`) that consumes source text, parses it carrying line/column metadata, and produces errors with source positions. Likely depends on `@endo/marshal`'s `parseJSON` or `@endo/justin`'s parser; consider extending those parsers to emit position-annotated ASTs.
3. **Phased rollout** — Axes A + B first (highest leverage per LOC, backwards compatible); Axis C as a follow-up that depends on parser changes upstream. Use the project's "Phased implementation" section convention from `designs/CLAUDE.md`.
4. **API sketch** — for each axis, the public surface (what callers see). For Axis C the question of whether the new `matchesText` returns a *value* (parsed specimen) alongside the match verdict matters for ergonomics.
5. **Design decisions** with rationale — at minimum: (a) path-string format ("`.foo[2].bar`" vs. structured `[]string`), (b) how Axis C handles patterns that match across non-source-bearing constructs (e.g., a remotable inside JSON makes no sense; declare the syntax boundary), (c) error-message format (single line vs. structured multi-line), (d) interaction with existing `mustMatch(s, p, label)` `label` argument.
6. **Known gaps and TODOs** as a checklist — the design surfaces what it *doesn't* solve so the builder doesn't have to rediscover them.
7. **Dependencies table** — Axis C dependencies on `@endo/marshal` / `@endo/justin` if you go that route; Axis A + B have no new deps.
8. **Prompt** — capture the maintainer's directive verbatim under a `## Prompt` heading at the bottom per `designs/CLAUDE.md`.

Then **sync the design into `designs/README.md`** per the convention: add a row to the Summary table, assign to a milestone (likely M5 or whichever covers pattern-matching ergonomics; designer's call), insert into the dependency graph if it has dependencies (Axis C does), add a per-design size/duration estimate (Axis A: S, Axis B: S, Axis C: L per the design's own phasing), and update milestone totals.

Then **open as DRAFT PR** against `endojs/endo-but-for-bots@llm`. Branch: `design/patterns-diagnostic-feedback`. Title: `design(patterns): substantially improve diagnostic feedback for pattern mismatches`. Body cites the maintainer directive, summarizes the three axes, and names which axes are mergeable in one PR-flow each vs. dependent.

## Per-action authorization

Standing on endo-but-for-bots: push to `design/patterns-diagnostic-feedback`, open draft PR. No comment authority on anything outside the new PR's body. READ-ONLY on `endojs/endo`.

## Out of scope

- No implementation. This is a design dispatch; the design surfaces what to build, the builder lands it later.
- No edits to `@endo/patterns` source itself.
- No upstream ferry (boatman handles when the design is approved and a builder dispatch produces the implementation PR).
- No un-draft of the design PR — design PRs stay draft until the maintainer green-lights with the typical "you've persuaded me" reaction.

## Report

≤ 500 words: PR URL + head SHA, design path on llm, the three exemplar error messages used to motivate the design (current vs. improved), the axis split with size estimates, any open design questions the designer surfaced rather than picking, one-line `Self-improvement: ...`. The liaison adds a bulletin row.
