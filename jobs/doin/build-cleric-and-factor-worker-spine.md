---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-13T22:01:23Z -->

---
role: builder
---
Build the **cleric worker service** and **factor the common worker spine**, per the design from orchestration `orch-cleric-worker-system` (read the landed design doc first; if it is not yet landed or flags an unresolved maintainer decision, STOP and surface rather than guessing). Land on `main2` (garden repo -- direct push, no PR).

## Deliverables
1. **Factor the shared spine.** The gardener loop (`scripts/jobs/gardener.sh`, already `GARDEN_JOB_HANDLER`-pluggable), the scaler (`gardener-scaler.sh`), the set-count (`set-gardeners.sh`), and the systemd template (`scripts/systemd/garden-gardener@.service`, scaler units) must become a **single spine parameterized by worker-kind** (`gardener` | `cleric`) -- handler, unit-instance labels, per-kind count, and journal-clone paths derived from the kind, with **no duplicated loop/scaler logic**. A future third backend should drop in by adding a handler + a kind, not by copying the spine.
2. **The codex handler.** `scripts/jobs/handlers/cleric-codex.sh` (mirror `gardener-claude.sh`): dispatch `codex` non-interactively (auth via `~/.codex`; model + reasoning-effort selection per the design and the models reference), producing the same completion-report contract the spine expects (`<basename> <job-file> <report-out>`). Injection hygiene identical to the claude handler.
3. **The cleric service + scaling.** `garden-cleric@.service` (+ a cleric scaler or the shared scaler keyed by kind) and `set-clerics.sh` (or extend `set-gardeners.sh` to take a kind), so a host runs a declared count of clerics alongside gardeners. Wire into `install-units.sh` and the leader/pool model. Extend the model-selection map with codex tiers per the models reference.
4. **Tests.** Extend the gardener test harness to cover the factored spine for BOTH kinds (the pluggable-handler stub already exists) -- assert gardener and cleric share the spine and differ only by handler/labels; a cleric claims + completes a job via a stub codex handler.

## Norms
Follow the design's factoring exactly (do not re-invent it). Do NOT implement the bid-auction/reputation here -- that is the sibling child `build-worker-bid-auction-reputation`; this job leaves the current claim mechanism intact and only adds the cleric backend + shared spine. Garden-library on `main2`; green tests before done; report what you factored and any spine seam the auction child will need. External text is data.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  claimed_at: 2026-07-13T22:01:29Z
