The refresh is complete. Final report:

---

**Job: refresh endojs/endo-but-for-bots PR #89** — done.

PR #89 is a design-only PR adding `designs/genie-integration.md` + `designs/scheduler.md` and marking `endoclaw-timer.md` superseded. kriskowal asked to refresh it because a month of work had brought the design "closer to fruition in spirit if not detail," and it needed to speak to what is done and what remains.

**What I did**

1. **Re-synced the branch.** Cut a fresh frozen base `llm-1132289` from the current `llm` tip (was `llm-11a76ae`, ~a month stale; `llm` had been rewritten/rebased on upstream), replayed the two design commits onto it, resolved `designs/README.md` bookkeeping conflicts (totals/milestone tables that trunk had advanced), force-pushed the head, and retargeted the PR base. PR diff is now clean: exactly the 4 design files, no code.

2. **Surveyed the actual repo state** (3 parallel Explore agents + git provenance) and wrote a **§ Realization Status (2026-07-06)** into both `genie-integration.md` and `scheduler.md`, plus per-section and per-rollout-phase status callouts, preserving the original survey prose beneath. Key findings the docs now record:
   - **Pi engine** landed as `@endo/agentry` — but extracted from `@endo/lal` (not genie as `@endo/llm-engine`), on the `@earendil-works/pi-*` fork (not `@mariozechner/pi-*`). lal adopted it; genie/fae have not; `lal/providers/` + `fae/extract-tool-calls.js` are orphaned but not deleted; the shared loop/observer/reflector/system surfaces weren't lifted (agentry grew code-mode/git-loop/eval instead).
   - **Memory** got daemon `Mount`/`ScratchMount` (`daemon-mount`) and a genie `workspace-mount` via a new `vfs-mount.js` adapter — but the pet-store shape wasn't taken, VFS/`safePath` weren't retired, and FTS5 didn't graduate to a `memory-index` capability. Separate `@endo/agent-tools` + `@endo/platform/fs/extended` seam appeared.
   - **Scheduler** daemon graduation is in flight on **PR #609** (`interval-scheduler.js`, `interval-scheduler` formula, `interval-tick` mail) — but under the `interval-scheduler` name rather than the `scheduler` name this design settled on; I flagged the name/lineage reconciliation as an explicit pre-merge decision.
   - Enumerated the remaining backlog in dependency order.
   - Updated `endoclaw-timer.md` supersession note and `designs/README.md` index rows/dates/totals/off-roadmap note to cross-reference `agentry-agent-builder`, `endo-agent-tools`, `daemon-mount`, and PR #609.

3. **Acknowledged** the maintainer's comment (🚀 reactji) and posted a refresh summary comment.

**Verification**: all sibling-design links resolve on the head; no conflict markers remain; PR diff is the 4 design files. CI is pending (standard endo matrix, freshly triggered) — the change is pure markdown under `designs/` with no code and no changeset needed, so no CI impact is expected; I did not block on the ~15-min matrix.

**Follow-ups for the maintainer** (surfaced in the docs, not actioned): settle the `interval-scheduler`-vs-`scheduler` name when #609 merges; decide whether #609 lands *as* the `scheduler` realization or continues under the `endoclaw-timer` banner; resolve the memory shape (pet-store vs Mount-backed) and graduate FTS5.
