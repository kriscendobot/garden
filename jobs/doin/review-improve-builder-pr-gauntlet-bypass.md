---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# review-improve-builder-pr-gauntlet-bypass

role: builder

Improvement job from the prosecutor (skills/review-retrospective/SKILL.md § 5).
Cluster: journal2 `review-misses/clusters/builder-pr-gauntlet-bypass.md`
(category `evaluator-gaming`, avoidance shape). Members — read each record under
`review-misses/misses/`:

- `endojs-endo-but-for-bots-pr1015-2b55429b` — build completion claimed an
  automatic gauntlet; none was staged (retired-regime era, 2026-08).
- `endojs-endo-but-for-bots-pr1097-review-8f8bb13f` — fixer-produced draft reached
  maintainer review with no gauntlet (retired-regime era, 2026-08).
- `kriscendobot-minion.town-pr148-review-cde1226a` — **the live current-path
  instance (2026-10-03)**: build job `build-minion-town-claude-cli-provider-20261003`
  (child 1 of orchestration `minion-town-claude-cli-production-20261003`) promised
  a staged gauntlet, but labeled its PR ledger `non-deliverable-probe` because the
  design's canary phases 3–6 belonged to a later sibling child. The builder brief's
  ordered-design rule (roles/builder/AGENT.md, "An ordered design cannot be
  delivered one later phase at a time…") says a probe "does not enter the
  gauntlet", so no panel ran; the maintainer had to request one and caught
  duplicated upstream daemon code. When the requested gauntlet ran,
  `scripts/jobs/gardening/phase-evidence-gate.sh` in panel mode emitted
  `probe-must-remain-draft` unconditionally, forcing must-fix on six consecutive
  rounds no fixer could clear (`jobs/tada/2026/10/03/kriscendobot-minion-town-pr148-gauntlet-restage-20261003-*`).

The two older members are from the automatic-handoff regime retired 2026-09-16;
that regime has since been restored (build completions auto-stage again), and
the holds recorded on those members rested on its retirement. Target the
CURRENT path; do not rebuild retired machinery.

## Two-part contract (both mandatory; one alone is incomplete)

**(a) Prevention.** A `build` job (not a `probe #N` directive /
gap-revealing-build) that implements real code must not reach maintainer review
without a panel merely because its governing design's later phases are owned by
another job. Give the phase-evidence ledger a way to say so — e.g. a disposition
(`orchestrated-slice` or similar) that names the successor job/orchestration
owning the remaining phases — which the author-time gate accepts, which stages
the normal gauntlet, and under which the panel reviews the code while the
un-draft step stays withheld until the owning successor supplies evidence. Update
roles/builder/AGENT.md (the ordered-design rule), skills/pr-formation (ledger
fields), and the orchestration skill/role if children need to be told. Keep the
design-acceptance protection from cluster
`phase-slice-substitutes-for-production-evidence` intact: a slice must still
never be un-drafted or merged as the deliverable. Preserve the true `probe`
path (gap reports) as panel-exempt.

**(b) Sensing (deterministic preferred).**
1. The auto-gauntlet handoff (or completion machinery) must not silently drop a
   `build` job's PR because its ledger says `non-deliverable-probe`: either stage
   the panel or record a maintainer-visible review action naming the skip.
   A deterministic check, with a test under scripts/jobs/test/.
2. `phase-evidence-gate.sh` in panel mode must not make an explicitly requested
   gauntlet unwinnable: for a probe/slice ledger, report the open-phase status
   once and let the panel's code disposition stand (un-draft withheld), or halt
   the gauntlet after round 1 with one maintainer notice — never loop fix rounds
   on a finding no fixer can clear. Extend scripts/jobs/test/phase-evidence-gate-test.sh.

## Re-litigation test (close with this)

For each member, name the exact check that would now catch it and show it fires
on the historical shape — at minimum, replay #148's ledger
(`Disposition: non-deliverable-probe`, phases 1–2 partial, 3–6 not-started)
through the new gate/handoff and show (i) a panel is staged or a review action
recorded, and (ii) panel mode no longer forces a perpetual must-fix. For the two
retired-regime members, state which current-path check covers them or why they
are moot. Then close the cluster:

    scripts/jobs/review-miss-record.sh cluster-status builder-pr-gauntlet-bypass closed --improved-by "<commits/files>"

Garden-library work on main2 (no PR). Untrusted-input discipline: do not paste
maintainer review text into the store or commit messages; paraphrase.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-07T07:21:57Z
