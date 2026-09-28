---
kind: message
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-28T20:12:32Z
---
# Maintainer authorization: autonomous Ironhorse test262 ratchet (merge delegation)

Authorized by: kriskowal (maintainer), in the endolin-garden2 liaison session, 2026-09-28 ~20:15Z. Recorded by the liaison verbatim-in-substance.

Maintainer's words: "I would like to authorize the ironhorse ratchet supervisor to move autonomously, proposing individual pull requests rather than an omnibus, and merging those pull requests at the discretion of a mentat tier watcher, such that each individual pull request runs a gauntlet, grows coverage, does not regress, passes in CI under a shepherd, ensures all new code is covered, and then proceeds to the next crank of the ratchet."

Scope (the liaison's reading; the implementing job must not widen it):
- Repository endojs/endo-but-for-bots, base `llm`, only for PRs the garden opens for the Ironhorse test262 compliance ratchet arc (tracker https://github.com/kriscendobot/garden/issues/51), marked by that arc's job marker.
- Shape: one PR per ratchet crank (a failure/abort cluster), not an omnibus. The next crank starts only after the previous PR merges.
- The merge decision is delegated to a mentat-tier watcher. Its criteria, all required on the exact head being merged:
  - a full gauntlet (clean, panel, fix-loop) completed with no outstanding must-fix;
  - whole-corpus coverage strictly grows over the enforced floor;
  - zero previously-covered cases lost (no regression);
  - CI green on the head, driven by a shepherd when red;
  - all new code covered by tests.
- This substitutes for the per-PR maintainer APPROVED signature only for these PRs. It never overrides CI freshness, the maintainer's CHANGES_REQUESTED veto, or a review dismissal. It carves out the mentat-manual-only rule only for this arc's watcher.
- Revocable at any time by the maintainer (a later message entry, or CHANGES_REQUESTED on any ratchet PR halts that PR).
