---
title: Phases
source: designs/hardened-url-shim.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 6ddaa541d27da22f01ad49437f0d690eaed8329a
source_date: 2026-05-06
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript, repository-governance]
status: current
notes: The "tame inside SES, not as an external shim" decision is the load-bearing structural call — folding into SES intrinsics pipeline avoids opt-in fragmentation AND avoids duplicating the whitelisting machinery in a per-package shim. The "no polyfill in this design" decision keeps XS users without URL but accepts a future @endo/url polyfill as a layerable addition. All three phases are S-sized.
parent: endo-but-for-bots--llm-designs-hurl--comparison-tests-decisions
---

**Phase 1: Permits and sampling (S)** — extend `permits.js` with `%URL%` + `%SharedURL%` + `%URLSearchParams%` + `%URLSearchParamsIteratorPrototype%`; plumb `urlBlobMethods` opt-in; extend `get-anonymous-intrinsics.js` (or equivalent) for iterator-prototype sampling; update whitelist pass if needed.

**Phase 2: Tests and changeset (S)** — test cases from the plan; changeset describing tamed intrinsics + `urlBlobMethods` option + removed methods + host-without-URL behavior.

**Phase 3: Downstream audit (S)** — grep monorepo for `URL.createObjectURL` and `URL.revokeObjectURL` (none should remain in code that runs under SES); grep for `new URL(` in compartment-running code (newly enabled, candidates for simplification).

Source: [designs/hardened-url-shim.md](https://github.com/endojs/endo-but-for-bots/blob/6ddaa541d27da22f01ad49437f0d690eaed8329a/designs/hardened-url-shim.md) at commit `6ddaa541` on branch `llm`.
