**Completion report: design-daemon-agent-tools-reconcile-mount-git-capabilities**

**Deliverable:** Draft PR **endojs/endo-but-for-bots#611** (`design/daemon-agent-tools-reconcile` → `llm`, commit e335cb4f3), reconciling `designs/daemon-agent-tools.md` against the landed mount/git trio.

**What the reconciled design does:**
- Repositions the 2026-03 sketch as the capability-layer map and build sequence for M3's "Claw-like coding capabilities" pillar, resolving its own 2026-05-18 deferral note. Ownership boundaries are explicit: the trio owns the capability shapes, `endo-agent-tools` owns the tool records; this doc owns the group map, the Shell capability, and the build order.
- Maps each tool group onto landed vocabulary: `Dir` → `Filesystem` (`mountAsFilesystem(mount)` live / `Git.filesystemAt(ref)` historical), `Git` → `provideGit` over `EndoMount` (#364), remote git → the `GitRemote` bundle (#365/#368) the sketch had omitted, with `EndoMountEntry` descriptors at every path boundary.
- Adds the net-new normative **Shell capability** design (the one group with no owning design): `provideShell(mountCap, petName, policy)` mirroring `provideGit` — writable-mount-only, cwd via the host-private `EndoHost.provideHostPath` bridge, formula-owned allowlist/env/timeout policy, argv-array `exec`, execution through genie's existing `Spawner` seam (host spawner now, `@endo/sandbox` bwrap slice as the confinement destination), plus an honest-boundary section stating that only the sandbox engine adds a kernel boundary.
- Phases the builder delta: Phase 1 remaining file tools (list/edit/stat), Phase 2 Shell (formula + `makeShellTool` + hardening tests + optional sandbox engine), Phase 3 push tier (`makeGitRemoteTool`), Phase 4 provisioning plus the `daemon-git-next-steps` worked loop as the M3 acceptance pass. All shipped-symbol citations (`mountAsFilesystem`, `makeHostSpawner`, `makeSandboxSpawner`, `isGitReadOnly`, `provideHostPath`) verified against the tree.

**Design-record corrections:** `daemon-agent-tools` Not Started → In Progress (Updated 2026-07-06); `designs/README.md` synced (summary row, totals recount 24/36 with dated note, dependency-graph node + repointed stale `dfs → dtools` edge, M3 milestone row, estimates row); `daemon-git-capability` Phase 6's "update daemon-agent-tools" checkbox ticked with its Updated/README row synced.

**Follow-ups:** (1) PR #611 is draft pending maintainer review; un-drafting is the maintainer's call. (2) Posted garden infra job `fix-ensure-project-worktree-silent-stale-fetch`: the worktree helper's swallowed fetch failure handed me an 8-week-stale checkout of `llm` (missing the very designs this job named); caught and worked around by re-fetching before drafting.

Verification status: design-doc work only, no runtime surface; all cross-linked design files confirmed present and the PR confirmed open at the URL above. Self-improvement: the stale-fetch hazard was routed as the fix job above; nothing else this time.
