---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
---
# Open the draft PR for build-endo-claude-backends-1357 (phase 2 of endo-claude-inference-backends)

The builder job `build-endo-claude-backends-1357` finished the implementation on
host oros-studio-garden-ce242c49, whose bot PAT cannot create PRs on endojs
(403) and whose `ensure-pr.sh` marker scan times out. The head branch is already
pushed: `build/endo-claude-backends-1357` on `endojs/endo-but-for-bots` at
`d19665933dcbdb15558e328306f43e8840b2e15d`. It is stacked as a `--no-ff` merge of
#1403's head plus two commits, on the frozen base `llm-80054c3`, which is #1403's
base too.

Your ONLY task: open the DRAFT PR via ensure-pr.sh using the JOB BASE
`build-endo-claude-backends-1357`, so the marker matches the original job:

    scripts/jobs/gardening/ensure-pr.sh build-endo-claude-backends-1357 \
      endojs/endo-but-for-bots build/endo-claude-backends-1357 llm-80054c3 \
      --title 'feat(claude): add the Claude CLI and Agent SDK inference backends (#1357)' \
      --body-file <file holding the body below, between the markers>

Do not modify the branch. Name the PR number in your completion report, which
stages the gauntlet. If the branch head is no longer `d19665933`, still open the
PR, but report the difference.

----- PR BODY BEGIN -----
## Summary

