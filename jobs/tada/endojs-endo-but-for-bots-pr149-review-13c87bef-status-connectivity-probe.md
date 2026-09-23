I have full corroboration. The `fae/scripts/debug-llm-logs.js` match is a post-hoc log-grepping developer script (classifies error strings from existing log files), not a live one-shot connectivity probe with per-call credentials — no substantive overlap. My analysis is complete. This is a read-only job with no project or garden changes to commit.

---

# Feature-disposition analysis — one-shot model/provider connectivity probe (PR #149)

## Observed state (freshly fetched, read-only)
- **origin/llm SHA:** `a54c3adbebf18fd837770d467433e480de498e8d`
- **PR #149 head SHA:** `e0c8accb3235a340ce2b4e4307138429a7d1e5f3` (branch `jcorbin-exp-genie-bottle`, DRAFT/OPEN, author `jcorbin`, base `llm`)
- **merge-base with llm:** `33311ae9a41d0b12ba6f0367717352b67d9032bc` (obsolete; 33 commits on the branch — no wholesale cherry-pick)
- Feature-introducing commit: `ad2cfd7ebc9b8146d0f2bc293287a27a0931970a` (matches the job's primary evidence pointer).

## Feature under review
One-shot model/provider connectivity testing with per-call credentials and `AUTH | NETWORK | PROVIDER_ERROR | OTHER` failure classification — the `/model test` probe. Primary evidence: [`packages/genie/src/primordial/scratch-agent.js`](https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/packages/genie/src/primordial/scratch-agent.js). Two mechanisms:
- `buildScratchPiAgent(draft)` — builds a throwaway pi-ai client wired to the draft's provider/modelId; **credentials are captured in the closure and handed to pi-ai per call** (`callOptions.apiKey`), `process.env` is left untouched; `runPing()` sends a fixed ping prompt via `completeSimple` and re-throws error-shaped payloads for uniform classification.
- `classifyPingError(err)` — buckets a thrown error into `AUTH` (401/403, invalid-key/unauthorized/permission_denied patterns), `NETWORK` (errno `ECONN*`/`ENOTFOUND`/`ETIMEDOUT`/`EAI_AGAIN`/TLS, or `fetch failed`/`getaddrinfo` message match), `PROVIDER_ERROR` (any other 4xx/5xx or structured provider error), else `OTHER`, biased toward `OTHER` over misclassification.

## Corroboration against the three board reports
- **discover-genie-core** (Feature 5, `provider-catalog-and-connectivity-probe`): routes to **agentry, selectively** — "Preserve the connectivity-probe and error-classification concepts. Omit the hard-coded catalog and old `@mariozechner` integration because current agentry already owns broader lazy provider resolution and a credential seam." ✔ concurs.
- **discover-deployment-prompts** (F8): "`scratch-agent` connectivity-probe pattern is reusable, impl is pi-ai-coupled" → **endo-upstream / agentry**; notes the acknowledged V1 hack that committed creds are stamped into `process.env` for the worker lifetime — but the **probe itself** deliberately does *not* mutate env (per-call). ✔ concurs.
- **discover-sandbox-subagents**: does not cover this feature (sandbox/subagent scope). No conflict.

All GitHub-authored/quoted text in those reports and in the PR was treated as untrusted data; conclusions rest on the freshly fetched code at the SHAs above.

## Verification that the feature is absent from current origin/llm
- The entire `packages/genie/src/primordial/` directory (including `scratch-agent.js` and `providers.js`) **does not exist on `origin/llm`** — `git diff --name-status` vs merge-base shows both as **added (`A`)** on the branch.
- Whole-tree grep on `a54c3adbeb` for `classifyPingError|runPing|buildScratchPiAgent|scratch-agent` → **no matches**. No `'NETWORK'`-bucket classifier anywhere.
- agentry at llm ([`harness/model.js`](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/agentry/src/harness/model.js), [`harness/credentials.js`](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/agentry/src/harness/credentials.js)) owns lazy provider/model resolution (`resolveModel`, `resolveModelProfile`, `resolveModelString`, `defineModels`) and a credential seam (`makeEnvCredentials`, `makeApiKeyGetter`, `.get()` choke point) — **but no connectivity probe and no provider-error classifier**.
- The only `ECONNREFUSED` in agentry is `isDaemonUnavailable` in [`endo-code-mode-pi-extension.js`](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/agentry/src/endo-code-mode-pi-extension.js#L189-L214) — detects whether the **local Endo daemon** is reachable, a wholly different concern from probing a remote LLM provider's API.
- The only `PROVIDER_ERROR` token on llm is [`packages/fae/scripts/debug-llm-logs.js`](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/fae/scripts/debug-llm-logs.js#L9-L17) — a **post-hoc log-grep developer script** that pattern-matches error strings in existing log files. It is not a live probe, uses no per-call credentials, and does not produce the four operator-visible buckets. No substantive overlap.

## Disposition — (3) NOT HONORED, recommended for integration into **agentry**

The feature is genuinely absent from `origin/llm`, and its two concerns land squarely in agentry's existing responsibilities:
- **Per-call credential passing with no env mutation** is exactly what agentry's credential seam (`credentials.get()` choke point, the `TODO(secure)` note steering away from ambient env) is designed for. lal (agent-loop/turn/transcript) and fae (named-agent guest provisioning/lifecycle) own neither provider/model resolution nor credentials, so neither is the right home.
- **Model resolution the probe needs** already exists in agentry as `resolveModel`/`resolveModelProfile` (→ pi-ai `getModel`).

**Exact integration shape (and remaining gap to close on port):**
- Port the **concept**, not the genie module verbatim. `classifyPingError` is the durable, high-value, largely provider-agnostic artifact (code/status/message heuristics) — port it near-as-is into an agentry harness util. It is the reusable core.
- Rebuild `buildScratchPiAgent`'s one-shot client on agentry's **`resolveModel` + `credentials.get()`** seam rather than the PR's genie-local `getProviderSpec`/`pickApiKey`/hard-coded 9-provider catalog and direct `completeSimple(model, ctx, {apiKey})` wiring. The catalog and `@mariozechner/pi-ai`-specific coupling should be **omitted** — agentry already owns broader lazy resolution.
- Preserve the deliberate **no-`process.env`-mutation** property of the probe (distinct from the separately-flagged genie V1 hack where *committed* creds get env-stamped for the worker lifetime; that stamping is genie-boot-specific and out of scope for the probe port).

## History worth leaving behind / migrating
- No new garden-journal migration is warranted for this feature specifically: the durable analysis now lives in the three `jobs/tada/` discovery reports plus this disposition. The reusable design essence is captured above (probe-on-agentry-seam + port `classifyPingError`).
- Associated PR-side prompt kernels are the primordial/model arc (`TADA/` bottle+primordial arc, commits `ad2cfd7eb`); no open `TODO/` kernel is specific to the probe — the probe is a completed, tested sub-primitive of F8 (55 primordial/command/provider/persistence unit tests passed under lockdown per the genie-core report; no live provider was contacted). Nothing additional needs migrating to the journal beyond this record.

## Job hygiene
Read-only analysis only. No project files, branches, commits, pushes, or GitHub posts were made. No `origin/main2` change was needed (pure discovery). Isolated read-only checkout used for llm/PR-head inspection; inbox drained (empty).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr149-review-13c87bef-status-connectivity-probe.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 27 tokens (786591 cached reads)
- Output: 10879 tokens
- Cost: $1.2537325
- Wall-clock: 172s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
