---
title: Open questions
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

1. **Synthetic-intrinsic name**: `%URLSearchParamsIteratorPrototype%` mirrors the `%IteratorPrototype%` convention. Shorter alternative?
2. **Cross-compartment `instanceof`**: shared-prototype is the recommendation (single prototype value across compartments → instanceof works); cost is `Foo.constructor === URL` gives different answers depending on origin compartment. Alternative: distinct prototype chains, push burden onto cross-compartment helpers.

Source: [designs/hardened-url-shim.md](https://github.com/endojs/endo-but-for-bots/blob/6ddaa541d27da22f01ad49437f0d690eaed8329a/designs/hardened-url-shim.md) at commit `6ddaa541` on branch `llm`.
