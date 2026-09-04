---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Run the gauntlet on **kriscendobot/minion.town PR #90** (the clip app-shell,
head branch `build/clip-shell-framework`, base `main`) and drive it to un-draft.

This is the residual review→un-draft stage handed off from the build job
`build-minion-town-clip-shell-framework`. The build deliverable is complete and
already deployed live (gated `https://minion.town/shell.html`); four panel rounds
have already run and every must-fix each round was fixed and pushed (latest head
pushed to `origin/build/clip-shell-framework`). What remains is to carry the
panel-fixer loop to a clean disposition and un-draft.

Procedure:
1. Get an isolated checkout of the PR head:
   `scripts/jobs/ensure-project-worktree.sh <this-base> kriscendobot/minion.town build/clip-shell-framework`
   (resolve head owner/branch with `gh pr view 90 --json headRefName,headRepositoryOwner`).
2. Run the panel-fixer loop against it, base `HEAD~1`
   (`scripts/jobs/gardening/panel.sh <worktree> 90 HEAD~1`), with `GARDEN_YARN=npm`
   (this repo is npm-based; the default `yarn` walks up to the garden root and
   fails), and `GARDEN_GH_IDENTITY=kriscendobot`. NOTE: a full 29-seat panel runs
   ~15-20 min — longer than the reaper window — so launch it DETACHED (`setsid …
   > /tmp/panel-90.out 2>&1 &`) and read the disposition from the output file; it
   survives a requeue.
3. On each `must-fix`, apply the fixes on the head branch, re-run `npm run
   typecheck` + `npm test` + `GARDEN_YARN=npm pre-push-gates.sh`, commit with an
   explicit pathspec, and `git push --force-with-lease` (rebase onto the current
   `origin/main` first if it advanced — it has been moving).
4. Re-deploy the review surface after any shell change:
   `bash deploy/aws/scripts/deploy-www.sh` (per-file SSM; the payload-ceiling fix
   already landed). Caddy header changes need `bash deploy/aws/scripts/deploy-caddy.sh`.
5. When the loop terminates with no must-fix, un-draft:
   `GARDEN_GH_IDENTITY=kriscendobot gh pr ready 90 -R kriscendobot/minion.town`,
   and post the panel aggregate + a completion-summary comment naming the final
   head SHA.

Known deferred items already recorded in the design's `## Open questions` and the
PR body (do NOT treat as must-fix to block un-draft; they are follow-ons): live
`*.ocap.site` framing (needs the per-clip isolation-floor relaxation), a shared
`account.js` module deduping index.html/shell.js, account-scoped clip storage,
canonical base32 id minting, and reconciling the clip-id model against PRs #85/#88
(fresh-id-on-upgrade). The panel may keep flagging these; they are scoped out of
this build and belong to the § 6 follow-on.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 6
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-04T07:58:43Z
