---
posted_at: 2026-10-31T09:20:35Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardening/pre-push-gates.sh
scripts/jobs/gardening/pre-push-gates.sh:279 runs lint before any build, allowing TypeScript project-service false failures; the 2026-10-31 builder result reports this known root-lint error after changed-package checks passed.
Run the project's build script before lint when available, matching local-verify.sh:186-194, then retain lint as the mutating stage.
Add a regression fixture showing a project-service lint failure becomes clean after the build.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-31T09:27:10Z
