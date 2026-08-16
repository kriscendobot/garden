All must-fix items applied, pushed as a review-feedback follow-up commit, PR description refreshed against the upstream template, and CI is green.

## Completion report — FIX round 1, endojs/endo-but-for-bots PR #997

**PR head:** `kriscendobot:design/worker-retention-and-revocation` (design-only: `designs/worker-retention-and-revocation.md` + `designs/README.md`). Follow-up commit `5445ad950` pushed over `ffe04315a` via `safe-push-pr-head.sh --mode advance` (no rewind). CI: **5/5 green**.

### Panel round-1 must-fix items applied (each verified against the tree before editing)

1. **`makeRetainedValue` overstatement** (typist, archivist, prover, migrator, curator, surfacer, integrator, wire-watcher) — confirmed it exists **only** in `designs/chat-slot-slash-commands.md` (Proposed), not in `packages/`. Rewrote the Thread-5 "already has this pattern" paragraph and the Citations block to attribute only `pinTransient`/`unpinTransient`/`transientRoots` (`graph.js:629,645`) to the tree; relabeled the `{ id, release }` surface and `release`-exo guarantees as **Proposed, inherited**; added a `chat-slot-slash-commands` dependency row and a "Proposed (not yet landed)" citation.
2. **`op:gc-answers` release trigger contradicts Thread 3** (assessor, breaker, engine-realist, corner-prober, saboteur) — made **resolution (`fulfill`/`break`)** the sole authoritative trigger; demoted `op:gc-answers` to a Thread-3 optimization hint (finalizer-emitted → local-timing artifact). Reconciled Q4, the "documented gap" paragraph, and Design Decisions 3 & 6.
3. **README authoritative totals stale** (archivist, surfacer, migrator) — bumped the *superseding* "Current totals" line to **33 Proposed / 151 designs**; added the mermaid dependency-graph node and a per-design estimate row.
4. **Type/runtime drift** (typist, stylist, archivist) — fixed `identify`→formula-id / `locate`→locator signatures (`types.d.ts:943-944`); `daemon.js`→`manager.js` for `cancelValue`; tagged the `WorkerDiscipline` fence (`ts`); `identity: 'eq-stable'`→`'worker-import'`.
5. **Remaining seat must-fixes** — Q2 bound (3) dropped "buffer" (assessor); admission cap restated over the transitively-pinned union-find closure (breaker); Q1 three zero-refcount windows specified with mint-atomicity + partition-shaped reject on arrival-after-collection (saboteur, corner-prober); DD2/Thread-2 reframed as a *tightening* since `GuestInterface` already exposes `identify`/`locate` (curator); gift-id discriminator restated as **redemption-boundness** (purist); kill-the-worker **fail-safe default (unknown provenance ⇒ kill)** added to DD1 + open question (breaker).
6. **PR description** (integrator) — rewritten section-for-section against `.github/PULL_REQUEST_TEMPLATE.md`, dropped the `## Files` pointer, added a `Refs:` line.

**Follow-ups:** none blocking. Per the gauntlet contract I did not re-run the panel; the driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr997-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 85 tokens (5058579 cached reads)
- Output: 46096 tokens
- Cost: $5.054966500000001
- Wall-clock: 999s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
