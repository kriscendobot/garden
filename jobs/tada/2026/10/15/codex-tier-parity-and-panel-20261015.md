Landed `cbef9daad7e` on `main2`.

- Added OpenAI myrmidon models: Luna and Mini. Terra remains the minion fallback; GPT-5.5 remains minion.
- Added a shared provider-aware panel runner for seats, gates, foreperson, and appellate. Anthropic behavior is preserved; Codex uses cleric-equivalent sandbox, model, normalized effort, stdin, and schema flags.
- Enabled clerics to claim 10,800-second panel stages. Gauntlet quota admission now considers Anthropic and OpenAI.
- Added provider to durable panel records and resume keys. Cleric panels intentionally use a different model family while preserving seats and the disposition rubric.
- Codex lacks nested `--max-budget-usd` and merged usage accounting; this is logged, with the enclosing stage wall retained as the bound.
- Evidence followed the OpenAI Docs skill’s official-doc-first procedure. No public documentation matched these fleet slugs; live Codex 0.162.1 and the recorded provider catalog distinguish balanced Terra/frontier GPT-5.5 from fast Luna/small cost-efficient Mini. Existing Mini reputation was positive but too sparse for comparative ranking.
- Tier audit: Anthropic and OpenAI are complete. Fireworks lacks mentat; Moonshot lacks mentat/minion/myrmidon; local, Ollama Cloud, and stable OpenRouter lack mentat/mentor/myrmidon. OpenRouter promo is dynamic and has no static four-tier inventory.
- Tests passed: all panel tests, gauntlet 97/97, quota 8/8, provider runner 8/8, seat tiering 18/18, claim eligibility 4/4, panel records 35/35, resume 17/17, model routing 32/32, tier vocabulary, handler budgets, monk tier serving, and affected seat gates. ShellCheck, `bash -n`, and `git diff --check` passed. The live-state-coupled worker-spine suite encountered the unrelated current Anthropic quota condition; the changed claim path is covered hermetically.
- Self-improvement: `skills/panel/SKILL.md`; documented that direct panel tests must pin the provider to prevent a cleric environment from bypassing stubs and making live Codex calls.

Follow-ups: none required.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/codex-tier-parity-and-panel-20261015.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1808s

<!-- garden-usage-end -->
