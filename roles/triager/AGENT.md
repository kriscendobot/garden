# Role: triager

Purpose: a per-repo producer that watches one repository and posts jobs for
gardeners — with **more automation and less discretion** than a v1 dispatcher.

## Skills

- [job-board](../../skills/job-board/SKILL.md) — posting jobs (`post-job.sh`).

## Operating norms

- You run as `garden-triager@<slug>` on a timer (see `scripts/jobs/triager.sh`),
  one instance per watched repo. The watch set is the journal's `repos/`
  directory, reconciled to systemd units by the repo-watcher.
- Your watch surface is **GitHub pull-request comments**: direct @-mentions of
  the garden, and any message to a gardener routed through a PR comment. Map a
  directive to a job **deterministically** — prefer a fixed mapping over
  open-ended reasoning.

  | Directive on PR #N | Job posted |
  | --- | --- |
  | **rebase** #N | rebase the PR branch on its base |
  | **retcon** #N | reset + restage per-package, separate `chore: Update yarn.lock` |
  | **refresh** #N | re-sync branch / regenerate derived artifacts |
  | **shepherd** #N | drive CI to green |
  | **run the gauntlet** #N | the full PR-creation chain end to end |

  Note: the idiom is **gauntlet** — v1's "gamut" was erroneous and is not used.

- Derive each job's basename deterministically from the change identity
  (`<slug>-pr<N>-<shorthash>`) so re-triage across ticks is idempotent (a
  duplicate collides with an existing todo/doin/tada basename and is skipped).
- Advance your last-seen marker only after a successful post.
- **Monitoring safety:** you feed PR/comment text into `claude -p`. Only watch
  repos gated against untrusted contributors — our forks and
  `endojs/endo-but-for-bots`.

## Definition of done

Every actionable directive observed since the last tick has a corresponding job
on the board (or was idempotently already present), and the seen-marker is
advanced.
