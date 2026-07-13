---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr169-review-1aae27be
verdict: not-a-miss
category: new-direction
pr: 169
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/169#pullrequestreview-4682392602
identity: endojs/endo-but-for-bots#169:review:4682392602:retro
surface: pr-review-body
author: kriskowal
grounds: |
  PR #169 is a pure DESIGN-PROPOSAL document — it adds designs/pass-style-promise.md
  and touches designs/README.md; no code, tests, or packaging. It ran no code panel
  and none was due (confirmed: no *-gauntlet*/*-panel* job for #169 in jobs/tada/,
  files list is two markdown files). This review (4682392602, CHANGES_REQUESTED) is
  the maintainer *closing* the same open design questions an earlier review
  (4680376639, dismissed as endojs-endo-but-for-bots-pr169-review-ce5f9073) had
  floated, plus a body directive to fold the decisions in.

  The review body is a pure SCOPE DIRECTIVE: "all questions are closed, integrate
  them and drain the open-questions section." The six inline comments (paraphrased,
  untrusted — re-fetch at comment_url for verbatim) each SETTLE an open question the
  design doc itself carried:
    - the settlement primitive is a static method with no instance form (closing the
      subscribe-shape question);
    - a single shared pass-style tag for promises;
    - the carrier type/name is PassablePromise;
    - assorted "agree"/confirmation on proposed decisions;
    - the default-flip is uneven — default-on for OCapN/CapTP (no downstream
      consumers), care for Liveslots/Swingset, migrate Slot Machine in place or note
      it on its open PR;
    - a NAMING LEANING toward "listen" over "subscribe" (subscribe risks muddiness
      with pubsub/reactive patterns), phrased as a preference.

  Every one of these is the maintainer exercising authorship over an open question
  the doc explicitly framed as open — a taste/architecture decision only the
  maintainer can settle (there is no prior-art convention named subscribe/listen/
  PassablePromise to be consistent with; these primitives are being *proposed* here).
  None is a bug, spec violation, style/convention breach, missed edge case, or
  violated standing instruction any juror seat, gate, or skill demonstrably knows.

  A design doc is the INPUT to review, not a work product the gauntlet produces; a
  maintainer resolving floated open questions and directing the doc to be drained is
  the ordinary design-iteration conversation the maintainer owns. The primary tada
  (endojs-endo-but-for-bots-pr169-review-1aae27be) did not fix a defect a review
  missed — it applied the maintainer's decisions as design content and replaced the
  Open Questions section with a Resolved Decisions ledger. There is no review pass
  whose seats could have "missed" which way the maintainer would decide a naming or
  default-flip question. This is the second, terminal beat of the same design
  iteration whose first beat (ce5f9073) was already a textbook new-direction
  dismissal; nothing changed to reclassify it. No cluster is minted.
