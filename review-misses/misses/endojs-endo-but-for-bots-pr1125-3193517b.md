---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1125-3193517b
verdict: miss
category: correctness-bug
pr: 1125
cluster: vestigial-mechanism-unquestioned
cluster_pattern: A PR extends or polishes an internal mechanism (a minted object, pin, retention edge) whose consumer an earlier refactor removed or whose job an existing mechanism already does, and review hardens the mechanism instead of asking what still consumes it.
review_at: 2026-09-15T20:58:13Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1125#discussion_r4020152492
identity: endojs/endo-but-for-bots#1125:comment:4020152492:retro
producing_role: builder
producing_job: endojs-endo-but-for-bots-pr1125-retention-pin-adversarial-5201186153
missed_by: breaker/saboteur (code panel, 6 rounds); the mentat adversarial-review job retention-pin-adversarial-5201186153
severity: minor
grounds: |
  Paraphrase: replying in the retention-pin thread, the maintainer said he was
  still confused, because invite already takes a result name that retains the
  invitation while it is pending and replaces itself with the acceptor's handle
  on accept. He was implying that the extra guest pin is redundant.
  The world confirms a real defect, not new direction. The primary job
  (tada 2026-09-15) traced it: on accept, the code minted a separate local
  guest and pinned it under @pins/guest-*. That guest was needed only for
  synchronized pet stores, which commit d0ce26b327 ("migrate to SQLite, remove
  LOCAL_NODE and synced pet stores") removed. Nothing named or exported the
  guest after that, so each accept pinned an otherwise-unreachable formula chain.
  The fix (546dc5dbdb, "use invitation result names as connection roots")
  removed the mint and the pin. I verified that llm's manager.js no longer has
  guestPinName after the split stack #1304/#1306/#1305 merged.
  The review should have caught this. #1125 did not create the pin, which
  already existed on llm as guest-<leaf>. But #1125 elaborated it: it added a
  length-prefixed injective path encoding in response to seat findings. Six
  panel rounds hardened the key's collision properties and never asked what
  consumes the retained guest. Worse, the maintainer explicitly requested a
  mentat adversarial review of "why this pin needs to exist". That review
  concluded "the pin must exist". It reasoned about retention of the local guest
  without asking whether that guest had any remaining consumer, so the gauntlet
  AND a targeted adversarial pass defended dead residue. Not evaluator-gaming:
  no measurement moved. No existing standing rule binds "ask what consumes a
  mechanism before hardening it". COMMON.md's pre-existing-equivalent-surface
  rule covers only public surfaces. So the severity bypass does not apply.
---

The maintainer asked why a retention pin existed, received a confident
justification, and then pointed out that the invitation's result name already
provides that lifecycle. The primary confirmed that the pinned guest was left
over from a removed synchronized-pet-store design and deleted it. The code panel
and a dedicated adversarial review polished and defended the mechanism instead
of tracing its consumers. Minting a new cluster.
