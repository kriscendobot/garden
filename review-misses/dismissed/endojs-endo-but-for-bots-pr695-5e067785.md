---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr695-5e067785
verdict: not-a-miss
category: new-direction
pr: 695
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/695#issuecomment-5903472512
identity: endojs/endo-but-for-bots#695:comment:5903472512:retro
review_at: 2026-09-30T03:28:13Z
producing_role: designer
severity: minor
grounds: >
  The maintainer's comment (2026-09-30) defers the #695 design until the
  SturdyRef foundation is built. It lays out a nine-layer plan, stated here
  for the first time: a SturdyRef shim with an enliven handler, SES
  permission and propagation, a pass-style kind, marshal encodings, CapTP
  minting, wire transport and construction, OCapN enlivening through the
  nonce locator, daemon SturdyRefs for formulas that are not incarnated, and
  then the Agent API. It asks for a mentat-tier supervisor to present the work
  as a stack. The comment names no defect in the PR's content. It is a
  sequencing and scope decision, so no seat, skill, or standing instruction
  could have anticipated it. Prior retros on #695 (23a03130, review-e6f842ee)
  were also dismissed as new direction, and this comment continues the same
  steering. World check (2026-10-07): the primary posted the mentat
  orchestrator ebfb-sturdyref-layering-supervisor-20260930 and replied on the
  PR (issuecomment-5904073194). The board shows the stack in motion:
  ebfb-sturdyref-layering-20260930 and layer1..layer9 jobs are in tada, and
  their gauntlets are running (layer8 fix-1 is in doin). The deliverable
  exists, and there is no discrepancy.
---

# Dismissal: endo-but-for-bots #695 comment 5903472512 (retro)

kriskowal parked the sturdy-refs agent-surface design PR #695 until the
underlying SturdyRef layers exist. The comment lists nine layers, from the
shim through SES, pass-style, marshal, CapTP, OCapN and the daemon to the Agent
API, and asks for a mentat-tier supervisor to deliver them as a reviewable
stack. This is new direction and sequencing, not a defect the panel missed. The
primary dispatched the supervisor, and the layer1-9 stack is on the board. See
comment_url for the verbatim text.
