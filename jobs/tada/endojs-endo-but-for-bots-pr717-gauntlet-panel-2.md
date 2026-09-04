The round-2 verdict is posted. Job complete.

## Completion report

**Job:** endojs-endo-but-for-bots PR #717 gauntlet — PANEL round 2 (design PR: "promise debug view for long-pending and unlistened-rejection promises").

**Re-derived state on resume:** worktree clean; round-1 panel = must-fix (posted 09-03), fix-1 stage ran and pushed head `b0292dafa…86ebf4ae`, syncing wrong-primitive-name fixes, entry-shape/id changes, README roadmap totals, etc. This stage owed exactly one more panel round.

**What I did:**
- Got an isolated project checkout of the PR head `design/promise-debug-view` (head `86ebf4aeeb`) at `/home/kris/garden2/scratch/project-wt-endojs--00f960030565-75c6c86c`.
- Computed the current merge-base against `origin/llm` → `1d91f0d9d` (diff: `designs/README.md` + `designs/promise-debug-view.md`, 450 lines).
- Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` (design-kind, seats: copyeditor, critic, decomplector, ergonomist, novice, pedant, skeptic — all completed). Foreground so the session stayed alive. Disposition: **must-fix** (panel exited 0).
- Posted the aggregate as a `gh pr review --comment` on #717 (request-changes is rejected on our own bot's PR), review submitted 2026-09-04T04:34:30Z, carrying the `disposition=must-fix` marker.

**Findings the panel surfaced for the next fix stage (headline):** the recency-FIFO ring-buffer eviction policy systematically evicts the `delivered:false` unlistened-rejection entries the view exists to correlate at finalization time; the "buffer never retains a carrier" invariant is defeated by the strongly-held `reason` (transitive reachability back to the carrier); `FinalizationRegistry` is assumed present though the repo treats it as optional; `debugView()` on a shared intrinsic is a cross-compartment confidentiality/GC side-channel hazard (cf. `captp/src/finalize.js`); "walk the weak live-set" isn't implementable as written (no enumerable weak collection); and unreconciled in-repo prior art in `ses/src/error/unhandled-rejection.js`.

**Changed:** nothing in the garden repo or the PR source — this stage only reviews. One comment review added to PR #717. Ran exactly one round and stopped (no fix, no un-draft, no loop), per the staged-gauntlet contract.

**Follow-ups:** none from this stage; the must-fix verdict is the recorded stage result for the next gauntlet stage (fix round 2).

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr717-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 28 tokens (636063 cached reads)
- Output: 5715 tokens
- Cost: $1.0457527500000001
- Wall-clock: 506s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
