---
title: Design Decisions
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

1. **`%URL%` on start, `%SharedURL%` on shared.** Date-style split — smallest change that captures both intents (host app keeps powered binding; shared compartments get powerless variant). Both bound to `globalThis.URL` so consumer code is identical. Naming follows `%SharedSymbol%`/`%SharedDate%`/`%SharedError%`/`%SharedRegExp%` precedent.
2. **Lockdown opt-in to conflate.** `urlBlobMethods: 'remove'` collapses for embeddings with no blob use; default keeps host-provided start shape.
3. **Tame inside SES, not as an external shim.** Iterator-prototype hazard is an SES whitelisting concern; centralizing in `permits.js` avoids duplicating whitelisting machinery.
4. **TextEncoder/TextDecoder split to sibling design.** Same source issue but no implementation overlap.
5. **No polyfill in this design.** XS users continue without URL; a future `@endo/url` polyfill can layer cleanly.
6. **Permit `URL.parse`, `URL.canParse`, iterator prototype's `[Symbol.toStringTag]`.** Pure helpers admitted; absence on older hosts handled by skip-when-missing.
7. **Bundle-size impact negligible.** Tens of lines of permits + one sampler + one boolean check. No measurement required.

Source: [designs/hardened-url-shim.md](https://github.com/endojs/endo-but-for-bots/blob/6ddaa541d27da22f01ad49437f0d690eaed8329a/designs/hardened-url-shim.md) at commit `6ddaa541` on branch `llm`.
