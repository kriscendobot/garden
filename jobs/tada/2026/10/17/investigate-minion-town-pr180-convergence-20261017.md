# kriscendobot/minion.town PR #180 convergence: the panel has converged, the design question has not

The automated review has converged, but the design question behind most of the churn was never decided by the maintainer. While I was investigating, round 17 came back **pass**. The PR is still a draft: un-drafting waits on the PR #178 gauntlet, and CI is green on head `d9b9dd09`. The full report is in the maintainer inbox as message `20261017T063344Z-21dfcc`. This was read-only: I made no pushes to the PR, no garden commits and no follow-up jobs.

**What I looked at:** all 17 panel reviews on the PR, the 13 panel-run records in the journal, the completion reports for every fix and panel job, the maintainer-inbox messages, and the diff between each pair of consecutively reviewed heads.

**1. Per round.** The number of seats asking for changes went 10 → 7 → 4 → 1 → 2 → 3 → 5 → 1 → 1 → 3 → 2 → 6 → **9** → 6 → 1 → 1 → 0.
- Most rounds from 2 to 16 included a regression caused by the previous fix. Five examples:
  - Fix 1 added authentication, which led to the master secret being handed to every guest.
  - Fix 5 added a cap, which led to a slot leak.
  - Fix 7 added open-by-id, which let a public partition id become readwrite authority.
  - Fix 10 added a mint cap, which let a read-only holder block minting.
  - Fix 13 added the `/hello` check, which led to rotation stranding partitions and a relay hole.
- Some findings kept coming back. Secret rotation came up in 7 rounds and scan/quota cost in 6. The mint-cap problem was raised 3 times before it was fixed. Server authentication was declined in fix 7 and came back as a must-fix in round 13.

**2. Trends.**
- **Severity:** a sawtooth, not a decline. It was flat or rising from round 4 to round 14, peaked in round 13, and only fell from round 15.
- **Churn:** the fixes added about 2,780 lines and deleted about 1,200, against a final PR of +2,689/−42.
- **Same files:** `control.ts` changed in 10 of 16 fixes, `git-caplet.ts` in 11, and `DEPLOYMENT.md` in 12. The PR has 28 commits.
- **Cost:** about $41.70 and 9.5 hours of wall-clock across 39 jobs.

**3. Yes, there is a design-level flaw.** Almost all the churn is in one place: the custom loopback HTTP control plane, which rebuilds Endo's object-based access control as passwords and keys sent between two processes.
- The decomplector seat flagged this in rounds 7, 10, 12 and 14. In round 14 it also said the PR contradicts section 7 of the parent design you approved in PR #41, which says write authority is a capability object, "not a bearer token".
- The arc supervisor decided on 10-15 to keep the key layer. That decision came before the section 7 objection and doesn't answer it.
- On 10-16 the proxy answered the fix-14 escalation tentatively: rework the plane as a daemon registry and stop patching it. That answer never reached the gauntlet, because fix 14 had already finished. Fixes 15 and 16 then kept hardening the plane anyway. The round-17 pass is therefore of the shape the proxy said to abandon.

**4. Recommendation:** stop iterating and grant no more rounds. Settle section 7 instead.
- **If a key confined to the internal plumbing is acceptable** (the guest still only ever holds an object): record that ruling, squash or regroup the 28 commits, and let the PR un-draft through the #178 phase ledger.
- **If it isn't** (the proxy and I both lean this way): redesign the control plane as a daemon-hosted registry, following `installSiteRegistry`, in a new PR. Keep the store, the caplet object shape, the guest binding and the tests, and drop the control-plane commits.
- **Don't split the PR:** all the churn is inside one mechanism, so both halves would carry the same flaw.
- **Garden fix:** an answer to a gating question from a finished fix job should be passed on to the gauntlet, so it isn't lost. That is a recommendation only; I posted no job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/investigate-minion-town-pr180-convergence-20261017.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (2247671 cached reads)
- Output: 15335 tokens
- Cost: $1.6266022
- Wall-clock: 233s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
