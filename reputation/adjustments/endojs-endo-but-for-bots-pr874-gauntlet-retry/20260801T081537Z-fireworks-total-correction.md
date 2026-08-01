---
base: endojs-endo-but-for-bots-pr874-gauntlet-retry
agentic_dollars: 0.79
agentic_cents: 79
source: maintainer-authoritative-fireworks-total-5700-cents
allocation_batch: fireworks-total-correction-20260801
duration_secs: 420
weight_method: duration-secs-wallclock-share
confidence: high
---
Append-only cost correction. The maintainer states the collective cost of all
Fireworks work completed to date is $57.00. This batch allocates that
authoritative total across the 42 Fireworks engagements present in jobs/tada/
(glm-5p2, deepseek-v4-pro, and the fireworks-unconfigured arm), weighted by
duration_secs -- the reducer's own wallclock proxy basis, and the only weight
available for all 42 (just 3 carry usable token counts). The prior wallclock
proxy implied $130.08 in aggregate, more than double the true figure. No raw
event is rewritten.
