---
source: README.md
source_repo: ucan-wg/spec
source_commit: 9955aa1fb7b32897f80b57651f4ee8b22ebf35a7
source_date: 2026-07-08
source_authors: [Brooklyn Zelenka, Irakli Gozalishvili, Daniel Holmgren, Philipp Kruger]
ingested: 2026-07-28
ingested_by: scholar
section_count: 5
status: current
notes: |
  Version status, observed 2026-07-28 and stated honestly because it is easy
  to get wrong: the README on `main` reads "Version 1.0.0", but the
  repository's most recent git tag is `v1.0-rc.1` (prior tags `v0.10.0`,
  `v0.9.2`) and there are no GitHub releases. The sub-spec repositories
  (ucan-wg/delegation, ucan-wg/invocation, ucan-wg/revocation) carry no tags
  at all, and ucan-wg/revocation's README self-describes as `v1.0.0-rc.1`.
  Treat UCAN 1.0 as recently stabilized text that is not uniformly frozen,
  and pin to a commit rather than a version string.

  The 0.10 line is a DIFFERENT artifact, not an older draft of the same one:
  its abstract describes providing capabilities "by extending the familiar
  JWT structure", whereas 1.0 uses a signed DAG-CBOR Varsig envelope. The
  two are not wire-compatible.
---

> Abstract: The high-level UCAN 1.0 specification: the concepts, roles, and canonical encoding that the Delegation, Invocation, Promise, and Revocation sub-specs build on. UCAN is "a trustless, secure, local-first, user-originated, distributed authorization scheme" providing "public-key verifiable, delegable, expressive, openly extensible capabilities" with principals as DIDs (`did:key` required), a capability modelled as `subject x command x policy`, and every token canonically DAG-CBOR encoded and CIDv1 content-addressed. The design centre is inversion of control: "There is no Authorization Server (AS) that sits between requestors and resources", bought at the documented cost of no confinement, unobservable sub-delegation, and best-effort revocation.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [motivation-and-auth-model-comparison](../sections/ucan-wg--spec-readme--motivation-and-auth-model-comparison.md) | ucan-authorization, capability-security, capability-theory | current |
| [inversion-of-control-and-security](../sections/ucan-wg--spec-readme--inversion-of-control-and-security.md) | ucan-authorization, capability-security | current |
| [roles-subject-issuer-audience](../sections/ucan-wg--spec-readme--roles-subject-issuer-audience.md) | ucan-authorization, capability-security, identity | current |
| [capability-authority-command-attenuation](../sections/ucan-wg--spec-readme--capability-authority-command-attenuation.md) | ucan-authorization, capability-security | current |
| [canonicalization-envelope-and-cids](../sections/ucan-wg--spec-readme--canonicalization-envelope-and-cids.md) | ucan-authorization, content-addressed-storage, marshal | current |

Deferred from this cycle, and named in the follow-on `scholar-ingest-ucan-atproto-remainder` job: the Lifecycle / Time / Token-Resolution / Nonce / Metadata sections, the Implementation Recommendations (delegation store, memoized validation, replay-attack prevention, beyond-single-system-image, wrapping existing systems), the FAQ, and the Related Work section.

Source: [`README.md`](https://github.com/ucan-wg/spec/blob/9955aa1fb7b32897f80b57651f4ee8b22ebf35a7/README.md) at commit `9955aa1f`.
