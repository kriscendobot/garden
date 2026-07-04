# Posting a first job

The last teaching stage: post one small real job, watch it cross the board's
three states, and read the report back — so the user sees the whole
producer→board→worker→report loop once, concretely. This page is how the liaison
posts that first job, what the board states mean, and the core verbs that turn a
sentence of intent into a job. If your question is "how does work reach a
worker" or "what does the board look like," you are here; the full job-board
mechanics (the git-push claim CAS, the per-doer worktrees) are
`skills/job-board/SKILL.md`, and the complete verb list is `README.md` § Key
vocabulary and `CLAUDE.md` § Orchestrator vocabulary.

## Posting the job

The liaison never does the substance itself — it **posts a job to the board**,
and a gardener claims it. The primitive:

```sh
scripts/jobs/post-job.sh <basename> [body]
```

`<basename>` is a short deterministic name derived from the change identity; the
body names the repo, any PR/comment URL, and the task in a sentence or two. For
the tutorial, a tiny self-contained job (a trivial garden-library edit, or a
"say hello and report" job) is enough to demonstrate the loop without waiting on
CI. Post it, then watch.

## The three board states

Every job is a file that moves through three directories on the `journal2`
branch:

- **`todo/`** — posted, unclaimed. Any eligible gardener may race to claim it.
- **`doin/`** — claimed. The accepted `git push` to `origin/journal2` is the
  compare-and-swap that serializes the claim: first pusher wins, the rest back
  off to another job. The worker runs it in an isolated per-job worktree.
- **`tada/`** — done. The worker's completion report lands here; the follow-up
  service reads each report's `## Follow-ups` section and turns actionable ones
  into new jobs, so the board feeds itself.

Watch a job cross `todo/ → doin/ → tada/`, then read the report back to the
user. That is the entire life of an issue in miniature (`README.md` § The life
of an issue).

## The core verbs

The user steers in plain language — a sentence of intent becomes a job — but
these verbs are precise shorthand, and the PR-comment watchers recognize the
branch-op ones deterministically:

- **design X** / propose X / spec X — draft a design, open it as a DRAFT PR.
- **build #N** / build X — implement an approved design.
- **run the gauntlet #N** — the full PR chain: clean → panel review → fix-loop →
  un-draft.
- **fix #N**, **rebase #N**, **weave #N**, **shepherd #N**, **merge #N** — the
  branch-op verbs that unstick and advance a PR.
- **defer X** / park X, **promote X** / go ahead — steer the plan queue.
- **ferry #N** — carry approved work upstream under the maintainer's identity;
  authorization required.

The authoritative tables (with what each does and which are watcher-recognized)
are `README.md` § Key vocabulary and `CLAUDE.md` § Orchestrator vocabulary —
point the user there rather than reproducing the full list.
