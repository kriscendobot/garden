---
withdrawn: true
withdrawn_reason: Superseded by the mentat arc supervisor (job npm-minion-town-arc-supervisor-20260930), per kriskowal's delegation on minion.town#135 review 5360931699: PR #135 merged 2026-09-30 (8c589eae27e9) and the supervisor is carrying deploy-validate itself; this notice would only duplicate that step.
withdrawn_by: npm-minion-town-arc-supervisor-20260930
withdrawn_at: 2026-09-30T03:50:06Z
withdrawn_from_gate: blocked
---

---
gate: blocked
blocked_on: https://github.com/kriscendobot/minion.town/pull/135
priority: normal
role: gardener
posted_by: producer
posted_at: 2026-09-29T03:27:08Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
## npm.minion.town dev-registry campaign — merge notice for PR #135

PR: https://github.com/kriscendobot/minion.town/pull/135 (sibling from the same build: https://github.com/endojs/endo-but-for-bots/pull/1362)
Campaign: build `build-npm-minion-town-dev-registry`, orchestration `npm-minion-town-dev-registry-orch`.
You were promoted because PR #135 closed (merged or declined). As of 2026-09-29 the gauntlet had completed and #135 was OPEN (draft), awaiting the maintainer's explicit "merge #135"; #1362 was likewise OPEN (draft).

Do this:
1. Read the REAL PR state (never infer):
     gh pr view https://github.com/kriscendobot/minion.town/pull/135 --json state,mergedAt,isDraft
     gh pr view https://github.com/endojs/endo-but-for-bots/pull/1362 --json state,mergedAt
2. If MERGED:
   - If the sibling #1362 is also MERGED, or the deploy-validate job already exists, post (idempotent):
       scripts/jobs/post-job.sh npm-minion-town-dev-registry-deploy-validate <body-file>
     using the "Deploy and validate" body below, stating which PRs have landed (dated suffix `-YYYYMMDD` if an earlier deploy-validate already completed).
   - If the sibling is NOT yet merged: minion.town#135's deploy script refuses to run until endo-but-for-bots#1362 is merged on llm, so do not deploy; say so in your report, and make sure the sibling's thread is armed: if neither `npm-minion-town-dev-registry-postgauntlet-pr1362` nor `npm-minion-town-dev-registry-merge-pr1362` is on the board (plan/todo/doin) or in tada/, re-arm with
       scripts/jobs/post-plan.sh --blocked --blocked-on https://github.com/endojs/endo-but-for-bots/pull/1362 --role gardener npm-minion-town-dev-registry-merge-pr1362 <body>
     (this notice shape with PR/sibling swapped). The sibling's notice posts deploy-validate when it merges.
3. If somehow still OPEN: re-park this notice with a dated suffix (`npm-minion-town-dev-registry-merge-pr135-YYYYMMDD`) via post-plan.sh --blocked --blocked-on the PR URL, rather than dropping it.
4. If CLOSED without merging: deploy nothing; send
     scripts/jobs/message-user.sh npm-minion-town-dev-registry-gauntlet-chain "PR https://github.com/kriscendobot/minion.town/pull/135 was closed without merging; the npm.minion.town registry campaign has stalled on this leg."
   and stop this thread.

## Deploy and validate (body for `npm-minion-town-dev-registry-deploy-validate`)

Campaign: npm.minion.town dev registry (orchestration `npm-minion-town-dev-registry-orch`,
build `build-npm-minion-town-dev-registry`). PRs:
- https://github.com/endojs/endo-but-for-bots/pull/1362 (`@endo/npm-registry-server`)
- https://github.com/kriscendobot/minion.town/pull/135 (systemd unit, deploy/DNS/secret scripts, Caddy site, runbook `deploy/aws/npm-registry/README.md`)

State in the job body which of these PRs is actually MERGED; deploy/validate only what has landed.
Note: minion.town#135's deploy script refuses to run until `NPM_REGISTRY_ENDO_COMMIT` is pinned
to a merged #1362 commit on `llm`, so a full deploy needs BOTH merged.

1. Deploy the merged change so https://npm.minion.town is live and serving the registry, following
   the landed runbook (`deploy/aws/npm-registry/README.md` / `DEPLOYMENT.md` in minion.town): set the
   pin, run `deploy-npm-registry.sh`, deliver the secret (`deploy-npm-registry-secret.sh`), create DNS
   (`deploy-npm-registry-dns.sh`), move the Caddy site into `conf.d/`, run the design's § 10 live
   acceptance test. Only then add the CD target.
2. From a worktree of endojs/endo-but-for-bots at the merged commit, pick 2-3 small real packages
   (prefer at least one with a transitive dependency) and publish each with a dated dev tag:
     npm publish --registry https://npm.minion.town --tag dev-$(date -u +%F)
   (the registry only accepts `<v>-dev.<YYYYMMDDHHMMSS>.g<sha>` versions with the matching tag and a
   bearer grant naming the package.)
3. In a FRESH scratch directory outside any garden worktree, with an npm cache directory that has
   never touched npm.minion.town (`--cache <fresh-tmp-dir>` or a project-local `.npmrc` registry
   override), run `npm install <pkg>@dev-$(date -u +%F)` for each published package and confirm:
   (a) the exact tagged version installs; (b) every transitive dependency resolves and installs from
   npm.minion.town with zero reliance on npm's default registry and zero reliance on any pre-existing
   local cache (show the fresh cache directory was empty beforehand); (c) the installed package
   actually runs/imports correctly.
4. Report pass/fail per package with the exact commands run. Production-npm promotion is explicitly
   future work — do not attempt it.
