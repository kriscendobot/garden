• Worktree ready with warm deps. Now let me explore the project structure and conventions.

• Rich survey results. Now let me read the key local files: interfaces, types, conventions, and a model design document.

• Now the types, README, tests, and the canonical follow design (filesystem-watchers).

• Inbox is empty. I have everything needed. Now drafting the design document.

• Design document written. Now the `designs/README.md` sync — a series of precise anchored edits, one at a time.

• Now validation — first the mermaid-validation skill procedure.

• All three diagrams parse. Spot-checking a few cited precedents and repo lint conventions.

• One loose end in the draft: the sketch references `GitRootChangeShape` without defining it. Fixing.

• Final consistency pass — the job explicitly asks for invariants and the observation-shape answer. Adding a compact Invariants subsection.

• Mermaid re-validated on the final file. Committing and pushing.

• PR #889 opened. Verifying its shape, then final inbox drain.

• # Completion Report: exo-git-follow-root-advancement-design

  ## What I did

  Designed a followable exo-git root advancement stream and landed it as a design document on the repo's design branch, per the designer role conventions.

  **Deliverable:** draft PR **endojs/endo-but-for-bots#889** (https://github.com/endojs/endo-but-for-bots/pull/889), head `kriscendobot:design/exo-git-follow-root-advancement` → base `llm`, commit `32b0206e4`, carrying exactly two files:

  - `designs/exo-git-follow-root-advancement.md` (new, 725 lines) — the design.
  - `designs/README.md` — the sync `designs/AGENTS.md` mandates (summary-table row, "recently added" entry, M3 milestone row, dependency-graph node + edge, per-design estimate, Current-totals line: Proposed 32→33, designs 150→151, M3 items 18→19).

  ## The design in brief

  - **`Git.followRoot({ cancelled })` → `Promise<PassableReader<GitRootChange>>`** on both `WritableEndoGit` and `ReadOnlyEndoGit` — follower-shaped (pull-based async iteration over a push-fed lossless topic), matching the daemon's `followNameChanges`/`followMessages` idiom: snapshot-first, then ordered transitions.
  - **Event vocabulary:** `GitRootPosition` (ref + commit OID + tree OID), transitions with `from`/`to`, `relation` (`fast-forward`/`rewind`/`unrelated`/`same-commit`/`unknown`) for reorg/non-fast-forward replacement, and a best-effort in-band `cause`. Per-subscriber re-anchoring gives a chain property (`from` == previous `to`) immune to subscribe skew and coalescing.
  - **Detection:** a refcounted per-repository watcher registry (keyed by `backend.repositoryKey()`, linked-worktree-correct) fed by in-band touches from mutating methods plus a poll-first `backend.watchRoot` (1 s, the `followPollMs` precedent) for external writers; native fs.watch deferred behind the same seam (exo-google-sheets poll-now/push-later precedent).
  - **Capability discipline:** observation ⊆ the read authority the cap already discloses; the reader exposes only stream methods (no mutation/ambient authority); events disclose ref identity + OIDs only, hardened, treated as untrusted data; revocation = iterator `return()` or the `cancelled` `Promise<never>` (Endo cancellation idiom); heap-only state, purely additive upgrade, restart self-heals via snapshot.
  - **Backed by direct reading of** `packages/exo-git` (git.js, interfaces.js, types.ts, tests), `@endo/pubsub` `makeChangeTopic`, `@endo/exo-stream` `readerFromIterator`, daemon `provideGit`, and the design corpus (daemon-git-capability/-remotes/-next-steps, filesystem-watchers, endor-git-bindings, endo-fs-from-git, buffered-channel, cap-std-watch). Six alternatives compared with rejection rationale; 8 acceptance criteria; 14-test strategy; 3-phase implementation plan.

  ## Verification evidence

  - Mermaid parse validation (skill procedure, real execution): `mm-1.mmd OK flowchart-v2` for the design's diagram; README's graph/gantt also OK.
  - Spot-verified citations: `followPollMs = 1000` (manager.js:3608), revocation race (mount.js:1019), `makeCancelKit` (cancel-kit.js:30), guard/exo-name match `PassableReader` (reader-from-iterator.js).
  - PR shape verified via `gh pr view`: draft, base `llm`, files = design + README only.
  - Design-only: no package code touched, per the job's constraint.

  ## Unresolved questions (recorded in the design's Open Questions)

  1. Generalize to `followRef(name)` / `followAllRefs()` (e.g., remote-tracking refs after fetch)?
  2. Should the poll interval be host-tunable rather than a 1 s constant?
  3. Should events optionally carry commit summary metadata for UI consumers?
  4. Can `cause` attribution be made authoritative by matching operation-result OIDs instead of best-effort FIFO?
  5. Endor-side counterpart over `GitCas` `refs/endor/` roots — named, not designed; tracking issue to be filed.

  **Follow-ups:** maintainer review/un-draft of PR #889; a builder dispatch for Phase 1 (core follower, in-band only) then Phase 2 (poll watcher + integration tests) once accepted.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/exo-git-follow-root-advancement-design.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 327874 tokens (7977216 cached reads)
- Output: 78484 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 2089s
- Model(s): kimi-k3 ×1

<!-- garden-usage-end -->
