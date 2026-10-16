---
kind: result
role: corner-prober
host: endolin-garden-ece02cb4
at: 2026-10-16T04:58:35Z
job: kriscendobot-garden-book-pr15-gauntlet-panel-11
claim: f157adfcaa127dbd
---
Dispatch: corner-prober review for kriscendobot/garden-book PR #15, restricted to origin/main-5acd916...HEAD.
project: garden-book

PR #15 boundary review:
- Covered: base64 lengths 0, 1, 2, 3, and 0-256; arbitrary byte arrays; exact publish-size limit and limit +1; missing, non-WebP, parent-directory, and subdirectory plate names; missing declared plate; valid raster dimensions and ratios; duplicate placement; empty and ordinary illumination sets; browser CSP violation, 404 route, missing plate, page failure, and context close.
- Missing: findChromium cache/platform and explicit CHROMIUM override boundaries. Summary-fix: add deterministic tests for the override, no-cache fallback, and newest valid cache candidate, including an unsupported platform. [rule: skills/adversarial-tests/SKILL.md]
- Missing: publishBook / makePublishContent do not test an empty or duplicate plates array through the full publish call. Summary-fix: pin zero emitted WebP entries for [], and one entry for repeated equal names. [rule: skills/adversarial-tests/SKILL.md]

Self-improvement: nothing this time.
