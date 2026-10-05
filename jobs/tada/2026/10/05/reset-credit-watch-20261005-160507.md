I sent one recommendation to the maintainer inbox. It needs a decision within about 36 hours, since both credits are best spent in that window.

**Inventory check:** `reset-credits.md` was not changed. No credit has been used or has expired since the 10-03 inventory, so the file still matches the evidence. The acceleration markers the liaison set on 10-05 (claude2 → 10-06 15:00Z, codex → 10-07 03:00Z) were already there.

**Readings:** from the live meter at 10-05 ~15:33Z, divided by the true-cap estimates from the 10-05 dashboard checkpoints. `fit-quota-calibration.sh --dry-run` printed only "bad host", so I used those checkpoint estimates instead. The percentages are estimates from the meter, so I asked the maintainer to confirm them on the dashboard.

**Recommendation sent:**
- **codex-endolin, about 72%:** reaches 90% around 10-05 22:00Z. Use the credit that expires 10-22 on Monday evening PT (10-06 ~01:00–04:00Z). It is ahead of its marker, so the fleet doesn't need to speed up. The 10-29 credit is for mid next window and is not at risk of expiring.
- **claude-endolin2, about 75%:** reaches 90% around 10-06 19:00–20:00Z, a few hours behind its marker. Use its only credit (expires 10-22) on Tuesday evening PT (10-07 ~00:00–03:00Z). Moving work over from claude1 would help it hit the marker.
- **claude-endolin1, about 69%, no credits:** at its current pace it reaches 100% around 10-06 23:00Z, about 3 days before its Friday reset. That breaks the "90%, never 100%" policy, so it needs to be slowed down or its work moved to claude2 once it passes about 90%.
- **claude-oros:** offline, credits unknown.

I didn't change budget pools, worker counts, the backoff fraction or reset events.

**Follow-up:** when the maintainer confirms a credit was used, log it in the `reset-credits.md` use log, or leave it for next week's watch.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/reset-credit-watch-20261005-160507.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (233191 cached reads)
- Output: 3465 tokens
- Cost: $0.5207302
- Wall-clock: 48s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
