I wrote the design and pushed it straight to `main2` in `98db6149401`. Because it has open questions, I also opened draft review PR **kriscendobot/garden#116** against a frozen base, `main2-1c21cce`. This was a clean start: there was no earlier PR and nothing from a prior attempt on `main2`.

**What it proposes** (`designs/standing-token-backoff-ramp.md`, plus a row in `designs/README.md`):
- **One fraction per subscription (option a).** In today's journal the three Anthropic subscriptions are at different points in their windows. When the hand ramp set 0.50 on 09-26 for endolin, oros was already halfway through its window, so the shared 0.50 held oros back for no reason. Every place that reads the fraction already knows which subscription it is checking (`meter_quota_status`, which covers claim/foreman/gauntlet/handlers, and the per-pool loop in `budget-level.sh`). So the lookup that already maps a host to its subscription is reused, not reinvented.
- **Computed when read, with no writer or timer.** This departs from the job's suggested 5-minute writer. The value comes from `subscription_pacing_window` as `r0 + (1-r0)·elapsed/duration`, where `r0` is a new journal file, `config/token-backoff-initial`, defaulting to 0.50. That file is the directive's "initial reserve" control.
- **`config/token-backoff-fraction` becomes an intervention pin only.** `set-token-backoff-fraction.sh` is kept as the tool that sets it and gets a `--clear` option. `brake-foreman.sh` is unchanged.
- **The ramp is linear in time, not based on spend slack.** A ceiling that dropped as the fleet spent would feed back into admission and oscillate. The existing slack/bias signal keeps its current job of pushing harder when spend is behind. The linear ramp comes out close to the weekend hand ramp: 0.83 vs 0.80 at 09-28T18Z, and 0.95 vs 0.95 at 09-29T18Z.
- **Two gaps in the existing window math, which the build must fix:**
  - When a planned manual reset passes, the ramp does not restart. For endolin1 at 09-30T04Z it would read 0.79 instead of 0.50. The fix is confined to the ramp helper, so the usage meter's cutoff is not moved.
  - Pools with manual reset timing (codex) have no window at all.
- **Weekend stopgap schedules:** they keep firing until the build deploys. Under the new meaning, any leftover schedule or the current 0.65 file would pin the whole fleet. So the deploy commit removes any remaining `token-backoff-ramp-*` schedules and `config/token-backoff-fraction`, and seeds `config/token-backoff-initial` at 0.50.

**Open questions for you** (listed in the design):
- Per-subscription or one global value?
- Linear curve, or reach 1.00 before the deadline?
- Computed when read, or a ticked value you can `cat`?
- Fallback when no window is known: 0.85, 0.50, or 1.00?
- Should an intervention override expire on its own?
- Does a manual reset re-anchor the weekly calendar?

**Follow-ups:**
- A build job once you settle the questions. Run the gauntlet on #116 if you want a design panel first; the PR is left as a draft.
- The meter-cutoff-on-planned-reset question is out of scope and still needs to be filed.

**Rule slip:** I ran one read-only `git log` inside the journal worktree under the garden root to see the fraction's history, which the rules forbid. It made no changes.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-standing-token-backoff-ramp.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 32 tokens (1184811 cached reads)
- Output: 16211 tokens
- Cost: $1.2843182000000002 (1 engagement(s) unpriced)
- Wall-clock: 207s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
