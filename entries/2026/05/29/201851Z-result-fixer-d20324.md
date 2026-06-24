---
ts: 2026-05-29T20:18:51Z
kind: result
role: fixer
project: endo
repo: endojs/endo-but-for-bots
---

Addressed naugtur's review feedback on upstream endojs/endo#3276
(via the bot mirror per the dispatch's authorization scope).

Disposition: **verified, no source change**, with executable parity
evidence landed as a single regression test.

Mirror PR state: new PR endojs/endo-but-for-bots#379 (closed #336 was
force-pushed beyond GitHub's reopen tolerance; the API returned
"state cannot be changed. The branch was force-pushed or recreated.").

Addressing SHA on the mirror branch: `96ea2c59c` (test-only commit
on top of synced upstream PR head `f4aad15a`).

One-line technical answer: the "all calls happen before upstreamNotify
is obtained" subcase is reachable (a cyclic re-export of an unused
live binding with no higher wireUp and no downstream subscriber) but
benign; the value stays undefined, which matches Node.js's behavior
for the same fixture shape.

What the new test pins:

```
star-reexporter.js: export * from './export-renamer.js';
export-renamer.js:  export { y as x } from './star-reexporter.js';
                    export var y;          // declared, never assigned
main.js:            import { x } from './star-reexporter.js';
                    import * as ns1 from './star-reexporter.js';
                    import * as ns2 from './export-renamer.js';
                    export const captured = x;
                    export const namespace1 = { x: ns1.x, y: ns1.y };
                    export const namespace2 = { x: ns2.x, y: ns2.y };
```

Verified Node.js reads all four projections as undefined. The new
SES test (`cyclic star export with renaming reexport, unused live
binding`) asserts the same.

Upstream sync done by resetting the mirror branch directly to
`f4aad15a` (the head naugtur reviewed) since the mirror's pre-ferry
content is identical in substance to the upstream squash. The
post-ferry advance (test rename mod1/mod2 → star-reexporter /
export-renamer, plus compartment-mapper companion tests) came along
in the reset.

Test runs:
- `yarn workspace ses test`: 503 pass + 2 known failures + 2 skipped.
- `yarn workspace @endo/compartment-mapper test` cycle-rename suites:
  12 pass.

Comment posted on mirror PR #379 (authorized by standing relaxation
for the bot-mirror repo). No comment posted on upstream PR #3276 (not
authorized; the boatman's later mirror-cross-link convention surfaces
the response upstream when the next ferry happens).

Self-improvement: nothing this time.
