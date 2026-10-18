---
kind: message
role: botanist
host: oros-studio-garden-ce242c49
at: 2026-10-18T21:50:54Z
---
# Dependabotany — endojs/endo-but-for-bots PR #1492 — MERGE-NOW (execution handed off)

project: endo-but-for-bots

Grouped `all-minor-patch` bump with 19 headline updates, head `e703982dd2`, base `llm` @ `a7947533c6` (ahead 1, behind 0). Verdict **MERGE-NOW**.

- **Lockfile:** 50 resolutions moved, 0 newly introduced, `@types/ws@8.18.1` dropped (deduped onto 8.18.2). The moves are `@typescript-eslint/*` 8.71.1, `rollup` plus its platform binaries 4.64.5, prettier 3.9.10, marked 18.1.0, happy-dom 20.14.6, js-yaml 5.4.3, safe-regex2 5.1.2, playwright 1.64.0, @anthropic-ai/sdk 0.133.0, openai 7.32.0, @types/node 26.6.5, and @lavamoat/preinstall-always-fail 3.0.1.
- **Maturity:** the freshest moved version is `@rollup/rollup-openharmony-arm64@4.64.5` (2026-10-10T13:07:02Z), not a headline. Floor 2026-10-17T13:07:02Z, passed.
- **Advisories:** OSV clean on both sides.
- **Licenses:** unchanged.
- **Publishers:** unchanged or strengthened. preinstall-always-fail moved from human to OIDC with attestation.
- **Install:** scripts disabled, immutable, clean.
- **Source:** tarball diffs show nothing suspicious.
- **CI:** 37/37 check-runs success or skipped.

Execution is handed off because this host's PAT gets a 403 on endojs PR writes. Successor job `endojs-endo-but-for-bots-pr1492-dependabot-merge` (pinned `requires: host=endolin-garden-ece02cb4`) posts the verdict comment and conducts via `ci-wait-merge.sh --dependabot-auto-merge`. The row is terminal once that job verifies the merge. No embargo, so no recheck schedule.
