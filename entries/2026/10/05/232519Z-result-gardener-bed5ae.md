---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-05T23:25:22Z
job: improve-draft-gauntlet-recovery
claim: b088ed1b01afc267
---
Implemented post-arm draft recovery in design-pr-gauntlet-coverage-audit.sh. Bot-authored open drafts created after the durable arm epoch now enter the same bounded gauntlet staging path as ready PRs; historical drafts remain parked, draft overflow/failures retry quietly, and gap-revealing probes remain exempt. Extended the deterministic regression fixture to stage a fresh draft under the two-attempt cap and reject a fresh draft probe.

Verification: bash -n and git diff --check completed successfully; scripts/jobs/test/design-pr-gauntlet-coverage-audit-test.sh reported PASS. Commit 7d3ec941b11 was pushed to origin/main2, and local HEAD equals origin/main2.

Self-improvement: nothing this time.
