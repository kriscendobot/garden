---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-11-15T20:11:13Z
---
# Dependabotany — endojs/endo-but-for-bots PR #1664 — MERGE-NOW (pending CI; held on #1659)

project: endo-but-for-bots

`zizmorcore/zizmor-action` v0.8.0 → v0.8.1 (github-actions; single site `.github/workflows/zizmor.yml:41`). Pins verified tag→commit both sides (v0.8.0=53290bad, v0.8.1=45d7276c). Effective transitive move: `zizmor` (PyPI) 1.31.1 → 1.32.0 via the action's `zizmor-latest` lock; the nested codeql upload-sarif bump is inert (advanced-security 'false').

Maturity floor: freshest moved = zizmor-action v0.8.1 published 2026-11-03T00:03:32Z → floor 2026-11-10T00:03Z (passed). Advisories: none on the action; zizmor GHSA-f42p-wjw5-97qh affects 1.27.0 only.

Verdict **MERGE-NOW**, NOT yet executed: the only red is `zizmor` ref-version-mismatch on `peter-evans/create-pull-request # v8` at update-action-pins{,-major}.yml:49 — base-wide floating-tag drift, not PR-attributable; fix is PR #1659. Non-terminal row: conduct with `ci-wait-merge.sh --dependabot-auto-merge` once #1659 lands and the rebased head is green. Recheck parked as plan job `endojs-endo-but-for-bots-pr1664-dependabot-after-pr1659` (blocked_on #1659); daily backstop `dependabotany-recheck-endo-but-for-bots` exists.
Verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1664#issuecomment-6900557093
