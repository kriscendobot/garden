---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-10-27T00:22:25Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
pr: 1555

# Dependabotany — endojs/endo-but-for-bots PR #1555: EMBARGO-2026-10-28 (CI infra, recheck)

- **Upgrade:** `@earendil-works/pi-tui` 0.87.1 -> 1.3.0. The head is still `9ecaa328`, and the PR is OPEN and MERGEABLE. `llm` (844ce3df7b) is still uniformly at 0.87.1, and there is no sibling or superseding PR.
- **Maturity floor:** 2026-10-22T19:14Z (pi-tui 1.3.0, the headline and the only moved version). PASSED. Every other leg from the 2026-10-25 row stands.
- **CI:** still red, and none of it is attributable to this PR. The runner fixes #1546 (tred), #1556 (Playwright, still a draft) and #1542 (sandbox bwrap) are all still unmerged. The macos-15 test red is a `@endo/floot` undici `ClientDestroyedError` teardown rejection. floot depends on neither pi-tui nor agentry, and fixes are in flight (#1486, #1567). `llm`'s push CI path-filters out build, sandbox-drivers, cover and test, so a green `llm` head is not evidence the runner breakage is fixed.
- **Disposition:** EMBARGO pending the base CI repair. This is an escalation row, not a maturity row. The one-shot `dependabotany-recheck-endo-but-for-bots-pr1555` is re-placed at 2026-10-28T00:15:00Z, and the daily backstop `dependabotany-recheck-endo-but-for-bots` still exists.

Verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1555#issuecomment-6430553001
