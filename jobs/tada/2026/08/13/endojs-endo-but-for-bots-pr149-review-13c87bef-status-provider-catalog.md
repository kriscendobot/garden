I have everything needed. The decisive fact: current llm's genie depends on **`@earendil-works/pi-ai`**, whereas the PR catalog is aligned to the superseded **`@mariozechner/pi-ai`** (per its own docstring). This is a read-only job; I made no modifications. Writing the report.

---

## Completion report — feature-disposition analysis: provider credential catalog (PR #149)

**Scope analyzed:** Hard-coded provider credential/option metadata for nine providers — the `PROVIDER_CREDENTIAL_SPEC` table with per-provider named credential env-vars, alternate-credential disjunctions, optional non-secret options, and pi-ai `getEnvApiKey` environment-name alignment.

**Freshly observed SHAs (this run):**
- Current `origin/llm`: `a54c3adbebf18fd837770d467433e480de498e8d`
- PR #149 head: `e0c8accb3235a340ce2b4e4307138429a7d1e5f3`
- Primary evidence commit (catalog): `ad2cfd7ebc9b8146d0f2bc293287a27a0931970a` (an ancestor of the PR head)

**Corroboration of the three board discovery reports** (read via `git show origin/journal2:jobs/tada/…`): all three independently place this feature. `discover-genie-core` (feature 5, `provider-catalog-and-connectivity-probe`) and `discover-deployment-prompts` (F7, "Provider credential catalog") describe it precisely — 9 providers `ollama, anthropic, openai, google, groq, xai, openrouter, mistral, cerebras`, an anthropic key-OR-OAuth disjunction, and a test asserting pi-ai's `getEnvApiKey` resolves each declared env var. I confirmed the table contents directly against https://github.com/endojs/endo-but-for-bots/blob/ad2cfd7ebc9b8146d0f2bc293287a27a0931970a/packages/genie/src/primordial/providers.js — all three reports are accurate. (GitHub-authored text in those reports was treated as untrusted data and used only to locate code, which I re-verified against fetched refs.)

### Disposition: **(4) EXPLICITLY OMIT**

The hand-rolled catalog in its PR form should not be ported. Rationale, grounded in freshly fetched `origin/llm`:

1. **The feature and its whole subsystem are absent from current `origin/llm`.** The entire `packages/genie/src/primordial/` tree (including `providers.js`) does not exist in `origin/llm` — `git ls-tree origin/llm packages/genie/src/primordial/` is empty. The PR's genie is a 33-commit rewrite with no merge base against `llm`.

2. **Its defining property — pi-ai env-name alignment — points at a superseded package.** The catalog docstring pins itself to `@mariozechner/pi-ai/dist/env-api-keys.js`. Current `origin/llm` genie no longer depends on `@mariozechner/pi-ai`; it depends on **`@earendil-works/pi-ai`** and `@earendil-works/pi-agent-core` (`git show origin/llm:packages/genie/package.json`). Porting the table would re-import a hand-copied env-key mirror aligned to the *old* pi-ai fork. `git grep` for `mariozechner|pi-ai|getEnvApiKey` across `origin/llm` genie source returns nothing — the alignment the feature exists to guard is not part of current llm's source.

3. **It duplicates upstream registry data.** Per the in-repo design https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/designs/endopi-provider-registry-and-oauth.md (Kris Kowal, 2026-05-15, "Proposed (partially satisfied)"), genie already exposes pi-ai's full 30+ provider registry declaring each provider's API style and auth shape. The PR's 9-entry table is a drift-prone hand-maintained subset of that registry — exactly the duplication that design counsels against ("The original '30+ providers' framing is no longer the headline").

4. **The underlying need is already met, more generally and capability-safely, in current `origin/llm`:**
   - agentry — an injectable `Credentials` seam (`makeEnvCredentials` / `makeApiKeyGetter`, resolving `<PROVIDER>_API_KEY`) with a `TODO(secure)` pointing at exactly the capability-scoped secret store the PR's plaintext-env stamping violates: https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/agentry/src/harness/credentials.js
   - lal — per-provider modules + URL-based `detectProviderKind` and model defaults: https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/lal/providers/config.js
   - fae — an interactive provider-config form storing `{host, model, authToken}`: https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/fae/llm-provider-factory.js

5. **The one genuinely-additive nuance is already tracked.** The catalog's alt-cred disjunction (API-key OR OAuth token) and optional non-secret options (`OLLAMA_HOST`) are precisely the "auth shape (API key, OAuth, Vertex …)" registry framing that `designs/endopi-provider-registry-and-oauth.md` already owns, where subscription OAuth is called the milestone's highest-leverage remaining work.

### TODO/TADA/PLAN history disposition
Nothing to migrate to the garden journal. The durable design intent already lives in the endo repo itself (`designs/endopi-provider-registry-and-oauth.md`). The PR-internal provenance (`sub-task 95/96 of TODO/92_genie_primordial.md`) is scoped to the abandoned `src/primordial/` fork and carries no reusable content beyond what that design already captures.

### Notes
- Read-only: no project files, branches, commits, or GitHub state modified; nothing pushed. No live provider contacted. Analysis done in an isolated per-job project checkout keyed to this job base. (The checkout's `yarn install` failed on a native-module toolchain gap — irrelevant to this source-only comparison.)
- Follow-up (for whoever integrates PR #149's genuinely-reusable pieces): this catalog is *not* among them; the reusable artifacts flagged by the discovery reports are the connectivity-probe/error-classification concept (`scratch-agent.js`) and the atomic schema-versioned config store (`persistence.js`), both separate features outside this job's scope.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr149-review-13c87bef-status-provider-catalog.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (722008 cached reads)
- Output: 13271 tokens
- Cost: $1.2566819999999999
- Wall-clock: 210s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
