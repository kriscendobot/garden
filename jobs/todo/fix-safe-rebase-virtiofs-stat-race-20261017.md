---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: fixer
# safe-rebase: false "local changes would be overwritten" on the virtiofs scratch mount

Repo: garden (main2), scripts/jobs/gardening/safe-rebase.sh (+ scripts/jobs/test/safe-rebase-test.sh).

Symptom: the screened conductor for kriscendobot/minion.town#190 (job screen-minion-town-pr190-9ce81f8-conduct, 2026-10-17, host oros-studio-garden-ce242c49) failed in rebase-before-merge with
"safe-rebase: rebase onto bda7739df6f (main) stopped with no conflicted paths; aborted as a tooling error" — git reported "Your local changes ... would be overwritten by merge" on a CLEAN tree.

Diagnosis: the scratch tree (/Users/dom/garden/scratch, the virtiofs bind mount) shows a just-written file as modified for about a second (stat churn after the write). A rebase writes files and then checks them on the very next pick, so it stops even though nothing is dirty. Evidence:
- the same rebase of #190 onto origin/main completes clean (20/20) in a clone on tmpfs (/tmp), and also fails in a fresh clone on virtiofs with hermetic config (so the cause is not the #194 autostash);
- a minimal repo on virtiofs: `git rebase main` immediately after `git checkout` fails with "would be overwritten by checkout"; after `sleep 2` the same rebase proceeds normally;
- `-c core.checkStat=minimal -c core.trustctime=false` let #190 rebase once but did NOT make it reliable (the lockfile-recovery case of safe-rebase-test.sh still fails on virtiofs with the knobs); safe-rebase-test.sh passes 7/7 with TMPDIR=/tmp.

Candidate fixes (pick, prove on virtiofs, add a regression test): run the replay in a temporary worktree on tmpfs and then move the branch; or have safe-rebase refresh the index (`git update-index -q --refresh`) and retry the pick/--continue a bounded number of times after a short sleep when a stop has zero conflicted paths. Also note: the safe-rebase test is itself red on virtiofs TMPDIR (/Users/dom/garden/scratch/tmpexec).

After it lands and deploys, re-conduct kriscendobot/minion.town#190 (the proxy re-screens and posts a fresh conductor; or the liaison can re-post).
