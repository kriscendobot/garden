Panel round 2 complete. Verdict posted as a review on the PR.

## Completion report

**Job:** Gauntlet PANEL stage, round 2, for endojs/endo-but-for-bots PR #997 (`design(daemon): reassess worker retention, revocation, and the batch-flush retention root`).

**What I did:**
- Resolved the PR head (fork `kriscendobot/endo-but-for-bots`, branch `design/worker-retention-and-revocation`) and set up an isolated project worktree at the PR head (`5445ad950`).
- The PR is a design-only change (943-line `designs/worker-retention-and-revocation.md` plus a `designs/README.md` tally update). Diff base = merge-base with upstream/llm, `16fa8ebcc`.
- Ran the panel in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`). It sensed a **design panel**, fanned 8 seats (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice), aggregated, and decided.

**Disposition: must-fix** (panel.sh exited 0 — it decided cleanly, so this stage did not fail).

**Posting:** A `--request-changes` review is rejected by GitHub on our own bot's PR ("Can not request changes on your own pull request"), so I posted the aggregate as a `gh pr review --comment` with the disposition explicitly marked **must-fix** at the top.

**Key must-fix themes** (for the next fix stage):
- **critic / decomplector / skeptic:** internal contradiction on whether `op:gc-exports` / wire messages are authoritative (Thread 3 vs Q4); a fourth uncounted zero-refcount window at question-resolution; DD3/DD4 "universal test" overclaim; `WorkerDiscipline` complects independent concerns and should be a sum type, not a validated grid.
- **skeptic:** code-citation defects — `lookupById`/`storeIdentifier` already expose formula-ID redemption (DD2 confinement claim vacuous); CapTP tables seam does not supply what the Dependencies row claims.
- **novice:** `formula` never defined though load-bearing; no thread roadmap; Thread 2 has no worked example.
- **copyeditor / pedant:** `saboteur`/`doc` voice leaks; em-dash + `→`/`…`/`✅` style violations; `-ly` hyphenation; inconsistent citation form; `designs/README.md` shows two contradictory same-dated design totals (151 vs 152).

**Changed:** nothing in the garden repo or the PR source — this stage reviews and posts a verdict only (no fix, no un-draft, per single-round contract).

**Follow-up:** the gauntlet's next stage (fix-loop) owns addressing the must-fix items.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr997-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 23 tokens (522338 cached reads)
- Output: 4703 tokens
- Cost: $0.805277
- Wall-clock: 293s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
