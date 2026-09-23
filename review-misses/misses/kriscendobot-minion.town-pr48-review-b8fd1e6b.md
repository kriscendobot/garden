---
kind: review-miss
primary_job: kriscendobot-minion.town-pr48-review-b8fd1e6b
verdict: miss
category: process
pr: 48
cluster: stale-related-design-direction
cluster_pattern: A build and its code panels continue toward merge after a related design PR already carries maintainer direction that invalidates the implementation seam, so the maintainer must stop and reconstruct the work.
review_at: 2026-08-19T04:46:22Z
repo: kriscendobot/minion.town
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/kriscendobot/minion.town/pull/48#pullrequestreview-4968492528
identity: kriscendobot/minion.town#48:review:4968492528:retro
producing_role: builder
producing_job: build-minion-town-git-content-substrate
missed_by: design-dependency preparation and integrator seat across four code-panel rounds
severity: major
grounds: |
  This is a review-process miss, not direction first stated on PR 48. The
  maintainer's changes-requested review on related PR 47 was submitted at
  2026-08-17T23:22:53Z, before PR 48's first commit at
  2026-08-18T00:38:55Z and before every recorded panel round. That earlier
  review replaced the weblet publication model with a guest-held @sites power
  registering and watching a front/back directory. PR 48 nevertheless built
  and repeatedly refined a separate projection, mutable-record advance, and
  content-serving seam, then reached the maintainer after four must-fix panel
  rounds. The maintainer consequently closed it for reconstruction behind PR
  47; the PR is now closed and the primary directive deliverable exists.

  Two standing review mechanisms already covered this situation and did not
  bind. skills/design-dependency-walk/SKILL.md calls itself the preparation
  step of a build job and requires classification of open related design PRs.
  roles/jurors/integrator/AGENT.md requires coherence with the roadmap and
  dependency graph, and gives as a recurring finding that a PR should return
  to draft until a prerequisite concept advances. The build report instead
  asserted that its slice was independent of the adjacent changes-requested
  design without reconciling the current review on PR 47. Four code panels,
  including the integrator lens, then concentrated on local implementation
  defects and never re-fetched that dependency direction.

  Severity is major because the missed standing rules allowed a whole
  implementation to proceed on an invalidated seam, consuming a clean stage,
  four panel rounds, and four fix rounds before the maintainer stopped it.
  This mints stale-related-design-direction. The single-major severity bypass
  applies because both the dependency-walk procedure and integrator seat line
  existed before the review and failed to bind. Dispatch one improvement job
  that prevents a build or panel from proceeding on stale related-design state
  and adds a durable review-cycle check, with PR 48 as the re-litigation case.
---

# Miss: PR 48 proceeded after PR 47 invalidated its implementation seam

The maintainer directed that PR 48 be closed and reconstructed after the related
design work on PR 47. This is a bot-authored paraphrase. The original untrusted
review text remains available only at `comment_url`.

## Threshold call

Dispatch under the single-major standing-rule bypass. The dependency-walk
preparation rule and integrator review lens existed before PR 48's build and all
four panels, but neither reconciled the already-posted direction on PR 47.

Self-improvement: nothing this time.
