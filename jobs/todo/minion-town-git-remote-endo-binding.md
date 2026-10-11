---
role: builder
tier: mentor
arc: minion-town-git-remote
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-10-11T02:01:11Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Endo-directory binding for git-remote partitions (guest @git power + MCP mint)

Repo: kriscendobot/minion.town (branch main). Arc `minion-town-git-remote`. Plan of record: https://github.com/kriscendobot/garden/blob/main2/designs/minion-town-git-remote-plan.md (increment 3). Designs of record: `designs/git-remote-capability.md` and `designs/git-remote-capability-increment-1.md` in the repo.

Make a partition a pet-named ocap in the guest's Endo inventory (parent design § 7, § 12.2; increment-1 deferred item 2). Follow the in-repo @sites precedent. Add a guest-held git power whose create(petName) makes a guest-owned partition and stores it under that pet name. The partition object carries its unconditional attenuation field, read/readwrite attenuations are distinct objects, and mintUrl() returns a show-once capability URL. Revoke goes through the held object. The guest service reaches minion-git-remote only over a loopback/unix control channel, never the public git.minion.town route. Register reconciled MCP tool names in src/endo/mcp-tool-names.ts. Test create -> mint -> stock-git push -> revoke. If the @sites precedent does not fit and a daemon formula would be needed (endo-but-for-bots work), stop and open a design PR instead of improvising. Draft PR on kriscendobot/minion.town.
