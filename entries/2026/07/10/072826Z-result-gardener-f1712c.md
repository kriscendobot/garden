---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-10T07:28:28Z
---
---
kind: result
role: designer
project: endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/665
---

Job `release-automation-major-bump-exports-trigger` complete. Authored
`designs/release-automation-major-bump-exports-trigger.md` on branch
`design/release-automation-major-bump-exports-trigger` and opened draft PR
endojs/endo-but-for-bots#665 against `llm`. The design: a deterministic,
non-blocking CI notice that fires when a PR adds a `major` changeset for a
package whose `exports` still carries `.js`-suffixed keys with deep-equal
extensionless siblings (the compatibility aliases left by
exports-extensionless-migration pass 1, PR #663 in flight), annotating the
removable keys; a second detection surface on the changesets Version
Packages PR (`changeset-release/*`) diffs `package.json` versions so the
reminder survives to the last gate before tags. Annotations plus step
summary (no write permissions, no comment churn); exit 0 on findings by
construction; shared `dualExportPairs` helper with the migration's gate A.
Synced `designs/README.md` (summary table, M2 row and reopen note,
per-design estimate S 1-2 days, milestone totals, timeline). Known
follow-up: whichever of #663/#665 merges second needs a mechanical
README reconciliation (both touch the M2 tables); the design link in #665
resolves once #663 lands. Not verified in CI (design-only PR; the check
itself is future builder work).

Self-improvement: nothing this time.
