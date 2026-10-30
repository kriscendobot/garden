**Completion report: `improve-foreman-malformed-repair`**

A malformed foreman reply now gets one repair attempt on the same provider instead of failing the pump right away. Pushed to `main2` as `72a742aacc4`. Both provider test suites pass (foreman: 58/58, mentor: 54/54), and shellcheck reports nothing new.

**Root cause.** The rejected reply captured at `~/.garden-state/foreman/rejected/20261030T001431.008093455Z-openai.txt` was a `MAINTAINER` block with a body but no closing `ENDMAINTAINER` line. That is a format error the provider can fix, but the handler treated it as fatal.

**What changed in `scripts/jobs/handlers/foreman-claude.sh`:**
- **Repair attempt.** When validation fails, the handler still saves the bad reply. It then asks the same provider exactly once more, sending the original prompt plus a fixed `PROTOCOL CORRECTION` paragraph that restates the one-block format. The paragraph is the same every time and inserts nothing, including the malformed reply, so the repair cannot carry injected text forward.
- **Still fails closed.** If the repair reply is also malformed, the handler saves it as `<provider>-repair` and stops with a "malformed … again after one repair attempt" error. If the repair call itself fails or the provider is unavailable, it also stops, and it never moves on to the next provider.
- **Off switch.** `GARDEN_FOREMAN_MALFORMED_REPAIR_ATTEMPTS` defaults to 1. Setting it to 0 restores the old immediate stop, and anything above 1 is treated as 1.
- **Usage accounting.** On the Anthropic route the repair is a second metered call. Its token counts are added to the first call's in `GARDEN_FOREMAN_USAGE_OUT` (marked `repair_attempts: 1`) rather than replacing them. If the two measurements can't be combined, the first one is kept.
- The header comment now describes the repair behaviour.

**Tests:**
- The fake `codex` and `claude` providers can now give a different scripted reply to the repair prompt.
- Subtest 3 now expects the trace `openai openai-repair`, followed by the fail-closed error.
- New cases:
  - an unterminated `MAINTAINER` block is repaired on the same provider;
  - a failed repair call never falls through to Claude and posts nothing;
  - repair can be switched off;
  - an Anthropic malformed reply is repaired on Anthropic, and the repair prompt contains the fixed correction but not the bad reply;
  - the repair's usage is added to the first call's.

**Follow-ups:** none required. Hosts pick this up on their next deliberate deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-foreman-malformed-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (982629 cached reads)
- Output: 11977 tokens
- Cost: $1.0250658
- Wall-clock: 208s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
