The retrospective is complete. Job done.

## Completion report

**Job:** Prosecutor review-retrospective (second loop) on `endojs/endo-but-for-bots` PR #160, review 4730182358 (identity `#160:review:4730182358:retro`).

**Idempotency:** No existing record for `endojs-endo-but-for-bots-pr160-review-9858a782` in `misses/` or `dismissed/` — proceeded.

**Discrimination (grounded in PR review history):** kriskowal's "Refresh" review carried four inline comments on the freshly authored `exo-unzip` package. Judged each against the PR's actual review arc (2026-05-09 panel + later maintainer directives; the code was rewritten in between):
- **One miss** — "Use endo/errors": the module throws raw `new Error(...)` in 13 places where the pervasive Endo house convention is `@endo/errors` (`Fail`/`assert`/`q`). Confirmed established (143 `llm`-branch source files import it) and stable at panel time; the fixer's response was a mechanical rewrite to `throw Fail\`…\``. No garden seat/skill/gate encodes the idiom, so the gauntlet missed it.
- **Three new-direction** (not misses): the extensionless-alias and `@endo/bytes` comments reference capabilities that only appeared during the two-month `llm` evolution between the panel and this review; "use exo-strram" names a package absent from the workspace.

**Recorded:** miss written via `review-miss-record.sh` → `review-misses/misses/endojs-endo-but-for-bots-pr160-review-9858a782.md`, category `style-convention`, minting new cluster **`endo-errors-over-raw-throw`** (count=1, prs={160}, status=open). Shape deliberately mirrors the existing `named-imports-over-namespace` cluster (a real Endo convention the garden hasn't encoded yet).

**Threshold: HELD, no dispatch.** Cluster is count=1 across one PR — below the K≥3 / ≥2-PR floor. Severity bypass does not apply (it requires a standing *written* rule that failed to bind; `@endo/errors` is written in no garden seat/skill/gate, and severity is minor). Rationale recorded in both the miss body and the `result` journal entry (`entries/2026/07/20/192416Z-result-gardener-cfd840.md`).

**Follow-up:** If a second distinct-PR instance of raw-`throw new Error`-over-`@endo/errors` lands, the cluster reaches the floor and should dispatch `review-improve-endo-errors-over-raw-throw` (prevention: a builder/fixer AGENT.md or COMMON.md norm; sensing: a pre-push gate probe detecting `throw new Error` in `@endo/*` package source, plus a stylist/purist seat line).

No new-direction misclassification risk left open; primary feedback loop is unchanged and untouched.
