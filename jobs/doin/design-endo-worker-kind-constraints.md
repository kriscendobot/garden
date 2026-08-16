---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: endojs/endo-but-for-bots @ llm (bare clone: worktrees/endojs-endo-but-for-bots.git).

## Task

Design a forward-looking, portable constraint model for the daemon's worker
selection, replacing the closed two-value `kind: 'locked' | 'node'` union that
`makeWorker`/`makeIdentifiedWorker` carry today (`packages/daemon/src/manager.js`,
`bus-manager-rust-xs.js`, `manager-node-powers.js`, `manager-go-powers.js`, and the
`kind?: 'locked' | 'node'` signature in `types.d.ts`, threaded identically across
all three supervisor backends). The maintainer's ask (verbatim intent): a
through-line that is portable across platforms, lets a caller express worker
constraints or leave them flexible, and does not hard-code today's two kinds as
the ceiling.

**This must be forward-looking but land something usable now.** Do not just
propose a distant target architecture. Define the constraint schema and the
seam it plugs into now, migrate today's two kinds (`locked`, `node`) onto it as
the first two instances with zero behavior change, and leave explicit,
well-typed extension points for the categories below — even though most of
them are not ready to implement yet.

## Known converging pieces (reconcile with these; do not duplicate them)

- **Durable orthogonal-persistence worker category** — the maintainer's
  headline case: consistent, portable, snapshotted, embargoes messages to
  prevent hangover-inconsistency, transcripted and/or snapshotted for durable
  storage. Maps to:
  - `@endo/thixotrope` (design `ocapn-orthogonal-persistence`, PR #786 merged,
    In Progress) — sleepy workers, XS heap snapshots, delivered-watermark
    journals, durable host exports, at-most-once host obligations. Phases 1-4
    landed; Phases 5-9 (name-hub + upgrade-by-rebinding, resource vats,
    non-reifying host) open.
  - PR #989 (draft design, awaiting panel) — the quiescence embargo itself:
    admit one inbound envelope per crank, flush outbound atomically. Explicitly
    distinct from thixotrope's journal-replay embargo; the two compose.
  - `daemon-xs-worker-snapshot` design (In Progress) + PR #281 (open) — the
    streaming-CAS snapshot/suspend/resume substrate underneath both of the above.
  - Issue #984 (open, unclaimed) — the metered-storage worker type itself:
    configurable indefinite-ledger retention, observable snapshot/message-byte
    growth for external metering (Minion Town). This design's constraint model
    should make #984 expressible as one constraint combination, not a bespoke
    worker kind.
  - Issue #813 (open) — snapshot continuity across a live code upgrade.
- **Alternate worker runtime** — Ironhorse (PR #600, merged): Rust process
  embedding XS. `designs/worker-rust-xs.md` motivated it but is stale
  ("Not Started"); this design should note the doc needs a status sync
  (informational only, not this job's work) and treat "worker runtime/engine"
  as its own constraint dimension, since XS-in-Rust vs. XS-via-xsnap-in-Node vs.
  plain Node are three points on that axis, not three unrelated kinds.
- **Sturdy-refs / worker retention** — PR #511 (draft design).

## Entirely unfiled — this design is where they first get a home

Neither of these has any issue, PR, or design doc yet. Give them an explicit,
named place in the constraint schema so they are additive later, not a rework:

- **Version pinning.** A caller must be able to pin a specific worker build
  (binary/engine version), not just a kind. Sketch what a version constraint
  looks like in the schema (exact pin vs. range vs. "flexible/latest") without
  committing to a resolution mechanism yet.
- **Platform/architecture-specific binary fetch on demand.** On deployments
  like minion.town, the daemon may need to pull a platform+arch-matched worker
  binary from remote storage (e.g. S3) rather than assume a local binary is
  present. This is adjacent to but distinct from the AWS storage line (PR #637
  draft, PR #689 draft, `designs/endo-daemon-aws-storage.md`) — that work is
  DynamoDB+S3 for daemon *structured state and blobs*, and does not mention
  worker binaries or platform/arch selection anywhere. Note the seam where a
  future binary-fetch provider would plug into `makeWorker`'s constraint
  resolution (e.g. alongside `endoWorkerBin`/`endoNodeWorkerBin` in
  `bus-manager-rust-xs.js`), without designing the fetch mechanism itself here.

## Shape to aim for

A constraint expression a caller passes to `makeWorker` (or the formula that
requests one) with independent, individually-optional axes — kind/runtime,
persistence class (ephemeral vs. durable/transcripted/snapshotted with
hangover-consistency guarantees), version, platform/arch — each either pinned
or left flexible for the daemon to resolve. Today's `'locked'` and `'node'`
become the flexible-default resolution of the kind/runtime axis with every
other axis flexible. Keep the wire/API surface additive over the current
`kind?: 'locked' | 'node'` signature so existing callers need no changes.

## Output

A design doc (`designs/<slug>.md` per the repo's existing design-doc
convention) plus a `designs/README.md` summary-table row, per the usual
process for this repo's design corpus. Flag open questions rather than
resolving them past the load-bearing seam (the schema + the migration of
today's two kinds onto it); the unfiled pieces above should end as explicit
`Not Started` extension points, not implementation plans.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-16T07:22:47Z
