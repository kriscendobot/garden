---
posted_at: 2026-11-02T16:50:38Z
role: builder
arc: moonshots
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
---
Relay job on endojs/endo-but-for-bots. Its only task is to open a draft PR that the oros host's token cannot create (403 on createPullRequest). The code is finished and pushed; do not edit it.

1. Get a project checkout, then run the rest with cwd there, because the phase-evidence gate resolves `designs/*.md` from cwd.
2. Confirm with `git ls-remote` that head `feat/lal-model-command` is at `379dd71d9243c1acf6012f4f27abbf87d06deddc` and that base `llm-48d6f3e` exists. If the head has moved, stop and report it.
3. Save the body below, everything between the BEGIN and END lines, to a file and run:

    scripts/jobs/gardening/ensure-pr.sh endopi-provider-registry-and-oauth-build endojs/endo-but-for-bots feat/lal-model-command llm-48d6f3e --title 'feat(lal): switch models mid-session with a host-only /model command' --body-file <file>

   Keep the original job base `endopi-provider-registry-and-oauth-build` as the marker key.
4. Check on GitHub that the PR is a draft with that base and head, and give its full URL in your completion report so that the gauntlet is staged for it.

-----BEGIN PR BODY-----
Refs: #670, #1573, #1575, #1587

## Description

The host can now move a running Lal worker to another provider or model by sending it `/model <provider>/<model-id>`. The conversation carries forward, and pi-ai adapts earlier turns for the new model. Bare `/model` reports the current selection.

This is phase 5 of `designs/endopi-provider-registry-and-oauth.md`, the one phase no open PR owns. The ledger below records where the others went. The design's status still cited the removed `packages/genie`, so this PR also refreshes that section and the date in `designs/README.md`.

### Security Considerations

Please review these two rules closely:

- **Only the host can switch.** From any other sender, `/model` is ordinary mail for the LLM, so a peer cannot choose what the worker's credentials are spent on. The check compares formula identity, because `locate()` adds connection hints that a message's `from` lacks.
- **`LAL_AUTH_TOKEN` stays with its endpoint.** `makeWorkerGetApiKey` falls back to that token for any provider, so a plain provider switch would have sent one vendor's key to another. Now only a model at the configured provider and base URL receives it. Any other model needs its own credential in the daemon's environment, and without one the switch is refused.

No subscription or OAuth path is enabled.

### Scaling Considerations

A switch is a state change between rounds, with no added process, listener, or polling. The inbox loop runs rounds one at a time, so a switch cannot land mid-round.

### Documentation Considerations

The Lal README gains a section on switching models. It also drops a stale claim that the token is copied into `process.env`.

### Testing Considerations

`packages/lal/test/model-switch.test.js` drives `runInboxLoop` over a real `PiAgent`, and drives `spawnWorkerLoop` against a local fake of the OpenAI-compatible endpoint. That end-to-end test switches between two `ollama/` models. A switch between different providers is covered only with a scripted stream, because no live vendor credentials were used.

Regression evidence, each mutation failing the named test:

- Always passing the auth token fails `the worker auth token stays with its configured endpoint`.
- A strict `from` locator comparison fails `/model recognizes the host when its locator carries hints`.
- Dropping the sender check fails `/model from a sender other than the host is ordinary mail`.
- Clearing messages on a switch fails `/model switches provider between rounds and carries the transcript`.
- Dropping the credential check fails `a rejected /model keeps the current model`.

The Lal suite passes (206 passed, 1 skipped), as do `tsc`, eslint on the changed files, and the pre-push probes. Repo-wide lint outlasts the tool limit on the build host, so CI is the first full lint.

### Compatibility Considerations

Workers that never receive `/model` behave as before, including their key precedence. A host message consisting only of a `/model` line used to reach the LLM and now does not.

### Upgrade Considerations

None. The selection lasts as long as the worker's in-memory transcript, and neither survives a restart.

### Out of scope

- Fae and Jaine still use `createProvider` and have no `/model`. Whether to retire `packages/lal/providers/` is an open question in the design, left for the maintainer.
- Lal's self-mail check compares `from` to `locate('@self')` with `===`, which has the same hint mismatch. It predates this PR and is not changed here.

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: `designs/endopi-provider-registry-and-oauth.md`
Index: `designs/README.md` (date only)
Disposition: deliverable
Phase 1: superseded | Lal's agent loop goes through pi-ai's registry via `@endo/agentry/harness`; the durable owner-scoped registry is #1573
Phase 2: superseded | API-key providers come from pi-ai's registry; brokered adapters are #1575
Phase 3: superseded | `designs/hosted-agent-broker-oauth.md` keeps Claude subscription mode closed; #1587 and #670 own this work
Phase 4: superseded | the same design leaves ChatGPT and Copilot unproven; #1587 registers them as explicitly unavailable
Phase 5: satisfied | this change, with the mutation evidence above
Phase 6: satisfied | image input landed on `llm` in 5f88cd7f3 and df02fc8aa, covered by `packages/lal/test/image-messages.test.js`
Acceptance: satisfied | the design names no acceptance observations; `spawnWorkerLoop` was exercised end to end against a local fake endpoint, and no live vendor run was made
<!-- /garden-phase-evidence-ledger -->

🤖 Generated with [Claude Code](https://claude.com/claude-code)
-----END PR BODY-----
