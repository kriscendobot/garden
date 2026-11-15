---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-11-15T20:37:11Z
---
# Dependabotany — endojs/endo-but-for-bots PR #1663 — MERGE-NOW (pending CI; held on #1659)

project: endo-but-for-bots

`actions/setup-java` v6.1.0 → v6.2.0 (github-actions; single site `.github/workflows/floot-android.yml:31`). Pins verified tag→commit (v6.1.0=b843ebf9, v6.2.0=77dd5b2c). Source read: opt-in `mvn-mirrors` input, Corretto-only first-party fetches (unused; workflow uses temurin), bundled npm refresh incl. undici 6.29.1.

Maturity floor: freshest moved = setup-java v6.2.0 published 2026-11-04T22:12:26Z → floor 2026-11-11T22:12Z (passed). Advisories: none.

Verdict **MERGE-NOW**, NOT yet executed: the only red is `zizmor` ref-version-mismatch on `peter-evans/create-pull-request # v8` at update-action-pins{,-major}.yml:49 — base-wide floating-tag drift; fix is PR #1659. Non-terminal row: conduct with `ci-wait-merge.sh --dependabot-auto-merge` once #1659 lands and the head is green. Recheck parked as plan job `endojs-endo-but-for-bots-pr1663-dependabot-after-pr1659` (blocked_on #1659); daily backstop `dependabotany-recheck-endo-but-for-bots` exists.
Verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1663#issuecomment-6900965224
