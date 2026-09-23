Both companion documents are ingested and landed on `journal2`.

## What I did

**Two new sources, three sections** — both new, so the idempotency check was degenerate as expected (no prior anchor). Each records both the `source_content_sha256` fetch anchor and the file-specific `source_commit`, since both files have real per-file git history.

1. **`tc39-module-harmony--shadowrealm-errors`** (1 section) — `errors.md`, sha256 `f96224a3…`, file commit `e191b135` (2023-01-26, Caridy Patiño), fetched `direct`. Single-section ingest per `conventions.md` § Sectioning shapes (two pages, one H2 + one H3): `errors-crossing-the-callable-boundary`, topics `module-harmony` + `errors`. It supplies the detail behind the main explainer's one line about stack censoring: total replacement by a fresh `TypeError`; a message composed from the original's `name`/`message` but re-composed **from scratch on every crossing**, so nested realms and re-entrancy accumulate nothing and leave no visible reference to the original; `[[ErrorData]]`-slot reads that user-land code must not observe (host-cached values where those are accessors); a generic message for thrown non-errors.

2. **`tc39-module-harmony--import-attributes-content-type-vs-file-extension`** (2 sections) — sha256 `517bae82…`, file commit `9015a79a` (2020-06-26, Sven Sauleau), fetched `direct`. Split into `overview-why-the-extension-is-not-the-type` (the argument) and `analysis-cloudflare-content-type-measurements` (the evidence), topic `module-harmony`. This is what the README's "widespread mismatch" claim rests on: 61.8% of `.js` served as `application/javascript`, 67.6% of `.json` as `application/json`, with the security argument living in the tail (0.66% of `.json` served as a JavaScript type).

**One sectioning judgment worth flagging:** I transcribed the two measurement tables in full rather than shape-summarizing them. `conventions.md` § *Shape, not content, for upstream meta-tables* exists to stop the library mirroring a row set that drifts at upstream's cadence; these are a frozen 2019/2020 observation and the numbers *are* the evidence, not an index of it.

**Pages touched:** `topics/module-harmony.md` (3 rows), `topics/errors.md` (1 row), `concepts/module-harmony-intersection-surface.md` (3 rows), `sources/README.md` (2 rows + preamble), `keywords.md` (2 lines). All section rows went in via `insert-sections-table-row.sh`; all ten content files landed via `land-journal-edit.sh`, the five whole-file replacements carrying `--base-blob` — none was refused, so no peer edit was overwritten.

**Two stale-fact corrections** in the concept page, beyond the asked-for row: its "Module-harmony neighbors (adjacent proposals, **not yet ingested**)" heading and preamble had gone false when the 2026-07-29 hourly cycle ingested all three, and the ShadowRealm bullet still said "Stage 3" where the page's own Sections table already carried Stage 2.7. Import attributes corrected to Stage 4 in the same pass. I also replaced `sources/README.md`'s "Still not ingested from these repos: …" sentence, which this job just made obsolete.

## Verification (real runs, not inspection)

- `library-link-check.sh --changed` on the staged commit: **OK — every checked link resolves to a committed file** (exit 0).
- `regenerate-topics-counts.sh --check` before landing: stale counts, 12 lines, **no missing topic page** — informational per step 8, cured by step 9.
- `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` both ran as the final landing step and landed `sections/README.md` and `topics/README.md`.
- Re-run against the landed tip: `library-link-check.sh --source-slug` **OK** for both new clusters including their `sections/README.md` rows, and `regenerate-topics-counts.sh --check` reports counts **current**.

Result entry: `entries/2026/07/29/021541Z-result-scholar-d51190.md`. Inbox drained (empty). My garden worktree is clean — this job was entirely journal work, so nothing needed pushing to `main2`.

## Follow-ups

None. The scope was the named remainder and it is complete; no deferred backlog, no follow-on job posted.

Self-improvement: the recurring cost here was not the ingest but the **stale-by-design cross-reference** — a concept page that says "not yet ingested" and a source-README that says "still not ingested from these repos" both become false the moment a follow-on cycle lands, and only a human-noticed re-read catches it. Both are structurally detectable: a "not yet ingested"/"still not ingested" phrase naming a slug that now exists in `sources/` is a mechanical check, the same shape as `library-link-check.sh`'s dangling-row scan run in reverse. That is a checker worth carving, but it is a skill/script change, so per the scholar's authority bounds I am routing it as a lesson rather than landing it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/scholar-ingest-shadowrealm-errors-and-content-type-companions.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 75 tokens (3977834 cached reads)
- Output: 26722 tokens
- Cost: $3.7987900000000003
- Wall-clock: 589s

<!-- garden-usage-end -->
