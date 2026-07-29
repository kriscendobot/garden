---
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-shadowrealm/main/explainer.md
source_content_sha256: 4842a1efb89d6b281962be7db9f9b5d4b863bdc6f75137abfc5a44a78031eca9
source_authors: [Dave Herman, Caridy Patiño, Mark S. Miller, Leo Balter, Rick Waldron, Chengzhong Wu]
source_date: 2024-12-01
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
section_count: 4
status: current
notes: "TC39 ShadowRealm API explainer (Stage 2.7), the substantive companion to the thin README ingested as tc39-module-harmony--shadowrealm-readme. Repo is proposal-shadowrealm, default branch `main`. Fetched direct via scripts/jobs/fetch-source.sh (source_fetched_via=direct); idempotency anchor is source_content_sha256. Sectioned by H2 with related H2s consolidated: the Errors / Modules / examples / Status Quo / Iframes / FAQ tail folds into the clarifications and use-cases sections rather than becoming six thin files. The repository's separate errors.md explainer is NOT ingested (candidate follow-on). Two images referenced by the explainer (detachable-realms.png, amp-workerdom-challenge.png) are not reproduced. source_date is an era approximation from the README's latest listed presentation (2024-12). Canonical human page: https://github.com/tc39/proposal-shadowrealm/blob/main/explainer.md. Ingested as one of the three module-harmony NEIGHBOR proposals flagged but deferred by the layer-4 cycle (job scholar-research-module-harmony-compartment-layer4); part of the tc39-module-harmony cluster."
---

The **ShadowRealm explainer** is the document behind the four-line API. Its stated primary goal is "to provide a proper mechanism to control the execution of a program, providing a new global object, a new set of intrinsics, no access to objects cross-realms, a separate module graph and synchronous communication between both realms". The mechanism is the **callable boundary**: only primitives and callables cross, and a callable becomes a wrapped function exotic object whose connection to the far side is internal and untraceable from user land, so the **identity discontinuity** that afflicts iframes is structurally impossible and no serialization is needed (the ShadowRealm shares the incubator realm's heap and thread). Three facts matter most to the rest of the library. First, the explainer draws the Compartments line itself: ShadowRealm defines **no** virtualization mechanism for host behavior, which is exactly what distinguishes it from Compartments; the two compose (`compartment.globalThis.ShadowRealm`), and Compartments "plans to provide the low level hooks to control the module graph per ShadowRealm", named as one of the intersection semantics between the two proposals. Second, the security triage is stated honestly in the vocabulary of Agoric's taxonomy-of-security essay: **✅ integrity, ⛔️ availability, ⚠️ confidentiality**, with integrity scoped to programs that "might inadvertently step on each other's feet" and confidentiality defeated by Spectre-class side channels and fingerprinting. Third, the status quo it replaces is Node's `vm` ("a very good approximation") and same-domain iframes ("problematic"), for four enumerated reasons ending in identity discontinuity.

| Section | Topics | Status |
|---------|--------|--------|
| [api-motivations-and-non-goals](../sections/tc39-module-harmony--shadowrealm-explainer--api-motivations-and-non-goals.md) | module-harmony, capability-security | current |
| [clarifications-globals-csp-module-graph-and-compartments](../sections/tc39-module-harmony--shadowrealm-explainer--clarifications-globals-csp-module-graph-and-compartments.md) | module-harmony, compartments | current |
| [security-integrity-yes-availability-no-confidentiality-partial](../sections/tc39-module-harmony--shadowrealm-explainer--security-integrity-yes-availability-no-confidentiality-partial.md) | capability-security, module-harmony | current |
| [use-cases-and-the-iframe-and-node-vm-status-quo](../sections/tc39-module-harmony--shadowrealm-explainer--use-cases-and-the-iframe-and-node-vm-status-quo.md) | module-harmony, testing | current |
