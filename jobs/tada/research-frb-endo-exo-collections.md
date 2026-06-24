Done. The deliverable is live on `origin/journal2` and the temp worktree, stale local commit, and clone are cleaned up. Here is my completion report.

---

**Job `research-frb-endo-exo-collections` — complete.**

**What I did**

Ran the research-and-design investigation against real source (no theorizing from memory). Read, in order: the FRB fork `kriscendobot/frb` @ `131db347` (cloned and read `observers.js`, `package.json` directly), the garden library's FRB ingest (concepts `frb-incremental-update`, `frb-compiled-observer-tree`; the windowing section), and the recent endo-but-for-bots pubsub work via the GitHub API — **PR #513** (`@endo/pubsub`: read `change-topic.js`/`latest-topic.js`/`pub-sub.js`/`cancel-kit.js`/`README.md`), **design PR #507** (`@endo/exo-pubsub`), and **design PR #450** (`E.whenSevered`). Searched for a propagator artifact and found none.

**Deliverable (where it lives)**

`journal/projects/endo/drafts/frb-reactive-exo-collections.md` (584 lines, `status: draft-for-maintainer-triage`), registered in that directory's `README.md`. Landed on **`origin/journal2`** as commit `fa94266c` (verified present on origin).

The report covers, all source-grounded:
- **FRB operator survey** — the incremental range-delta engine; the operator catalogue with `observers.js` line numbers; the `collections` dependency (`SortedSet` splay tree / `SortedArraySet` sorted array). Key finding: **FRB's `view(start, length)` operator already *is* the sliding-window machinery the maintainer described** — `makeViewObserver` (l.817) keeps a window consistent incrementally as both the underlying ordered collection *and* the window position/length mutate; the README's own example windows a `SortedSet`.
- **Endo-implements / Exo-lifts layering** — grounded in the real `@endo/stream`→`@endo/exo-stream` and `@endo/pubsub`→`@endo/exo-pubsub` precedents; what lives where, and that only frozen *deltas* cross CapTP, never the collection.
- **Hardening constraints** — `harden` at boundaries, no producer back-pressure from subscribers (the `nullSpring` design in #513), deterministic severance-driven teardown (#450 is load-bearing), no ambient authority, sealed terminals.
- **The splay-tree / sorted-array-set interface + window-topic operators** — the ordered-set observable contract and a concrete `makeWindowTopic` that drives `view` and republishes its deltas as an `@endo/pubsub` topic.
- **Query+subscriber model for agent sync** — `query()` pull + `subscribe()` push; lossless→replicated-log vs lossy→latest-snapshot regimes.
- **Relationships to the recent pubsub work** (#513/#507/#450, `formulaChangeTopic`, `retention-accumulator`, construction-time-notifiers) and a concrete proposed module shape (`@endo/reactive-collection` + `@endo/exo-reactive-collection`) with 6 open questions.

**Honest gaps (per the brief)**
- **Propagators:** I could **not** verify any Sussman-sense propagator artifact in endo / endo-but-for-bots / the library — `propagat*`/`constraint`/`dataflow` searches returned only unrelated hits (#264, #353). The report states plainly that the propagator relationship is an **architectural analogy** (FRB *is* a synchronous, partially-bidirectional propagator network), not an integration with an existing package, and flags this for maintainer confirmation.
- **Biggest practical risk surfaced:** FRB is CommonJS/pre-SES and depends on the `collections` shim; the report recommends reimplementing just the ~40-line `view` splicer against a SES-clean ordered-set rather than hardening the whole shim surface.

**Follow-ups**
- Recommended next step (in the doc): a **designer dispatch** (with researcher precedence) to formalize `@endo/reactive-collection` into a design PR against the `llm` branch, coherent with #507, plus a focused spike on the FRB `view`-splicer-reimplementation question. I did **not** open a PR myself — that is a designer/builder dispatch, and all work stayed within kriskowal's own in-scope repos (no agoric-sdk).

**Infra note:** the shared `/home/kris/journal` worktree was 153 commits behind origin with concurrent-gardener uncommitted edits, so the in-place rebase couldn't detach HEAD. Per the garden's isolated-worktree discipline I landed via a fresh worktree off `origin/journal2`, then soft-reset the stale local ref (leaving peers' uncommitted files untouched) and removed the temp worktree and clone. No follow-up needed; this is the documented pattern for garden infra writes.
