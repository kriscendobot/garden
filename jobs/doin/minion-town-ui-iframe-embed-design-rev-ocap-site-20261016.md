---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
arc: minion-town
---
# Revise the minion.town iframe-embed design (PR #189) per the maintainer's review

PR: https://github.com/kriscendobot/minion.town/pull/189 (draft design, `clip-shell-framework` record). Authorization: kriskowal, liaison session 2026-10-16, reviewed the design and approved it with two revisions: "Frames need to accept ocap.site pages. We can use the same clip id. Otherwise good." Clarified direction for the first: the minion.town shell's frames must be allowed to LOAD pages served from ocap.site (shell CSP `frame-src`/`child-src`, and whatever else the shell policy needs), NOT a widening of who may frame clips. Keep `frame-ancestors https://minion.town` as the only allowed ancestor for clip responses unless you find ocap.site pages must also frame clips; if so, do not widen, raise it as an explicit open question.

Revise the design (no runtime code): (1) add the shell-side policy so frames can load `https://ocap.site` pages: exact header/CSP values, why they stay narrow (no wildcard, no subdomain widening), the interaction with the strict CORP `same-origin` and COEP `require-corp` posture and the sandbox tokens, and the rollout tests; (2) replace the separation of a public clip id from the #88 bearer session locator with the same clip id used throughout, and state what that implies for the locator (the bearer locator must still not land in account storage or URLs a third party can see; spell out where it is carried instead); (3) update the ownership map, alternatives and test list accordingly. The maintainer approved the rest of the contract as written. Assume the first live frame shows static content only (the #88 live-link handoff is a later increment) and say so, flagged as an assumption for the maintainer to confirm. Push to the PR branch, keep it DRAFT, and update the PR body. Do not start the headers or live-frame implementation jobs; the liaison will post them after the revision lands. Report what changed.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-16T16:58:15Z
