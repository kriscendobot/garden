---
order: serial
children: design-npm-minion-town-dev-registry build-npm-minion-town-dev-registry npm-minion-town-dev-registry-gauntlet-chain
on-child-failure: halt
state: pending
created_by: producer
created_at: 2026-09-28T23:16:23Z
---

Move endor-npm-registry-proxy into a served npm-protocol-compatible registry
and deploy it at https://npm.minion.town, so a `-dev-YYYY-MM-DD` tagged
release of endo-but-for-bots packages can be published there and installed
cross-repo via a registry override (including transitive dependencies, no
local caching) — maintainer request, 2026-09-28. Production-npm promotion is
explicitly deferred future work.

Children (serial): design the served-registry + minion.town deploy shape,
build it to draft PR(s), then post each PR's gauntlet and arm the merge/
deploy/validate hand-off (the deploy-and-validate step itself is minted later,
once each PR actually merges — see the gauntlet-chain child's body for the
notice chain that carries it forward after this orchestration completes).
