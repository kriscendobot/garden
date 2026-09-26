Done. Inbox is empty; no worktree code changes were needed (the deliverable was a job posting + PR acknowledgment, both pushed to their respective remotes).

## Completion report

**Directive** (verified read-only against the GitHub API, treated as data): kriskowal — a maintainer — on merged PR endojs/endo-but-for-bots#277 asked kriscendobot to *"post a follow-up job to factor watchDirectory out to `@endo/platform`."*

**Context established:**
- PR #277 (MERGED) landed `watchDirectory` as a self-contained ~120-line `node:fs.watch({persistent:false})` wrapper (50 ms debounce, buffered async-iterable, idempotent cancel, fs.watch-unavailable → terminated stream) inside `makeFilePowers` in `packages/daemon/src/daemon-node-powers.js`. Its only ambient dep is node `fs`. Consumed by `EndoMount.followNameChanges` (`mount.js`) via the `FilePowers.watchDirectory` entry.
- `@endo/platform` already exists on the `llm` branch ("Platform filesystem types and adapters for Endo") with node-fs adapters under `src/fs-node/` and a `watcher-exo.js` + `test/watch.test.js` — a natural home.

**What I did:**
1. **Posted the follow-up** to the job board as a `plan/deferred`, normal-priority item `factor-watchdirectory-to-endo-platform` (roadmap `endo-filesystem-watchers`, posted_by gardener). The body is a designer→builder extraction spec on endojs/endo-but-for-bots (base `llm`, bot identity): move the primitive into `@endo/platform`, keep the `FilePowers.watchDirectory` surface and `followNameChanges` behavior byte-for-byte invariant, carry the test coverage along, and explicitly excludes the multiplexing fanout and the `NameHubInterface` unification as separate follow-ups. Cites `designs/filesystem-watchers.md`.
2. **Replied on PR #277** ([comment](https://github.com/endojs/endo-but-for-bots/pull/277#issuecomment-4858346700)) confirming the parked follow-up and its scope — a reply comment, not just a reactji, per comms discipline.

**Routing rationale:** parked as `deferred` (not `go-ahead`) because the maintainer already authorized the work; parked rather than dropped straight into `todo/` because a "follow-up" is non-urgent and this involves a small API-shape decision (design-first per endo convention) — the foreman auto-promotes it when the board is idle, so no intent is lost.

**Follow-ups:** the parked job awaits foreman promotion (or liaison promotion if prioritized sooner). No garden-infra defects encountered.
