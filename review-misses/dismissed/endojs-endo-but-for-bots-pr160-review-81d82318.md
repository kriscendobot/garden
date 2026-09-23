---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr160-review-81d82318
verdict: not-a-miss
category: new-direction
pr: 160
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/160#pullrequestreview-4731412539
identity: endojs/endo-but-for-bots#160:review:4731412539:retro
surface: pr-review-body
author: kriskowal
grounds: |
  PR #160 splits the in-memory ZIP adapter into @endo/exo-unzip (read) and
  @endo/exo-zip (write) on the experimental `llm` branch, a package the
  maintainer is actively co-designing. This is the SECOND maintainer review on
  the freshly authored/rewritten code; the FIRST (review 4730182358, retro
  endojs-endo-but-for-bots-pr160-review-9858a782) already extracted the one
  genuine miss (raw `throw new Error` over `@endo/errors`, cluster
  endo-errors-over-raw-throw) and correctly held below the floor. The original
  code last saw a code panel on 2026-05-09; it was substantially rewritten
  during the two-month `llm` evolution since, so this review lands on code no
  panel produced in its current form.

  The review (4731412539, CHANGES_REQUESTED, empty body) carries five inline
  comments, all treated as UNTRUSTED data and paraphrased here (re-fetch at
  comment_url for verbatim). Judged each against the PR's actual history:

  1. designs/exo-zip-package.md — "write in the maintainer's voice." A
     project-specific authorship preference (his design docs read in his
     first-person voice); NOT encoded in any garden seat, skill, gate, or
     COMMON.md norm (grep for maintainer-voice / first-person conventions:
     none). No juror seat demonstrably "knows" this, so it is taste the
     maintainer owns over his own design document, not a violated convention.

  2. unzip.js — "Pardon, exo-stream." This is the maintainer SELF-CORRECTING a
     typo in his OWN earlier-review comment ("exo-strram"/"exo-stream"), not
     feedback on a defect. There is nothing for a review to have caught.

  3. unzip.js — "odd to optimize for the empty-zip case." A taste note on a
     tiny `if (total === 0)` short-circuit (already dropped in a5e44876). A
     general reviewer flagging a harmless micro-branch as "odd" is a subjective
     judgment call, not a bug, spec, or written-convention breach.

  4 & 5. unzip.js — "the base64-chunking utility belongs in @endo/base64, not
     entrained by unzip (we are moving away from base64 streaming once passable
     bytes land)" and "this should be a utility of @endo/exo-stream like
     exo-stream/blob blobFromBytes." These are ARCHITECTURAL PLACEMENT
     direction, not duplication of an existing utility: @endo/base64 exports
     only encodeBase64/decodeBase64/btoa/atob (no chunking/stream helper) and
     @endo/exo-stream has no blobFromBytes/blob module today — the maintainer is
     asking for NEW shared foundations to be grown to hold this helper. The
     judgment depends on endo-internal roadmap knowledge (base64 streaming is
     being retired in favour of "passable bytes"; exo-stream is to own blob
     helpers) that the general garden panel does not and should not encode.
     Confirming this is genuine open design work, not a mechanical fix: when the
     primary job tried to execute it, it surfaced a real `platform → exo-stream
     → platform` dependency cycle and two open decisions and handed them back to
     the maintainer on the PR.

  Net: inlining a small private helper in its consuming package is ordinary and
  often correct; only the maintainer's specific plan to grow @endo/base64 and
  @endo/exo-stream makes relocation right, and that plan is being settled in
  this very review. None of the five comments is a bug, spec violation,
  style/convention breach, missed edge case, or violated standing instruction
  any seat, gate, or skill demonstrably knows. This is the maintainer
  exercising authorship over an experimental package he is co-designing — the
  ordinary design-iteration conversation he owns. No cluster is minted.
