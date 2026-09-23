Batch analysis complete and the job is posted (already claimed by a peer gardener). Cleaning up — the temp body file lives only in my torn-down worktree and no `main2` commit is needed (this job's product is a board post, already made).

---

## Completion report — batch design→build dispatch for the current active milestone

**Current active milestone:** **M3 — Remote Access and Coding Capabilities** (on `endojs/endo-but-for-bots@llm`). M1 and M2 are Complete on `llm`; M3 is the first active milestone. I read the current committed roadmap state (`designs/README.md` on `llm`), coordinating with the in-flight `groom-refine-endo-roadmap` by relying on the committed roadmap, not any un-landed grooming.

I walked every M3 design against the three ready-to-build tests (design-complete/approved · dependencies met · no build in flight — board todo/doin/tada + open PRs).

### Build job posted (1)

| Design | Basename | Why ready |
|---|---|---|
| `daemon-rename-to-manager` | `build-daemon-rename-to-manager` | Design blessed & merged (PR #85), Status Not Started; **no design dependency** (mechanical rename); **no build in flight** (all PR hits are the design/status-sweep, none implementing). Base `llm`, bot identity. Job body grounds the builder in the design's 3-phase plan and flags the heavy-`packages/daemon`-churn collision risk (land Phase 1 as a DRAFT first, rebase before each push, park if the maintainer prefers to wait for the daemon PRs to quiesce). |

The post won a CAS retry and landed; a gardener has already claimed it (`jobs/doin/build-daemon-rename-to-manager.md`).

### Ready designs deliberately skipped — none (all other M3 designs fail a test). Full accounting:

**Already shipped (implementation merged; roadmap row still says "Proposed" — likely roadmap drift for the in-flight groom to fix):** `daemon-git-capability` (#364 merged), `daemon-git-remotes` (#365/#368 merged).

**Build in flight — open PR, no double-dispatch:** `registry-capability` (#563/#403), `mvs-resolver` (#564), `snapshot-mapper` (#565), `daemon-docker-selfhost` (#568), `daemon-locator-terminology` (#567), `endoclaw-network-fetch` (#566), `gateway-package` (stack #343/#388–#397/#409–#420). *(#563–#568 are clearly a prior run of this same batch.)*

**In Progress — build in flight:** `endo-agent-tools` (#523/#524/#424), `agentry-agent-builder` (#517), `daemon-mount` (#135), `daemon-xs-worker-snapshot`, `endoclaw-timer`; `daemon-agent-tools` is realized under the `endo-agent-tools` In-Progress work.

**Dependency unmet:** `daemon-worker-import-from-mount` (Layer 4 — blocked on Layers 1–3 registry/mvs/snapshot, still open/unmerged); `daemon-mount-capabilities` (blocked on `daemon-mount` In Progress, Phase 4 #135 open); `endo-gateway-mcp` (gated on gateway-package phases 2/7/8 — #395/#396 open, unmerged).

**Not a discrete build target / follow-up already in flight:** `daemon-git-next-steps` (Proposed roadmap-over-the-trio doc; its concrete open work `provideGitClone` is in flight via #538); `filesystem-watchers` (design #115 merged, `followNameChanges` landed #277; the remaining `watchDirectory`→`@endo/platform` extraction is already the `factor-watchdirectory-to-endo-platform` doin job).

**Complete / Reference rows (not build targets):** `gateway-bearer-token-auth`, `platform-fs`, `daemon-content-store-gc`, `daemon-cross-peer-gc`, `daemon-guest-eval-simplification`, `daemon-capability-filesystem` (Reference).

### Summary

M3 is effectively saturated — the substrate (gateway stack, git trio, mount, agent-tools, the registry four-layer stack, docker/locator/network-fetch) is either shipped, in flight, or dependency-blocked on that in-flight work. **One** genuinely-ready design remained (`daemon-rename-to-manager`), and I posted its build job. No follow-ups required from me; the roadmap's stale "Proposed" markers on the merged git-capability/git-remotes rows are worth the in-flight groom's attention but are out of this job's scope.
