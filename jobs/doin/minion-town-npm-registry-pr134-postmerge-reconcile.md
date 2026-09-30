---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot/minion.town. PR #134 ("design: deploy npm development registry at npm.minion.town") merged 2026-09-30T03:49:44Z, landing `designs/npm-minion-town-registry.md` on `main`. Two now-stale things need reconciling as a result:
1. The design doc (designs/npm-minion-town-registry.md) still specifies the loopback listener as `127.0.0.1:3003` (diagram, prose, and the Caddy reverse_proxy snippet), but every implementation file already deliberately uses 3004 instead, because git.minion.town (#136) claimed 3003 first. `deploy/aws/npm-registry/README.md` explicitly says this "should be reconciled to 3004 before or when #134 merges" — #134 has now merged, so update the design doc's port references from 3003 to 3004 and drop/update the README's "deliberate deviation" note accordingly.
2. Several files still describe the design as an unmerged draft and should be updated to reference the landed in-tree design doc instead of "draft PR kriscendobot/minion.town#134, not yet in this tree": `DEPLOYMENT.md` (lines ~216, ~226), `deploy/aws/npm-registry/README.md` (Status section), `deploy/aws/npm-registry/npm-registry-backup.sh`, `deploy/aws/npm-registry/npm-registry.caddy`, `deploy/aws/scripts/deploy-npm-registry-dns.sh`, `deploy/aws/scripts/deploy-npm-registry-secret.sh`, `deploy/aws/scripts/deploy-npm-registry.sh`, `deploy/aws/systemd/npm-minion-registry.service`.
Grep for `#134` and `not yet in this tree` across the repo to find every instance; fix comments/docs only, no behavior change.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T04:08:50Z
