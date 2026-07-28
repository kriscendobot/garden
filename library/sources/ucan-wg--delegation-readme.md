---
source: README.md
source_repo: ucan-wg/delegation
source_commit: 1cb32dbc9d4d15a23bf9844a02515d760b81e816
source_date: 2026-07-08
source_authors: [Brooklyn Zelenka, Irakli Gozalishvili, Philipp Kruger]
ingested: 2026-07-28
ingested_by: scholar
section_count: 4
status: current
notes: |
  README on `main` reads "Version 1.0.0"; the repository carries no git tags
  and no releases, so the commit SHA is the only reliable pin. See
  ucan-wg--spec-readme for the fuller version-status note across the UCAN
  sub-specs.
---

> Abstract: The UCAN Delegation 1.0 sub-specification, the REQUIRED half of the UCAN lifecycle: the `ucan/dlg@1.0.0` envelope tag and its nine-field payload, the Subject / Resource model that makes a chain self-certifying by default, the Powerline (`sub: null`) forward-delegation pattern, the `cmd` path and `pol` predicate language that carry attenuation in band, and the three offline-checkable validation criteria (time bounds, principal alignment, signature validation). Where the high-level spec says what a capability is, this says exactly what bytes express it and exactly what a validator checks.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [delegation-payload](../sections/ucan-wg--delegation-readme--delegation-payload.md) | ucan-authorization, capability-security | current |
| [subject-resource-and-powerline](../sections/ucan-wg--delegation-readme--subject-resource-and-powerline.md) | ucan-authorization, capability-security, identity | current |
| [command-and-policy](../sections/ucan-wg--delegation-readme--command-and-policy.md) | ucan-authorization, capability-security, patterns | current |
| [token-validation](../sections/ucan-wg--delegation-readme--token-validation.md) | ucan-authorization, capability-security | current |

Deferred from this cycle, and named in the follow-on `scholar-ingest-ucan-atproto-remainder` job: the full Policy detail (selectors, glob matching, connectives, quantification, nested quantification, differences from jq, validation semantics) and the Semantic Conditions section.

Source: [`README.md`](https://github.com/ucan-wg/delegation/blob/1cb32dbc9d4d15a23bf9844a02515d760b81e816/README.md) at commit `1cb32dbc`.
