Landed `designs/non-claude-completion-nudge-parity.md` on `main2` at commit `5b002b64606`.

The design concludes all three handlers support same-session continuation. It recommends bounded nudge parity for Codex, Kimi, and OpenCode, while keeping OpenCode disabled pending its existing paid canary.

Verification:

- OpenCode harness: 9/9 passed.
- Kimi harness: 33/33 passed.
- Codex resume handling: 7/7 passed.
- Pre-push probes: 10/10 passed.
- Broad checks found one unrelated, pre-existing `CLAUDE.md` inventory omission.

Follow-ups: none for this design-only scope.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-nudge-continue-handler-parity-20260929.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 410s

<!-- garden-usage-end -->
