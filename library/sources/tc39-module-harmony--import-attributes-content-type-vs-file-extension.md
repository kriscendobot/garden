---
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-import-attributes/master/content-type-vs-file-extension.md
source_content_sha256: 517bae82cc71751c9f0b557df479b01ee1cac0d720dbc2c468e324d496011d29
source_commit: 9015a79a2c28
source_authors: [Sven Sauleau]
source_date: 2020-06-26
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
section_count: 2
status: current
notes: "The companion document the import-attributes README cites for its claim of a 'widespread mismatch between file extension and the HTTP Content Type header' — the evidence behind the whole motivation, which is why it is ingested separately rather than folded into the README's synopsis section. Repo is proposal-import-attributes, default branch `master`. Fetched direct via scripts/jobs/fetch-source.sh (source_fetched_via=direct); idempotency anchor is source_content_sha256, with the file-specific commit recorded alongside (9015a79a2c28, 2020-06-26, both of the file's commits by Sven Sauleau). The measurement tables are transcribed rather than shape-summarized because they are a frozen 2019/2020 observation, not a mirror of a drifting upstream row set. Predates the rename to import attributes — the intro links tc39/proposal-import-conditions#4, the proposal's first name. Companion to tc39-module-harmony--import-attributes; ingested by the follow-on job scholar-ingest-shadowrealm-errors-and-content-type-companions, the remainder the 2026-07-29 hourly cycle scholar-library-cycle-20260729-013504 named but did not ingest. Canonical human page: https://github.com/tc39/proposal-import-attributes/blob/master/content-type-vs-file-extension.md. Part of the tc39-module-harmony cluster."
---

The evidence document behind import attributes. Its argument is that a file extension is not a type: in Node and webpack the extension-to-type association is already broken by arbitrary resolution redirection, and on the web the type is the server-sent `Content-Type` header rather than the URL suffix at all, so a misconfigured or malicious server "could end up" serving a `.css` URL as JavaScript "and be evaluated by the client." Its evidence is a measured distribution at Cloudflare's traffic scale: only **61.8%** of `.js` responses carry `application/javascript` (20.1% carry an empty Content-Type, 2.5% carry `text/html`), and only **67.6%** of `.json` responses carry `application/json` (14.7% carry `text/html`, and 0.66% carry a JavaScript type — the direction that gets data evaluated as code). Most of the spread is benign vagueness among the four JavaScript spellings; the security argument rests on the tail, and on the document's own note that "even a very small percentage can reprensent a lot of requests" at that scale. This is what the README's one-line "widespread mismatch" claim is standing on.

| Section | Topics | Status |
|---------|--------|--------|
| [overview-why-the-extension-is-not-the-type](../sections/tc39-module-harmony--import-attributes-content-type-vs-file-extension--overview-why-the-extension-is-not-the-type.md) | module-harmony | current |
| [analysis-cloudflare-content-type-measurements](../sections/tc39-module-harmony--import-attributes-content-type-vs-file-extension--analysis-cloudflare-content-type-measurements.md) | module-harmony | current |
