Propose the `@earendil-works/pi-*` migration 0.79.9 → 0.80.3 for endojs/endo-but-for-bots
(default branch `llm`). Surfaced by the weekly pi-release watch.

## State
- Repo currently PINS `^0.79.0` (resolved 0.79.9 in yarn.lock) for
  `@earendil-works/pi-agent-core` and `@earendil-works/pi-ai` in packages:
  agent-tools, agentry, genie, lal.
- Upstream latest is **0.80.3** (npm + earendil-works/pi GitHub releases, published
  2026-06-30). The 0.80.x line is OUTSIDE the pinned `^0.79.0` range.
- Dependabot PR #607 already MECHANICALLY bumps the ranges `^0.79.0` → `^0.80.3`
  (agent-tools, agentry, genie, lal) plus the lockfile, but ONLY the version
  numbers — it does NO code migration for the breaking API moves below, so it will
  break our consumers (typecheck and/or runtime). Treat #607 as the version-bump
  half; THIS job is the code-migration half that must land with it.

## Migration-relevant upstream changes (0.80.0 → 0.80.3)
BREAKING (v0.80.0):
- pi-ai's old global API (`stream`/`complete`/`completeSimple`,
  `getModel`/`getModels`/`getProviders`, `registerApiProvider`, `getEnvApiKey`, …)
  MOVED off the `@earendil-works/pi-ai` ROOT entrypoint to
  `@earendil-works/pi-ai/compat`. The root→compat loader alias only covers pi
  *extensions*; our packages import pi-ai directly as a normal dependency, so they
  do NOT get the alias and will break. Fix: repoint these imports to
  `@earendil-works/pi-ai/compat`, or migrate to the new
  `createModels()`/provider-factory API (compat is a strict superset and is
  slated for removal in a later release, so prefer the factory API where feasible).
- REMOVED selective-provider entrypoints `@earendil-works/pi-ai/base` and
  `@earendil-works/pi-agent-core/base`; use the root packages with explicit
  `Models` provider factories. (Grep confirms we do not import `/base` today —
  verify still true.)

BREAKING (v0.80.2):
- Renamed the agent-core public harness shell-exec options type
  `ExecutionEnvExecOptions` → `ShellExecOptions`. Update any reference.
- `ApiKeyCredential` discriminator changed `type: "api-key"` → `type: "api_key"`
  (and provider-scoped `env` values). Update any credential we construct directly.

Additive (v0.80.3, no action but nice-to-have): Claude Sonnet 5 in the
Anthropic/Bedrock catalogs, default OpenAI model → gpt-5.5, `Usage.reasoning`
token counts, RPC `get_entries`/`get_tree`.

## Consumer import sites that touch the moved runtime API (from origin/llm)
- `packages/agentry/src/harness/model.js` — `import { getModel, registerBuiltInApiProviders } from '@earendil-works/pi-ai'`
- `packages/genie/src/agent/index.js` — `import { getModel, getProviders } from '@earendil-works/pi-ai'`
- `packages/genie/main.js`, `packages/genie/dev-repl.js` — `registerBuiltInApiProviders`
- `packages/genie/test/system/slice-workspace-path.test.js` — `registerFauxProvider`
- `packages/lal/test/pi-agent-tools.test.js`, `packages/lal/test/smallcaps-footgun.test.js`, `packages/agentry/test/*` — `getModel`, `createAssistantMessageEventStream`
(These are runtime value imports; type-only `/** @import ... */` sites are
lower-risk but should still be audited against the moved published types.)

## Task
1. On a bot fork (kriscendobot/endo or the endo-but-for-bots fork branch), bump the
   four consumer package.json ranges to `^0.80.3` and refresh the lockfile (or
   rebase onto / co-opt dependabot #607 for the mechanical bump).
2. Repoint the moved-API imports above to `@earendil-works/pi-ai/compat` (minimal
   fix) or migrate to `createModels()`/provider factories (durable fix); apply the
   `ExecutionEnvExecOptions` → `ShellExecOptions` rename and `type: "api_key"`
   change if referenced; confirm no `/base` entrypoint imports remain.
3. Run the harness test suites (agentry, genie, lal, agent-tools) to green.
4. Open/《update the PR (or fold into #607). Read-only watch posted this; the
   experiment + PR happen on a bot fork per garden bounds.

Basename keyed to target version 0.80.3 so a later weekly watch does not duplicate
this proposal; re-post only for a version newer than 0.80.3.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 18
  claimed_at: 2026-07-09T18:53:37Z
