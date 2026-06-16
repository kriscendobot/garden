---
source: packages/init + packages/lockdown (entry-point files)
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/init
source_path: packages/init/*.js, packages/lockdown/*.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Mark S. Miller (prompted)
  - Kris Kowal (prompted)
topics:
  - hardened-javascript
  - getting-started
genre: §endo-source-comment-fragment §canonical-bootstrap-pattern
cycle: 183
lane: chat
status: current
title: §The-§domainTaming-unsafe-always-injected (the pragmatic hole)
parent: endo--packages-init-and-lockdown--canonical-bootstrap-entry-taxonomy-with-two-phase-init-and-NOTE-TO-REVIEWERS-discipline
---

```js
rawLockdown({
  ...options,
  domainTaming: 'unsafe',
});
```

§Whatever-options-the-user-passes (via LOCKDOWN_OPTIONS, via
`defaultOptions` argument, or via default fallback),
§`domainTaming: 'unsafe'` is always merged in last so it
overrides any user attempt to set it.

§The-prose-justification (lines 152-162):

> Domain taming causes lockdown to throw an error if the
> Node.js domain module has already been loaded, and causes
> loading the domain module to throw an error if it is pulled
> into the working set later. This is because domains may add
> domain properties to promises and other callbacks and that
> these domain objects provide a means to escape containment.
> However, our platform still depends on systems like
> standardthings/esm which ultimately pull in domains. For
> now, we are resigned to leave this hole open, knowing that
> all contract code will be run under XS to avoid this
> vulnerability.

§"For now we are resigned to leave this hole open" is the
§honest-admission discipline. §Compare-to-cycle-180-hex-
package's §boundary-sites-explicitly-named-and-defended — both
are §named-trade-off rather than §silent-default.

§The-mitigation-named: "all contract code will be run under XS
to avoid this vulnerability." §The-hole-is-pragmatic-not-
principled; it exists because of legacy dependency chains, and
the mitigation moves the vulnerability surface (contract code
under XS doesn't see the domain module).

§Compare-to-cycle-170-daemon-capability-filesystem's §defense-
in-depth-deny-patterns + §map-to-existing-substrate. §domain-
Taming-unsafe is the dual: §not-a-defense-but-an-acknowledged-
hole with a §named-mitigation-strategy.
