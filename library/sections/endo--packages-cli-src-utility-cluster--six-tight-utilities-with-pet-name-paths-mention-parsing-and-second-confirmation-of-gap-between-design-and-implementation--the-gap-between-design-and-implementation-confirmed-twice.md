---
source: packages/cli/src/{pet-name,message-format,message-parse,number-parse,random,prompt}.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/cli/src
source_path: packages/cli/src/pet-name.js, packages/cli/src/message-format.js, packages/cli/src/message-parse.js, packages/cli/src/number-parse.js, packages/cli/src/random.js, packages/cli/src/prompt.js
section_kind: source
ingested: 2026-06-05
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - tooling
  - daemon
genre: §endo-source-comment-fragment §canonical-CLI-utility-cluster
cycle: 195
lane: chat
status: current
title: §The-§gap-between-design-and-implementation, confirmed twice
parent: endo--packages-cli-src-utility-cluster--six-tight-utilities-with-pet-name-paths-mention-parsing-and-second-confirmation-of-gap-between-design-and-implementation
---

§Cycle-180-hex-package-design's §audit-table predicted two
§boundary-sites would be §retained-as-is (not migrated to
`encodeHex`):

| Cycle 180 audit row | File | Prediction | Actual source |
|--------------------|------|------------|---------------|
| Row 23 | `packages/check-bundle/index.js` line 14 | "Retained as-is: digest already returns hex directly" | Migrated to `encodeHex(hash.digest())` (cycle 185 finding) |
| Row 32 | `packages/cli/src/random.js` line 9 | "Retained as-is: crypto.randomBytes(n).toString('hex')" | Migrated to `encodeHex(bytes)` (this cycle) |

§Two-of-two-boundary-sites-named-in-the-audit-have-since-been-
migrated. §The-pattern-is-clear: §designs-are-guides-not-
contracts; §the-implementation-can-drift-toward-greater-
consistency over time even when the design rationalized
keeping the boundary.

§The-actual-cycle-195-`random.js`:

```js
import { encodeHex } from '@endo/hex';
import crypto from 'crypto';

export const randomHex16 = () =>
  new Promise((resolve, reject) =>
    crypto.randomBytes(16, (err, bytes) => {
      if (err) {
        reject(err);
      } else {
        resolve(encodeHex(bytes));
      }
    }),
  );
```

§Six-lines + import. §Uses `encodeHex(bytes)` after `crypto
.randomBytes(16, ...)` instead of `crypto.randomBytes(16).
toString('hex')`. §The-design-predicted-this-would-be-extra-
work-without-clarity-benefit; §the-migration-happened-anyway.

§Why-twice-might-happen: §the-policy-of-routing-all-hex-
through-@endo/hex was easier to enforce uniformly than to
maintain a §two-classes-of-hex-call-site distinction. §A-
mechanical-grep-and-replace pass that the audit-table didn't
anticipate.

§Compare-to-cycle-186-break-dev-deps' §audit-as-cycle-break-
precondition (grep for unused devDeps before adding new
packages). §Cycle-186-uses-audit-to-find-things-to-remove;
§cycle-180's-audit-was-used-to-find-things-NOT-to-touch — and
the implementation §didn't-respect-the-list.

§Tier-1-borrowing: §designs-are-guides-not-contracts is
§confirmed-by-two-independent-sites (not just one). §Future-
library-memory-should-verify-against-source not just against
designs. The §verify-against-source-not-design discipline
cycle 185 named is now §confirmed-as-a-recurring-pattern.
