Panel stage complete.

## Completion report

**Job:** endojs-endo-but-for-bots-pr717-gauntlet PANEL round 1 (PR #717 — "design: promise debug view for long-pending and unsubscribed-rejection promises").

**What I did:**
- Resumed after 4 prior reaper requeues. Prior sessions had launched the panel in the background, but the panel process was killed each time the agent session was torn down (all seats stuck `pending`, no aggregate produced). This time I ran the panel in the **foreground** so the session stayed active until it finished.
- Set up an isolated project worktree of the PR head (`design/promise-debug-view`, head `b0292dafa`).
- Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode against the real merge-base SHA `cc41f42e2` (per the base-normalization gotcha), a design-kind panel over the 2-file/380-line diff. Seats: copyeditor, critic, decomplector, ergonomist, novice, pedant, skeptic — all completed.
- Disposition: **must-fix** (panel exited 0).
- Posted the aggregate as a `gh pr review` on PR #717. `--request-changes` is rejected by GitHub (the PR is authored by our own bot `kriscendobot`), so I posted a **comment review** carrying the aggregate and the `disposition=must-fix` marker — review `#pullrequestreview-5104668528`.

**Key findings the panel surfaced (for the next fix stage):**
- The design leans on `designs/pass-style-promise.md` as a "parent" contract but uses the wrong primitive names — it says `subscribe`/`onFirstSubscribe`/`unsubscribed-rejection` where the merged parent uses `listen`/`onFirstListen`/`unlistened` (the parent explicitly rejected `subscribe`). ~47 mismatched references and a cited section that doesn't exist.
- `onFirstListen` is an optional producer-supplied callback, not an always-on tracked signal, so the "no new plumbing / Phase 2 = S" premise is unsound.
- Entry Shape correlation across GC relies on `carrierRef: WeakRef`, which is dead exactly when the FinalizationRegistry callback needs it — needs a stable id key.
- The parent design file is absent at this PR's base (branch predates the parent landing on `llm`); dead links today — rebase onto current `llm` before merge.

**Follow-ups:** none from this stage — I ran exactly one panel round and stopped (no fix, no un-draft, no loop), as the gauntlet stage requires. The must-fix verdict is now the recorded stage result for the next gauntlet stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr717-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 1 host(s)
- Input: 58 tokens (1915702 cached reads)
- Output: 11371 tokens
- Cost: $1.9595859999999998
- Wall-clock: 516s
- Model(s): claude-opus-4-8 ×7

<!-- garden-usage-end -->
