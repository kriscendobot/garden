---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr234-review-dc699b94
verdict: not-a-miss
category: new-direction
pr: 234
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/234#pullrequestreview-4680396595
identity: endojs/endo-but-for-bots#234:review:4680396595:retro
producing_role: none-design-doc-open-question
severity: minor
grounds: >
  kriskowal's review on PR #234 (a "Proposed"-status design doc,
  designs/agent-follow-stream-tool.md) carried a single inline comment
  (paraphrased): a one-line naming decision picking `monitor` as the tool name,
  landing on the `monitorCapability` bullet under the doc's own Open Question #1
  ("Tool-name pick"). This retro judges whether the garden REVIEW PROCESS should
  have anticipated it, and concludes it could not have. The dispositive facts
  from the PR's actual history: (1) the doc itself EXPLICITLY posed this as an
  open question and enumerated candidate names (followStream / subscribeStream /
  monitorCapability) with a tentative recommendation, deliberately deferring the
  final pick to the maintainer — surfacing an open question for maintainer
  resolution is exactly what a "Proposed" design doc is for. (2) The comment is a
  pure naming/taste preference, a requirement first stated in the comment itself;
  no seat brief, skill, or standing convention prescribes which of several
  plausible tool names the maintainer will prefer. (3) The journal shows no build,
  gauntlet, or panel job for this design in jobs/tada/ (only the -review-dc699b94
  routing/response job) — there is no review surface that demonstrably knew a
  rule and failed to bind. A review-cycle check that tried to pre-answer "the
  maintainer will want `monitor`" would be guessing taste, not enforcing a known
  convention. This is new direction (resolving a self-posed open question by
  maintainer choice), not a garden review-process miss. Recorded as a durable
  dismissal so the comment is never re-litigated. No cluster minted; no
  improvement dispatched.
---

# Dismissal: endo-but-for-bots #234 review 4680396595 (retro)

The review on the agent-follow-stream design doc (PR #234, "Proposed" status)
made a single naming decision: call the proposed tool `monitor`. It landed on the
doc's OWN Open Question #1 ("Tool-name pick"), which the doc had deliberately left
open with candidate names and a tentative recommendation. Not a garden
review-process miss: a "Proposed" design doc exists to surface open questions for
maintainer resolution, and picking a tool name from among plausible candidates is
taste — a requirement first stated in the comment, unanticipatable by any seat,
gate, or convention. No panel/gauntlet ever ran on the doc (only the review-response
job exists for #234). Maintainer resolution of a self-posed open question is new
direction, not a miss. See comment_url for the verbatim review.
