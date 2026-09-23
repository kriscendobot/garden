---
source: packages/check-bundle/{index,lite,src/json}.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/check-bundle
source_path: packages/check-bundle/index.js, packages/check-bundle/lite.js, packages/check-bundle/src/json.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - capability-security
  - bundles
  - hardened-javascript
genre: §endo-source-comment-fragment §canonical-powered-powerless-pair
cycle: 185
lane: chat
status: current
title: §The-§gap-between-design-and-implementation (cycle 180 boundary site migration)
parent: endo--packages-check-bundle-js--powered-and-powerless-symmetric-pair-with-frozen-bundle-assertion-and-design-boundary-migration
---

§Cycle-180-hex-package-design's-§audit-table-row-23:

> `packages/check-bundle/index.js` line 14 `hash.digest()
> .toString('hex')` — SHA-512 digest at the Node powers
> boundary. **Retained as-is**: the hash digest already
> returns a hex string directly from Node; converting through
> `encodeHex` would require `digest()` + conversion with no
> benefit. Marked as "boundary" — not a migration target.

§The-actual-current-source:

```js
import { encodeHex } from '@endo/hex';
// ...
const computeSha512 = bytes => {
  const hash = crypto.createHash('sha512');
  hash.update(bytes);
  return encodeHex(hash.digest());
};
```

§The-design's-prediction-was-overturned-by-implementation:
the line was migrated to use `encodeHex(hash.digest())` despite
the design's audit explicitly marking it as §retained-at-
boundary.

§Three-possible-readings:

1. **Migration-happened-anyway**: someone (maybe even Kris)
   noticed that even though `digest('hex')` returns hex
   directly, using `digest()` + `encodeHex` gives a cleaner
   policy boundary — "all hex encoding goes through @endo/hex"
   — and the marginal allocation cost was acceptable.
2. **Design-was-honest-about-uncertainty**: cycle 180's design
   text said "Could migrate for consistency; low priority, not
   on the critical migration path" for some sites. §The-
   actual-migration-was-low-priority-but-eventually-done.
3. **Forgetting-the-design**: the migrator may not have
   consulted the design's audit table; just saw `digest()`
   returning bytes and naturally reached for `encodeHex`.

§The-§honest-design-evolution-record discipline (cycles 178/
180/183/184) extends to §the-design-doesn't-always-predict-
where-the-line-ends-up. §Cycle-180-design-was-a-prediction-at-
2026-04-23; §the-implementation-state at cycle 185 (2026-06-03)
differs.

§This-is-not-a-criticism — the design did its job (named the
migration policy + identified the boundary candidates). §The-
boundary-sites-table-was-a-guide, not a contract. §The-§gap-
itself-is-the-honest-design-implementation-relationship: not
1:1 binding, but mostly-aligned-with-room-for-evolution.

§Tier-1-borrowing: §audit-tables-in-designs-are-guides-not-
contracts; §allow-the-implementation-to-diverge-with-good-
reason; §consult-the-source-not-the-design when verifying
current state.
