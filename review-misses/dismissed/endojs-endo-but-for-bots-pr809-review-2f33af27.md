---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr809-review-2f33af27
verdict: not-a-miss
category: new-direction
pr: 809
review_at: 2026-07-21T09:54:15Z
repo: endojs/endo-but-for-bots
surface: pr-review-comment
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/809#discussion_r3619637364
identity: endojs/endo-but-for-bots#809:review:4741475567:retro
producing_role: designer
producing_job: design-endo-daemon-store-family-pr809
missed_by: n/a
severity: minor
---

# Dismissal: defer-to-external-prior-art redirect on the SHON key encoding

On the `daemon-persistent-stores` design doc, in the "Expressing keys and
values" section, the maintainer directed **deferring** the shell-friendly
passable key/value encoding portion, noting that this vocabulary is already
specified in external prior-art references on the maintainer's personal site,
and asked that a **scholar** be posted to ingest those references. This
paraphrase omits the untrusted review text; the verbatim comment is at
`comment_url`.

## Grounds

This is new direction, not a review-process miss. The judgment rests on the PR's
own material, not the comment text:

1. **The design already surfaced this honestly.** The SHON entry in the design
   doc explicitly flags SHON as "Not yet vendored in this repo; a dependency
   this vocabulary introduces (see Known Gaps)." The design author did not
   silently assume SHON; they named it as an open, unvendored dependency. There
   is no defect to have caught — the gap was already declared.

2. **The redirect points to knowledge no review surface could hold.** "Defer
   this / it already exists at the maintainer's external specs / post a scholar
   to ingest" is a pointer to prior art living on the maintainer's personal
   website. No juror seat, skill, gate, or standing instruction encodes the
   existence of those external documents; a panel that ran perfectly could not
   have known to prefer them over an in-repo specification. This is the
   maintainer supplying private/external context first stated in the comment
   itself.

3. **"Defer" is a scope-and-sequencing call.** Choosing to postpone the
   key-encoding surface and ingest an existing external spec instead of
   designing one here is a taste/scope decision reserved to the maintainer, not
   a knowable correctness, spec, or convention violation.

## Distinct from the sibling process miss

The sibling retro `endojs-endo-but-for-bots-pr809-review-581b1021` recorded a
genuine `process` miss — the required design-panel gauntlet never ran on this
design PR (cluster `garden-design-pr-gauntlet-bypass`). That miss stands on its
own grounds. It does not convert *this* comment into a miss: even a fully-run
panel could not have anticipated the maintainer's external SHON/YAY prior art or
his decision to defer that surface. The two are independent — one a real
process gap, this one pure new direction.
