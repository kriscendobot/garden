---
title: §the-named-pre-written-PR-language-for-ecosystem-cooperation
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

Lines 932-948 provide **verbatim text** for downstream maintainers to paste into upstream issues:

```
> This project has some assignments that break in an environment with frozen
> intrinsic objects, such as
> [Hardened JS (a.k.a. SES)](https://github.com/endojs/endo/blob/master/packages/ses#ecosystem-compatibility)
> or Node.js with the
> [`--frozen-intrinsics`](https://nodejs.org/docs/latest/api/cli.html#--frozen-intrinsics)
> option.
> Specifically, [link to source in the project] does not work correctly in such
> an environment.
>
> Please consider increasing support by replacing assignments to object
> properties inherited from intrinsics with use of `Object.defineProperties`
> (thereby working around the JavaScript "override mistake"), and if applicable
> also by avoiding mutation of intrinsic objects.
> If you don't have the capacity but would accept a PR, please comment to that
> effect so that a volunteer knows their efforts would be welcomed.
```

**§the-named-pre-written-PR-language-for-ecosystem-cooperation** — first-explicit-observation as a tier-3 meta-pattern. The README anticipates that downstream users will encounter incompatibilities AND that fixing those incompatibilities requires upstream cooperation. The README provides the EXACT TEXT to use.

**§the-named-README-as-cultural-artifact-not-just-documentation** — first-explicit-observation. The README is not merely describing the package; it's SCRIPTING the community-action that the package's adoption requires. Tier-3 framing: when a package's success depends on ecosystem cooperation, the README should provide *verbatim cooperation language* for downstream users to deploy.

Compare to cycle 343 @endo/init's §the-named-cross-package-compensation-named (pointing to @endo/ses-ava for Ava compatibility); cycle 345's pre-written PR text is the *scaled-up* version — instead of one named compensation package, the README provides text for AD HOC compensation across the entire JS ecosystem.

**§the-named-volunteer-PR-language-with-named-fallback-comment** — the text includes *"If you don't have the capacity but would accept a PR, please comment to that effect so that a volunteer knows their efforts would be welcomed"* — anticipating two distinct downstream maintainer responses (do-it-yourself vs accept-volunteer-PR) and naming both.
