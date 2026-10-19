**Reset-credit watch, week of 2026-10-19: done. It needs a maintainer decision within about 24 hours.**

**Recommendation sent to the maintainer inbox:** reset codex-endolin on **Tue 10-20, daytime PT**, once it reaches about 90%.
- At the current pace (~20% a day) it gets there around 10-20, 13–15Z.
- Its natural reset is 10-23T03:51Z, so a Tuesday reset gains about 2.5 days.
- No acceleration is needed.
- No credit is at risk of expiring unused.

The message also gives a one-line status for every subscription. I sent a second one-line message to fix a day name (I wrote "Mon 10-20"; 10-20 is a Tuesday).

**Inventory change (landed on journal2 with `land-journal-edit.sh`):** I updated `projects/garden/reset-credits.md`.
- **codex-endolin:** the maintainer reported a manual reset at 10-16T03:51Z, three days after its ~10-13 natural reset. I recorded that as using the credit that expires 10-29, which leaves **one credit (expires 11-06)**. This is an inference, and I asked the maintainer to confirm it.
- **claude-oros:** the entry still said "offline since 09-28", but its meter shows it in use (74%). I marked its credits as unknown and treated them as none, and asked the maintainer to confirm.

**Other findings:**
- **claude-endolin1 has no credit and will cross 90% before its natural reset.**
  - The live meter says 60%, but its 263M tokens would be about 85% against the ~310M cap the maintainer's dashboard checkpoints imply.
  - At ~23% a day it crosses 90% around Tue 10-20, ~20Z, well before the Fri 10-24T03:00Z reset.
  - I flagged it for a dashboard check and a possible brake.
- **The calibration check wouldn't run:** `fit-quota-calibration.sh --dry-run` only printed "bad host", with or without a subscription argument. I worked from the live meters and the maintainer's dashboard checkpoints instead. The script probably wants a different argument form, which is worth a look.

I changed no budget pools, backoff, worker counts or reset events.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/reset-credit-watch-20261019-160508.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (841005 cached reads)
- Output: 6858 tokens
- Cost: $0.7790649999999999
- Wall-clock: 88s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
