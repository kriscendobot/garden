Job `scholar-ingest-erights` complete (doin → tada). Report:

## scholar-ingest-erights — completion report

**What I did:** Ingested the foundational erights.org HTML pages reachable via the GitHub Pages mirror, fetching every page through `fetch-source.sh` (mirror provenance + content-SHA-256 anchors matching the SHAs the job verified).

**Sources ingested (3 net-new, all `source_fetched_via=mirror`):**
- `erights--elang-index` (1 section) — the E Language index/landing hub; section captures the doc-tree map + E-to-Endo translation.
- `erights--elang-same-ref` (2 sections) — *Semantics of "Same"*: `synchronous-sameness-and-reflexivity` and `selfish-and-selfless-objects`. This is the direct ancestor of Endo's pass-style discipline.
- `erights--elib-capability-ode-index` (0 sections, **HTML-form pointer**) — the Ode index. I did **not** re-transcribe it because the Ode *is* the already-ingested paper `papers--miller-morningstar-frantz-capability-based-financial-instruments-2000`; instead the page maps the HTML chapters to the existing paper sections, recording mirror provenance without duplicating content (per the maintainer's efficient-context directive).

**New index pages:** topic `e-language` (new); concept `selfless-and-selfish-objects` (new, draft), cross-linked to `pass-invariant-handle-equality` / `object-capability` / `granovetter-operator`.

**Indexes updated:** `topics/README.md`, `concepts/README.md`, `keywords.md` (19 lines), `topics/pass-style.md`, `sources/README.md`. I deliberately skipped the 5561-entry auto-generated `sections/README.md` (whole-file-replace on a 40 KB+ auto-gen index is impractical/risky; the gate does not require it; regeneration will pick up the new sections).

**Overlap I caught and handled:** My first survey hit the *stale live worktree* and missed that a 2026-06-27 cycle already ingested the E tutorial intro (+chapters) and two ode chapters. My three sources turned out genuinely net-new (no collision), and after re-surveying against a tip-synced clone I corrected two landed files (the overview's "queued" → "ingested" claims; the ode-index now cross-references the two existing ode chapter sections and notes their overlap with the paper).

**Integrity gate:** `library-link-check.sh --source-slug` on all three clusters → **PASS**. A `--nav` sweep found ~20 pre-existing danglers, **none** in any file I touched (endo-but-for-bots design cluster + polaris/powerbox concepts + daemon-persistence); flagged for separate cleanup.

**Follow-ups:** Posted `scholar-ingest-erights-2` (remaining E-language spec/data-type pages, un-ingested ode chapters with a duplicate-the-paper caution, and the pre-existing dangling-link cleanup flag). Result entry `entries/2026/06/28/155751Z-result-gardener-00a5dd.md` landed; scratch cleaned.

Self-improvement: nothing this time (the stale-live-worktree survey gap is already covered by the standing "inspect journal2 read-only via `git show`" memory; I recovered via a tip-synced clone).
