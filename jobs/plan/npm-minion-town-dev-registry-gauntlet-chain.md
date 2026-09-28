---
gate: orchestrated
orchestrated_by: npm-minion-town-dev-registry-orch
priority: normal
role: gardener
posted_by: producer
posted_at: 2026-09-28T23:15:59Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Read the `jobs/tada/` report of `build-npm-minion-town-dev-registry` and
collect every PR URL it lists (there may be one or two — one per repo, per
the design's split between endo-but-for-bots and minion.town).

For EACH PR URL `<pr-url>` (`<owner>/<repo>#<N>`), do two things:

1. **Post its gauntlet** (this is the "run the gauntlet #N" job — panel
   review + fixer loop + un-draft, per `skills/pr-creation-flow/SKILL.md`):

   scripts/jobs/post-gauntlet.sh <owner>-<repo>-pr<N>-gauntlet <pr-url> \
     --build-job build-npm-minion-town-dev-registry

2. **Arm the hand-off so the eventual merge is never forgotten.** This
   campaign has two waits this job cannot itself sit through: the bot-driven
   gauntlet (panel review), and — separately and with no bound — the
   maintainer's own decision to merge. Use the same shape as
   `skills/chained-followup/SKILL.md` (design -> notice -> follow-up), applied
   twice in series: park a notice blocked on the gauntlet; once that notice is
   promoted (gauntlet done), it checks the PR's live state and either mints
   the deploy-and-validate job (if already merged) or re-arms a second notice
   blocked directly on the PR URL (which `blocked_on` treats as done on
   either merge or close — branch on which one actually happened before
   doing anything). Concretely:

   scripts/jobs/post-plan.sh --blocked \
     --blocked-on <owner>-<repo>-pr<N>-gauntlet \
     --role gardener \
     npm-minion-town-dev-registry-postgauntlet-pr<N> <body-for-that-notice>

   where `<body-for-that-notice>` instructs the gardener who eventually claims
   it, once promoted, to:
   - run `gh pr view <pr-url> --json state,mergedAt,isDraft` to read the real
     PR state (never infer from the gauntlet's own report alone);
   - if MERGED: post the deploy-and-validate job now (see "Deploy and
     validate" below) with `post-job.sh npm-minion-town-dev-registry-deploy-validate`
     — if a sibling PR from this same build is not yet merged, say so in that
     job's body so it only deploys/validates what has actually landed, and
     separately re-arm this same two-step notice for the sibling;
   - if still OPEN (review passed, awaiting the maintainer's explicit "merge
     #N"): re-park a follow-up notice blocked directly on `<pr-url>` itself
     with `post-plan.sh --blocked --blocked-on <pr-url> --role gardener
     npm-minion-town-dev-registry-merge-pr<N> <body>`, where `<body>` repeats
     this same merged/open/closed check once THAT notice is promoted (it will
     only promote once the PR closes one way or the other);
   - if CLOSED without merging (declined): do not deploy anything from that
     PR; send the maintainer a note via `scripts/jobs/message-user.sh
     npm-minion-town-dev-registry-gauntlet-chain "PR <pr-url> was closed
     without merging; the npm.minion.town registry campaign has stalled on
     this leg."` and stop that thread.

## Deploy and validate (the eventual job this chain mints once merged)

Compose this as the body of `npm-minion-town-dev-registry-deploy-validate`
once every relevant PR is confirmed merged:

1. Deploy the merged change so https://npm.minion.town is live and serving
   the registry — whatever the landed design specifies as the minion.town-side
   process/service step (redeploy, service restart, formula publish, etc.).
2. From a worktree of endojs/endo-but-for-bots at the merged commit, pick 2-3
   small real packages from that repo (prefer at least one with a transitive
   dependency) and publish each with a dated dev tag:
     npm publish --registry https://npm.minion.town --tag dev-$(date -u +%F)
3. In a FRESH scratch directory outside any garden worktree, with an npm
   cache directory that has never touched npm.minion.town (an isolated
   `--cache <fresh-tmp-dir>` or an equivalent project-local `.npmrc` registry
   override), run `npm install <pkg>@dev-$(date -u +%F)` for each published
   package and confirm: (a) the exact tagged version installs; (b) every
   transitive dependency resolves and installs from npm.minion.town with zero
   reliance on npm's default registry and zero reliance on any pre-existing
   local cache (show the fresh cache directory was empty beforehand); (c) the
   installed package actually runs/imports correctly.
4. Report pass/fail per package with the exact commands run. This validates
   cross-repository consumption of dev-tagged releases per the maintainer's
   ask; production-npm promotion stays explicitly future work — do not
   attempt it here.

## What THIS job (the gauntlet-chain job) must do before completing

Post every gauntlet, park every first-level notice, and send one summary
message to the maintainer inbox —
`scripts/jobs/message-user.sh npm-minion-town-dev-registry-gauntlet-chain
"<summary>"` — naming every PR now under gauntlet review and stating plainly
that deploy + dev-tag publish + cross-repo install validation will fire
automatically once each PR is merged (no further action needed from the
maintainer except reviewing and merging when ready). Then complete this job —
do NOT wait for the gauntlets or the merges yourselves; the notices you
parked are what carries the rest of the campaign forward.
