---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr667-review-20347bb0
verdict: not-a-miss
category: new-direction
pr: 667
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/667#pullrequestreview-4689432512
identity: endojs/endo-but-for-bots#667:review:4689432512
producing_role: gardener (gauntlet/panel)
producing_job: gauntlet-endo-but-for-bots-pull-request-667-genie-stdio-jsonl-rpc-bridge
missed_by: n/a (dismissed)
severity: minor
---

**Verdict: not-a-miss (new direction — architectural package placement).**

PR #667 built a stdio JSONL RPC bridge as `@endo/genie/src/rpc/`. On review the
maintainer asked to refresh the branch and relocate the facilities into
`@endo/agentry` **or** `@endo/agent-tools`. The primary loop honoured it, moving
the framing/protocol/bridge/serve/types/session blocks (with history) into
`@endo/agentry/rpc` and leaving genie with only the spawnable `rpc.js`.

**Grounds (should the review have caught this? No):**

- The ask is an **architectural-home / package-placement** decision — which sibling
  package should own a newly-built transport subsystem — first stated in the
  review. The maintainer's own phrasing offers two candidate destinations
  ("agentry **or** agent-tools"), which signals a steering direction, not a
  bright-line pre-existing rule the panel violated.
- The gauntlet ran a full five-cluster code panel (dispatcher concurrency,
  framing, SES/OCAP/types, packaging/docs, test coverage) with **no must-fix from
  any seat**; CI was 24/24 green. The packaging/docs cluster reviewed export
  surface, package.json, and dependency placement — none of which is wrong for a
  bridge hosted in genie. The seats verified the code was *correct where it sat*,
  which it was.
- No garden review surface encodes the endo repo's internal package topology
  (genie vs agentry vs agent-tools ownership boundaries). Confirmed by search:
  no seat brief, skill, context page, gate, or COMMON.md norm states "transport /
  harness infrastructure belongs in agentry, not genie." The code panel is
  generic across repos; a repo-internal architectural convention the panel does
  not read cannot be a garden review-miss.
- Discriminator rule (skills/review-retrospective/SKILL.md §1): *not a miss* is
  "new direction, taste, a scope change, or a requirement first stated in the
  comment itself." Relocating a subsystem to a sibling package on the maintainer's
  taste is squarely that.

No cluster minted. Dismissal is durable so this comment is never re-litigated.