Phase 2 of [`designs/endo-claude-inference-backends.md`](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/endo-claude-inference-backends.md) (merged in #1357): the Claude core and its two backends over the provider-neutral `@endo/inference` seam. It adds two `InferenceBackend` plugins to `@endo/claude`, each made over one `CredentialSource`:

- **`makeClaudeCliBackend`** (`@endo/claude/cli-backend.js`) runs one confined `claude -p` per turn. The prompt goes on stdin. The process gets a fresh scratch directory as `HOME`, `CLAUDE_CONFIG_DIR`, and working directory, plus an environment built from nothing. The guest's tools reach it through one stdio MCP server, named in a per-turn `--mcp-config`. That server is launched by the deployment's `stdioProjection(guest)` power, following the endo-guest-stdio-mcp shape.
- **`makeClaudeSdkBackend`** (`@endo/claude/sdk-backend.js`) runs one Agent SDK `query` per turn and hands it the projection's MCP server in process (`mcpServers: { endo: { type: 'sdk', instance } }`). The SDK's `query` is injected, so `@endo/claude` takes no SDK dependency and the tests run without the SDK.

The shared Claude-specific parts are subpath modules, as Decision 2 lays out:

| Module | What it holds |
| --- | --- |
| `confinement-options.js` | `buildCliArguments` / `buildSdkOptions`: Decision 3's recipe for both front ends. That is `--bare`, `--strict-mcp-config`, `--setting-sources ""`, `--tools ""` plus a `--disallowedTools` belt, `--disable-slash-commands`, the exact `mcp__<server>__<tool>` allow-list (never a wildcard), `--permission-mode dontAsk`, and optionally `--permission-prompts none`. The CLI argv also passes the existing `assertConfinedArgv`. |
| `constructed-environment.js` | `buildConstructedEnvironment`: `PATH`, locale, a per-turn `HOME`/`CLAUDE_CONFIG_DIR`/`TMPDIR`, three quiet settings, and the grant's credential variables. A grant may deliver only `ANTHROPIC_AUTH_TOKEN`, `ANTHROPIC_API_KEY`, or `ANTHROPIC_BASE_URL`. Anything else fails the turn, including `CLAUDE_CODE_OAUTH_TOKEN`, which `--bare` ignores (Decision 5). |
| `stream-reducer.js` | `makeClaudeStreamReducer`: reduces stream-json stdout or SDK messages to one terminal outcome and maps usage onto `InferUsage`. It counts model turns by distinct assistant message id, so the turn limit applies to both backends. |
| `response-shapes.js` | `CLAUDE_CODE_RESPONSE_SHAPES` (the pinned table) and `turnOutcome`. Each tag has one writer: the limit enforcer's outcome, then the stream's success or turn ceiling, then a pinned row, and otherwise `unavailable`. |
| `scratch-directory.js` | `makeNodeScratchDirectoryMaker`: the Node implementation of the per-turn private directory (`0700`, files written `0600`). |

Both backends:
- call `acquire()` before any work, and map a refusal to the tag of the same name through `admissionRefusalResult`;
- enforce wall clock, output bytes, turns, and cancellation through `makeLimitEnforcer`. The CLI backend kills the whole process group and does not wait for `close`, which a grandchild holding stdout could delay forever;
- release the grant, close the projection, and remove the scratch directory on every path;
- never reject for a turn outcome.

### Differences from the prototypes

Ported from kriscendobot/minion.town#105 (CLI) and #106 (Agent SDK), not from #1015, where they differ, and changed where the merged design requires:

- **Permission mode is `dontAsk`**, not #105's `bypassPermissions` (Decision 3).
- **The allow-list is the exact pinned catalog.** #105 allowed `mcp__guest__*`.
- **The credential comes from the `CredentialSource` grant**, not a constructor `apiKey` or `apiKeyHelper` (Decisions 5 and 7). There is no `--settings` credential path; the settings file is `{}`.
- **No formula identifier reaches the provider.** #106 put it in the SDK `systemPrompt`; the design makes it a host-side label only (§ The facet is the authority). Both backend suites assert that it appears in nothing the process sees.
- **No substring auth heuristic.** #105's `looksLikeAuthFailure` and #106's regex are gone. `needs-auth` comes only from a row of the response-shape table pinned to the running binary's exact version. That table ships **empty**: verification gate 3 has not captured the failure shapes. So today every failure is `unavailable`, which is what the design asks for until those shapes exist.
- **A malformed stream or a second terminal result is `unavailable`**, never a partial success. Both rules come from `@endo/agent-mcp-stdio`'s parser. A success result with a nonzero exit is also `unavailable`.
- **Kind names** are `claude-cli` / `claude-sdk`, with `provider: 'anthropic'`, as `describe()` requires.

### What this leaves to the deployment (and to later phases)

- **`stdioProjection`**: the CLI backend needs a launchable stdio server that serves the projection's `buildMcpServer()`. This is the #1369 "Gap 1" that phase 1 deferred to phase 2. This PR makes it an explicit injected power. Building the relay itself (a harness-owned process outside the confined tree, per endo-guest-stdio-mcp) is deployment work, so it is not in this package. The power's contract says the launcher must close over the projection, never resolve the guest by `formulaIdentifier`.
- **The existing #1015 `make()` harness is unchanged.** `@endo/claude-sandbox` still composes it. Phase 6 moves the slice onto these backends.

## Phase ledger

| Phase | State | This PR |
| --- | --- | --- |
| 1. Provider-neutral seam | Open as #1403 (draft) | Stacked on: merged here as a `--no-ff` stack commit of #1403's head `34a4a0b` |
| 2. Claude core and two backends | **This PR** | Unit tests only; no live credential |
| 3. Secret-store credentials, root canary | Not started | Out of scope: needs live credentials |
| 4. Evidence (gates 1–5, 8) | Not started | Out of scope: maintainer-gated deployment |
| 5. Broker delivery | Not started | Out of scope |
| 6. Slice composition, guests' credentials | Not started | Out of scope |

This PR delivers phase 2's code; it does not supply production evidence. The design stays "Draft, awaiting production evidence", and every "documented"/"stub" row of § Observed versus documented stays one. In particular, these tests show neither that a real model reaches only the guest's tools, nor any credential path, nor any failure shape.

## Stack

Base is the frozen `llm-80054c3`, the same base as #1403. The first commit on this branch is a `--no-ff` merge of #1403's head, so the diff includes phase 1. Review the last two commits for this PR's own change. When #1403 lands, a weave reduces the stack.

## Tests

`packages/claude`: 119 tests pass, 52 of them new. None needs a credential, a network, or a `claude` binary.

- `cli-backend.test.js` drives a fake child process. It covers argv, the environment, the mcp-config file, the prompt on stdin, and that neither the credential nor the formula identifier appears in anything but the environment. It also covers each limit (process-group kill), cancellation before and during a turn, refusal, unpinned and pinned classification, nonzero exit, malformed output, spawn failure, a disallowed credential variable, an inadmissible tool name, and the exo guard rejecting an extra request field.
- `cli-backend-process.test.js` runs the backend against a real child, `test/fixtures/fake-claude.js`. It checks that the process sees only the constructed environment, and that the wall clock kills a real process group whose grandchild holds stdout open.
- `sdk-backend.test.js` drives an injected `query` and checks the option record, the in-process server identity, each limit through the abort controller, refusal, thrown errors, and pinned classification.
- `stream-reducer`, `confinement-options`, `constructed-environment`, `scratch-directory` unit tests, plus a test that a multibyte character split across stdout chunks decodes intact. The CLI backend decodes stdout one complete line at a time with `@endo/utf8`.

Regression evidence: I broke the source in 12 ways, one at a time, and at least one test failed for each: `dontAsk`→`bypassPermissions`; admitting `CLAUDE_CODE_OAUTH_TOKEN`; dropping the task-notification filter; dropping message-id deduplication; ignoring the exit code; skipping the pinned classifier; not settling on terminate; not releasing the grant; skipping the pre-spawn limit check; not killing the process group; not aborting the SDK query; admitting `evaluate`.

`yarn lint` (tsc + eslint) is clean for `packages/claude`, apart from `safe-await-separator` warnings in test files, which also appear in `packages/inference`. Root `prettier --check` passes.

<!-- garden-related-design: 1403,1102,1369 -->

🤖 Generated with [Claude Code](https://claude.com/claude-code)

----- PR BODY END -----
