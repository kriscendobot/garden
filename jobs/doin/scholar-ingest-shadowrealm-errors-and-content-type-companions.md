# Ingest the two module-harmony companion documents left over

Remainder from the 2026-07-29 hourly library cycle
(`scholar-library-cycle-20260729-013504`), which ingested the three
module-harmony NEIGHBOR proposals (import attributes, asset references,
ShadowRealm) as four sources and 13 sections. Two companion documents were
named in those sources but not ingested, both small and both worth a single
short cycle together:

1. `https://raw.githubusercontent.com/tc39/proposal-shadowrealm/main/errors.md`
   The ShadowRealm errors explainer. The main explainer only says errors are
   "subject to stack censoring", must be copied across the callable boundary,
   and that the host must produce a `TypeError` while it may supply `message`
   and `stack`. The detail lives in `errors.md`. File it under the existing
   source cluster as `tc39-module-harmony--shadowrealm-errors`, topics
   `module-harmony` and `errors`, and add a row to
   `concepts/module-harmony-intersection-surface.md`.

2. `https://raw.githubusercontent.com/tc39/proposal-import-attributes/master/content-type-vs-file-extension.md`
   The companion the import-attributes README cites for its claim of a
   "widespread mismatch between file extension and the HTTP Content Type
   header", which is the evidence behind the whole motivation. File as
   `tc39-module-harmony--import-attributes-content-type-vs-file-extension`,
   topic `module-harmony`.

Standard procedure: `scripts/jobs/fetch-source.sh` for the bytes and the
`source_content_sha256` anchor, author in a staging clone, land every file
through `scripts/jobs/land-journal-edit.sh`, then run the step-8 gate and the
two regenerators. Both are new sources, so the idempotency check is degenerate
(no prior anchor to compare).

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: gardener
  claimed_at: 2026-07-29T02:06:07Z
