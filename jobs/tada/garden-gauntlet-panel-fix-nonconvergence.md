Inbox empty. The investigation is complete.

## Completion report

**Job:** Investigate why the gauntlet panel/fix loop repeatedly fails to converge; recommend a fix.

**What I did.** Read the gauntlet driver (`scripts/jobs/gauntlet.sh`) and panel state machine (`scripts/jobs/gardening/panel.sh`, `sense.sh`), then read the actual journal stage records — all 13 tada reports (clean/panel-1..6/fix-1..6) for four gauntlets (#995, #997, #286, #1019), the maintainer halt messages, and the disposition/base-ref logic. Encoded the finding as `designs/gauntlet-panel-fix-nonconvergence.md`, committed and pushed to main2 (`ae8bb0aded`).

**Verdict: (a) — the panel keeps moving the target.** Not (b): the request-changes count is flat/noisy across rounds, not shrinking, so a cap of 7–8 would just burn two more rounds and halt again. The round-5 and round-6 must-fix lists on #995 share **no items**; #1019 ran a consistent 7-seat design panel every round and still never converged, with `pedant` approving in round 4 then flagging **newly-introduced** em-dashes in round 6 (fix-6 rewrote the doc +207/−113).

**Three mechanical causes.**
1. **Single-blocker disposition, no severity floor** — any one of 7–35 seats' request-changes forces another round; a copyeditor's em-dash blocks as hard as a critic's RCE finding, so all-approve ≈ never happens.
2. **No cross-round memory** — every round is a stateless re-review; deferred/satisfied items resurface, and rewrites create fresh critique surface.
3. **Stale-base panel-kind flips** — `sense_panel_kind` reads the diff against `origin/llm`, which is itself stale in the fork clone (up to ~502 commits → 3431-file diff), so 2-file design PRs get reviewed as 28-seat code panels on some rounds; the prior `origin/llm` normalization fix is documented-insufficient (true base is `upstream/llm`).

**What a halt costs (load-bearing).** Halts are **mostly harmless to the PR**: all fix stages reported `fix=done`, committed, pushed, CI-green — the branch is improved, not dirty. #995 **merged post-halt**. The real cost is tokens (~$51/gauntlet, ~$203 across the four) and a **false-alarm failure** alert (`orchestration-status: halted`), which matters under the active budget pause.

**Recommendation (report-only; maintainer chooses).** Do **not** raise `max_iterations` — it can't fix a moving target. Instead, in priority order: (1) reframe the non-convergence halt as a quiet near-success ("review budget reached, PR improved + CI-green, ready for human merge") rather than a failure; (2) lower default `max_iterations` from 6 to ~3–4; (3) fix base-ref sensing to resolve against the upstream branch so design PRs are never mis-panelled as code; (4) optionally add a must-fix vs should-fix severity floor to the disposition (deeper, overlaps `evaluation-epochs-panel-calibration.md`, wants maintainer calibration). Options 1–3 are safe and clearly indicated; I stopped short of implementing because the cheaper-vs-quieter-vs-stricter choice is a budget/quality tradeoff for the maintainer.

**Aside:** `kriscendobot-minion.town-pr39-gauntlet` is unrelated — its `panel-1` stage was requeued to exhaustion and doomed (never completed a round); infrastructure/flake, not non-convergence.

**Follow-ups:** none owed. If the maintainer picks options 1–3, they're small deterministic edits to `gauntlet.sh`/`panel.sh` that a fixer job can land.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-gauntlet-panel-fix-nonconvergence.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 37 tokens (1328490 cached reads)
- Output: 18641 tokens
- Cost: $1.9286829999999997 (1 engagement(s) unpriced)
- Wall-clock: 292s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
