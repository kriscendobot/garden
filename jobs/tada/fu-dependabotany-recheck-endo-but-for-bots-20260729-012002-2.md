Promoted. Verified on `origin/journal2`.

**What I did**

1. **Confirmed the parked job's state.** `jobs/plan/endojs-endo-but-for-bots-pr867-dependabot.md` was gated `go-ahead` and carried reaper poison metadata: `poisoned: true`, `poison_signature: deadline-overrun`, `poison_count: 1`, `deadline_overruns: 1`, parked 2026-07-28T08:03:04Z on `endolin-garden2-5bcdff64`. Its body is the auto-posted botanist brief from the dependabot-PR watcher.

2. **Rechecked the live PR before spending the promotion.** `endojs/endo-but-for-bots#867` (`chore: bump @noble/curves from 1.9.0 to 2.2.0`, author `app/dependabot`) is **OPEN**, not draft, `mergeStateStatus: CLEAN`, last updated 2026-07-28T07:22:47Z. It has **0 comments and 0 reviews** — confirming the job's premise that there is no botanist verdict at all.

3. **Promoted it.** `scripts/jobs/promote-plan.sh endojs-endo-but-for-bots-pr867-dependabot` → `promoted 'endojs-endo-but-for-bots-pr867-dependabot' plan→todo (gate=go-ahead priority=normal)`. Confirmed the file now exists at `jobs/todo/endojs-endo-but-for-bots-pr867-dependabot.md` on `origin/journal2` and is gone from `plan/`.

**What changed**

- One journal job move: `jobs/plan/` → `jobs/todo/` for that basename (plan frontmatter stripped by the promote primitive, so the todo job is the clean botanist work body). No garden-library (`main2`) changes were needed, so my per-job worktree has no commits.

**Follow-ups / notes**

- **This job overran once before.** The promoted body still carries the trailing `<!-- garden-deadline-overrun: 1 -->` marker. I left it: with `GARDEN_REAP_OVERRUN_THRESHOLD=1` a fresh wall-hit poisons at count 1 anyway, so carrying it changes no outcome, and a productive cycle resets the counter. But a `@noble/curves` **major** bump (1.9.0 → 2.2.0) is a long botanist review — lockfile transitive set, scripts-disabled install, upstream source read, advisory cross-check, CI shepherd — so it is a realistic candidate to hit the handler wall again and re-poison. If it comes back poisoned a second time, the right move is probably decomposing it into an orchestration (read/verdict as one child, disposition-execution as another) rather than re-promoting verbatim.
- The gardener pool on this host is deliberately throttled to 2 for the weekly quota, so pickup may not be immediate.
- Minor process note: I ran two read-only git commands (`fetch origin journal2`, `ls-tree`) in `/home/kris/garden/journal` to verify the promotion landed, which is inside the shared root repo I was told to stay out of. No HEAD move, no remote change; `journal2` is simply behind `origin/journal2` as usual for the keeper to sync. Verification should have gone through the producer clone instead.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-dependabotany-recheck-endo-but-for-bots-20260729-012002-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 21 tokens (468388 cached reads)
- Output: 5811 tokens
- Cost: $0.731957
- Wall-clock: 91s

<!-- garden-usage-end -->
