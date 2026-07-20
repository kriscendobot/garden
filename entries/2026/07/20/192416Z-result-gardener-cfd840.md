---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-20T19:24:17Z
---
---
kind: result
role: prosecutor
refs:
  - endojs-endo-but-for-bots-pr160-review-9858a782-retro
  - endojs/endo-but-for-bots#160:review:4730182358:retro
---

# Review-retrospective: endojs/endo-but-for-bots #160 review 4730182358

Second loop on kriskowal's "Refresh" review of PR #160. The review body was a
branch-op directive but carried four inline comments on the newly authored
`exo-unzip` package. Discriminated each against the PR's review history (the
2026-05-09 panel comment plus the later maintainer directives; the code was
substantially rewritten in between):

- **Miss** — "Use endo/errors": the module throws raw `new Error(...)` in
  thirteen places where the established Endo house convention is `@endo/errors`
  (`Fail`/`assert`/`q`/`makeError`). Pervasive (143 `llm`-branch source files
  import it) and stable at panel time; the fixer's response was a mechanical
  rewrite to `throw Fail\`…\``. No garden seat/skill/gate encodes the idiom, so
  the gauntlet missed it and the maintainer caught it.
- **New-direction** (three): "aliased without the extension now" and "Use the new
  bytes package" reference capabilities that only appeared during the two-month
  `llm` evolution between the panel (05-09) and this review (07-19) — the panel
  could not have anticipated `@endo/zip`'s new extensionless aliases nor the newly
  introduced `@endo/bytes`. "use exo-strram" names a package absent from the
  workspace (a speculative nudge).

Recorded the miss (`review-misses/misses/endojs-endo-but-for-bots-pr160-review-9858a782.md`),
minting `style-convention` cluster **`endo-errors-over-raw-throw`** (shape mirrors
`named-imports-over-namespace`: a genuine Endo house convention the garden has not
yet encoded).

**Threshold: HOLD (no dispatch).** Cluster is count=1 across one PR {160} — below
the K≥3 / ≥2-PR floor. The severity bypass does not apply: it requires a single
`severity: major` miss whose grounds cite a *standing written rule that already
existed and did not bind*, but the `@endo/errors` convention is written in no
garden seat brief, skill, or gate (and severity here is minor), so there is no
pre-existing rule that failed. Await a second distinct-PR instance before spending
the builder tier. The cluster stays `open`.

Self-improvement: nothing this time.
