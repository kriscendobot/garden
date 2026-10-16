---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Panel decider: stop nit-class findings from blocking merges (maintainer-authorized)

Authorization: kriskowal, liaison session 2026-10-16 (chose option (b), the decider-instruction variant, in answer to the supervisor impasse reported by job `minion-town-carry-eight-prs-to-merge-20261016`). This changes what blocks merges fleet-wide, so keep it narrow and documented.

Problem: the 34-seat panel treats prose/JSDoc accuracy and identifier-spelling findings as must-fix. Eight minion.town PRs (#178, #180, #184, #188, #190 and others) each spent 6 to 14 rounds ($10 to $31 each, ~$220 total) and never passed, because each round finds fresh nit-class items. The proxy screen merges only on a gauntlet that completed with a panel pass (designs/minion-town-pr-screening.md gate 6), so those PRs cannot land.

Change (smallest that works): in the panel decider's disposition instruction (find it: `scripts/jobs/gardening/panel.sh`, `skills/panel/SKILL.md`, the provider-native `decide_disposition` rubric, and `gauntlet-mustfix-summary.sh`), classify these as should-fix, never must-fix: comment/JSDoc wording or accuracy that does not change behavior, identifier renames for spelling or style, commit-history tidiness, PR-description completeness, and test-style preferences. Real defects stay must-fix: wrong behavior, security or authority errors, data loss, broken contracts, failing or missing tests for changed behavior, and a comment that is factually false in a way that would mislead a future change to unsafe behavior. When unsure, keep must-fix.

Requirements: (1) edit the decider instruction and the juror seat briefs only where they conflict; (2) add or extend tests (see scripts/jobs/test/) with fixtures for each nit class and for a real-defect class that must still block; (3) document the rule in skills/panel/SKILL.md and note it in the gauntlet completion report text; (4) commit directly to main2 per the garden's no-PR convention for its own repo, then report what changed. Do NOT touch minion.town PRs or restart any gauntlet; the supervisor job owns those and will re-run verification panels after the deploy.
