---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr521-review-27079b07
verdict: not-a-miss
category: new-direction
pr: 521
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/521#pullrequestreview-4698736135
identity: endojs/endo-but-for-bots#521:review:4698736135:retro
producing_role: builder
producing_job: ebfb-build-sturdyrefs-pass-style-ocapn
severity: minor
grounds: >
  The review history shows that this is a request for a new integrated design
  decision, not a panel-detectable breach of an existing requirement. The build
  record for #521 explicitly delivered only the pass-style plus ocapn slice and
  declared marshal encoding, its rank position, and the associated wire work as
  deferred. No gauntlet or panel result exists for #521: it remained draft and
  the earlier primary response subsequently closed it in favor of draft #737.
  The review asks the author to choose a wire prefix and identity representation,
  carry that new wire work through, use the requested public spelling, and make
  the stack holistic. Those choices add scope and select a wire-format policy
  first stated by the reviewer. The primary job correctly provided options and
  awaited the maintainer's selection instead of inventing a policy. Although the
  requested spelling is consistent with nearby names, no reviewed PR history,
  seat brief, gate, or standing instruction is shown to require it for this new
  pass-style category. No existing review-cycle rule bound and failed, so the
  severity bypass does not apply.
---

# Dismissal: endo-but-for-bots #521 review 4698736135

The reviewer requested a coherent wire-format decision and a larger, holistic
change rather than identifying a defect against an already-binding review rule.
The response proposed the bounded options and deferred implementation until the
maintainer selects the policy. This is new direction, not a review-process miss.
See comment_url for the untrusted review text.
