All landed and verified on `origin/journal2`.

## Completion report — `scholar-ingest-gutentag`

**What I did.** Ingested the core of Kris Kowal's **Guten Tag** reactive web-component framework (`gutentags/gutentag`) into the cross-cutting library, seeding a new `html-modules` topic — a genuinely new domain relative to the endo-centric corpus (per AGENT.md § Do not overfit, new topic rather than bending existing taxonomy).

**Repo-shape finding.** Contrary to the job body, `gutentags/gutentag` is **not a monorepo** — it's a single npm package (loader + five building-block tags as flat files, plus an `essays/` example dir). Its "component packages" are **sibling repos** in the `github.com/gutentags` org (koerper, wizdom, system, blick, kamera, ndim, and the single-tag `*.html` packages). I ingested the core README first pass and named the exact siblings in the follow-on.

**Landed (all via `land-journal-edit.sh`, no live-worktree edits):**
- Source `gutentag--readme` (README.md @ `38cdebb`, 2017-03-07) → **14 sections** covering the thesis, HTML-modules/lexical-scope model, on-the-fly translation, the `hookup` convention, container-free body nodes, the scope object model, bootstrapping, the five building-block tags, the `<meta accepts>` calling conventions, and this/space/xml.
- New topic page `html-modules.md` (14-row Sections table + concepts + see-also to reactive-bindings/web-frontend/node-packaging).
- **4 concept pages** (`guten-tag-component`, `guten-tag-scope`, `guten-tag-accepts-convention`, `guten-tag-body-node`) + **28 keyword lines**.
- Index updates: `sources/README.md` (new "Gutentags component framework" subsection), `topics/README.md` (html-modules row), `concepts/README.md` (4 bullets).

**Integrity gate (step 8):** `library-link-check.sh --source-slug gutentag--readme --wikilinks` → OK (exit 0); `regenerate-topics-counts.sh --check` → current (exit 0), both against a fresh origin/journal2 clone carrying all landed files.

**Projected indexes (step 9):** `regenerate-sections-index.sh` landed the updated flat `sections/README.md`; `regenerate-topics-counts.sh` reported counts already current.

**Follow-up posted:** `scholar-ingest-gutentag-packages` — the sibling component packages (koerper/wizdom/system prioritized, then blick/kamera/ndim and the `*.html` packages) plus gutentag's `essays/`; core README marked current so it won't be re-ingested.

**Self-improvement:** The job asserted a monorepo shape it hadn't verified, costing a survey cycle to discover otherwise. A producer positing an ingest job should state repo shape as an observation to confirm ("appears to be a monorepo") or omit it and let the scholar survey.
