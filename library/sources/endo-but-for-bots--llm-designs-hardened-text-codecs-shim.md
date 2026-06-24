---
source: designs/hardened-text-codecs-shim.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 6d2f3a03a0648edda82a0444898f1d1ff0c25806
source_date: 2026-05-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
section_count: 3
status: current
notes: **Status: Not Started** upstream. Sibling of [[endo-but-for-bots--llm-designs-hardened-url-shim]] — both add a vetted host-provided constructor to SES permits; split out per PR #84 review on the URL shim. The simpler of the two cases because `TextEncoder`/`TextDecoder` have **no ambient-authority static methods and no exposed iterator prototype** — placement lands on `universalPropertyNames` rather than the `initial`/`shared` split that URL needed.
---

> Abstract: SES taming of host-provided `TextEncoder` and `TextDecoder` constructors. Placement is `universalPropertyNames` (one identity-equal constructor across the start compartment and every post-lockdown compartment) because these codecs are pure transformations between `string` and `Uint8Array` with no ambient-authority methods. Permits table covers `prototype`, `encode`/`encodeInto`/`encoding` on `TextEncoder`, `decode`/`encoding`/`fatal`/`ignoreBOM` on `TextDecoder` — six entries, no iterator prototypes. `sampleGlobals` already handles missing properties so XS (which lacks the codecs) degrades gracefully without a new lockdown phase. Six standard test cases (presence, identity-across-compartments, frozen, round-trip, host-without, XS smoke) form a template that future SES-intrinsics-taming PRs can copy verbatim. Three S-sized phases. Three design decisions: (1) universal not start-only because there is no powered variant to tame down to; (2) tame inside SES not external shim, to avoid duplicating whitelist machinery; (3) no polyfill in this design — defer to a separate design when there is demand for XS users. Phase 3 names the convention this design enables: **prefer `Uint8Array` + `TextEncoder`/`TextDecoder` over Node's `Buffer`** for code that runs under SES.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [problem-and-permits](../sections/endo-but-for-bots--llm-designs-htcs--problem-and-permits.md) | hardened-javascript, compartments | current |
| [sampling-degradation-and-lockdown](../sections/endo-but-for-bots--llm-designs-htcs--sampling-degradation-and-lockdown.md) | hardened-javascript, compartments | current |
| [phases-tests-and-design-decisions](../sections/endo-but-for-bots--llm-designs-htcs--phases-tests-and-design-decisions.md) | hardened-javascript, compartments, tooling | current |

## See also

- `hardened-url-shim.md` (`hurl`) — sibling design split from the same source issue; both add a vetted host-provided constructor to SES permits
- `base64-native-fallthrough.md` — same family of work (tame and dispatch to native intrinsics inside SES); not yet ingested
