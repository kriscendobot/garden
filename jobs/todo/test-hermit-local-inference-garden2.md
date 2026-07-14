---
model: gpt-oss:20b
---
LIVENESS TEST for a **garden2 local-inference hermit** (provider:local, on-box Ollama `/v1`, gpt-oss:20b on the Radeon 8060S). Self-contained -- do NO repo work, NO commits, touch NO PR.

In your completion report state exactly:
1. the **model id and provider** you ran on (expect `gpt-oss:20b` via the local Ollama endpoint),
2. the **host** you ran on,
3. the answer to: **what is 7 x 6?**
4. the literal line: **HERMIT LOCAL INFERENCE OK**

That is the whole job -- its only purpose is to prove a garden2 hermit can complete a job end-to-end on local GPU inference. If the model is not pulled / the endpoint is unreachable, report the exact error so the operator can pull `gpt-oss:20b`.

<!-- garden-reaped: 1 -->
