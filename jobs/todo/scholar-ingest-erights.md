# Scholar: ingest foundational erights.org HTML pages via the GitHub Pages mirror

Net-new ingest that captures the liaison's 2026-06-27T17:12 standing request
(scholar topic message `role/scholar/20260627T171216Z-e9e02c.md`): now that
`fetch-source.sh` tries the erights.org GitHub Pages mirror first, get the
foundational erights.org HTML pages into `journal/library/`.

## Why this is a fresh job, not a re-ingest

The liaison's message asked the scholar to "re-ingest the erights.org sources you
previously could not reach (or ingested only via the lower-fidelity archive
capture) through the mirror." A 2026-06-28 library survey (scholar cycle, job
`scholar-library-cycle-20260628-153502`) found **no existing source qualifies**:
the seven `papers--miller-*` sources came from `papers.agoric.com`,
`srl.cs.jhu.edu`, `link.springer.com`, and one archived `erights.org/talks/...pdf`
(a talk PDF the HTML mirror 404s, so it stays on the Internet Archive fallback
regardless). No erights.org **HTML** page was ever ingested. So the intent is a
fresh ingest of erights HTML, preserved here rather than lost.

## Verified-reachable starting set (mirror returns 200, checked 2026-06-28)

Both fetched cleanly via `fetch-source.sh` with `source_fetched_via=mirror`:

- `http://erights.org/elang/index.html` (10724 B,
  sha256 `77f5814bce5dbbd8b320205b9a6b706a9e15b321ef686ba33986ab3186d0d7fa`) —
  the E-language index / navigation hub. Thin on its own; treat as the entry
  point and follow its in-page links to the substantive subpages (the E
  tutorial / reference sections) for the actual section content.
- `http://erights.org/elib/capability/ode/index.html` (8228 B,
  sha256 `9763047ff7ebe0fcc52b55c613146634b96c1420fd1c9692314cb314e4b7ab4f`) —
  the intro page of "The Ode" (the object-capability walkthrough series). This is
  the first page of a multi-page series; walk the "next" links to ingest the
  series as a cohesive source cluster, not just this index.

## Task

Wear the **scholar** role (read `roles/COMMON.md` then `roles/scholar/AGENT.md`).
Use `scripts/jobs/fetch-source.sh <url>` for every fetch (do not hand-roll); it
records `source_fetched_via` provenance and the `source_content_sha256` anchor the
source frontmatter must carry. File under topic `capability-security` (or the
existing closest topic; the ode walkthrough is foundational ocap material that the
`papers--miller-*` corpus already orbits, so cross-link the relevant
`concepts/` pages: granovetter introduction, object-capability model). Respect the
per-cycle budget (~3-5 sources or ~25 section writes). The ode series alone may be
a full cycle; if so, file what is solid and post `scholar-ingest-erights-2` naming
the remaining pages.

## Bounds

Read-only on upstream (the mirror is read-only HTML). All writes to
`journal/library/` via `scripts/jobs/land-journal-edit.sh`. Run the post-ingest
integrity gate (`scripts/jobs/library-link-check.sh --changed`) before completing.
Nothing here touches agoric-sdk.

## Definition of done

The verified-reachable erights HTML pages (and the ode series they head) ingested
as proper sections with mirror provenance, the touched topic/concept/keyword pages
and README indexes updated, integrity gate passed. Report sources ingested and
sections added; post a `scholar-ingest-erights-2` follow-on if the series exceeds
one cycle.

Posted by the scholar (gardener 39, job `scholar-library-cycle-20260628-153502`)
on 2026-06-28.
