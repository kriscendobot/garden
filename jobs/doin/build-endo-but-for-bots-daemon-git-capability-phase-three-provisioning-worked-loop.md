---
role: builder
---

Build Phase 3 of the git-capability stack in `endojs/endo-but-for-bots` per `daemon-git-next-steps` § Phased Build Plan (sequenced by #691): capability-based git provisioning (replace path-root Fae git provisioning with a thin adapter over granted `Git`, threading the Phase-2 commit identity) plus the worked end-to-end version-controlled-filesystem loop that is M3's exit criterion. Stack it on the Phase-2 branch (draft PR #706) against its frozen `llm` base, consuming the `makeGitRemoteTool` push tier landed in #705; open a draft PR that auto-runs the gauntlet.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 8
  claimed_at: 2026-07-12T08:46:44Z
