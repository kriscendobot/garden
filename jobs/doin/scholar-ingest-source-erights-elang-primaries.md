# scholar-ingest-source: deeper erights.org E-language primaries via the mirror

Continue the maintainer-directed re-ingestion of erights.org sources now that
`fetch-source.sh` reaches them through the erights.github.io GitHub Pages mirror
(`source_fetched_via=mirror`). Two index/overview pages are already ingested:
`erights--elang-index` (the E docs index) and `erights--elang-intro` (the tutorial
index). What remains is the substantive primary content that grounds the
secondary-source survey `ocap-history--e-capdesk-polaris`.

## What is left to ingest (mirror-reachable HTML; PDFs still need the Wayback fallback)

Fetch each via `scripts/jobs/fetch-source.sh <erights.org URL>`; keep the `erights--`
slug prefix and `source_kind: web`. Idempotency anchor is `source_content_sha256`.

- The tutorial body chapters under `elang/intro/` (text-finding example, standalone
  programs, lambda-based objects, remote objects, the single-page money example):
  the actual E code walkthroughs that the intro index page only lists.
- The "Ode to the Granovetter Diagram" deep subpages under `elib/capability/ode/`.
  Note: overview.html is already covered at higher fidelity by the ingested FC2000
  paper `papers--miller-morningstar-frantz-capability-based-financial-instruments-2000`;
  check the remaining subpages for material the paper omits before ingesting, to
  avoid duplication.
- CapDesk and Polaris primary pages if present on the mirror (the survey currently
  cites only secondary sources for these). Confirm reachability; some HP Labs
  technical reports (HPL-2004-116, HPL-2006-116) are PDFs that 404 on the mirror and
  need the Internet-Archive original-bytes fallback.

## Notes

- Respect one cycle's budget (3 to 5 sources or ~25 section writes); post a further
  follow-on if the remainder exceeds it.
- The headline ocap document (the Granovetter "Ode" = Capability-Based Financial
  Instruments, FC2000) is ALREADY in the library from the agoric.com PDF; do not
  re-ingest it from the mirror. Verify content-sha / document identity before writing.
- Run the post-ingest integrity gate (`scripts/jobs/library-link-check.sh --changed`)
  before completing.

Posted by scholar cycle scholar-library-cycle-20260627-210543 (gardener 78, endolinbot).

---
claim:
  host: endolinbot
  gardener: 68
  claimed_at: 2026-06-27T21:20:37Z
