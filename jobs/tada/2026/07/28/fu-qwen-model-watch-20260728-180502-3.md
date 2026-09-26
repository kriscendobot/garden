Inbox empty, worktree clean.

## Report

**What I did.** Replaced the body of the `qwen-model-watch` weekly schedule on `journal2` via `scripts/jobs/set-schedule.sh qwen-model-watch weekly qwen-model-watch <body-file>` (cadence `weekly` and `last_dispatched: 2026-07-28T18:05:02Z` preserved; CAS push accepted). No `main2` changes were needed — this is journal state only.

**What changed in the body:**

- **Sources.** `https://qwen.ai/blog` is demoted from "the source" to an explicit anti-source. The new primaries are the **ollama library** (`https://ollama.com/library`, Qwen slice `https://ollama.com/search?q=qwen`, plus per-model `/library/<name>` and `/tags` pages) and the **Hugging Face `Qwen` org** (`https://huggingface.co/Qwen`, browsed by most-recently-updated). Ordered deliberately: ollama first (no tag → not harnessable), HF second (catches announced-but-untagged releases — the "watch" column).
- **Baseline.** The hardcoded "currently serves **qwen3.6**" premise is gone; the body now names *no* model. The runner must establish the baseline each run from `scripts/jobs/set-model-routing.sh --show` (journal `config/model-routing` over the tracked `model-routing-defaults.tsv`) **and** `ollama list`, must state that baseline as the first line of its report, and is told to say so plainly rather than invent if ollama is unreachable. The failure is named inline so a future editor doesn't reintroduce it.
- Report shape updated to require the baseline line and to judge candidates "against the baseline" rather than against a literal tag; hardware/GTT/MoE guidance and the "nothing new is a fine outcome" clause kept.

**Verified fetchability before recommending** (this was the whole defect): `ollama.com/library` and `ollama.com/search?q=qwen` both return real content (the Qwen slice lists `qwen3.6` at 27b/35b, `qwen3.5`, `qwen3-vl`, `qwen3-next`, …); `huggingface.co/Qwen` returns dated recent models. `qwen.ai/blog` fetches as the bare word "Qwen" — a client-side-rendered shell with no post list, confirming it was unfetchable.

**Follow-ups (not in scope, flagged):**

1. The tracked routing table's `local` default is `qwen3:0.6b`, and this instance has **no** `config/model-routing` override — yet the 2026-07-21 report claimed the live hermit was `qwen3.6:latest` (23 GB). One of those is wrong. The new body will surface the discrepancy on the next tick, but a maintainer may want to settle it now with `set-model-routing.sh`.
2. `ollama list` failed in my container ("could not connect to ollama server"), so the baseline step will degrade to the routing table alone unless the ollama server is running where the tick lands.
3. The prior tick's job `qwen-model-watch-20260728-180502` is still sitting in `jobs/doin/` with an empty work dir — worth a look if it wasn't reaped.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-qwen-model-watch-20260728-180502-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 393 tokens (925217 cached reads)
- Output: 10022 tokens
- Cost: $1.2704075
- Wall-clock: 170s

<!-- garden-usage-end -->
