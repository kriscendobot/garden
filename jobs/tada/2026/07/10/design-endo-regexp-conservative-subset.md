The design is landed. PR #676 is a draft against `llm` with the single design file, exactly matching the peer precedent (#675) and the designer role's default flow.

## Completion report

**Job:** `design-endo-regexp-conservative-subset` — design a conservative, ReDoS-mitigating regex subset for `@endo/platform` search parity, dispatched by the maintainer's `isConservativeRegex` review on PR #675.

**What I did**
- Gathered ground truth: the full parent design (`platform-search-pushdown.md`, PR #675) and its Resolved-decisions dependency directive; the maintainer's inline comment; the grep case-table shape (`mount-grep-cases.json`, `feat/mount-grep`); and the Rust parity runner (`rust/mount_parity`, PR #654) whose `mount_grep_parity.rs` seam is currently stubbed pending exactly this work.
- Wrote **`designs/conservative-regexp-subset.md`** covering all four required deliverables:
  1. **Grammar, not an allowlist** — a precise EBNF for what `isConservativeRegex` accepts/rejects, with side conditions (quantifier arity, `REPEAT_MAX`, program-size cap) and an exclusion table mapping each excluded feature to the ECMA-262↔Rust-`regex` divergence it closes (backreferences, lookaround, flags, `\p{…}`, `\s`/`\w`/`\b` corner semantics).
  2. **JS↔Rust parity as a first-class contract** — one normative match semantics both engines target (ASCII-pinned `\w \d \s \b`, per-line `^ $`, case-sensitive), the JS classifier as the sole classifier, and a shared conformance corpus.
  3. **RE2-style linear matcher in a dedicated `@endo/regexp` package** — recommends shipping a linear-time acceptor so the JS *floor* (XS's backtracking engine) is ReDoS-immune, not just the native pushdown; the Rust side is a parity *configuration* of the `regex` crate, not a new engine. Justified the package home over living inside `fs/search`.
  4. **Case-table/parity-runner contract** — `regexp-subset-cases.json` (`classification` + `match` cases) at `packages/regexp/test/`, consumed by both a JS runner and the #654 `rust/mount_parity` runner, seeded from the existing grep cases.
- Surfaced two refinements fed back to #675: unbounded `*`/`+`/`{n,}` are safe in-subset under a linear matcher (refining "bounded quantifiers only"), and a recommendation to make the subset the *whole* grep language rather than falling back to native `RegExp`. Both are left as maintainer decisions in Open Questions.

**What changed / artifacts**
- Draft **PR #676** (`design/conservative-regexp-subset` → `llm`), single-file diff, matching the #675 peer precedent.
- Cross-link comment on **#675** noting the dependency is now designed and carrying the two refinements for review.
- Bus message to the `orch-endo-glob-grep-pushdown` orchestration owner (inbox gone → dead-lettered and promoted to a fresh job by `garden-deadmail`, so intent is preserved).

**Follow-ups (named, not silently dropped)**
- The `@endo/regexp` implementation is a separate builder dispatch after #676 is accepted (base per package-availability rule).
- #675's native `hostGrepFiles` (layer R) stays gated on #676 landing.
- Maintainer decisions pending on the two Open Questions (subset-as-grep-language; `\s` ASCII narrowing) and the policy constants.

**Verified:** PR #676 is `isDraft:true`, base `llm`, head `design/conservative-regexp-subset`, one file — confirmed via `gh pr view`. This was a design (documentation) job with no runtime surface to execute.
