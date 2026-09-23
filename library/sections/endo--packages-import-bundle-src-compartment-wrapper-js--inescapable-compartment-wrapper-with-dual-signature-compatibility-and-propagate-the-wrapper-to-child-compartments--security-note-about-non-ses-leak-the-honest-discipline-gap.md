---
source: packages/import-bundle/src/compartment-wrapper.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/import-bundle/src/compartment-wrapper.js
source_path: packages/import-bundle/src/compartment-wrapper.js
section_kind: source
ingested: 2026-06-05
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Brian Warner (prompted)
topics:
  - compartments
  - hardened-javascript
  - bundles
genre: §endo-source-comment-fragment §canonical-inescapable-compartment-pattern
cycle: 193
lane: chat
status: current
title: §SECURITY-NOTE about non-SES leak (the §honest-discipline-gap)
parent: endo--packages-import-bundle-src-compartment-wrapper-js--inescapable-compartment-wrapper-with-dual-signature-compatibility-and-propagate-the-wrapper-to-child-compartments
---

```js
// SECURITY NOTE: if this were used outside of SES, this might leave
// c.prototype.constructor pointing at the original (untamed) Compartment,
// which would allow a breach. Kris says this will be hard to fix until he
// rewrites the compartment shim, possibly as a plain function instead of a
// class. Under SES, OldCompartment.prototype.constructor is tamed
```

§The-§SECURITY-NOTE-prefix names this comment-block as a
security disclosure. §Two-named-properties:

1. §Outside-of-SES, the wrapper might leak the untamed
   Compartment via `c.prototype.constructor`.
2. §Under-SES, `OldCompartment.prototype.constructor` is
   tamed, so the leak doesn't apply.

§The-§"Kris says" attribution-in-source preserves the
authority chain. §The-§"hard-to-fix-until-rewrite" honesty
names the §deferred-fix without committing.

§Compare-to-cycle-188-perf's §working-copy-inventory (eight
uncommitted change clusters) and cycle 184-metering's §six-
known-gaps. §All-three-are-§named-deferred-fixes-in-source.

§Compare-to-cycle-183-init's §domainTaming-unsafe-always-
injected with §"For now we are resigned to leave this hole
open" comment. §Both-are-§security-disclosure-with-named-
mitigation patterns; cycle 183 names the runtime mitigation
(contract code under XS); cycle 193 names the structural
mitigation (only used under SES).

§Tier-1-borrowing: §SECURITY-NOTE-prefix for §security-
disclosure-comments — distinctive from regular comments;
greppable.
