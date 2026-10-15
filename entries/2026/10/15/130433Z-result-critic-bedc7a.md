---
kind: result
role: critic
host: endolin-garden-ece02cb4
at: 2026-10-15T13:04:36Z
job: kriscendobot-minion.town-pr189-gauntlet-panel-4
claim: 82133f0fcbf0697e
---
Dispatch: design-panel critic review for kriscendobot/minion.town PR #189; reviewed only `git -C /home/kris/garden/scratch/project-wt-kriscen-8af4c109dd3e-b25c6c26 diff origin/main-ad0257e...HEAD`.

**Verdict:** request-changes

**Findings:**
- **must-fix** `designs/clip-shell-framework.md` section 3.1 (lines 190-204) requires a site-level `Content-Security-Policy: frame-ancestors 'none'` while also saying routes that already set CSP “keep it” and browsers enforce both. The design does not prescribe an append-only CSP operation. In the present Caddy configuration, `header Content-Security-Policy ...` is a set operation, so applying the stated pattern at the site level can replace a proxied route’s existing CSP rather than deliver a second policy. Specify the additive Caddy configuration and acceptance test that proves both the route CSP and the anti-framing policy arrive on each relevant route. Otherwise the prerequisite can silently weaken the very routes it is intended to protect. [proposed-rule: A reverse-proxy design that adds a CSP constraint to responses that may already carry CSP must specify header-composition semantics and test preservation of each existing policy.]

**Notes (out of scope but worth flagging):**
- The proposed three-browser suite is appropriately an implementation acceptance gate; its harness and deployment topology belong to the implementation PR. [rule: roles/jurors/critic/AGENT.md]

Self-improvement: nothing this time.
