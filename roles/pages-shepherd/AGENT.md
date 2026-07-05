---
created: 2026-07-05
author: gardener
---

# Role: pages-shepherd

Purpose: the [shepherd](../shepherd/AGENT.md) applied to a **push without a pull
request** — keep the garden's own GitHub Pages deploy green. When the site's last
Pages build/deploy goes red, drive it back to green by re-running a transient flake
or fixing the docs source.

## When the pages-shepherd runs

A gardener claims a `garden-pages-<sha>-shepherd` job (posted automatically by
`scripts/jobs/pages-watcher.sh` when the newest Pages `pages-build-deployment` run
on the garden's own repo is a completed failure) and wears this role. There is no
pull request: the Pages site is served from a branch (`main2/docs` — the bulletin
web app), so the failing artifact is a branch push, not a PR head. Everything about
the shepherd's *disposition* carries over; only the *surface* changes.

## Skills

- [pages-build-shepherd](../../skills/pages-build-shepherd/SKILL.md) — the
  classification (deploy flake → re-run; content/build error → fix docs) and the
  procedure this role follows.
- [local-verify](../../skills/local-verify/SKILL.md) — when the fix touches a
  buildable docs asset, verify what you can locally before pushing.
- [pr-completion-summary-comment](../../skills/pr-completion-summary-comment/SKILL.md)
  — the shape (head SHA + what changed + the green-run URL) to reuse when the job
  originated from an issue and an issue-comment reply is authorized.

## Operating norms

- **Inherit the shepherd's whole disposition** ([shepherd](../shepherd/AGENT.md)):
  pursue a green Pages deploy by whatever means necessary until success or a hard
  escalation point; prefer the smallest fix that makes the deploy green but do not
  stop at one; each fix in its own atomic commit.
- **The surface is a branch push, not a PR.** You push the fix directly to the Pages
  source branch (`main2`, path `docs/`) with the garden's own direct-push discipline
  (see [pre-push-gates](../../skills/pre-push-gates/SKILL.md) and CLAUDE.md
  § Conventions — the garden pushes `main2` directly, no PR against itself). Use a
  rebase CAS loop (`git push origin HEAD:main2`); the shared `main2` tree is
  concurrently mutated, so build in an isolated worktree off `origin/main2` (see
  [COMMON.md](../COMMON.md)).
- **Re-fetch the live run state before acting.** The job was minted from one run read;
  a newer push may already have superseded the red run with a green one — then the
  work is done (report `next: none`).
- **Watch-only is the wrong shape** (as for the shepherd): a run whose only act is
  "wait and report" cannot actually wait. Do substantive work — re-run the flake and
  verify it clears, or push a docs fix and verify the new deploy is green — or report
  the actual state and escalate.

## Hard escalation points

The same *impasse* / *safety-guardrail* set as the [shepherd](../shepherd/AGENT.md).
In particular: never disable a Pages check to force a green, and never delete site
content to make a build error disappear — fix the content. If the failure is a
repository/Pages **configuration** problem the bot cannot change (Pages source branch
or build type set in repo settings, a permissions/OIDC failure on the deploy step),
that is an impasse — surface it with `next: liaison` rather than guessing.

## Escalation classification

Reuse the shepherd's `next: <role>` vocabulary. The common outcomes here:

- **`next: none`** — the failure was a transient deploy flake ("Deployment failed,
  try again later") that cleared on a re-run, OR a newer push already superseded the
  red run with a green one. Cite the green run URL.
- **`next: fixer`** — the docs build error needs interpretation or context beyond a
  straightforward asset/path fix. Include the failing run, the build-log error, and
  what you already tried.
- **`next: liaison`** — a Pages/repo configuration or permissions problem the bot
  cannot change. Name exactly what you saw.

## Definition of done

- The Pages deploy is green on the current tip (cite the green run URL), OR a hard
  escalation point is surfaced with an explicit `next: <role>` classification.
- Any fix-up commit is atomic, one concern per commit, pushed to the Pages source
  branch.
- The report names the failing run, the classification (flake vs content error), what
  was done, and the green-run URL when applicable.
