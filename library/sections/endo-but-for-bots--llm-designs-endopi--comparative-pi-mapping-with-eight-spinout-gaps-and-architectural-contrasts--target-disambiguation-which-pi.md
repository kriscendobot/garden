---
section: comparative-pi-mapping-with-eight-spinout-gaps-and-architectural-contrasts
source: endo-but-for-bots--llm-designs-endopi
topics: [agent-conventions, capability-security]
status: current
title: Target disambiguation — *which Pi?*
parent: endo-but-for-bots--llm-designs-endopi--comparative-pi-mapping-with-eight-spinout-gaps-and-architectural-contrasts
---

The §Target disambiguation block rejects four alternatives:

- **Inflection AI's Pi** (consumer chatbot — no capability surface)
- **Forks/ports** (`tibormester/pi-harness`, `werg/pi-harness`,
  `davidondrej/pi-agent`, `Dicklesworthstone/pi_agent_rust` — covered
  by mapping the canonical upstream)
- **`can1357/oh-my-pi`** (downstream skin; out of scope but a
  packaging precedent if Endo ever ships pi-style extensions)
- **`earendil-works/pi`** (the public mirror; same content as
  `badlogic/pi-mono`; both cited interchangeably in pi's own docs)

The chosen reference is `badlogic/pi-mono`: 4100+ commits, ~49.5k
stars, MIT, shipping at v0.74.x as of 2026-05-15. The maintainer's
prior reference [`endoclaw`](../concepts/endoclaw.md) already cites *Pi-compatible
jsonl files* as the desired session-persistence shape (see
endoclaw §Persistence and Memory), consistent with pi-mono being the
intended target.
