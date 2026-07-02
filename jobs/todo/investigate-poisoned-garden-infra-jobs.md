# investigator: root-cause the 5 poisoned garden-infra jobs, then re-post fixed

**Scope:** garden-infra (`main2`) self-improvement jobs. Isolated worktree off `origin/main2` per the hard rule (`garden/roles/COMMON.md` § Per-subagent worktrees); the root checkout is read-only.

## Why this job exists

During/around the last restart, five garden-infra jobs were **poisoned** by the reaper (handler failed 5 requeue cycles, then dropped from the board). They are unrelated to the lint ceiling. Blindly re-posting a poisoned job just re-poisons it, so each needs a root-cause first. Maintainer decision (kriskowal, 2026-07-02): **investigate, then re-post fixed.**

## The 5 poisoned job bases

- `build-daemon-rename-to-manager`
- `improve-gardener-transient-failure-backoff-and-fleet-brake`
- `improve-garden-identity-drift-detector`
- `improve-issue-inbox-child-git-reaping`
- `improve-repo-watcher-arm-retry`

## Where the evidence is

Each has a reaper **POISON report** in the maintainer inbox (`journal/inbox/maintainer/unread/`) whose body carries the **original job body** (after a `--- original job body ---` marker) and the drop context. Grep the unread dir for each base to recover its original body. Cross-check the reaper's requeue history in the journal (`git -C journal log --all --grep <base>`) and any `prompt-on-failure` capture the handler saved (`skills/prompt-on-failure-capture`).

## Task

For each of the five, in an isolated `main2` worktree:

1. **Recover** the original job body from its poison report.
2. **Diagnose** why the handler failed all 5 times. Common causes: the job body references a path/symbol that has since moved or never existed; the task depends on state absent at claim time; the handler hit a genuine bug in the target script; or the work was already done by a peer (making the job a no-op that nonetheless exited non-zero). Distinguish "bad job body" from "real bug in the garden infra it targets."
3. **Decide and act** per finding:
   - **Fixable job body** (stale path, missing context): re-post a corrected job (`post-job.sh <base>` with the fixed body).
   - **Real infra bug** the job would need to fix: either fix it in this worktree and land it on `main2` (explicit-pathspec commit, push `HEAD:main2` via rebase CAS), or, if it is larger than one cycle, re-post the job with a precise, corrected body that names the bug.
   - **Already done / obsolete**: do not re-post; record that it is moot and archive its poison report (`scripts/jobs/maintainer-archive.sh <msgid>`).
4. Do **not** re-post any job unchanged. If a cause is genuinely undiagnosable from the available evidence, say so in the report and route it to the maintainer inbox rather than re-posting blind.

## Definition of done

A journal `result` entry with, per job: the recovered intent, the root cause, and the action taken (corrected re-post / infra fix landed / dropped-as-moot with its poison report archived). No poisoned job is re-posted unchanged. Land any infra fixes on `main2` from an isolated worktree.
