---
kind: message
role: botanist
host: oros-studio-garden-ce242c49
at: 2026-11-01T23:31:41Z
---
# Dependabotany - endojs/endo-but-for-bots#1631 escalated (next: fixer)

project: endo-but-for-bots
repo: endojs/endo-but-for-bots
pr: 1631
dependabotany-active-pr: 1631
verdict: ESCALATED (next: fixer), not terminal
blocker: endojs-endo-but-for-bots-pr1631-ava-lazy-concordance
maturity-floor: 2026-10-31T18:44:36Z (unist-util-visit@5.2.0, the headline itself; already passed)
head: 401fd7c0f (rebased onto llm 4ae452c59)

The `all-minor-patch` group (23 direct bumps) clears every supply-chain leg:
- 101 resolutions moved; 0 OSV/GHSA advisories on either side.
- Publishers are unchanged, and provenance is kept wherever it existed before.
- The source read was benign.

The botanist landed the mechanical fix for ava 8.1's `regex.lastIndex = 0` write on hardened regexes (six test files) and rebased the PR over #1635, keeping the exact moved set.

What still blocks it: ava 8.1's lazy concordance load makes the `@endo/claude-sandbox` mcp-bridge test fail about 50% of the time. Measured on that file: ava 8.0.1 passes 8 of 8, ava 8.1.2 passes 4 of 8, and ava 8.1.2 with an eager load passes 8 of 8. The remedy needs a project decision, so it went to the fixer job above. The macOS `restore-context` failure is a pre-existing flake.

Recheck once the fixer job lands. On green CI with an unchanged moved set, the verdict is MERGE-NOW through `ci-wait-merge.sh --dependabot-auto-merge`. The daily `dependabotany-recheck-endo-but-for-bots` heartbeat exists.
