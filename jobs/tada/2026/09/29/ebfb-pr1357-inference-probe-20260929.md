## Completion report: ebfb-pr1357-inference-probe-20260929

I built a minimal `@endo/inference` seam and a Claude CLI backend, ran 19 real turns on the minion.town production host, and opened draft **endojs/endo-but-for-bots#1369** with the gap report and evidence log. Gates 5 and 6 did not run, and gates 1, 3 and 7 are only partly met, so this is evidence for revising the design, not a pass.

**PR:** head `probe/endo-inference-1357` at `3bce385630`, based on a frozen snapshot of the design branch (`design/endo-claude-inference-backends-7a6d425`). It stays draft and no gauntlet runs. I replied on the #1357 review thread asking for evidence, linking the PR: https://github.com/endojs/endo-but-for-bots/pull/1357#discussion_r4130964936

**What the code does (stacked on #1357):**
- **`packages/inference` (`@endo/inference`):** names no provider. It has guards for the backend interface, the seven result types, and the usage record, plus three add-on layers that wrap any backend: a result guard, one-turn-at-a-time admission per credential, and a usage-record sink. 2 tests pass.
- **`packages/claude` (`@endo/claude`):** the confinement flags, a constructed environment, a parser for the CLI's streamed output, a version-pinned failure table, and `makeClaudeCliBackend`. The backend reads its credential fresh from a secret-manager entry on every turn. 4 tests pass.
- **`packages/claude/probe/`:** the evidence harness (using the real secret manager, in memory), a stand-in guest tool server, and the raw logs. The logs contain no credential bytes.
- A separate `chore: Update yarn.lock` commit. Lint and typecheck were not run.

**Evidence:**
- **minion.town:** 19 real `--bare` turns on the deployed Claude Code 2.1.278, run as the `minion-mcp` user.
  - 13 of 13 write-then-read turns returned `ok`, and each effect was checked by reading the guest's store directly. Median time was 4971 ms (range 3424–8800 ms).
  - Gate 2 (hostile config) passed on the tested set.
  - An invalid second credential was reported as `needs-auth` in 716 ms.
  - A second turn on the busy credential was refused before starting, without blocking the other credential.
  - The wall-clock and max-turns limits each stopped a real turn.
- **Garden host (2.1.280):** 12 turns gave the same results.
- **Gates:**

  | Result | Gates |
  | --- | --- |
  | Pass | 2 |
  | Partial | 1, 3, 7 |
  | Fails, as the design predicts for the interim delivery | 4 |
  | Not run | 5 (no SDK backend), 6 (no broker subscription mode) |

**Gaps: 11 surfaced.**
1. The design's one projection type can't serve the CLI backend.
2. **The most important finding:** the guest's MCP server process inherits `ANTHROPIC_AUTH_TOKEN` from the Claude binary, on both 2.1.278 and 2.1.280.
3. No live Endo daemon guest is available on the host; the probe used a stand-in.
4. The design doesn't say how a credential gets into the deployed secret store.
5. The design puts admission in two places that contradict each other.
6. An auth failure is a two-minute retry loop, not an error response, so the backend has to fail fast.
7. There is no way to capture usage-exhausted or rate-limited failures.
8. The design names a `setup-token`, but only a short-lived access token is reachable headlessly.
9. Nothing the client sees attributes usage to a subscription, and no second subscription is authorized.
10. The comparison (gate 5) is blocked because the SDK path is API-key-only.
11. The recipe doesn't specify the environment variables or a default model.

**Skeleton:** 6 parts implemented, 8 not.

**Credentials and production changes:**
- I used only the authorized credential. It was the short-lived access token from the garden host's Max login (expires 11:45Z today), sent encrypted to a one-time key on the host, so SSM history holds only ciphertext.
- Everything was shredded or removed afterwards on both hosts. The refresh token never left the garden host.
- Nothing about the `minion-mcp` service was changed; `ENDO_CLAUDE_ENABLED` is still unset. These were turns on the production host, not turns through the running service.

**Follow-ups for the maintainer:**
- Confirm that the garden host's Max login is the "kriscendobot subscription" you authorized.
- Decide the design revisions for gaps 1, 2, 4, 5, 6, 8, 9 and 10.
- Consider authorizing a second subscription for gate 7 and a sacrificial one for gate 3.
- Correct the design's deployed version from 2.1.268 to 2.1.278.
- Link #1369 in the design's § Evidence probe, which still says "pending".

I saved a memory note with the probe's findings and the encrypted-transfer recipe.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-pr1357-inference-probe-20260929.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 108 tokens (6860160 cached reads)
- Output: 74625 tokens
- Cost: $4.255515999999999
- Wall-clock: 1063s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
