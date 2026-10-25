---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-10-25T21:03:05Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
pr: 1555

# Dependabotany — endojs/endo-but-for-bots PR #1555: EMBARGO-2026-10-27 (CI infra)

**Upgrade:** `@earendil-works/pi-tui` 0.87.1 -> 1.3.0 (npm, major), direct dep of `packages/agentry`. Base `llm` uniformly at 0.87.1; head ahead=1 behind=0; no sibling PR.

- **Transitive set:** only pi-tui 1.3.0 moved (new lock entry); its deps get-east-asian-width 1.6.0 / marked 18.0.11 are identical exact pins already in the lockfile. MIT both sides. 0.87.1 copy stays (pi-coding-agent@0.87.1 pins it) — dual pi-tui copy; structural Component interface unchanged, so benign. Follow-up suggestion: bump the pi family in lockstep / dependabot group.
- **Maturity floor:** 1.3.0 published 2026-10-15T19:14:02Z (the headline is the only moved version) -> floor 2026-10-22T19:14Z, PASSED.
- **Publisher:** GitHub Actions OIDC trusted publisher (same oidcConfigId) + SLSA v1 provenance on both 0.87.1 and 1.3.0.
- **Advisories:** OSV empty for pi-tui 0.87.1/1.3.0, get-east-asian-width 1.6.0, marked 18.0.11; GHSA none for pi-tui; marked GHSA-6v9c-7cg6-27q7 (18.0.0–18.0.1) does not cover 18.0.11. Not CVE-repairing.
- **Source read:** no install scripts/bin; new files colors/oklab/program-status/wheel-scroll have no network/spawn/eval/fs-write; Container/truncateToWidth unchanged, Text adds setPaddingX + flattenLines. No upstream prose read (no Jev classification needed).
- **Install/tests:** scripts-disabled WARM-CACHE install; agentry endo-code-mode-pi-extension.test.js 52/52; full agentry suite 1 local failure in eval/conflict-rebase (git fixture, no pi import — local env).
- **CI:** red only from Ubuntu 26.04 runner migration — tred missing (#1546), Playwright chromium unsupported (#1556), bwrap ulimit -u / parent-death in packages/sandbox -> sandbox-drivers + cover (#1542). Not PR-attributable; affects every dependabot PR opened 2026-10-25.
- **Disposition:** EMBARGO pending base CI repair. One-shot `dependabotany-recheck-endo-but-for-bots-pr1555` at 2026-10-27T00:15:00Z; daily backstop `dependabotany-recheck-endo-but-for-bots` exists. Recheck: if the runner fixes landed, conduct with `ci-wait-merge.sh --dependabot-auto-merge`.

Verdict comments: https://github.com/endojs/endo-but-for-bots/pull/1555#issuecomment-6402599236 (MERGE-NOW conditional on CI, now replaced) and the EMBARGO update after it.
