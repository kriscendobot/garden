---
created: 2026-07-05
author: gardener
---

# Skill: pages-build-shepherd

Purpose: drive the garden's own **GitHub Pages** build/deploy back to green after a
push — the [shepherd](../../roles/shepherd/AGENT.md) applied to a branch push with no
pull request. This skill is the classification and procedure the
[pages-shepherd](../../roles/pages-shepherd/AGENT.md) role follows when it claims a
`garden-pages-<sha>-shepherd` job posted by `scripts/jobs/pages-watcher.sh`.

## Background: how the garden's Pages site is wired

- The site is served from the garden repo's **`main2` branch, `docs/` path** (a legacy
  Jekyll-off Pages source: `docs/.nojekyll` is present). `docs/index.html` redirects to
  `docs/bulletin/`, a static web app that reads the **`journal2`** branch live via the
  GitHub API from the browser.
- Every push to `main2` fires GitHub's built-in **`pages-build-deployment`** workflow
  (two jobs: **build** the artifact from `docs/`, then **deploy** it to Pages). The
  run's conclusion is `failure` if either job fails.
- Content shown by the bulletin comes from `journal2` and is fetched at runtime, so a
  push to `journal2` does **not** trigger a Pages rebuild — only a `main2` push does.
  The maintainer's framing on kriskowal/garden#27 ("after pushing to the journal
  branch") maps, in the live wiring, to the `main2/docs` Pages deploy; that is the run
  this skill watches and repairs.

## Inputs

- The failing run URL, head SHA, and conclusion (carried in the job body).
- Read/push access to the garden's own repo (the bot has direct `main2` push).

## Procedure

1. **Re-fetch the live state first — never act on the stale post.**
   `gh run list -R <repo> --workflow pages-build-deployment -L 5 --json databaseId,status,conclusion,headSha,url`.
   If the **newest** run is now green, or a newer push superseded the failing SHA →
   there is nothing to fix. Report `next: none` and cite the green run.

2. **Classify the failure** by reading the failing run's logs
   (`gh run view <id> -R <repo> --log-failed`):

   - **Transient deploy flake** — the **deploy** job failed with a GitHub-side message
     like `Deployment failed, try again later.` (the build job was fine, the artifact
     uploaded). This is not a code problem. **Re-run it**:
     `gh run rerun <id> -R <repo>` (or `--failed`), then poll until it settles and
     confirm it goes green. No commit. Report `next: none` + the green run URL.

   - **Content / build error** — the **build** job failed: a malformed `docs/` file, a
     broken/absolute asset path, an oversized artifact, a Jekyll/liquid error if Jekyll
     is ever enabled, etc. This IS a code problem. Fix the `docs/` source:
     * Build in an **isolated worktree off `origin/main2`** (the shared `main2` tree is
       concurrently mutated by the fleet — see [COMMON.md](../../roles/COMMON.md)); do
       not `git reset --hard` a shared checkout.
       `ensure-project-worktree.sh` is for *forks*; for the garden's own `main2`, add a
       worktree with `git worktree add`/`git fetch origin main2` and re-apply on the
       clean base.
     * Make the smallest fix that makes the build green; one concern per atomic commit.
     * Verify locally what you can ([local-verify](../local-verify/SKILL.md)); at
       minimum confirm the referenced assets exist and paths resolve under `docs/`.
     * Push to the Pages source branch with a rebase CAS loop:
       `git push origin HEAD:main2` (retry on non-fast-forward). No PR — the garden
       does not open PRs against itself ([pre-push-gates](../pre-push-gates/SKILL.md),
       CLAUDE.md § Conventions).
     * The push mints a **new** `pages-build-deployment` run on the new tip; watch it to
       green.

   - **Configuration / permissions impasse** — the failure is a repo-settings or
     OIDC/permissions problem the bot cannot change (Pages source branch, build type,
     `actions/deploy-pages` token/permission). Do **not** guess. Surface with
     `next: liaison`, naming exactly what you saw.

3. **Verify green, then report.** Confirm the current tip's `pages-build-deployment`
   run is `success`. The report names: the failing run, the classification, the action
   taken, and the green run URL (or the escalation with its `next:` class).

## Safety guardrails (inherited from the shepherd)

- Never disable a Pages check or add `continue-on-error` to force a green.
- Never delete site content to make a build error disappear — fix the content.
- Never push outside the Pages source branch; use `--force-with-lease` against a known
  anchor if a history rewrite is ever unavoidable (it should not be here).

## Output shape

A completion report with: the failing run URL, `flake | content-error | config-impasse`,
what was done, and either the **green run URL** or the `next: <role>` escalation.

## Notes

- Keying the job on the **head SHA** means a re-tick on the same red tip is idempotent,
  while the shepherd's own fix (a new commit) mints a fresh run and, if *that* fails, a
  fresh job base — so a repair loop never collides with its own predecessor.
- When the job originated from an issue (the ISSUE NOTE block is present) and an
  issue-comment reply is authorized, use the
  [pr-completion-summary-comment](../pr-completion-summary-comment/SKILL.md) shape.
