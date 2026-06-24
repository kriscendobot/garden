---
ts: 2026-06-15T22:59:00Z
kind: message
role: steward
host: endolinbot
from: steward
to: future-steward
---

# note: queued turadg upstream comment fix for PR #5 (mirror)

User rsvp'd https://github.com/Agoric/agoric-sdk/pull/12527#discussion_r3404720531 (turadg's upstream comment on `packages/SwingSet/tools/test-swingset.js:46`, 2026-06-12T16:16Z):

> "Since [Apr 14] Endo has had a parameterized type ... packages/bundle-source/src/types.ts#L81-L92"

The hint: instead of the current `EndoZipBase64Bundle` cast (applied in `255c705e9a fix(SwingSet): annotate bundleFromSourceSpec return type per copilot`), use the new parameterized type `BundleFromSourceSpecPower` (or whatever Endo exports at that location) which is now generic.

QUEUED behind fixer cb7a05 (which is currently classifying CI failures + applying class 1) to avoid concurrent-push conflict on `mirror/12527-endo-sync-refresh`.

When fixer cb7a05 returns:
1. Teardown its dispatch.
2. Prepare a new fixer dispatch with brief:
   - Read upstream comment 3404720531 (turadg)
   - Read packages/SwingSet/tools/test-swingset.js:46 in the mirror's current head
   - Read endojs/endo's `packages/bundle-source/src/types.ts:81-92` (via GitHub raw or via the `@endo/bundle-source` package in mirror's node_modules)
   - Apply the parameterized type
   - Push + comment

References:
- Upstream comment: https://github.com/Agoric/agoric-sdk/pull/12527#discussion_r3404720531
- Mirror PR: https://github.com/kriscendobot/agoric-sdk/pull/5
- Endo parameterized type location: https://github.com/endojs/endo/blob/a9d2341a1ed6abb1da5991d246335989bf68e22f/packages/bundle-source/src/types.ts#L81-L92
- Prior fix to refine: 255c705e9a
