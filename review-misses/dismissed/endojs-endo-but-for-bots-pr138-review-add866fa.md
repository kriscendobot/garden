---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr138-review-add866fa
verdict: not-a-miss
category: new-direction
pr: 138
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/138#pullrequestreview-4730180779
identity: endojs/endo-but-for-bots#138:review:4730180779:retro
producing_role: designer
severity: minor
grounds: >
  kriskowal's CHANGES_REQUESTED review 4730180779 on PR #138 is a single declarative
  body directive with zero inline comments. Paraphrased: skip the staged @nets
  migration entirely and cut over directly, because @nets is not widely deployed.
  It lands on the same DESIGN DOCUMENT as the earlier #138 review
  (designs/ocapn-daemon-integration.md), never on application code. This retro judges
  whether the garden REVIEW PROCESS should have anticipated the directive, and
  concludes it could not, on the same two dispositive facts that grounded the prior
  #138 dismissal (review 4680309727 / base 86c2eb0e), drawn from the PR's actual
  board history rather than the comment text.
  First, PR #138 is a DESIGNER output on branch design/ocapn-daemon-integration whose
  body carried a "10 Open Questions" section soliciting the maintainer's architectural
  direction. No gauntlet, panel, build, fix, or clean job exists for #138 anywhere on
  the board (confirmed: the only #138 artifacts are these two review jobs and their
  retros) — only review jobs and their retros. The code gauntlet/panel does not run on
  a pure design-doc PR, and correctly so: its seats (breaker, prover, typist,
  spec-keeper, stylist, packager, migrator, releaser, ...) lens over CODE correctness,
  style, spec, packaging and types. None of them can pre-decide whether the maintainer
  wants a staged deprecation window or a single direct cutover for an internal netlayer
  the maintainer alone knows the deployment footprint of. There is no review surface
  that knew a convention and failed to bind.
  Second — dispositive even had a panel run — the directive is a FIRST-STATED design
  decision resting on a fact only the maintainer holds: that @nets "is not widely
  deployed." A migrator/releaser seat weighs backward-compat obligations from an
  OBSERVABLE install base; it cannot originate the maintainer's private call that this
  particular netlayer has no install base worth a deprecation window. The designer
  correctly surfaced a staged @nets→@transports migration path as the conservative
  default; choosing to collapse it to a direct cutover is the maintainer's design
  authority, exercised in review. The primary loop absorbed it exactly right — it
  revised the doc to a single direct cutover (drop the shadow/route/remove/keys steps,
  the deprecation window, the fallback shim; "endo nets" retired outright), a
  new-direction absorption in a design-doc-only change, not a corrective fix of an
  overlooked defect.
  Structurally and substantively of a piece with the prior #138 (review-86c2eb0e),
  #135 (review-63a86be1) and #124 (review-a736154b) dismissals: a pre-gauntlet,
  maintainer-directed designer PR whose feedback is forward architectural direction
  resting on the maintainer's own design intent. New direction, not a garden
  review-process miss. Recorded as a durable dismissal so the same review is never
  re-litigated. No cluster minted; no improvement dispatched.
---

# Dismissal: endo-but-for-bots #138 review 4730180779 (retro)

kriskowal's CHANGES_REQUESTED review on PR #138 is a single body directive with no
inline comments, on the same DESIGN DOCUMENT as the earlier #138 review
(`designs/ocapn-daemon-integration.md`). Paraphrased: skip the staged `@nets`
migration and cut over directly, since `@nets` is not widely deployed.

Not a garden review-process miss. PR #138 is a **designer** output whose body carried
an explicit "10 Open Questions" section soliciting exactly this kind of direction. No
gauntlet/panel/build/fix job ran on it — the code panel does not (and should not) run
on a pure design doc, since its seats lens over code correctness, style, spec,
packaging and types, none of which can pre-decide whether the maintainer wants a
deprecation window or a direct cutover for an internal netlayer. And the directive
rests on a fact only the maintainer holds — that `@nets` has no install base worth a
staged migration — so even a migrator/releaser seat could not have originated it; those
seats reason from an observable install base, not the maintainer's private deployment
call. The primary loop handled it correctly as new direction: it collapsed the staged
migration to a single direct cutover in the doc and retired `endo nets` outright, an
absorption of forward direction rather than a corrective fix. Directly parallels the
prior #138 (review-86c2eb0e), #135 (review-63a86be1) and #124 (review-a736154b)
dismissals. First-stated forward direction, not a miss. See comment_url for the
verbatim review.
