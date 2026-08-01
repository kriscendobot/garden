cadence: weekly
last_dispatched: 2026-07-28T22:35:02Z
job_basename_prefix: fu-qwen-model-watch-20260728-180502-1
---
Weekly Qwen model watch. Probe `https://ollama.com/library/qwen3.7` (a 404→200 flip is the trigger to report) and the Hugging Face `Qwen` org listing (`https://huggingface.co/Qwen`) as the primary sources; the Qwen blog is not reliably fetchable, so do not depend on it. Do NOT hardcode a baseline: read the garden's live model routing table and the host's `ollama list` output to determine what the local lane currently serves, and compare that against what the sources show as current. Report only the delta (new releases, and whether the local default is behind), with source URLs.
