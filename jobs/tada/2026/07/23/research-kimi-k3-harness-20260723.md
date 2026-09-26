Research complete. Recommended harness: official Kimi Code CLI, with its Agent SDK optional for event-level approvals and usage capture. It directly supports Moonshot Chat Completions, K3, tool use, headless execution, isolated `KIMI_CODE_HOME`, and persisted sessions.

Integration: add a `kimi-code` handler that reuses `worker-common.sh`; set per-job `KIMI_CODE_HOME`, pass `KIMI_MODEL_*` credentials/model, run `kimi --auto -p`, capture final output to the report, and retain the existing completion-marker/sentinel, worktree cleanup, timeout, and requeue behavior. Keep Kimi explicit-model-only.

Primary evidence:
- https://platform.kimi.ai/docs/guide/kimi-k3-quickstart
- https://moonshotai.github.io/kimi-code/en/configuration/providers.html
- https://moonshotai.github.io/kimi-code/en/configuration/overrides.html
- https://github.com/MoonshotAI/kimi-agent-sdk

Canary: one isolated explicit `model: kimi-k3` job requiring a forced shell tool call and a small committed change; verify captured output and sentinel, then interrupt/requeue to verify session resume and preserved worktree. Assert no deployed-root mutation and no completion without the marker. Do not enable Kimi workers until all checks pass.

No production configuration changed. Sent this summary to the maintainer inbox.
