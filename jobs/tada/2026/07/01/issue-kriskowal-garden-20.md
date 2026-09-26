Done. Comment posted, inbox clean, no main2 changes needed.

---

**Completion report — job `issue-kriskowal-garden-20`**

**What was asked:** Maintainer kriskowal (garden issue #20) asked me to post a job for a gardener to pick up the work described in upstream issue [Agoric/agoric-3-proposals#316](https://github.com/Agoric/agoric-3-proposals/issues/316) — adding missing passed Agoric mainnet governance proposals — in a kriscendobot fork of that repo.

**What I did:**
- Fetched issue #20 (title/body pointed at agoric-3-proposals#316) and read #316 verbatim: the repo's `proposals/` dir stops at `110:upgrade-22` and is missing passed proposals 111–116.
- Confirmed no kriscendobot fork of `Agoric/agoric-3-proposals` exists yet, and no matching job was already on the board.
- Composed a follow-on job body carrying the ISSUE NOTE block verbatim (so the downstream gardener can comment back on garden #20), the transcribed proposal list (marked untrusted, verify-against-chain), the fork-creation step, and a scope guardrail: base+head stay on the kriscendobot fork; no PRs/comments/links against upstream Agoric/agoric-3-proposals.
- Posted it: `post-job.sh agoric-3-proposals-316-missing-proposals` → landed in `todo/` on `origin/journal2`, and gardener-63 (endolinbot2) has already claimed it (now in `doin/`).
- Drained my inbox (empty) and commented the outcome back on garden issue #20 (comment #4849561940); left the issue open per the issue-inbox contract.

**What changed:** One journal job posted; no changes to `main2` (this was a job-board/journal operation, not a code change).

**Follow-ups:** The claiming gardener (gardener-63) will do the actual fork work and, because the job carries this issue's spine, will comment back on garden #20 with the fork branch/commit when it lands. It must create the fork first (none exists) and author each proposal directory from its real on-chain record; proposal 117 is excluded (rejected), 118 (text proposal) deferred to the repo's convention.
