---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr708-review-ecdedc30
verdict: not-a-miss
category: new-direction
pr: 708
repo: endojs/endo-but-for-bots
surface: pr-review-comment
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/708#discussion_r3599659687
identity: endojs/endo-but-for-bots#708:review:4704991767:retro
producing_role: builder
producing_job: build-endo-but-for-bots-endo-fs-from-git-wrap-backend-oid-qid-and-git-hash-hook
missed_by: n/a (new direction — no seat or standing rule covers it)
severity: minor
---

# Dismissal: PR #708 — "cite the prior art for the term QID"

On `designs/endo-fs-from-git.md`, the maintainer asked (verbatim untrusted text
at `comment_url`, paraphrased) that the design cite the prior art for the term
**QID**, which the design borrows to name a filesystem node's content-addressed
identity. The primary loop resolved it cooperatively by adding a Plan 9 **Qid**
prior-art citation (commit `9252e5bf8`); no code changed.

## Grounds (not a miss — new direction)

This is a scholarly attribution/enrichment request, first stated in the comment,
not a violated convention the review demonstrably knows.

- **No standing rule to bind to.** A grep of `roles/` and `skills/` finds no
  instruction — seat brief, skill, or COMMON.md norm — that a borrowed term of
  art in a design document must carry a prior-art citation. The docs-facing juror
  seats cover adjacent-but-different concerns: the archivist checks that
  cross-document references resolve and that API prose lives in JSDoc; the
  copyeditor and novice flag jargon-before-use and mental-model gaps (a term used
  before it is introduced). None demands *provenance/attribution of a term that is
  itself the vocabulary being introduced*. The scholar's provenance discipline is
  scoped to the garden's own `library/` ingestion, not to terminology inside an
  endo design doc.

- **The review did run, and had nothing to bind here.** A full gauntlet ran on
  #708 (`gauntlet-...-708-git-filesystemat-content-address`): a 19-seat code panel,
  verdict PASS after one fixer round, then un-drafted CLEAN with 23 green checks.
  The fixer round even edited `designs/endo-fs-from-git.md` for unrelated defects
  (stale adapter path, Phase 5/6 labeling, the OID-vs-uint64 fold note). Docs were
  actively reviewed; a "cite the origin of the word QID" expectation simply was not
  among the seats' checks because no such check exists.

- **Fresh editorial preference, not a caught-elsewhere pattern.** The maintainer
  values provenance broadly, but requiring a specific Plan 9 Qid citation for the
  term as used here is a judgment call surfaced for the first time in this comment.
  The store holds no prior "cite prior art for a term" record; this is a singleton
  editorial nicety, exactly the new-direction shape the taxonomy dismisses. A
  panel probe that demanded citations for borrowed vocabulary would be an
  un-mechanizable taste gate (which term counts as "borrowed"? which needs a
  citation?), the same reason the mhofman deeper-docs/naming reviews were
  dismissed.

No cluster is minted; no threshold evaluation applies to a dismissal.
