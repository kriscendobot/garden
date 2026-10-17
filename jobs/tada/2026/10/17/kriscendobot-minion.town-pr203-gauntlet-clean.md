CI hadn't finished when the wait deadline ran out, so the clean stage is still pending, not done.

**What happened:**
- **PR #203** (`design/git-remote-s7-bearer-identity-test` → `main-945aaaa`, draft, open, head `78bbbfda8ad`) only changes `designs/git-remote-capability.md` (+49 −2). It touches no code, so there was nothing to measure for coverage and no dead code it could have orphaned. I made no changes and pushed nothing.
- **CI wait:** I ran `ci-wait-merge.sh --no-merge` for about an hour in total. My first run was cut off at about 10 minutes by my own `timeout` wrapper. A second run with a 3000s deadline then exited rc 4 (still pending).
  - `Claude harness (arm64)` passed.
  - `test` and `Claude harness (amd64)` stayed QUEUED with no job ever starting.
- **Likely cause:** this pattern (jobs queued but none running) usually means the ci.minion.town runner is stalled because its token minter hit GitHub's rate limit. That normally clears at the hourly reset. Nothing failed red.

**Follow-up:** re-post this stage with a fresh budget. If `test` and `amd64` are still queued after that, someone should check the ci.minion.town runner and its JIT token minter.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr203-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (456485 cached reads)
- Output: 2325 tokens
- Cost: $0.507309
- Wall-clock: 3649s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
