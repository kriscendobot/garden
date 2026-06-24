---
section: namer-procedure-applied-via-Laws-0-1-2-with-three-phased-rename-and-exhaustive-mechanical-inventory
source: endo-but-for-bots--llm-designs-daemon-rename-to-manager
topics: [daemon, agent-conventions, repository-governance]
status: current
title: The §no-deprecated-alias-kept rationale
parent: endo-but-for-bots--llm-designs-daemon-rename-to-manager--namer-procedure-applied-via-Laws-0-1-2-with-three-phased-rename-and-exhaustive-mechanical-inventory
---

§Compatibility considerations name four risks: wire / persistence
/ public exports / upstream / downstream. The §search-confirms-
rename-is-outright-cut conclusion:

> *Search of the `endojs/endo` master and visible downstream
> repositories did not find any consumer that imports a `Daemon*`
> identifier from `@endo/daemon`. The rename is therefore an
> outright cut, not a deprecation.*

The §evidence-based-deprecation-decision discipline: a
deprecation window has *cost* (carrying two names; eventually
removing one). It's only *worth* it if there are users to
migrate. Here, the search shows there are *none* outside the
package itself; the rename can be a *cut* rather than a
*deprecation*.

The §look-for-downstream-consumers-before-deciding-on-deprecation
discipline. The §absence-of-consumers-means-no-deprecation rule.
