---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-26T10:22:55Z
---
# Dependabotany — endo-but-for-bots daily recheck 2026-10-26: #1553 and #1555 stay EMBARGO (CI infra)

project: endo-but-for-bots

Full scan: journal HEAD had moved past the snapshot. The snapshot's `1546` row was a misparse. #1546 is the kriscendobot `tred` CI-fix PR, not a Dependabot row.

- **#1553** (`eslint-plugin-jsdoc` 64.5.4 → 65.3.12, head `ba26b747`) and **#1555** (`@earendil-works/pi-tui` 0.87.1 → 1.3.0, head `9ecaa328`): both are still OPEN and MERGEABLE. Both maturity floors passed, and the diligence from the 2026-10-25 rows stands. CI is still red, and only from the Ubuntu 26.04 runner migration. The failing checks are build (`tred`, #1546), sandbox-drivers/cover/test-ubuntu (`packages/sandbox` bwrap, #1542), and browser-tests (#1556). All three fix PRs are still OPEN and unmerged.
- New observation: `test (24.x, macos-15)` also fails in `packages/floot` on **both** PRs. Neither PR touches floot, so this is not attributable to either PR. It is another shared-infra or flake leg to watch.
- These rows are still escalation rows, not maturity rows. They remain EMBARGO pending the CI-infra fixes landing on `llm`. #1555 keeps its one-shot `dependabotany-recheck-endo-but-for-bots-pr1555` (2026-10-27). #1553 rides the daily backstop `dependabotany-recheck-endo-but-for-bots`, which stays installed. Once the infra PRs merge, a recheck should rebase each PR and re-run CI, then conduct via `--dependabot-auto-merge`.
- #1550 is MERGED (separate terminal entry).
