---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Self-improvement (the garden itself, main2, pushed directly per CLAUDE.md
Conventions).

Observed defect, 2026-08-16: a requeued job re-opened a pull request that an
earlier claimant of the SAME job had already opened, producing two identical
PRs (endojs/endo-but-for-bots#999 and #1000, both `+28/-4` in one file, both
green). #999 was closed by hand.

The journal records the exact sequence for job base
`endo-but-for-bots-pin-node-24x-ci`:

    151da0477f  todo   posted by endolin-garden2-5bcdff64
    7c65ae7ae6  claim  endolin-garden-ece02cb4/gardener-2
    4611c2ca4a  usage  requeue
    2ab03880f4  reap   "transient handler kill" by endolin-garden-ece02cb4
    3f25779a52  claim  endolin-garden2-5bcdff64/gardener-1
    ea37b5deb3  tada   done endolin-garden2-5bcdff64/gardener-1

The claim CAS behaved CORRECTLY throughout: there was never a double claim, only
a sequential requeue. The gap is narrower. A requeue that crosses HOSTS has no
session for the re-claiming worker to `--resume`, so that worker starts clean and
never learns what the first claimant already pushed. Same-host requeue is covered
by `--resume`; cross-host requeue is not.

Task: investigate and propose (or build, if the fix is small and clearly correct)
a rediscovery step, so a worker starting a job that has been claimed before looks
for its own prior work product before creating a new one. Points to consider,
not a prescription:
- The job basename is already the spine tying todo/doin/tada/worktree together,
  so it is the natural key for "did a previous claimant already open a PR?"
- A previous claimant's PR may be discoverable from the branch name, a PR body
  marker, or a journal record written at PR-open time. A journal record written
  by the OPENING worker is the most robust, since it does not depend on
  guessing a branch convention or on a GitHub search.
- Consider whether the fix belongs in the worker spine (so every role inherits
  it) rather than in any single role's playbook.
- Weigh the false-positive risk: a job legitimately re-run to open a SECOND PR
  must not be blocked by rediscovery. Prefer surfacing "a prior PR exists, here
  it is" over silently refusing.

Deliverable: either a design PR on the roadmap branch, or a small implementation
PR on main2 if the change is genuinely contained. Include the journal evidence
above so the case is recoverable.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-17T01:29:15Z
