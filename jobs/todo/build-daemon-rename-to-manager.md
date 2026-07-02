<!-- POISON POSTMORTEM (investigate-poisoned-garden-infra-jobs, 2026-07-02) -->
<!--
This job was dropped from the board as POISON after 5 reaper requeue cycles. Root
cause of the poisoning was NOT this job body and NOT the infra it targets: a
sustained Claude quota/usage outage (2026-07-01T00:26-00:50Z, recurring in the
2026-07-02T01:20-01:45Z window) made EVERY gardener claude -p handler exit rc=1
with a transient "claude quota/usage cut" signature. The reaper counts requeue
cycles regardless of transient-vs-deterministic classification, so 5 cycles inside
one sustained outage poisoned this job and dozens of unrelated peers
(pr96-shepherd, pr394-fixer, pr216-weave, pr587/588/591-shepherd, ...) identically.
Compounding factor: the endolinbot2 host-identity drift was (and at re-post time
still is) live -- /home/kris/.garden holds "endolinbot2" though hostname -s and the
leader marker are "endolinbot", so is-main-host reports FOLLOWER and the leader-only
singletons were down. The target defect below was re-verified present at re-post
time against origin/main2. Do the work as specified; if claude -p is CURRENTLY
failing with a quota/usage signature, that is an environmental outage -- let the
tick requeue, do not treat it as a job defect.
-->

# Build: rename `daemon.js` → `manager.js` (`Daemon`/`Mignonic` → `Manager`/`Worker`)

Batch design→build dispatch for the **current active milestone (M3: Remote Access
and Coding Capabilities)** on the endo roadmap. This is the one M3 design that is
**ready to build** — design-complete, no unmet dependency, and no build in flight.

Repo: **endojs/endo-but-for-bots**, base branch **`llm`**, **bot identity**
(kriscendobot / bot fork — bot-repo work only, no upstream `endojs/endo` touch).

## Design (blessed, merged)

`designs/daemon-rename-to-manager.md` on `llm` (Status: Not Started; design landed
via merged PR #85). Align the JS orchestration layer's naming with the Rust
`endor` supervisor, which already calls this role the **manager**:

- `packages/daemon/src/daemon.js` → `manager.js` (and peer `daemon-*.js` per the
  design's *File renames* table).
- Identifiers `Daemon`/`Daemonic` → `Manager`, and `MignonicPowers` →
  `WorkerPowers` (the exo tag `'EndoDaemonFacetForWorker'` renamed on both
  producer and consumer in the same package — no wire-compat window needed).
- The npm package `@endo/daemon` and the directory `packages/daemon/` **keep**
  their names; only the orchestration file and the `Daemon*` identifiers change.

## What to do

Wear **designer** only if a short implementation delta is needed, then
**builder**; the standard researcher-precedes-builder chain and the gardening
state machine apply. Ground the work in the design's **Phased Implementation**:

- **Phase 1** — file renames only (`git mv`, update `import` specifiers pointing
  at the renamed files, no identifier renames). Package builds, types check, tests
  pass. This is the safest, smallest-review slice — open the initial **DRAFT** PR
  on `llm` here.
- **Phase 2** — whole-word identifier renames (`Daemon`/`Daemonic` → `Manager`,
  `MignonicPowers` → `WorkerPowers`, exo tag). Independently mergeable; depends on
  Phase 1.
- **Phase 3** — sweep workspace consumers (small; most import unchanged names like
  `EndoHost`/`EndoGuest`/`EndoWorker`). Add the `@endo/daemon` CHANGELOG entry
  (`makeDaemon` → `makeManager`, exports otherwise unchanged; outright cut, no
  deprecated alias — no downstream consumers of `Daemon*` identifiers).

## Sequencing / collision note (read before pushing)

`packages/daemon/*` is under heavy concurrent churn — ~40 open PRs (the mount
stack #135, the gateway-package stack #343/#388–#397/#409–#420, sturdyrefs #541,
etc.). A project-wide identifier rename will conflict with any of them that edit
`daemon.js` or `Daemon*` names. Mitigations, in order:

- Keep the PR **DRAFT** and land **Phase 1 first** (mechanical, smallest surface),
  so review can sequence it against the in-flight daemon PRs rather than
  merge-storming them.
- Rebase on `llm` immediately before each push; expect to re-run the whole-word
  replace after a rebase.
- If the maintainer prefers to hold the rename until the daemon PRs quiesce,
  surface that on the PR and park — do not force it through against open work.

## Idempotency

Deterministic basename `build-daemon-rename-to-manager` — a re-run of this batch
collides and no-ops.
