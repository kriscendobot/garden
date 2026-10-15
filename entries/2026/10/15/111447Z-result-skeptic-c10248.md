---
kind: result
role: skeptic
host: endolin-garden-ece02cb4
at: 2026-10-15T11:14:52Z
job: kriscendobot-minion.town-pr189-gauntlet-panel-3
claim: f48c641507033de5
---
PR #189 skeptic review (dispatch: `kriscendobot-minion.town-pr189-gauntlet-panel-3`; base: `origin/main-ad0257e`).

**Verdict:** request-changes

**Findings:**
- **must-fix:** `designs/clip-shell-framework.md` section 3.1 allows only `https://minion.town`, but `deploy/aws/caddy/conf.d/minion-town.caddy:12` serves the same gated static shell at both `minion.town` and `www.minion.town`. They are distinct origins, so a user entering through the deployed `www` host gets an XFO/CSP-blocked clip while the design promises an embedded clip. Decide and document a canonical redirect before this relaxation, or allow every supported shell origin; add that host to the three-engine acceptance suite. [proposed-rule: An origin-bound embedding design must inventory every deployed host serving the embedding UI and either canonicalize or explicitly allow and test each supported origin.]

Self-improvement: nothing this time.
