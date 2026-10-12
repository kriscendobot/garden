**Verdict: degraded.** Four of the eight monks were stuck offline, and oros is still on `78f9dacc`, behind main2.

**What I found**
- **Monks 5–8 offline for hours.** On each claim tick a monk copies the journal from the root repo, then checks out the full journal tree (about 68k files). On oros's virtiofs disk that takes minutes, and well over 15 when several run at once. The fleet's git wrapper kills it at 120s. The fallback, a network clone, then times out at 300s. That fallback can't borrow objects from the root repo because the **root repo is shallow**: its `.git/shallow` points at journal2 commit `1fa90b4f` and was written 2026-10-11 09:15Z. I couldn't find what made it shallow.
- **Deploy blocked.** At 02:00Z the pre-deploy test gate rejected `fe7f5b4f`: three test suites hit rc=124 and the total time limit was exceeded, the known under-load pattern. After that the deploy kept being deferred behind long-running monk jobs, including this check-up. It is still deferred.
- **Everything else looked normal at 02:33Z.** No failed units. The budget meter (19% used) pushed at 00:32, 01:18 and 02:06. Disk 54%, inodes 1%, 12 of 15 GiB memory available, 10 days uptime, no drain observed. The old `*.lock` files are leftover lock files, not stuck holders. There were 76 journal clones in the state dir.

**What changed**
- **main2 `75b15068`:** the journal checkout during that copy now gets its own time limit, `GARDEN_JOURNAL_SEED_CHECKOUT_TIMEOUT` (default 1800s), instead of the wrapper's 120s. I added a regression case to `journal-clone-seed-from-root-test.sh`. It fails on the old code; with the fix the suite passes 16/16. On one earlier run the unrelated alias-recovery case failed with a "dubious ownership" error; it passes on the old code, so it looks flaky.
- **Manual relief:** I ran a temporary unit that rebuilt the monk clones one at a time with a longer limit. At 07:10Z monks 5, 6 and 8 had clones again. Monk 7's rebuild didn't finish; its own loop keeps retrying under the old 120s limit until oros deploys the fix.
- **Health log:** the 03:05 check-up (`oros-health-checkup-20261012-030519`) had already created the log and covered most of this. I added this run's entry (journal2 `f1051a08`). The usual `land-journal-edit.sh` timed out twice on this host, so I committed the entry directly with low-level git commands and a compare-and-swap push.

**Needs the maintainer or a person at the machine**
1. **Unshallow the root repo.** Run `git fetch --unshallow origin journal2` against the root's object store at a quiet moment, and find what made it shallow on 10-11. I didn't do this myself because it changes the repo the whole host shares.
2. **Checking out the journal on virtiofs is very slow when several run at once.** Consider letting only one run at a time per host, or keeping journal clones on the container's local disk.
3. **This check-up keeps deferring the deploy.** It runs longer than 300s, so it holds back any deploy that reaches its gate while it runs (03:45, 04:51, and again now). Oros will keep lagging main2 until the cadence or the deferral rule changes.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261012-000506.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 14 tokens (910910 cached reads)
- Output: 4384 tokens
- Cost: $4.532687800000001 (1 engagement(s) unpriced)
- Wall-clock: 4657s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
