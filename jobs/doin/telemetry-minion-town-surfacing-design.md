---
role: designer
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-11T18:31:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: the garden itself (this repo, `main2` branch)
role: designer

Garden-infra design edit, not a fork/PR design: land the edit straight onto
`main2` from an isolated per-job worktree off `origin/main2`
(`roles/COMMON.md` § the one correct shape for a garden-infra job) — no
branch, no PR (garden's own repo takes no PR workflow).

## Task

Amend `designs/fleet-telemetry-and-anomaly-response.md` § Surfacing (and the
Phase 2 line in § Build phasing that names the bulletin panel) with the
maintainer's redirected surfacing decision (2026-08-11):

- The Vitals view should be surfaced through a **minion.town weblet**, not
  (only) the existing GitHub Pages bulletin panel the design currently
  proposes. The maintainer's stated reason is explicit and belongs in the
  document's rationale, not just this job body: building a real weblet that
  consumes garden telemetry **gives the minion.town weblet-gateway system
  exercise and motivates its own improvements** — the choice of frontend is
  deliberately also a forcing function for that system's maturity, not purely
  a UI preference.
- Leave the existing GitHub Pages bulletin panel proposal in place as a
  fallback/interim note rather than deleting it outright — the minion.town
  weblet is the new primary target, but say plainly whether the design still
  considers the Pages panel a live alternative or now-superseded, and why.
- Record, as an explicit **forward-looking, out-of-scope-for-now** item: the
  maintainer additionally wants the garden's *entire* existing GitHub-Pages
  bulletin (not just the Vitals panel) eventually migrated to minion.town,
  "in due course." This document should note that direction so its surfacing
  design does not foreclose it, without designing or building it now.
- Two companion minion.town-side design jobs are running alongside this one
  (same orchestration): `minion-town-git-content-substrate-design` (a
  general capability letting a weblet source its content from a git
  branch — the garden's public `journal2` in this case — instead of only the
  existing tarball/S3/SSM deploy pipeline) and `minion-town-vitals-weblet-design`
  (the concrete vitals weblet built on that substrate, consuming this
  document's `vitals/fleet.json` shape). Reference them by name/basename;
  their PR numbers won't exist yet when this job runs first in the
  orchestration, so cite them descriptively rather than leave a dangling
  link.

Do not change the vitals schema, the derivation/collection design, the
response ladder, or anything else in the document — this is a surfacing-target
edit plus the recorded future direction, nothing else.

## Deliverable

The amended `designs/fleet-telemetry-and-anomaly-response.md` committed
directly to `main2`. Report exactly which sections changed.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-11T18:31:09Z
