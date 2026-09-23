---
section: token-threshold-trigger-with-iterative-summary-and-cumulative-file-tracking
source: endo-but-for-bots--llm-designs-endopi-iterative-compaction
topics: [agent-conventions]
status: current
title: The trigger conditions — token threshold + idle, two axes
parent: endo-but-for-bots--llm-designs-endopi-iterative-compaction--token-threshold-trigger-with-iterative-summary-and-cumulative-file-tracking
---

The §Trigger conditions are the *two-axis trigger discipline* that
both Pi and Genie use:

```
contextTokens > contextWindow - reserveTokens
```

Auto-compaction triggers when the active context approaches the
model's window minus a reserve. `reserveTokens` defaults to *16384*
(leaving room for the model's response). Both knobs are
configurable per-host in the settings store.

The §manual side: a `/compact [instructions]` slash command lets
the user trigger on demand with focused intent (*preserve the
bug-hunt thread, drop the API exploration*). The optional
instructions parameter is the *user-directed-compaction* knob.

The Genie observer's *idle-timer* trigger (not in this design's
algorithm but mentioned in the Status section) is a third axis the
implementation already supports. The design's algorithm only
specifies the threshold; the idle trigger is implicit in the
*loop-running-as-background-PiAgent* shape.
