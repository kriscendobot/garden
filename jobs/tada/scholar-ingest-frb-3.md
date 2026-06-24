Done. The frb grammar/compiler source is ingested and `kriskowal/frb` is now fully ingested. Final report:

---

## Completion report — `scholar-ingest-frb-3` (scholar cycle 4)

**Outcome:** Ingested the `kriskowal/frb` grammar and compiler **source**, the last frb backlog item. With this, `kriskowal/frb` is fully ingested (README from cycles 2–3 plus source now); no further `scholar-ingest-frb-*` follow-on is needed. Job completed `doin → tada`; all writes pushed to `origin/journal2` (commit `4f225ea5`).

**Sources ingested (5, `source_kind: repo`, per-file commit anchors):**
- `frb--grammar` — grammar.pegjs (`2162ce7c`) — 4 sections
- `frb--compile-observer` — compile-observer.js (`2162ce7c`) — 2 sections
- `frb--compile-binder` — compile-binder.js (`5a0203b2`) — 2 sections
- `frb--language` — language.js (`70019397`) — 1 section
- `frb--parse` — parse.js (`70019397`) — 1 section

10 section files total, all under topic `reactive-bindings`.

**What the source adds beyond the README prose:** the implicit-`mapBlock` rewrite and `inline: true` bare-function flag in the grammar; the entire README-undocumented declarative MCS *sheet* sub-language (`@label { target <- source; on event -> handler }`); the function-returning `tail`/`pipe` left-fold mechanism; the open-world method/operator fallback in the observer compiler; the enumerated invertible-roots set in the binder compiler; and the `algebra.js` `solve` routine that is the literal mechanism behind "automatic algebraic inversion."

**Two findings recorded (notice/investigate/propose):**
1. **Prose-vs-source drift** — the unary `+` node is `toNumber` in the source (`operators.js` exports `toNumber`; no `number` operator exists), but the README labels it `number` in two Reference sections. Low-stakes; flagged in `frb--grammar--token-tables-and-precedence-climbing` for a possible README fix, not acted on.
2. **Job-framing correction** — `language.js` is *not* the module tying parse and compile together. It is the operator-precedence/token tables consumed only by `stringify.js`; the actual parse→compile→binding assembly lives in `bind.js`/`observe.js`. Recorded in the section and source-index. The README's `frb/parse`, `frb/compile-observer`, `frb/compile-binder` module paths all verified accurate.

**Indexes updated:** enriched concept `frb-compiled-observer-tree` (10 new section rows; "Deferred" note replaced with a "Source coverage" note clearing the backlog); `topics/reactive-bindings.md` (new grammar/compiler-source section block; count 21→31 in `topics/README.md`); `sources/README.md` (5 new rows + frb-fully-ingested note); `keywords.md` (35 new grep keywords). Skipped the 8665-line auto-generated `sections/README.md` per the role's "rely on directory listing if it grows beyond pragmatic" (cycle 3's frb ingest did likewise).

**Process notes:** Worked in an isolated worktree off `origin/journal2` to avoid clobbering a concurrent collections-package ingest mutating the shared `/home/kris/journal` tree; committed explicit pathspecs, pushed `HEAD:journal2`, resolved one `sources/README.md` rebase conflict (kept the peer's updated collections row, my frb rows). Worktree and scratch clone cleaned up.

**Follow-ups:** None — the frb backlog is empty.

Self-improvement: nothing this time.
