---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr160-review-9858a782
verdict: miss
category: style-convention
pr: 160
cluster: endo-errors-over-raw-throw
cluster_pattern: Freshly-authored Endo package code throws raw `new Error(...)` (or hand-rolls a raw-JS equivalent like `new TextDecoder`) where the pervasive Endo house convention is the idiomatic `@endo/errors` `Fail`/`assert`/`q` (and sibling `@endo/*` utilities); no garden seat brief, skill, or gate encodes this yet.
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/160#pullrequestreview-4730182358
identity: endojs/endo-but-for-bots#160:review:4730182358
producing_role: fixer
producing_job: endojs-endo-but-for-bots-pr160-review (exo-zip/exo-unzip package authoring)
missed_by: stylist/purist (no seat encodes the @endo/errors idiom)
severity: minor
---

The maintainer's "Refresh" review carried four inline comments on the freshly
authored `exo-unzip` package. One of them — "Use endo/errors" on
`packages/exo-unzip/src/unzip.js` — indicts the review process: the new module
throws a raw `new Error(...)` in thirteen places where the established Endo
house convention is to build hardened, redaction-disciplined errors with
`@endo/errors` (`Fail` / `assert` / `q` / `makeError`). This is not taste or new
direction: on the same `llm` branch 143 package source files import
`@endo/errors`, and the fixer's response was a mechanical rewrite of all thirteen
throws to `throw Fail\`…\``. A competent Endo panel should flag raw `throw new
Error` in newly authored package code as a matter of course, yet no garden seat
brief, skill, or pre-push gate currently encodes the convention, so neither the
gauntlet nor the panel caught it — the maintainer did.

Grounds for treating the other three inline comments as new-direction (not part
of this miss): "aliased without the extension now" and "Use the new bytes
package" both reference capabilities that only became available during the two
months of `llm`-branch evolution between the panel run (2026-05-09) and this
review (2026-07-19) — `@endo/zip` gained the extensionless subpath aliases and
`@endo/bytes` was newly introduced, so the panel could not have anticipated
either. "Please look into using exo-strram" points at a package that does not yet
exist anywhere in the workspace (the fixer confirmed it is absent); it is a
speculative future-direction nudge, not a caught defect. Only the `@endo/errors`
convention was both stable and pervasive at panel time.

This is the first recorded instance of the `@endo/errors`-over-raw-throw pattern;
it mints a new `style-convention` cluster (shape mirrors
`named-imports-over-namespace`: a genuine Endo house convention the garden has not
yet encoded). Held below the dispatch floor — see the threshold rationale in the
cluster.
