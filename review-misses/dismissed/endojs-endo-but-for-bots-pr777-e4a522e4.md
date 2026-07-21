---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr777-e4a522e4
verdict: not-a-miss
category: new-direction
pr: 777
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/777#issuecomment-5030379295
identity: endojs/endo-but-for-bots#777:comment:5030379295:retro
producing_role: none-maintainer-forward-directive
severity: minor
grounds: >
  kriskowal (the repo owner and maintainer) left a directive comment
  (5030379295) on PR #777 asking the garden to "add a lane for
  ocapn-cbor-quic-iroh on minion.town for validation," stating an expectation
  that iroh will either produce redundant cryptography or fail to participate in
  the noise-protocol network, and a wish to make progress on both and
  consolidate the best of both. This retro judges whether the garden REVIEW
  PROCESS should have anticipated this and concludes it could not have, for a
  dispositive structural reason: the comment indicts no work product at all. It
  is a FORWARD DIRECTIVE — an instruction to stand up net-new validation work on
  a different repo (minion.town) to test a research hypothesis — not feedback on
  a defect in PR #777's diff. PR #777 (@endo/ocapn-iroh, an iroh 1.0 QUIC OCapN
  netlayer) was contributor/maintainer-authored, not fleet-built: the journal
  holds no gauntlet/panel job for it (only this attention-directive primary and
  two deadmails), so there is no garden review pass that could have "missed"
  anything. And even if a panel had reviewed the netlayer code, nothing in a
  correctness/style/spec/edge-case lens surfaces "the maintainer will later want
  a validation lane on a sibling deployment repo to compare crypto stacks" —
  that is a scope-defining research request first stated in the comment itself.
  This is the same class as the standing maintainer-process/directive dismissals
  (#123 "rebase, retcon, and conduct"; #604 "please review"; #631 answering a
  surfaced question): a maintainer PROCESS/DIRECTION message, not a review
  critique. The PR history confirms the garden handled the directive correctly —
  the primary job (pr777-e4a522e4) routed it by opening kriscendobot/minion.town#12
  with a design doc for the validation lane, posting a routing reply, and
  messaging the maintainer with the blocking gates. A "please add a validation
  lane" directive is unanticipatable by any review surface — new direction, not
  a garden review-process miss. Recorded as a durable dismissal so the same
  comment is never re-litigated. No cluster minted; no improvement dispatched.
---

# Dismissal: endo-but-for-bots #777 comment 5030379295 (retro)

kriskowal (the repo owner) left a forward directive on PR #777 asking the garden
to add an `ocapn-cbor-quic-iroh` validation lane on minion.town, stating a
hypothesis that iroh would either duplicate cryptography or be unable to join the
noise-protocol network, and a wish to consolidate the best of both.

Not a garden review-process miss. The comment indicts no work product — it is an
instruction to stand up net-new validation work on a sibling repo to test a
research hypothesis, not feedback on a defect in PR #777's diff. The PR was
contributor-authored (no gauntlet/panel job exists for it in the journal), so
there was no garden review pass to miss anything; and no correctness/style/spec/
edge-case lens could have anticipated a request to build a comparison lane on a
different deployment repo — that scope is first stated in the comment itself.
Same class as the maintainer-process/directive dismissals (#123, #604, #631). The
PR history confirms the garden acted correctly: the primary job routed the
directive by opening kriscendobot/minion.town#12 with a validation-lane design
doc and messaging the maintainer. A forward "please add a validation lane"
directive is unanticipatable by any review surface — new direction. See
comment_url for the verbatim comment.
