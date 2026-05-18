---
ts: 2026-05-18T21:47:00Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
---

# Dispatch: builder replaces lal's agent memory + harness internals with genie's (pi-based)

Dispatch root: `dispatches/builder--d9624f/`. Project worktree on `endojs/endo-but-for-bots@llm` (head `68246ad92`).

Maintainer directive (2026-05-18): *"Please dispatch a builder to replace the agent memory system and harness in the lal agent harness plugin with the corresponding internals of the geni agent harness, using pi."*

## Source-of-truth: `packages/genie/`

`@endo/genie` (DESIGN.md = "Claw-like AI Agent framework for Endo") uses **pi** as its underlying agent + provider library:
- `@mariozechner/pi-agent-core` (^0.73.1)
- `@mariozechner/pi-ai` (^0.73.1)

(Mario Zechner = author of [`badlogic/pi-mono`](https://github.com/badlogic/pi-mono), the harness the maintainer had me draft `designs/endopi.md` against earlier today; see that design's analysis for the conceptual map.)

genie's harness internals are organized as:
- `src/agent/` — agent definitions + tool-gate
- `src/loop/` — `agents.js`, `builtin-specials.js`, `io.js`, `run.js`, `specials.js` (the main agent-loop)
- `src/heartbeat/` — periodic-tick mechanism
- `src/interval/` — scheduled/persisted intervals
- `src/index.js`, `main.js`, `setup.js`, `dev-repl.js`

Read `packages/genie/DESIGN.md` and `packages/genie/README.md` end-to-end before touching code.

## Target-to-replace: `packages/lal/`

`@endo/lal` ("AI agent plugin for Endo") uses home-rolled provider modules:
- `providers/{anthropic,gemini,llamacpp,ollama}.js` + `providers/config.js`, `providers/index.js`
- Top-level `agent.js`, `agent.types.d.ts`, `setup.js`
- `primer/` (extensive prompt material; **preserve**, this is the part lal is known for)
- `LAL-ARCHITECTURE.md` and `CLAUDE.md` document the current shape — read them before deciding what to keep.

Read `packages/lal/LAL-ARCHITECTURE.md`, `packages/lal/CLAUDE.md`, `packages/lal/agent.js`, `packages/lal/agent.types.d.ts`, and `packages/lal/providers/*.js` to understand the existing harness + memory shape.

## What "replace" means here

**Scope** (load-bearing — read carefully):

1. **Replace** lal's agent memory system + harness internals with genie's (pi-backed) versions. The lal package keeps its identity (`@endo/lal`), its `primer/` directory, its public surface as an Endo agent plugin, and its `.env.example` family. The internals — how the loop runs, how memory is persisted/loaded, how tool dispatch happens, how providers are wired — become genie's.
2. **Adopt pi as the provider substrate.** Drop the home-rolled `providers/{anthropic,gemini,llamacpp,ollama}.js` modules; route through `@mariozechner/pi-ai` instead (pi-ai is provider-agnostic; supports anthropic, openai, ollama, llamacpp, gemini, and openrouter via its provider registry). Reuse genie's wiring rather than re-deriving.
3. **Keep lal's primer** intact. The primer is the prompt-engineering surface that distinguishes lal from genie; do not import it into genie's loop unless the loop's prompt-template hook is the cleanest way to inject it.
4. **Keep lal's `setup.js`** working — i.e., `endo run --UNCONFINED setup.js --powers @agent` should still set up lal as an Endo agent. The setup script may need to wire the new internals.

**Out of scope**:
- Do not merge `@endo/lal` into `@endo/genie`. They remain distinct packages — lal becomes a thin agent-plugin shell that delegates internals to genie's library (or to a shared library extracted from genie's loop). The maintainer's pattern with `@endo/harden-test`, `@endo/hex-test`, etc. (sink-only test packages) shows the precedent of "tiny package, thin shell, dep on the real library."

## Two implementation shapes — builder picks

**Shape A: lal depends on genie as a library.** Move genie's loop / agent / memory into a public-export surface from `@endo/genie`; lal imports from `@endo/genie` and assembles its own setup. Smaller diff on lal; larger diff on genie (must broaden its exports).

**Shape B: extract genie's internals into a new `@endo/agent-loop` (or similar) package.** Both genie and lal depend on it. Most symmetric long-term shape, but adds a third package to the workspace. Heavier diff.

Pick whichever fits the existing surface better. Shape A is the smaller dispatch and likely the right first cut. If Shape A surfaces tight coupling that warrants extraction, surface that in the result and propose Shape B as a follow-up.

## Memory system specifically

Both genie and lal have agent-memory components. Genie's lives in `src/loop/io.js` + the heartbeat/interval modules; lal's lives somewhere in `agent.js` + (probably) provider-specific stash. The replacement should:
- Use genie's memory persistence shape (whatever it is — read it).
- Preserve lal's `~/.lal/` or equivalent on-disk layout IF the user's existing memory should survive the migration. Otherwise document a one-time migration path in the PR body (rename old path to backup; new path used going forward).
- Surface the question in the PR body if ambiguity warrants maintainer review.

## Task

Read `garden/roles/COMMON.md` + `garden/roles/builder/AGENT.md` first.

1. **Inventory**:
   - `packages/genie/` — full read of `DESIGN.md`, `README.md`, `src/loop/*`, `src/agent/*`, `src/index.js`, `main.js`, `setup.js`. Note the pi-agent-core + pi-ai integration shape.
   - `packages/lal/` — full read of `LAL-ARCHITECTURE.md`, `CLAUDE.md`, `agent.js`, `agent.types.d.ts`, `providers/*`, `setup.js`. Note the existing memory shape.
   - `designs/endopi.md` and `designs/endopi-*.md` on `llm` (today's designer dispatch output, head `68246ad92` or later) — the conceptual map for pi-based features.

2. **Pick a shape** (A or B above). Document the choice + rationale in your scratchpad / PR body.

3. **Implement**:
   - Replace lal's harness internals with genie's.
   - Replace lal's home-rolled providers with pi-ai's provider registry.
   - Preserve lal's `primer/`, `setup.js` invocation, `.env.example` family.
   - Implement the agent-memory migration (preserve or document the path).

4. **Test**:
   - `yarn workspace @endo/lal test` (if tests exist).
   - `yarn lint` clean.
   - `yarn workspace @endo/lal setup` (if dry-runnable) — the setup path is the contract.

5. **Per today's recurring self-improvement**: commit + push BEFORE extended local validation.

6. **Conventional commits**:
   - `refactor(lal): adopt @endo/genie loop + pi-based providers as harness substrate`
   - Separate `chore: Update yarn.lock` per `skills/yarn-lock-separate-commit/SKILL.md` (pi-agent-core + pi-ai will land in the lockfile if not already there from genie).

7. **Open as DRAFT PR** against `llm`. Branch: `feat/lal-pi-harness`. Title: `refactor(lal): adopt genie's pi-based harness + memory internals`. Body cites the maintainer's directive, the designs/endopi.md analysis, and the chosen shape (A vs B) with rationale.

## Per-action authorization

Standing on endo-but-for-bots: push to `feat/lal-pi-harness`, open draft PR. READ-ONLY on `endojs/endo`.

## Out of scope

- No comment on existing PRs.
- No upstream ferry.
- No un-draft (cleaner + judge run via the orchestrator's separate dispatches per the gamut).
- No merging of lal and genie into one package.
- No replacement of lal's `primer/` content.
- No edit to `packages/genie/` except as required to broaden its public surface for shape A. Mention any genie-side change in the PR body.

## Report

≤ 500 words: PR URL + head SHA, shape chosen (A or B) + rationale, files moved/replaced/added (one-line each, grouped by purpose), memory-migration approach (preserve / fresh / documented), pi-ai provider coverage (anthropic + gemini + llamacpp + ollama, plus any newly-available like openai or openrouter), local-validation outcome, one-line `Self-improvement: ...`. The liaison adds a bulletin row.
