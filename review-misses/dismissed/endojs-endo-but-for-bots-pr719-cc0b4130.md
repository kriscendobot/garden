---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr719-cc0b4130
verdict: not-a-miss
category: new-direction
pr: 719
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/719#issuecomment-5337803942
identity: endojs/endo-but-for-bots#719:comment:5337803942:retro
review_at: 2026-08-19T05:11:00Z
producing_role: external-maintainer-ferry
missed_by: none
severity: minor
grounds: >
  A read-only re-fetch confirmed that the maintainer asked for the ferried
  upstream pull request to be linked. The PR history already contained the
  upstream relationship before that request: on 2026-07-25 the maintainer
  posted the canonical upstream URL and head in a top-level mirror comment,
  and subsequent garden comments and completed jobs repeatedly identified
  endojs/endo#3332 as PR #719's upstream mirror. The full gauntlet had also run
  and posted its 12-seat review, but post-ferry relationship metadata is not a
  code-panel concern. More importantly, the standing boatman role and
  pr-handoff verification checklist require exactly one garden-side tagged
  cross-link comment; they do not require adding that link to the source PR
  description. Thus the prescribed review/process check had already been
  satisfied, while the later preference for a second, body-level durable link
  was first stated by this comment. The primary loop's deliverable was
  independently verified in the world: PR #719's current description begins
  with a ferried-upstream reference to endojs/endo#3332, and its follow-up
  comment records the completed edit. This is new presentation direction, not
  a bug, violated standing rule, or missed panel check. No cluster is minted
  and no improvement job is warranted.
---

# Dismissal: endo-but-for-bots #719 comment 5337803942 (retro)

The maintainer requested that the source PR expose its ferried-upstream
relationship more durably. Before that request, the PR timeline already named
the upstream mirror and its head, and later garden work consistently treated
endojs/endo#3332 as the matching upstream PR.

This is not a review-process miss. The standing ferry procedure requires one
tagged garden-side cross-link comment and does not require duplicating the link
in the source PR description; that prescribed surface was already present.
The request therefore introduced a body-level presentation preference rather
than identifying a defect or an existing convention that failed to bind. The
primary loop's actual deliverable now exists: the live PR description starts
with the upstream relationship, with a follow-up comment confirming the edit.
See comment_url for the verbatim request.
