---
handed-off: build-endo-claude-backends-1357-open-pr
deliverable-complete: false
---
I built phase 2 (`@endo/claude`'s CLI and Agent SDK backends) and pushed it, but could not open the draft PR from this host. Opening it is handed off to a pinned successor job.

**What's pushed:** branch `build/endo-claude-backends-1357` on `endojs/endo-but-for-bots`, head `d19665933`. It is stacked on the phase-1 PR #1403: the frozen base `llm-80054c3` (same base as #1403), then a `--no-ff` merge of #1403's head `34a4a0b`, then a feature commit and a separate `chore: Update yarn.lock`.

**What the package gains** (new subpath modules in `packages/claude`; the existing #1015 `make()` harness, which `claude-sandbox` uses, is unchanged):
- **`makeClaudeCliBackend`:** one confined `claude -p` per turn. The prompt goes on stdin, the environment is built from nothing, each turn gets its own scratch directory as `HOME` and `CLAUDE_CONFIG_DIR`, and the `--mcp-config` names one stdio server. The deployment supplies that server through an injected `stdioProjection(guest)` power; building the relay itself is left to deployment work.
- **`makeClaudeSdkBackend`:** one Agent SDK `query` per turn, with the guest's MCP server handed over in process. `query` is injected, so the package does not depend on the SDK.
- **Shared parts:**
  - `buildCliArguments` / `buildSdkOptions`: design Decision 3's flags, `--permission-mode dontAsk`, and an exact allow-list with no wildcard.
  - `buildConstructedEnvironment`: a grant may deliver only `ANTHROPIC_AUTH_TOKEN`, `ANTHROPIC_API_KEY` or `ANTHROPIC_BASE_URL`; `CLAUDE_CODE_OAUTH_TOKEN` fails the turn.
  - The stream reducer, which counts model turns by message id.
  - The response-shape table, which ships empty because no failure shapes have been captured yet. Until they are, every failure reports `unavailable`, never `needs-auth`.
  - A Node scratch-directory maker.
- **How a turn runs:** each backend acquires the credential before any work, maps a refusal to its result type, enforces the wall-clock, output-byte and turn limits plus cancellation (the CLI backend kills the whole process group), and releases the grant and cleans up on every path.
- **Changes from minion.town #105/#106:**
  - `dontAsk` replaces `bypassPermissions`.
  - The substring "looks like an auth failure" checks are gone.
  - The formula identifier is no longer sent to the provider (#106 put it in the system prompt).
  - The credential comes from the credential source, not a constructor key.
- A README section and a changeset are included.

**Checks:**
- All 119 tests in `packages/claude` pass, 52 of them new. None needs a credential or a `claude` binary; two run against a real child process using a fake `claude` script.
- I broke the source on purpose in 12 ways, one at a time, and each made at least one test fail.
- Type-check and eslint (no errors; warnings only in test files), the composite build, root prettier, the garden pre-push probes, and the related-design check (clear) all pass.
- I did not complete the full pre-push gates run (lint auto-fix plus probes): it timed out under host load during the repo-wide `eslint --fix`, so I ran the probes alone, and checked lint and types for this package only.

**Fixed along the way:**
- Under SES here, `Uint8Array.prototype.lastIndexOf` returned -1 even when the byte was present, which broke turn counting while a turn was still streaming. I replaced it with a manual scan; the turn-limit test caught the bug.
- The CLI backend now decodes stdout a complete line at a time with `@endo/utf8`, so a character split across two output chunks decodes intact. A test covers this.

**Why the PR isn't open:** on `oros-studio-garden-ce242c49`, `ensure-pr.sh` timed out twice. On this host the search for an existing PR is inconclusive and the bot token gets a 403 on PR creation in `endojs`. Narrow `gh` queries confirmed no PR exists for this job yet.

I posted successor job `build-endo-claude-backends-1357-open-pr` (confirmed in `jobs/todo` on `journal2`), pinned to `endolin-garden-ece02cb4`. Its only task is to run `ensure-pr.sh` with this job's base, so the PR carries this job's marker, and the full PR body is embedded. The body has a phase-accounting table and a related-design marker for #1403, #1102 and #1369.

**Follow-ups:**
- The stdio relay that serves `buildMcpServer()` to the `claude` process (#1369 Gap 1) is still deployment work.
- When #1403 merges, a weave reduces the stack.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-backends-1357.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 28 tokens (4003087 cached reads)
- Output: 6386 tokens
- Cost: $11.959742200000004 (1 engagement(s) unpriced)
- Wall-clock: 10385s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
