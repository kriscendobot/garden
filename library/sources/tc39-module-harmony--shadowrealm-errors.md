---
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-shadowrealm/main/errors.md
source_content_sha256: f96224a3dce4f6712929942f42d72d5e2cf78edbf2d69f95ec6c61d1a0fe80f4
source_commit: e191b135591e
source_authors: [Caridy Patiño]
source_date: 2023-01-26
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
section_count: 1
status: current
notes: "The ShadowRealm proposal's errors explainer — implementer guidance the main explainer only gestures at (errors are 'subject to stack censoring', are copied across the callable boundary, and the host must produce a TypeError while it may supply message and stack). Repo is proposal-shadowrealm, default branch `main`. Fetched direct via scripts/jobs/fetch-source.sh (source_fetched_via=direct); idempotency anchor is source_content_sha256, with the file-specific commit recorded alongside (e191b135591e, 2023-01-26, the file's only two commits both by Caridy Patiño). Single-section ingest per conventions.md § Sectioning shapes: the document is two pages with one H2 and one H3. Companion to tc39-module-harmony--shadowrealm-explainer and tc39-module-harmony--shadowrealm-readme; ingested by the follow-on job scholar-ingest-shadowrealm-errors-and-content-type-companions, the remainder the 2026-07-29 hourly cycle scholar-library-cycle-20260729-013504 named but did not ingest. Canonical human page: https://github.com/tc39/proposal-shadowrealm/blob/main/errors.md. Part of the tc39-module-harmony cluster."
---

The **ShadowRealm errors explainer**: how much of an error may survive the callable boundary, written as guidance for browser implementers rather than as spec text. The spec's rule is replacement — an error thrown across the boundary in either direction becomes a fresh `TypeError` — and this document fixes what a host may put in that `TypeError`'s `message`. It may be composed from the original's `name` and `message` (`"wrapped function threw, error was TypeError: null has no properties"`), but each further crossing re-composes **from scratch** rather than nesting, so neither nested ShadowRealms nor an error re-entering its realm of origin accumulates a chain or retains a visible reference to the original. Reading the original's `name`/`message` must be unobservable to user-land code: the host reads data values from the `[[ErrorData]]` slot, or host-cached values where those are accessors. A thrown value with no `[[ErrorData]]` slot yields the generic `"wrapped function threw, error was uncaught exception: Object"`. Firefox is cited as implementing this logic.

| Section | Topics | Status |
|---------|--------|--------|
| [errors-crossing-the-callable-boundary](../sections/tc39-module-harmony--shadowrealm-errors--errors-crossing-the-callable-boundary.md) | module-harmony, errors | current |
