---
role: researcher
---

Research an appropriate agent harness for hosted Moonshot Kimi K3 that can dispatch garden jobs and complete tool-using work safely.

Context from the live canary: Moonshot authentication and GET /v1/models succeed; Codex CLI 0.144.3 custom providers use the Responses API; Moonshot returned 404 for POST /v1/responses and its models payload also differs from Codex model-manager expectations. The garden currently routes explicit model: kimi-k3 jobs through scripts/jobs/handlers/cleric-codex.sh.

Evaluate current, maintained harnesses or adapters that support Moonshot Kimi K3 chat completions plus reliable shell/tool calling. Prefer a narrow integration compatible with the existing worker spine, completion sentinel, isolated per-job worktree, resume/session handling, output capture, and reputation metadata. Include primary-source evidence, security and maintenance tradeoffs, a concrete recommendation, exact integration sketch, and a bounded end-to-end canary plan. Do not change production configuration or enable Kimi workers. Complete with a report and send a concise summary to the maintainer inbox so the liaison can report back in this thread.
