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
- **Comment-watch arming + authorization.** The executable comment watcher is
  `scripts/jobs/comment-watcher.sh` (sibling to the commit triager
  `scripts/jobs/triager.sh`). Its watch set is the journal's **`comment-repos/`**
  directory — separate from `repos/` (which arms the laxer commit triager) so the
  stricter comment bar cannot be widened by accident. **Arming a new repo for
  comment-watching requires maintainer authorization recorded in a journal
  `message` entry FIRST** (CLAUDE.md § Monitoring safety constraint), then adding
  the slug to `comment-repos/`. As of 2026-06-24 the sole armed repo is
  `endojs/endo-but-for-bots`. The watcher maps the verb table deterministically,
  reactji-acknowledges (👀) before posting, and verifies each post reached
  `origin/journal2` before advancing its `comments/<slug>` cursor.
- **GitHub-wide @-mention watch + the SENDER-TRUST GATE.** A separate watcher,
  `scripts/jobs/mention-watcher.sh` (single instance, `garden-mention-watcher`),
  watches **all of GitHub** for @kriscendobot mentions — not a gated repo set.
  Because it cannot rely on repo-gating for monitoring safety, its injection
  defense is a **deterministic sender-trust gate** that runs in plain code with
  **no LLM, before any mention text reaches a job, a reactji, or `claude -p`**: a
  mention is dropped unless its author is (a) on the journal allowlist
  (`trusted-senders/allowlist`, extensible by appending a login and pushing) or
  (b) a current member of the **endojs** or **Agoric** org
  (`gh api orgs/<org>/members/<login>` → 204). An untrusted sender's mention is
  logged and discarded, never triaged. Confirming Agoric membership is a
  read-only trust check; it does **not** authorize any work on agoric-sdk, which
  stays off-limits. This GitHub-wide widening is maintainer-authorized and
  recorded in a journal `message` entry the day it was armed (the same
  authorization shape the comment-watch arming demands). The seed allowlist:
  `kriskowal`, `erights`, `gibson42`, `kumavis`, `0xpatrickdev`, `mhofman`
  (Mathieu Hofman).

## Definition of done

Every actionable directive observed since the last tick has a corresponding job
on the board (or was idempotently already present), and the seen-marker is
advanced.
