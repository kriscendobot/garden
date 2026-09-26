All three journal edits are on the tip, the PR is open, and my inbox is empty. The work is complete.

## Completion report

**Job:** Record the maintainer decision to defer synchronous import, and plan the follow-on proposal work.

### Task 1 — Charter item updated (journal)
In `journal/projects/proposal-compartments/README.md`, the Node.js-viability item **"Both TLA and non-TLA evaluation paths"** was rewritten from an open shortfall ("Maintainer decision requested…") into a **recorded deferral** (kriskowal, 2026-08-17): synchronous evaluation is deferred out of the minimal Compartments surface; anticipated future shape is `compartment.importNow` (method) + `import.now` (syntax), carried by a named successor. The checkbox stays `[ ]` (the minimal surface still provides no synchronous path) but the item is explicitly no longer awaiting a maintainer. Landed via `land-journal-edit.sh` with a base-blob CAS.

### Task 2 — Spec editorial change (PR, not "no change")
The decision affirms the current async-only semantics, so no *normative* spec change was needed. But `spec.emu`'s Node.js Viability Status annex was **factually stale**: it still marked the row **"Shortfall"** and carried a paragraph reading *"Maintainer decision requested… That is the only unresolved choice in this increment."* I made the smallest edit that keeps the annex honest — row **Shortfall → Deferred** with the successor shape named, and the stale paragraph replaced with the recorded deferral (leaving the open one-vs-pair sequencing question to the follow-on). The `Error separation` row was left untouched per the job. Strict `npm run build` renders clean. Opened as **draft PR kriscendobot/proposal-compartments#4** via `ensure-pr.sh` (carries the durable garden-job marker).

### Task 3 — Follow-on proposal plan (journal)
New file `journal/projects/proposal-compartments/deferred-synchronous-import.md` presents both shapes without picking:
- **Option A** — one proposal (`compartment.importNow` + `import.now` as Compartment operations) stacked on the Compartment core: fastest, single artifact, but binds sync import to Compartments and risks a later reconciliation anyway.
- **Option B** — a pair (general synchronous import first, then Compartment reconciliation): matches the real dependency structure, debatable on its own merits, but more to shepherd.
- The hinge — whether synchronous import is independently motivated outside Compartments — is analyzed, with a preliminary lean toward B (host `require(esm)`/interop demand predates and exceeds Compartments), explicitly flagged as a maintainer choice, not a decision made alone.

### Task 4 — Standing constraint recorded (journal)
Added a **"Standing design constraints"** section to the project README recording that **dynamic loader registration is unsound** (race between registration and loading can corrupt already-committed cache keys), binding on any future loader API (the deferred base-defaults item, or the open error-separation work), independent of the sync-import deferral. Placed where a future designer reading the project charter will find it.

### Follow-ups
- PR #4 is a **draft** awaiting maintainer review; it is a docs/annex editorial change, so I left it draft rather than running the gauntlet or un-drafting.
- When the deferral is promoted, the plan doc's "Next actions" call for the maintainer to pick Option A/B before any successor proposal repo is scaffolded.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/proposal-compartments-defer-sync-import.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 53 tokens (1707228 cached reads)
- Output: 19033 tokens
- Cost: $1.9341909999999998
- Wall-clock: 333s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
