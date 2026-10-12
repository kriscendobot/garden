Panel round 3 on kriscendobot/garden-book PR #8 came back **must-fix**. `panel.sh` exited 0, so this is a real verdict, not a sensor failure.

- **Setup:** made an isolated checkout of `kriscendobot/garden-book@book-reader-exposure-copyedit` at head `b044f89`. Ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh` against the PR's base SHA `e6f2790`. The run is logged at `panel-runs/kriscendobot-garden-book-8/c8acfa714642.md`.
- **Seat results:** 20 approve, 12 comment-only, 1 request-changes (scribe).
- **The one blocking item (scribe):** the supervisor's review 5495588201 asked for a fix and nothing has been pushed for it yet. The fix is to correct the `master` claims in:
  - ch1 §1.1 (`chapters/ch1-philosophy-history-metamorphosis.md:112`)
  - ch7 §7.2.4 (`chapters/ch7-procedures-workflows.md:345` and `:881`)

  The new text should tell apart the fork's `llm` integration branch, the frozen `master-<sha>` review bases, and the upstream destination. The historical maintainer quote stays as history. That fix push should also post a top-level summary comment. The comment should give the head SHA, what changed, what was declined, and deferred items such as the "2026-09-30 example" label for the config tables.
- **Non-blocking:** the assessor asked to confirm that the ch8 §8.7 claim that the accountant has shipped is backed by garden `main2`. It also flagged one long line to rewrap.
- **Review posted:** I posted it as a COMMENT review with the full aggregate, at 2026-10-12T20:39:15Z. GitHub refuses request-changes on the bot's own PR, so the body states the must-fix disposition, as in rounds 1 and 2.

I did no fixing and did not un-draft the PR. The next step is the gauntlet's fix loop.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-book-pr8-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (952612 cached reads)
- Output: 4843 tokens
- Cost: $0.7898623999999999
- Wall-clock: 187s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
