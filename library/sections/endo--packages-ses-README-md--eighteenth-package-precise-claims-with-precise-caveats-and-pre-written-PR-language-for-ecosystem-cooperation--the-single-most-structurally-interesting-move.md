---
title: The single most structurally interesting move
source: endo--packages-ses-README-md
url: https://github.com/endojs/endo/blob/master/packages/ses/README.md
authors: [Kris Kowal, Mark S. Miller, Endo project (collective)]
repo: endojs/endo
path: packages/ses/README.md
total-lines: 964
ingest-cycle: 345
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-precise-claims-with-precise-caveats-discipline
  - the-named-pre-written-PR-language-for-ecosystem-cooperation
  - the-named-acronym-with-named-philosophical-expansion
  - the-named-SES-stands-for-fearless-cooperation
  - the-named-four-pillars-of-HardenedJS
  - the-named-host-program-vs-guest-program-vocabulary
  - the-named-canonical-deployers-named-with-logos
  - the-named-three-attack-categories-lockdown-defends-against
  - the-named-undeniable-objects-discipline
  - the-named-taming-as-named-verb-of-art
  - the-named-realm-vs-compartment-distinction
  - the-named-three-tiers-of-isolation-claims
  - the-named-list-of-things-guest-cannot-do
  - the-named-list-of-things-guest-can-still-do
  - the-named-Trusted-Compute-Base-enumerated
  - the-named-override-mistake-as-named-JavaScript-anti-feature
  - the-named-defineProperties-workaround-for-override-mistake
  - the-named-audit-history-as-trust-signal
  - the-named-purple-teaming-as-collaborative-audit-style
  - the-named-Caja-as-named-predecessor-with-named-extensions
  - the-named-Math-random-and-Date-now-disabled-by-default
  - the-named-SharedArrayBuffer-as-named-attack-vector
  - the-named-reentrancy-attack-named-explicitly
  - the-named-defending-via-clean-stack-promise
  - the-named-locale-methods-as-fingerprinting-vector
  - the-named-eighteenth-package-in-the-pivot-cluster
  - the-named-964-line-substrate-policy-vast-README
  - eight-cycles-with-named-substrate-package-introduction
  - thirty-six-cycles-with-named-pivot-domain-stay
  - one-hundred-sixteen-citation-arc-closures-in-pivot-now
parent: endo--packages-ses-README-md--eighteenth-package-precise-claims-with-precise-caveats-and-pre-written-PR-language-for-ecosystem-cooperation
---

**§the-named-precise-claims-with-precise-caveats-discipline** — the "Security claims and caveats" section (lines 693-859, ~166 lines) pairs each GUARANTEE with its LIMITATION explicitly. The section structure:

1. **Boundary definition** — what kind of boundary `ses` provides (lines 695-703)
2. **Vocabulary** — "host program" vs "guest program" (lines 705-707)
3. **Single-guest Compartment Isolation** — claims + limitations
4. **Multi-guest Compartment Isolation** — additional claims under additional conditions
5. **Endowment Protection** — what the host is responsible for
6. **Caveats** — explicit limitations of the boundary
7. **Trusted Compute Base** — what `ses` itself depends on

**Single-guest isolation claims** (lines 716-722):

> * will initially only have access to one mutable object, the compartment's `globalThis`,
> * specifically cannot modify any shared primordial objects, which are part of the default execution environment,
> * cannot initially perform any I/O (except I/O necessarily performed by the trusted compute base like paging virtual memory),
> * and specifically cannot measure the passage of time at any resolution.

**Immediately followed by limitations** (lines 724-734):

> However, such a program can:
> * execute for an indefinite amount of time,
> * allocate arbitrary amounts of memory,
> * detect the platform endianness,
> * in some JavaScript engines, observe the contents of the stack. (...) `ses` occludes the stack on V8 and SpiderMonkey, but cannot on JavaScriptCore.

**§the-named-precise-claims-with-precise-caveats-discipline** — first-explicit-observation as a tier-3 meta-pattern. The discipline:

| Element | Purpose |
|---|---|
| Numbered list of guarantees | Establishes the security claim |
| "However, such a program can:" + numbered list | Names the residual capabilities |
| Platform-specific caveats (e.g., JavaScriptCore) | Names where the guarantee weakens |

The discipline is to **never claim more than is true**, and to **explicitly enumerate what is NOT guaranteed**. Compare to:
- Cycle 337 @endo/harden's §the-named-partial-safety-with-named-tradeoff (without HardenedJS, surface immutability without prototype-chain traversal)
- Cycle 342 @endo/lockdown/pre.js's §the-named-named-hole-with-named-mitigation (domainTaming-unsafe always injected because standardthings/esm)
- **Cycle 345 @endo/ses's full claims+caveats section** — the canonical example of the discipline at the package-level

**§three-cycles-with-named-precise-security-claim-discipline** (337 + 342 + 345) — first-explicit-observation as a tier-2 multi-cycle pattern. The discipline crosses three substrate-introduction cycles.
