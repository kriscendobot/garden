## Completion report: build-minion-town-codex-api-key-inference-20260923

I opened draft PR https://github.com/kriscendobot/minion.town/pull/115 with an OpenAI API-key backend on the shared inference seam and a gap report. **No OpenAI API key was available, so no request has reached OpenAI.** Everything up to the network call is tested, including a real HTTP round trip to a local stub server. Local build, typecheck and tests pass (447 passed, 5 skipped), and CI passed (test plus Claude harness amd64 and arm64). The PR stays draft, per the gap-revealing-build skill.

- **Branch:** head `codex-api-key-inference` at `c227a33`, on the frozen base `main-3062124` (a snapshot of current `main` that I pushed).
- **Flag:** the backend sits behind `ENDO_INFERENCE_BACKEND=openai-responses`. When it is unset, nothing mounts and no provider is called.
- **Deployment:** nothing is wired into deployment, so production cannot turn this on by accident.

**Which path confines better.** I measured both.
- **Codex CLI:** I pointed `codex exec` at a local stub server, with a throwaway home directory and no key. By default it offers the model a shell, image viewing, sub-agents, goal tools and web search. It took 15 `--disable` switches to get down to one tool (`request_user_input`); attaching the guest's MCP server adds 3 MCP resource tools. That is a denylist, and a later version can add a new default-on tool. Following the job's stop-and-report rule, I did **not** build a CLI backend. `dev/codex-cli-tool-surface-probe.sh` reproduces the evidence.
- **Responses API (built):** the model can call only the guest's own tools, which are declared as functions. The backend runs every call in process against that guest. It refuses any tool name it did not declare, and ends the turn if a built-in provider tool such as web search appears. No process is spawned, no filesystem is exposed, and the key goes only into the `Authorization` header.

**What changed in the repo:**
- The #105/#106 seam now lives in a provider-neutral `src/endo/inference/`. I widened it without breaking the existing shape: a `rate-limited` result, a `budget` limit, and usage data on success.
- A provider-neutral token broker, per-turn inference lease and telemetry sink, shared across providers. The secret never crosses the seam, admission is checked before any request, and each turn emits one usage record keyed by the guest's formula identifier.
- The `infer` tool is added to the tool-name manifest.
- New scripts: `dev/openai-infer-demo.ts` runs a live demo once a key exists.
- 16 new tests.

**Cost and rate limits.** These rest on list prices I have not checked against the live price page. A typical guest turn costs about $0.005 on `gpt-5.1-codex-mini` (the default) and about $0.026 on `gpt-5-codex`. The Codex CLI would add about 2.5× the input cost. Rate limits map to `rate-limited`; running out of credit maps to `unavailable`.

**Gaps (9, all in the PR body and `designs/codex-api-key-inference.md`):**
1. No key. A live run needs a capped, project-scoped key limited to Responses write and Models read, and never the fleet's `codex login`.
2. The seam now exists in three drafts, and the `ENDO_CLAUDE_ENABLED` flag used by #105/#106 collides with #87 on `main`.
3. Codex CLI confinement is denylist-only, so the CLI was not built.
4. The broker's key source and ledgers live in one process and reset on restart.
5. Spend is attributed to a guest, not to a payer or the existing Stripe credits.
6. The budget is enforced after each model round trip, and the rate card is unverified.
7. Guest content goes to a third-party provider and falls under its data retention.
8. Messages from other principals can steer a turn into acting with the guest's own authority. This applies to every backend.
9. No test against a real daemon yet.

I also added six findings for the Endo item-4 design. The central one is to define confinement by what the model can act through (functions the host runs against the guest), rather than by a confined process.

**Follow-ups for the maintainer:**
- Land `src/endo/inference/` on its own, then rebase #105/#106 onto it.
- Supply a capped test-project key and run `dev/openai-infer-demo.ts` once.
- Decide gaps 3, 4 and 5 in the Endo design.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-codex-api-key-inference-20260923.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 106 tokens (6429256 cached reads)
- Output: 73052 tokens
- Cost: $4.1638592
- Wall-clock: 982s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
