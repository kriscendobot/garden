I wrote Chapter 2 of the garden book, "Architecture and operation", and it is now on `journal2` at `projects/garden-book/ch2-architecture-operation.md`. `land-journal-edit.sh` exited 0 and reported the file landed on `origin/journal2`.

**What the chapter covers.** It follows the same format as the chapter 3 already in the directory: frontmatter, a contents list, and links written as full `main2` URLs. It covers all six items in the job:

- **2.1 The journal as job board and message bus.** How the one `journal2` branch serves as transcript, board and bus. Every job's files share one name (its basename), which is why re-posting the same ask does nothing, and why recurring jobs need a date suffix. A `git push` only succeeds if nobody else pushed first, and that is what lets many workers race safely. Claims back off after a lost race; posts and completions retry.
- **2.2 The job lifecycle.** The exact path from `todo/` through `doin/` to `tada/`, including the completion signals, time budgets and the reaper. A table covers the five `plan/` gates and who is allowed to promote each one.
- **2.3 The gardener fleet.** The shared worker loop and worker kinds (monk, cleric and others), the health check before a claim, and what the `role:` field controls. It explains per-job worktrees and three reasons the deployed root is never used for job work.
- **2.4 The message bus.** Per-job inboxes, the maintainer inbox via the liaison, role and broadcast channels, and the `msgs/host/` channel, with a summary table.
- **2.5 Fleet topology.** Why some services must run only on the leader (a second copy would do their work twice), the `is-main-host.sh` gate, and that there is no automatic failover. It covers the leader handoff, the sysop as the service that runs on every host, and capacity controls.
- **2.6 The deliberate deploy.** Why the root checkout is a deployed version, the steps of `deploy-garden.sh`, the `upgrade-ready` trigger, and the rolling deploy: followers go first as test hosts and the leader goes last. It explains why a release token cannot make a host deploy arbitrary code.
- **2.7 Summary of invariants.**

**How it was checked.** Besides the sources the job listed, I read the scripts and operations pages behind specific claims, including the handler and claim scripts, the leader/follower and deploy pages, and `rolling-deploy.sh`. I confirmed that every design and skill file the chapter links to exists. It contains no phrases from the garden's AI-cliché list and no British spellings.

**Discrepancies I found and handled:**
- `WORKTREES.md` still calls the journal branch `journal` rather than `journal2`, and still describes the retired per-dispatch worktrees. The chapter notes this.
- `designs/job-board.md` still refers to `set-gardeners.sh`, but the current script is `set-workers.sh`. The chapter uses the current name.

**Follow-up (not done here):** the two stale spots in `WORKTREES.md` and `designs/job-board.md` could be fixed on `main2`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/book-ch2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (2211695 cached reads)
- Output: 24342 tokens
- Cost: $1.9435310000000003
- Wall-clock: 230s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
