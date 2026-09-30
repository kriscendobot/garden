# Completion report: book-ch1

I wrote Chapter 1 of the garden book, "Philosophy, history, and metamorphosis," and landed it on `origin/journal2` at `projects/garden-book/ch1-philosophy-history-metamorphosis.md`. It went through `scripts/jobs/land-journal-edit.sh`, which reported the push as verified. The chapter is Markdown only, about 4,000 words, with the same frontmatter and link style as the other chapters.

**Sources.** The chapter is based on `README.md`, `CLAUDE.md`, the whole of `HISTORY.md`, and the README section "The bidding market: the next metamorphosis." For the bidding stage I also used `designs/gardener-bid-accept-market.md`, `designs/cleric-worker-bid-auction-reputation.md` and `skills/bid-auction/SKILL.md`. It was checked against `main2` at `7f0cb21902c`. Quotations and commit SHAs are copied directly from those files, and the chapter repeats `HISTORY.md`'s own warning that the "tmux" detail in stage three comes only from the maintainer's account.

**Sections:**
- **1.1 What the garden is:** the roles and skills library, the journal (job board and message bus), the gardener fleet (monks and clerics), and the liaison.
- **1.2 Why it exists:** the problem, the observe–orient–decide–act loop from the README, and how the appellate and proxy roles fit into it.
- **1.3 The four stages** from `HISTORY.md` (shepherd, containment, supervision, automation between two layers of cognition). For each: what changed, why the previous stage fell short, and what is still in use today.
- **1.4 Where the garden stands now:** what has changed since `HISTORY.md` was written on 2026-06-24, including the review panel, worker kinds and tiers, leader and follower hosts, the per-host sysop, rolling deploys, orchestration jobs, and worker counts sized to the budget.
- **1.5 The next stage, the bid/accept market:** what it adds and how it can roll out alongside today's first-to-claim race without breaking it.
- **1.6 What to carry forward**, plus a handoff to Chapter 2.

**Things the maintainer should know (no follow-up jobs posted):**
- **The README is out of date on the bidding market.** It calls the fifth stage "designed and tracking," but the code shows part of it already built: an opt-in `market: bid` path in `claim-job.sh`, reputation events written by `complete-job.sh`, and the `garden-reputation-reducer` service. It is temporarily switched back to the plain race on `endolin-garden*` hosts. The chapter describes it as started but not yet in charge.
- **The README and `CLAUDE.md` contradict each other on naming an instance.** The README says to run `echo <name> > .garden`. `CLAUDE.md` says there is no `.garden` file and the name comes from the checkout's path. I left this out of the chapter; the Chapter 4 author may run into it.
- **`HISTORY.md` stops at 2026-06-24.** Its "still in flight" list is partly outdated, since the judicial workflow is now the scripted panel. It may be worth updating.

No files on `main2` changed. The scratch file in the job's worktree has been deleted.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/book-ch1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (634308 cached reads)
- Output: 13421 tokens
- Cost: $0.9344096
- Wall-clock: 133s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
