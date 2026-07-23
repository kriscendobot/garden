---
role: builder
handler-timeout: 10800
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=high at=2026-07-23T18:50:13Z -->

handler-timeout: 10800
# Build a current-master CI baseline repair PR

Repository/fork: endojs/endo-but-for-bots
Upstream source: endojs/endo master at fb9cef49eee34d8cf65fb8c6f46cc9b333663f41
Frozen base to create/verify: master-fb9cef4
Dependent PR: https://github.com/endojs/endo-but-for-bots/pull/719

Wear the builder role. Verify the exact upstream master SHA is still fb9cef49eee34d8cf65fb8c6f46cc9b333663f41 at execution time. If upstream master moved, stop and report rather than silently changing this frozen request. Create or verify fork branch master-fb9cef4 points exactly at that upstream commit; never create or update a fork master branch.

From master-fb9cef4, create deterministic head branch fix/master-fb9cef4-ci-baseline. Reproduce the complete pull-request CI surface on the unmodified frozen snapshot and classify every failure as inherited standing debt, infrastructure/transient, or absent. Prior #719 shepherd evidence named CBOR dependency resolution, TextEncoder formatting/Prettier, and stale setup-node zizmor pins as hypotheses only; verify each against this snapshot.

Fix every reproducible standing CI defect needed to make the current-master snapshot green, with the narrowest semantically correct changes. Do not include any URL-shim or PR #719 feature changes. Run CI-equivalent local checks before pushing, preserve changeset/lockfile/commit discipline, and open a DRAFT PR in endojs/endo-but-for-bots with base master-fb9cef4. This is a diagnostic master repair PR for eventual upstream consideration, not a merge into a fork master. Carry the normal build gauntlet only to the extent compatible with a frozen master reflection; do not conduct or ferry upstream.

Report the PR URL, base/head SHAs, exact baseline failures and repairs, verification evidence, and how PR #719 should be rebased or stacked to consume the fixes without importing unrelated fork history.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 8
  worker_kind: cleric
  claimed_at: 2026-07-23T18:50:36Z
