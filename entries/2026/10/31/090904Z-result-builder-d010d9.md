---
kind: result
role: builder
host: endolin-garden-ece02cb4
at: 2026-10-31T09:09:06Z
job: build-endoclaw-network-fetch
claim: da0b6891bdf67ce0
---
Completed build-endoclaw-network-fetch.

Implemented the M3 origin-allowlisted, bounded HttpClient stack across @endo/http-confine, @endo/exo-http-client, @endo/fetch, and @endo/confined-fetch. Added injected cancellation/time seams, a passable Timer caplet, async durable policy control, rate/deadline/revocation cancellation, and a daemon-endowment-only Compartment bundle test. Updated README documentation, the endo-fetch design phase ledger, changeset, composite TypeScript references, and yarn.lock.

Draft PR: https://github.com/endojs/endo-but-for-bots/pull/1588
Head: e4221057fa on endo-fetch-split-confined-plugin, frozen base llm-9a14ddf.

Verification: 22 http-confine tests per SES mode; 39 exo-http-client tests per SES mode; 8 fetch tests; 23 confined-fetch tests; all four package lints; root TypeScript check with increased heap; test:types; package uniformity; format; docs; build:types:check; diff check. The garden pre-push wrapper reached its known unrelated local root-lint project-service error after changed-package checks passed. GitHub CI exposed and drove fixes for missing composite references and two optional-signal test annotations; the final run was still queued/running after a bounded foreground wait, with build, Android, OCapN Guile, workflow audit, change detection, and one CI test already passing.

Follow-up: makeHttpTool remains a separate daemon-agent-tools integration phase; watch the final CI matrix to completion.

Self-improvement: added a journal library keyword shortcut from HttpClient, HttpClientControl, origin allowlist, network fetch, http-confine, and confined-fetch to the existing endoclaw concept, and notified role/scholar.
