---
tier: mentat
dispatch: manual
---
# Supervise the npm.minion.town dev-registry arc to a validated deploy (mentat)

Directive: kriskowal's APPROVED review on https://github.com/kriscendobot/minion.town/pull/135#pullrequestreview-5360931699 (2026-09-30):
"Please use a mentat tier supervisor or proxy to carry the npm arc until it's deployed and validated against a real npm client." The maintainer considers the individual PRs in this arc below the level that needs maintainer review. Carry the arc end to end yourself and make the decisions yourself. Surface only real policy or authority questions.

Arc state at posting (re-verify, never infer):
- Design: https://github.com/kriscendobot/minion.town/pull/134 (OPEN, draft).
- Hosting code: https://github.com/kriscendobot/minion.town/pull/135 (APPROVED; conductor job `conduct-kriscendobot-minion-town-pr135-approved-20260930` posted to merge it).
- Server: https://github.com/endojs/endo-but-for-bots/pull/1362 (`@endo/npm-registry-server`, OPEN draft, no maintainer review). #135's deploy script refuses to run until NPM_REGISTRY_ENDO_COMMIT pins a merged #1362 commit on `llm`.
- Parked notices: `npm-minion-town-dev-registry-merge-pr135`, `npm-minion-town-dev-registry-merge-pr1362` (blocked on each PR). Their body holds the full "Deploy and validate" recipe (runbook deploy/aws/npm-registry/README.md, pin, deploy-npm-registry.sh, secret, DNS, Caddy conf.d, § 10 acceptance, then CD target; publish 2-3 real ebfb packages with dev-<date> tags; `npm install` from a fresh scratch dir and fresh npm cache).

Carry it:
1. Land #134, #135 and #1362: run the gauntlet where it is missing, and post conductor jobs when each PR is ready. If a conductor stalls on "no maintainer approval", send the maintainer this review's delegation as the one question, with a one-line summary of each PR's state.
2. After both code PRs merge, run (or post and watch) the deploy-validate step. Do it once: do not duplicate it with the parked notices. Either drive the notices or supersede them explicitly.
3. The arc is done only when https://npm.minion.town is live AND a real npm client (the stock `npm` CLI, fresh cache, no garden tooling) has run `npm install` for published dev-tagged packages, including one with a transitive dependency, and they resolved and installed. Record the transcript evidence.
4. Report the result to the maintainer (message-user.sh) with the evidence and links. Update minion.town deploy notes where the runbook drifted.
Deploy discipline: see the memories on minion.town deploys (EADDRINUSE orphan recovery, pin-bump verification over SSM, and CD www reverting unmerged changes). Use targeted CD dispatches.

<!-- garden-productive-cycle -->
<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T03:42:15Z
