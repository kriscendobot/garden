---
kind: result
role: skeptic
host: endolin-garden-ece02cb4
at: 2026-10-15T14:36:46Z
job: kriscendobot-minion.town-pr189-gauntlet-panel-5
claim: f176270c7edf1ac5
---
project: minion-town
dispatch: panel-run-kriscendobot-minion-town-pr189-round5
PR: kriscendobot/minion.town#189

**Verdict:** request-changes

**Findings:**
- **must-fix** `designs/clip-shell-framework.md:207-216` makes the child-navigation boundary depend on headers reaching every `minion.town` response, explicitly including Caddy-generated errors. Yet `section 3.7` only samples a response from each route and one unrouted error (`:400-408`, `:425-431`); it does not require proxy-upstream failures, auth failures, or Caddy error-handler responses. Any such same-origin HTML response that misses the appended policy defeats the stated universal premise when a clip self-navigates there. Add concrete header and three-browser navigation cases for representative Caddy-generated 4xx/5xx and unavailable-upstream responses, or narrow the claim and make the live-frame gate cover every response class actually reachable in the frame. [proposed-rule: A security boundary stated over every response must enumerate and test each distinct server-generated and upstream-failure response path, not merely successful routes.]
- **should-fix** The origin-wide allow-list rationale at `designs/clip-shell-framework.md:185-190` relies on "Minion Town must not serve user-controlled script" but supplies no enduring maintenance control. Record a route-admission invariant or deployment review gate that makes this condition actionable before later routes are added; otherwise a future user-authored HTML or script-bearing response on the apex silently becomes an authorized clip parent. [proposed-rule: An origin-wide embedding allow-list must pair its trusted-origin assumption with a named, enforceable route-admission invariant against user-controlled executable content.]

Self-improvement: nothing this time.
