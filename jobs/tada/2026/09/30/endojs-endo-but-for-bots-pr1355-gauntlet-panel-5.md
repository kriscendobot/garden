I ran round 5 of the panel on PR #1355 and it returned **must-fix**, but I could not post the review. I'm marking this round `panel-error` so the driver retries it.

**What happened**
- **Checkout:** I got an isolated copy of the PR head (`endojs/endo-but-for-bots` @ `design/hardened-url-shim-status-reconciliation`, head `ff0e38fc1`, "address hardened URL shim panel round 4") and compared it against base `origin/llm-47f6965`. The diff touches only `designs/README.md` and `designs/hardened-url-shim.md`.
- **Panel run:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` exited 0 with disposition **must-fix**. All 10 seats ran fresh and none errored:
  - **request-changes (3):** skeptic, copyeditor, pedant.
  - **comment-only (4):** critic, ergonomist, novice. Critic and ergonomist rated their main findings should-fix; novice rated one must-fix.
  - **approve (3):** decomplector, orthographer, thesaurus.
- **Record saved:** the run is recorded in the journal at `panel-runs/endojs-endo-but-for-bots-1355/138021176e4d.md`, keyed to head `ff0e38fc1`. A retry on the same head should reuse this verdict from the record instead of running the seats again.

**Main must-fix findings**
1. **Mixed names in a Complete design.** The document keeps the proposed `%URL%` in its body while the code shipped `%InitialURL%`, and it uses the shipped name for `urlBlobTaming`. Skeptic, novice, critic, ergonomist and decomplector all flagged this. The fix is to rename throughout, or keep all the translation in one table in the Status section.
2. **The `.constructor` pin is missing from the body.** The Design section and Open question 2 still read as proposals, and the test plan does not list the `new URL(...).constructor === URL` → `false` behavior.
3. **Completion claims lack evidence** (skeptic). The merge SHA, the "22 tests" count and the Phase 3 grep need to be cited and reproducible.
4. **Smaller prose fixes:**
   - Copyeditor: the "optional `new URL(` simplification sweep" sentence is unclear.
   - Pedant: file paths in the Status section are not relative to the design file.
   - Novice: the Status section uses terms before the body defines them.

**Why the verdict isn't posted**
`gh pr review --request-changes` failed with "GraphQL: Resource not accessible by personal access token (addPullRequestReview)". On host `oros-studio-garden-ce242c49` the bot token has no pull-request write access on the `endojs` org. That is a known limit of this host, not a panel decision. Rounds 2–4 were posted as COMMENTED reviews, so a retry claimed by a host with write access (the endolin host) should succeed. The review body I prepared is at `scratch/panel-1355-r5-body.md`.

**Follow-up:** the lasting fix is to grant the bot's fine-grained token pull-request read+write on `endojs`. Until then, gauntlet panel stages claimed on this host cannot post their verdicts.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1355-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (554829 cached reads)
- Output: 3836 tokens
- Cost: $0.5826698
- Wall-clock: 1017s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
