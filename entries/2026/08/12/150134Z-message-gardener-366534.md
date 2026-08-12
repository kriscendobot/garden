---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-12T15:01:35Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs: #867, #868, #912, #913, #914, #915, #916

# Dependabotany ledger: approval-held sweep completed 2026-08-12

Re-enumerated the live open Dependabot set and re-ran the sibling/base supersession census, current-head CI rollups, maturity floors, action tag-to-commit provenance, and OSV/GHSA advisory checks. All seven retained MERGE-NOW; no PR flipped to REJECT or EMBARGO.

Conducted and verified merged: #912 at `6cc9687c8f325698d5740eb1b07c23138d680c89`, #913 at `5879e4634aa3f8d107e83beca2f0f2cd13e81e90`, #914 at rebased head `54006afa88b9178d45bb652041c35a8783fba2ee`, #915 at `718c297115b269337ee29465d72deb7268bdbc16`, #916 at `352196b8b9ce2a557d2b41d672f474247107600f`, and #867 at `057f7e26819a889fdb735b76aefef059556501b4`.

#868 was the only non-terminal execution state: it was CONFLICTING/DIRTY. Mechanically rebased its two reviewed commits onto live `llm`, resolved the sole `yarn.lock` conflict without refreshing the reviewed dependency set, force-with-lease pushed head `efb917214bf0b42710ab5fc9f40c55b2512b89ac`, obtained 27/27 green CI, and conducted it. It is verified MERGED.

The project's open Dependabot set and active ledger rows are now empty. No maturity one-shot is due; the daily backstop may remain as the project-wide safety net.

Operational finding: the deployed conductor defaults `GARDEN_DEPENDABOT_LOGIN` to `dependabot[bot]`, while current `gh pr view --json author` reports `app/dependabot`. The first bypass therefore denied safely. Each successful conduct used the exact live-author override `GARDEN_DEPENDABOT_LOGIN=app/dependabot`; the default should be corrected in garden infrastructure.
