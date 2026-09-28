---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: scholar

Ingest https://github.com/NVIDIA/OpenShell (README, docs, architecture, security model, and source as needed) and report back on how the garden could use it for confinement, in addition to or instead of Docker. Requested by the maintainer (liaison session, endolin-garden2, 2026-09-28).

**Focus especially on masking secrets:** keeping credentials out of an agent's reach while it still does authenticated work.

**Ground the analysis in the garden's current confinement:**
- the `garden` launcher and its container: bind-mounted home and the container guard; see `context/operations/harden-container.md` and the container-hardening probe;
- the fleet `gh` wrapper that pins the bot identity;
- how Claude/codex OAuth credentials live in the shared `$HOME` today (`~/.claude/.credentials.json`, codex auth), readable by every worker;
- AWS/SSM access on some hosts;
- the ferry's separation of maintainer credentials;
- `GIT_CEILING_DIRECTORIES` and the root-repo guard;
- per-job worktrees.

**Answer concretely:**
1. What OpenShell is and what isolation primitives it provides: sandboxing, filesystem, network, process, and any credential/secret brokering or proxying. Say what the trust boundary is and what it assumes about the host.
2. **Secret masking:** can it inject or broker credentials so the agent never sees the raw token? For example proxy-side auth for API calls, `gh`/git over a broker, and OAuth token refresh without exposing the refresh token. Map this against each garden secret class: Anthropic/OpenAI subscription OAuth, the GitHub bot token/SSH key, AWS/SSM, and the journal push key.
3. **Fit:** could a gardener's `claude -p` / `codex exec` handler run inside it per job? What would change in `gardener.sh`, the handlers and the worktree setup? Cover rootless operation, systemd user units and linger, the noexec /tmp, and multi-host.
4. **Compared with Docker as we use it:** what it adds, what it loses, and whether it layers inside or alongside the container or replaces it.
5. Maturity, license, maintenance, platform requirements, and any security caveats or known escapes.
6. **Recommendation:** a staged adoption path (for example, a pilot on one worker kind or one secret class), with the smallest useful first step and what to measure.

Report as a scholar note under the garden's `references/` or `library/` conventions (whichever the scholar role specifies), and summarize in the completion report. Read-only research: install or run it only in a throwaway scratch sandbox, if at all, and never with real credentials.
