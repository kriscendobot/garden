---
source: designs/hardened-url-shim.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 6ddaa541d27da22f01ad49437f0d690eaed8329a
source_date: 2026-05-06
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
section_count: 6
status: current
notes: Targets endojs/endo issue #2635. Companion design `hardened-text-codecs-shim.md` covers TextEncoder/TextDecoder taming (same source issue but no implementation overlap). The design's central insight: a Date-style split between `%URL%` (powered, start compartment) and `%SharedURL%` (powerless, shared compartments) is the smallest change that captures both intents. Cross-cuts with hardened-javascript (this *is* SES intrinsics work), capability-security (createObjectURL/revokeObjectURL as ambient authority that ocap discipline forbids), and bundles (the SES bundle gains a small permits contribution).
---

> Abstract: Design for adding `URL` and `URLSearchParams` to SES's permitted intrinsics as a vetted shim. Two specific hazards make a naive `harden(URL)` unsafe: (1) `URLSearchParams` iterator prototypes leak past the SES intrinsic graph — `URLSearchParams.prototype.entries`/`.keys`/`.values`/`[Symbol.iterator]` return objects whose prototype `%URLSearchParamsIteratorPrototype%` is not on globalThis, not in permits.js, not visited by harden's transitive walk; (2) `URL.createObjectURL` and `URL.revokeObjectURL` are ambient authority (mint/revoke blob-registry handles observable across realms) — they must be removed before any compartment sees them. **Solution**: Date-style split — `%URL%` on `initialGlobalPropertyNames` (start compartment, keeps blob methods) and `%SharedURL%` on `sharedGlobalPropertyNames` (every shared compartment, blob methods removed). Both bound to `globalThis.URL` so consumer code is identical. Shared `prototype` value so `instanceof URL` works across the boundary. Lockdown opt-in `urlBlobMethods: 'remove'` collapses the split. The hidden `%URLSearchParamsIteratorPrototype%` is sampled by constructing a throwaway `URLSearchParams`, calling `.entries()` and walking to its prototype; added to the intrinsics graph under that synthetic name. **Hosts without URL** (XS): the shim is a no-op; existing `sampleGlobals` already skips absent permits. Six sections.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [problem-and-hazards](../sections/endo-but-for-bots--llm-designs-hurl--problem-and-hazards.md) | hardened-javascript, capability-security | current |
| [integration-shared-vs-start](../sections/endo-but-for-bots--llm-designs-hurl--integration-shared-vs-start.md) | hardened-javascript, capability-security | current |
| [permits-table](../sections/endo-but-for-bots--llm-designs-hurl--permits-table.md) | hardened-javascript | current |
| [iterator-prototype-sampling](../sections/endo-but-for-bots--llm-designs-hurl--iterator-prototype-sampling.md) | hardened-javascript | current |
| [lockdown-sequencing-and-degradation](../sections/endo-but-for-bots--llm-designs-hurl--lockdown-sequencing-and-degradation.md) | hardened-javascript | current |
| [comparison-tests-decisions](../sections/endo-but-for-bots--llm-designs-hurl--comparison-tests-decisions.md) | hardened-javascript, repository-governance | current |

## Cross-references

- Source issue: endojs/endo #2635.
- Companion design: `hardened-text-codecs-shim.md` (TextEncoder/TextDecoder; not yet ingested; same source issue).
- Related ponyfill family: `base64-native-fallthrough.md` and `hex-package.md` (external ponyfills around TC39 natives; this URL shim is the SES-internal analogue).
- The SES intrinsics pipeline this hooks into: `endo--docs-lockdown--*` for the high-level lockdown taxonomy.

## Source

[designs/hardened-url-shim.md](https://github.com/endojs/endo-but-for-bots/blob/6ddaa541d27da22f01ad49437f0d690eaed8329a/designs/hardened-url-shim.md) at commit `6ddaa541` on branch `llm`.
