Empty inbox. Work is complete.

## Completion report

**Job `foreman-active-job-target` — landed on `main2` as commit `f34f7520c`, `result` journaled.**

### What I did
Redefined the foreman's trigger from *"pump only when the board is fully idle"* to *"keep an active-job TARGET (default 3) progressing"*.

**`scripts/jobs/foreman.sh`**
- Added `GARDEN_FOREMAN_ACTIVE_TARGET` (default **3**) as the canonical knob, with `GARDEN_FOREMAN_WIP` kept as a deprecated back-compat alias: `: "${GARDEN_FOREMAN_ACTIVE_TARGET:=${GARDEN_FOREMAN_WIP:-3}}"`. (The prior mechanism already acted when `todo+doin < WIP`, but its default was 1 — the "idle = both zero" behavior the directive described; the substantive change is the default bump plus the new fill-to-target semantics and clearer name.)
- The pump now fires while under-subscribed and, on a sustained tick, **batch-promotes up to `TARGET - in-flight` top-priority deferred plan jobs in one tick** (re-syncing the clone between picks so the ranking updates), then falls through to generating **one** new step via the handler only when no deferred plan is queued. Chose batch promotion for the cheap pre-approved path (documented inline) while keeping the expensive `claude -p` path paced at one step per tick.
- Preserved every invariant: `GARDEN_FOREMAN_IDLE_SETTLE` debounce, go-ahead + blocked plans never auto-promoted, leader-only gating, anti-flap, token-quota back-off.

**`scripts/systemd/garden-foreman.service`**: switched `GARDEN_FOREMAN_WIP=3` → `GARDEN_FOREMAN_ACTIVE_TARGET=3` (now redundant with the default, pinned for clarity).

**`scripts/jobs/test/run-test.sh`**: added **SUBTEST 14d** proving the required scenario (1 in doin + N deferred plans → promotes exactly 2 to reach 3, top-priority first, go-ahead/blocked untouched; 0 at capacity). Pinned SUBTEST 14 and SUBTEST 20(5) to `target=1` to preserve their single-slot semantics; SUBTEST 14a now also exercises the deprecated `WIP` alias.

### Verification
Foreman/plan subtests (14, 14a, 14b, 14c, 14d, 20) run in isolation: **36 PASS, 0 FAIL**. The full suite dies at SUBTEST 6 (maintainer-channel) under this host's live ~100-gardener fleet load — a contamination flake the harness header explicitly documents, unrelated to this change.

### Follow-up / activation
This changes only the **deployed** foreman after a **deploy** (the running fleet uses the deployed root checkout). Until then the maintainer is bridging to 3 by hand-promotion, as the directive noted.
