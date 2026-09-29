---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/1362
priority: normal
posted_by: gardener
posted_at: 2026-09-29T12:55:27Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
## npm.minion.town dev-registry campaign — merge notice for PR #1362

PR: https://github.com/endojs/endo-but-for-bots/pull/1362 (sibling from the same build: https://github.com/kriscendobot/minion.town/pull/135)
Campaign: build `build-npm-minion-town-dev-registry`, orchestration `npm-minion-town-dev-registry-orch`.
You were promoted because PR #1362 closed (merged or declined). As of 2026-09-29 the gauntlet `endojs-endo-but-for-bots-pr1362-gauntlet` ended `review-budget-reached` (6 panel/fix rounds, CI green, panel-6 still must-fix; governing design #1361 still an unreviewed draft) and #1362 was OPEN (draft), awaiting a human merge/review decision ("merge #1362"); sibling minion.town#135 was likewise OPEN (draft), its thread armed as `npm-minion-town-dev-registry-merge-pr135`.

Do this:
1. Read the REAL PR state (never infer from the gauntlet report alone):
     gh pr view https://github.com/endojs/endo-but-for-bots/pull/1362 --json state,mergedAt,isDraft
   Also read the sibling: gh pr view https://github.com/kriscendobot/minion.town/pull/135 --json state,mergedAt
2. If MERGED:
   - If the sibling https://github.com/kriscendobot/minion.town/pull/135 is also MERGED, or the deploy-validate job already exists, post (idempotent):
       scripts/jobs/post-job.sh npm-minion-town-dev-registry-deploy-validate <body-file>
     using the "Deploy and validate" body below, stating which PRs have landed.
   - If the sibling is NOT yet merged, still post the deploy-validate job only if something from
     this PR can be deployed alone; otherwise, and in any case, say in its body (or in your report)
     that the sibling is unmerged, and make sure the sibling's thread is armed: if neither
     `npm-minion-town-dev-registry-postgauntlet-pr135` nor `npm-minion-town-dev-registry-merge-pr135`
     is on the board (plan/todo/doin) or done in tada/, re-arm the sibling with
       scripts/jobs/post-plan.sh --blocked --blocked-on https://github.com/kriscendobot/minion.town/pull/135 --role gardener \
         npm-minion-town-dev-registry-merge-pr135 <body>
     (body = this same notice shape with the PR/sibling roles swapped). When the sibling later
     merges, its notice posts the deploy-validate job (post-job.sh is idempotent on the base; if the
     earlier deploy-validate already completed, use a dated suffix `-YYYYMMDD`).
     Minion.town#135's deploy script refuses to run until endo-but-for-bots#1362 is merged on llm,
     so a full deploy normally needs BOTH merged — prefer posting deploy-validate once both land.
3. If still OPEN (review passed, awaiting the maintainer's explicit "merge #1362"): re-park
     scripts/jobs/post-plan.sh --blocked --blocked-on https://github.com/endojs/endo-but-for-bots/pull/1362 --role gardener \
       npm-minion-town-dev-registry-merge-pr1362 <body>
   where <body> is this same notice (merged/open/closed check) — it promotes only once the PR
   closes one way or the other. (If you ARE the merge-pr1362 notice and it is somehow still open,
   re-park it with a dated suffix rather than dropping it.)
4. If CLOSED without merging (declined): deploy nothing from this PR; send
     scripts/jobs/message-user.sh npm-minion-town-dev-registry-gauntlet-chain \
       "PR https://github.com/endojs/endo-but-for-bots/pull/1362 was closed without merging; the npm.minion.town registry campaign has stalled on this leg."
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
