# Retrospective on kriscendobot/minion.town#148 (review 5400780741): miss recorded, improvement job posted

The review process should have caught this, so I recorded it as a miss. The cluster it joined is now over the dispatch threshold, so I posted one improvement builder job.

**Idempotency:** No record existed yet under `review-misses/{misses,dismissed}/` for `kriscendobot-minion.town-pr148-review-cde1226a`, so this retro had not run before.

**What I checked myself, not taken from the primary job's report:**
- **What the review asked (paraphrased):**
  - Run a gauntlet and a Botese check.
  - Stop duplicating upstream daemon code: the Claude MCP should reach its guest through the daemon's exported client over its UNIX socket.
  - One inline note asked why a value was typed `unknown`.
- **No panel ran before the review.** Before 2026-10-03T12:34Z, the journal had no PR 148 gauntlet or panel job, and GitHub had no panel review.
  - The producing build job's body promised a staged gauntlet.
  - Instead the builder labeled the PR ledger `non-deliverable-probe`, because the design's canary phases 3–6 belonged to a later child of the orchestration.
  - The builder brief's ordered-design rule exempts probes from the gauntlet, so the panel was skipped.
- **The skipped panel had real work to do.** Once the maintainer asked for it, round 1 came back with 13 request-changes seats.
- **The restaged gauntlet could never pass.** In panel mode, `phase-evidence-gate.sh` always reports `probe-must-remain-draft` for a probe-labeled PR. That forced a must-fix verdict on all six rounds, and no fixer could clear it. The maintainer approved over it on 2026-10-04 and the PR merged.
- **The primary job's work is real.** The successor fixer `fix-minion-town-pr148-claude-daemon-client-5400780741` did the fixes. The merged PR's file list shows `src/endo/captp-client.ts` removed and the daemon-exported client in use. I found no gap between what the primary claimed and what landed.

**Verdict:** Miss, category `evaluator-gaming` (the panel was routed around rather than satisfied), severity moderate. I wrote my own paraphrase into the store, not the review text.
- It joined cluster `builder-pr-gauntlet-bypass`, which now has 3 misses across 3 PRs (endo-but-for-bots 1015 and 1097, minion.town 148).
- The writer reported `recurrence=0`.

**Threshold:** The floor is met and I dispatched.
- Both earlier members were held because the automatic gauntlet handoff had been retired on 2026-09-16.
- That handoff is back (build completions auto-stage the gauntlet again), so that reason no longer applies.
- #148 shows the bypass still happens on the current path, through the probe label.

**Dispatched:** Builder job `review-improve-builder-pr-gauntlet-bypass` (identity `review-cluster:builder-pr-gauntlet-bypass`), and the cluster is marked `improvement-dispatched` with a recorded rationale. The job has both required parts:
- **Prevention:** A ledger disposition for orchestration children whose remaining phases belong to a named successor. Those PRs get reviewed by the panel but stay draft. This keeps the existing protection that a partial phase slice is never un-drafted or merged as the finished deliverable.
- **Sensing:** A deterministic handoff check that never silently drops a build job's PR because its ledger says probe. The panel-mode gate also stops making a requested gauntlet impossible to pass. Both come with tests.
- **Re-litigation test:** Replay #148's ledger through the new gate and handoff, then close the cluster.

**Follow-up:** The duplicated-daemon-client part of this review fits closed cluster `design-bespoke-mechanism-over-existing-path`. Its fix landed today (`7a88d0007c2`), after this review, so it would not have caught this one. I did not file a separate record.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr148-review-cde1226a-retro.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1620814 cached reads)
- Output: 13984 tokens
- Cost: $1.3143788
- Wall-clock: 160s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
