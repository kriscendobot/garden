---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr288-e950e913
verdict: not-a-miss
category: new-direction
pr: 288
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/288#issuecomment-4932257960
identity: endojs/endo-but-for-bots#288:comment:4932257960:retro
producing_role: none-garden-did-not-gauntlet-review-the-package
severity: minor
grounds: >
  kriskowal's directive-attention comment on the @endo/cbor-frame PR is a pure
  maintainer PROCESS directive (paraphrased): "dispatch a fixer to address the
  feedback at comment 4886909660 and revisit prior maintainer feedback in light
  of the recommended changes." It surfaces NO new technical finding of the
  maintainer's own. The feedback it points at (comment 4886909660) is the
  garden's OWN Fable closer-review (job ebfb-pr288-fable-review, author
  kriscendobot) — the very second-pass the maintainer's earlier review requested
  — which itself FOUND the substantive defect: a quadratic re-materialization in
  decode.js (the reader re-ran materialize() over the whole carry on every
  arriving chunk, O(N*k) copying for an N-byte frame in k chunks) and specced
  the O(N) head-cache fix. So the review process WORKED: when a closer look was
  asked for, the garden's review layer produced the finding; the maintainer is
  now directing the fleet to ACT on that already-found finding, not catching
  something the panel missed. Recording a miss here would perversely blame the
  review process for a defect its own review produced and is now fixing (the
  primary fixer endojs-endo-but-for-bots-pr288-e950e913 applied the spec:
  33/33 tests, commits 2294acf1a + 293a71015). The dispositive structural fact
  is unchanged from the prior 330391eb dismissal on this same PR: the garden
  fleet NEVER authored via the gauntlet nor panel-reviewed @endo/cbor-frame — the
  board holds only branch-ops and routing jobs for #288 (-refresh, -shepherd,
  the -review-330391eb routing job, this -e950e913 fixer) plus the Fable pass; no
  build / gauntlet / panel / clean / judge job exists for the package. With no
  garden panel ever run, no seat "demonstrably knew a convention and failed to
  bind," so there is no review surface to indict — and a process miss ("a PR that
  never ran a panel when the gauntlet should have run one") does not fit either,
  because this package entered as a maintainer/bot-originated PR outside the
  liaison-posted "run the gauntlet" flow; nobody dispatched a gauntlet for it to
  have skipped. Unanticipatable maintainer process directive over
  externally-originated work whose defect the garden's own review already caught:
  new direction, not a garden review-process miss. Recorded as a durable
  dismissal so this comment is never re-litigated. No cluster minted; no
  improvement dispatched.
---

# Dismissal: endo-but-for-bots #288 comment 4932257960 (retro)

The directive-attention comment asks a fixer to apply the Fable closer-review's
recommendations (comment 4886909660) and revisit prior maintainer feedback. It is
a maintainer process directive that surfaces no new defect of its own. The defect
in view — a quadratic re-materialization in the cbor-frame reader's decode loop —
was found and specced by the garden's OWN Fable closer-review (the second pass the
maintainer's earlier review requested), and the primary fixer
`endojs-endo-but-for-bots-pr288-e950e913` applied the O(N) head-cache fix. The
review process caught it; the maintainer merely directed the fleet to act on the
already-found finding. As in the prior 330391eb dismissal on this same PR, the
garden never ran a gauntlet or panel on this externally-originated package, so no
seat knew a convention and failed to bind — there is no review surface to indict.
New direction, not a garden review-process miss. See comment_url for the verbatim
text.
