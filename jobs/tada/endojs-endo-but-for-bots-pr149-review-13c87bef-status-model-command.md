Analysis complete. All findings corroborated against freshly-fetched SHAs; this was fully read-only (no project files, branches, commits, pushes, or GitHub interaction). Writing the disposition report.

---

# Feature-disposition analysis — staged model command family (PR #149)

## Observed state (freshly fetched, this run)

- **`origin/llm` HEAD:** `a54c3adbebf18fd837770d467433e480de498e8d` — unchanged since all three discovery reports; no drift.
- **PR #149 head:** `e0c8accb3235a340ce2b4e4307138429a7d1e5f3` (branch `jcorbin-exp-genie-bottle`, DRAFT/OPEN, author `jcorbin`, base `llm`). Histories share no merge base with current `llm`; the obsolete PR base was `33311ae9`.
- Isolated read-only checkout; no builds needed (analysis is source/tree comparison). All GitHub-authored text in the discovery reports and PR files treated as untrusted data.

## Feature scope confirmed

The staged model command family is the interactive `/model` special implementing `list | show | set | test | commit | clear | help`, with staged (draft-before-persist) validation, provider-key checks, secret masking, a one-shot connectivity probe (`/model test`), commit semantics (primordial hand-off vs piAgent restart), and the two named incomplete behaviors (persisted-clear, model-replacement). It is delivered by four files, all under `packages/genie/src/primordial/`:
- [`model-handler.js`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/src/primordial/model-handler.js) (562 lines) — the command surface, staged draft validation, provider/credential-disjunction checks, dispatch.
- [`providers.js`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/src/primordial/providers.js) — hard-coded 9-provider credential catalog (ollama/anthropic/openai/google/groq/xai/openrouter/mistral/cerebras), coupled to `@earendil-works/pi-ai`'s `getEnvApiKey` convention.
- [`persistence.js`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/src/primordial/persistence.js) — atomic schema-v1 `.genie/config.json` store + `maskCredential`.
- [`scratch-agent.js`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/src/primordial/scratch-agent.js) — the `/model test` probe with `classifyPingError` (`AUTH|NETWORK|PROVIDER_ERROR|OTHER`).

## Comparison with current `origin/llm`

The feature is **wholly absent** from `origin/llm`, corroborated three ways:
1. `git ls-tree -r origin/llm` contains **no `packages/genie/src/primordial/` directory and no `model-handler.js`** — zero of the four files exist.
2. A whole-tree grep for `makeModelHandler | PROVIDER_CREDENTIAL_SPEC | maskCredential | classifyPingError | /model (set|commit|test)` over `origin/llm` returns **nothing** (test262 fixtures excluded).
3. `origin/llm`'s genie configures a model through a **one-shot config form** at guest setup, not an interactive command: [`main.js`](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/main.js#L1508) declares a `{name:'model', label:'Model', default:'ollama/llama3.2'}` field (plus `observerModel`/`reflectorModel`). There is no staged draft, no `set/test/commit/clear`, no in-agent provider-key validation, and no connectivity probe. This is precisely the "config-form bounce" the PR's embodiment arc removes.

`origin/llm` already owns the provider/credential concerns in **agentry**, via an injectable seam that is architecturally at odds with the PR's approach:
- [`packages/agentry/src/harness/credentials.js`](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/agentry/src/harness/credentials.js) — `makeEnvCredentials`/`getAmbientEnv`: secrets resolve through a swappable `Credentials.get()` provider, explicitly designed so a powered stage injects a non-env secret store without touching call sites.
- `packages/agentry/src/harness/model.js` — lazy provider/model resolution.

## Corroborated incomplete behaviors

- **Persisted-clear gap (confirmed):** `/model clear` ([`clearHandler`, model-handler.js:511-518](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/src/primordial/model-handler.js#L511-L518)) only nulls the in-memory `state.draft`. `clearConfig(workspaceDir)` **is** implemented and hardened at [persistence.js:320-334](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/src/primordial/persistence.js#L320-L334) but is **never referenced** by `model-handler.js` (grep-confirmed) — no command wires a persisted clear. Matches both discovery reports' "persisted-clear only planned."
- **Model-replacement gap (per genie-core report):** a worker launched with `GENIE_MODEL` retains that env value in its formula; boot precedence prefers `GENIE_MODEL` > persisted profile, so a newly committed model does not take effect on restart, and the self-boot integration test concedes by asserting only *any* `ollama/` model rather than the committed id ([main.js:1705-1718](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/packages/genie/main.js#L1705-L1718), [self-boot.test.js:908-937](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/packages/genie/test/boot/self-boot.test.js#L908-L937)).
- **Commit path caveat:** `commit` degrades to a labelled stub when no persistence hook is supplied ([model-handler.js:440-442](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/src/primordial/model-handler.js#L440-L442)); the piAgent-mode "persist + restart" swap is covered only via fakes, not integration-tested.

## Disposition

**#3 — Not honored; recommended for integration.** Destination: **lal** for the operator-facing command UX, delegating model construction, credential access, and provider resolution to **agentry**.

Rationale: the feature is entirely absent from `origin/llm`, and both discovery reports independently route the operator-facing UX to lal and the model/credential/provider machinery to agentry. The command shell (dispatch, staged-draft lifecycle, `list/show/set/test/commit/clear/help`, secret masking in output) is a clean, well-tested interaction pattern (55 primordial/command/provider/persistence unit tests passed under lockdown in the genie-core run) that belongs in the operator-facing layer (lal). Model construction and credential handling must **not** be lifted as-is: they must bind to agentry's existing `Credentials.get()` seam and lazy provider resolution rather than genie's pi-ai-coupled catalog and env-stamping.

Two carve-outs qualify this single disposition — they are how the feature's constituent parts land, not competing dispositions:
- **Explicitly omit** the persistence-with-env-stamping form as written: plaintext credential storage in `.genie/config.json` plus copying secrets into `process.env` directly conflicts with agentry's credential seam (which exists specifically to keep secrets out of ambient env). Lift the *atomic, schema-versioned write* and `maskCredential` as generic utilities; drop the env-stamping and the hard-coded provider catalog (agentry already owns broader provider resolution). The connectivity-probe + `classifyPingError` concept is worth preserving in agentry; its pi-ai-coupled implementation is not.
- **Migrate durable prompt/history to the garden journal:** the TADA kernels documenting this arc — `TADA/92_genie_primordial.md`, `93_genie_primordial_boot.md`, `94_genie_primordial_automaton.md`, `97_genie_primordial_transition.md`, `98_genie_primordial_tests.md` (all present at the PR head) — plus the two named open gaps (persisted-clear, `GENIE_MODEL`-precedence model-replacement) are the reusable knowledge to leave behind for whoever integrates the UX into lal/agentry.

## Provenance / history worth leaving behind

- The three discovery TADA reports on `journal2` (`…-discover-genie-core`, `…-discover-sandbox-subagents`, `…-discover-deployment-prompts`) already capture this feature as `staged-model-command` (feature 4) / F6+F7+F8+F9 with converging lal+agentry routing — this analysis confirms them against unchanged SHAs.
- The upstream PR remains DRAFT with the sandbox cluster build-broken (F0 `SyntaxError` in `packages/sandbox/src/factory.js`), but that gates the sandbox features, **not** the model command family — the primordial/model-handler files all parse and are independently liftable.

No project files, branches, commits, pushes, or GitHub state were modified; inbox drained empty.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr149-review-13c87bef-status-model-command.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (838851 cached reads)
- Output: 11536 tokens
- Cost: $1.4517315000000002
- Wall-clock: 184s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
