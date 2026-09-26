Reviewed [PR 149](https://github.com/endojs/endo-but-for-bots/pull/149) at [head](https://github.com/endojs/endo-but-for-bots/commit/e0c8accb3235a340ce2b4e4307138429a7d1e5f3) against [`origin/llm`](https://github.com/endojs/endo-but-for-bots/commit/a54c3adbebf18fd837770d467433e480de498e8d). The histories have no merge base. The PR has 33 commits after its obsolete [`llm` base](https://github.com/endojs/endo-but-for-bots/commit/33311ae9a41d0b12ba6f0367717352b67d9032bc), so its commits should not be cherry-picked wholesale.

Implemented features:

1. `root-agent-embodiment`
   - Behavior: launches Genie with the daemon host agent as `powers`, pins the result as `main-genie`, and consumes the root `@self` inbox directly. This removes the intermediate `setup-genie` guest and configuration-form bounce.
   - Evidence: [implementation commit](https://github.com/endojs/endo-but-for-bots/commit/84bfd2303877fdde645a6c0e361837e61d49511b), [launcher](https://github.com/endojs/endo-but-for-bots/blob/84bfd2303877fdde645a6c0e361837e61d49511b/packages/genie/setup.js#L30-L50), [direct-inbox test](https://github.com/endojs/endo-but-for-bots/blob/84bfd2303877fdde645a6c0e361837e61d49511b/packages/genie/test/boot/self-boot.test.js#L321-L356).
   - Likely destination: `fae`, as a daemon-hosting and identity pattern. It should only be adopted for an explicitly single-tenant root agent because two root-inbox consumers would race.
   - Depends on: daemon `makeUnconfined` and host-agent mail powers.

2. `retained-root-self-boot`
   - Behavior: setup is idempotent through `has('main-genie')`; the named `makeUnconfined` formula is retained, and lookup after daemon restart reincarnates the worker without rerunning setup.
   - Evidence: [launcher guard](https://github.com/endojs/endo-but-for-bots/blob/84bfd2303877fdde645a6c0e361837e61d49511b/packages/genie/setup.js#L22-L50), [restart test](https://github.com/endojs/endo-but-for-bots/blob/84bfd2303877fdde645a6c0e361837e61d49511b/packages/genie/test/boot/self-boot.test.js#L359-L400).
   - Likely destination: `fae`, as reusable retained-agent lifecycle machinery.
   - Depends on: `root-agent-embodiment` and daemon formula persistence.

3. `primordial-no-model-mode`
   - Behavior: a worker with a workspace but no model still starts its inbox loop, skips PiAgent and heartbeat construction, and replies to ordinary messages with pointers to `/help` and `/model list`.
   - Evidence: [implementation commit](https://github.com/endojs/endo-but-for-bots/commit/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a), [automaton](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/packages/genie/src/primordial/index.js#L125-L208), [mode wiring](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/packages/genie/main.js#L1488-L1617), [tests](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/packages/genie/test/primordial/automaton.test.js#L82-L132).
   - Likely destination: `lal`, as an agent-loop state that permits interactive turn-up before model construction.
   - Depends on: an inbox loop that can dispatch commands without constructing an LLM.

4. `staged-model-command`
   - Behavior: `/model` implements `list`, `show`, `set`, `test`, `commit`, `clear`, and `help`; configuration is staged before persistence, provider keys are validated, secrets are masked in output, and `/model test` runs a one-shot probe.
   - Evidence: [command surface](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/packages/genie/src/primordial/model-handler.js#L86-L110), [draft validation](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/packages/genie/src/primordial/model-handler.js#L275-L387), [probe and commit dispatch](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/packages/genie/src/primordial/model-handler.js#L389-L508).
   - Likely destination: `lal`, for the operator-facing command UX. Model construction and credential access should delegate to `agentry`.
   - Depends on: `primordial-no-model-mode`, provider resolution, and persistence.

5. `provider-catalog-and-connectivity-probe`
   - Behavior: defines provider credential and option metadata for Ollama, Anthropic, OpenAI, Google, Groq, xAI, OpenRouter, Mistral, and Cerebras. The scratch probe passes credentials per call without mutating ambient environment and classifies failures as `AUTH`, `NETWORK`, `PROVIDER_ERROR`, or `OTHER`.
   - Evidence: [provider table](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/packages/genie/src/primordial/providers.js#L54-L150), [probe](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/packages/genie/src/primordial/scratch-agent.js#L146-L207), [failure classification](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/packages/genie/src/primordial/scratch-agent.js#L209-L288).
   - Likely destination: `agentry`, selectively. Preserve the connectivity-probe and error-classification concepts. Omit the hard-coded catalog and old `@mariozechner` integration because current `agentry` already owns broader lazy provider resolution and a credential seam: [model resolver](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/agentry/src/harness/model.js), [credentials](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/agentry/src/harness/credentials.js).
   - Depends on: `agentry` model resolution and credentials.

6. `atomic-model-profile-persistence`
   - Behavior: reads and validates schema-v1 `.genie/config.json`, writes through a same-directory temporary file plus `fsync` and rename, applies POSIX mode `0600`, and boots with precedence `GENIE_MODEL` > persisted profile > primordial.
   - Evidence: [persistence implementation](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/packages/genie/src/primordial/persistence.js#L181-L309), [boot precedence](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/packages/genie/main.js#L1672-L1764), [atomicity and permissions tests](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/packages/genie/test/primordial/persistence.test.js#L114-L200).
   - Likely destination: explicit omission in this exact form. Persisting plaintext credentials and copying them into `process.env` conflicts with current `agentry`'s credential seam. The atomic, versioned persistence pattern remains useful for non-secret model profile data.
   - Depends on: provider selection and the model command.

7. `primordial-live-handoff`
   - Behavior: primordial `/model commit` persists the draft, constructs the agent pack once, flips routing to PiAgent mode, starts heartbeat processing, records the active model, and rolls back the persisted file if activation fails.
   - Evidence: [activation sequence](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/packages/genie/main.js#L1399-L1464), [one-shot handoff and rollback](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/packages/genie/main.js#L1513-L1599), [command transition](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/packages/genie/src/primordial/model-handler.js#L432-L507).
   - Likely destination: `lal`, with agent construction delegated to `agentry`.
   - Depends on: features 3 through 6.

Plans, omissions, and unfinished behavior:

- PiAgent-mode model replacement is incomplete for workers originally launched with `GENIE_MODEL`. The retained formula keeps that environment value, boot precedence continues to prefer it over the newly persisted model, and the integration test only checks for any `ollama/` model rather than the newly committed ID. Evidence: [precedence](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/packages/genie/main.js#L1705-L1718) and [test concession](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/packages/genie/test/boot/self-boot.test.js#L908-L937). Do not port the "persist, exit, reincarnate with new model" claim without resolving this precedence conflict.
- Capability-backed or keychain-backed secret storage is deferred. The landed implementation explicitly uses plaintext workspace storage and ambient environment mutation.
- `/model clear` only discards the in-memory draft. `clearConfig` exists, but a persisted-clear command is only planned.
- Child-agent spawning remains scaffolding and was not part of the embodied root-agent boot.

Execution evidence: 55 primordial, command, provider, and persistence unit tests passed under the lockdown AVA configuration. The nine daemon self-boot integration tests were not verified: they failed before feature assertions because the isolated worktree path made the Unix socket path unavailable (`ENOENT`). No live provider was contacted. No project files, commits, branches, or GitHub state were modified.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr149-review-13c87bef-discover-genie-core.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 571s

<!-- garden-usage-end -->
