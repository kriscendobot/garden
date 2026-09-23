---
ts: 2026-05-18T14:31:47Z
kind: result
role: builder
host: endolinbot
posture: liaison
short_id: cc02aa
dispatch_root: dispatches/builder--cc02aa
repo: endojs/endo-but-for-bots
branch: llm
pr_number: null
project: endo-but-for-bots
---

# Impasse: `endo inspect <name>` already implemented by open PR #129

Dispatch asked to implement Phase 1 of `designs/formula-inspector.md`:
the `endo inspect <name>` CLI verb. Pre-flight slug check used the
terms `formula-inspector OR endo-inspect OR inspect-verb`; none of
those match the actual title of the in-flight PR. A broader scan of
the open PR list turned up **#129** (`feat(daemon,cli): formula-type
introspection and worker-tenants lookup`, branch
`feat/formula-introspection`, base `llm`, **OPEN, not draft**, all CI
green, `CHANGES_REQUESTED` review). The diff already adds:

- `packages/cli/src/commands/inspect.js` (new, 41 lines).
- `packages/cli/src/endo.js`: registers the `inspect <name>` verb
  with a `--json` flag.
- `packages/daemon/src/host.js`: adds `host.inspect(petNameOrPath)`
  returning `{ id, formula }`.
- `packages/daemon/src/interfaces.js` and `types.d.ts`: interface
  guard and type for the new host method.
- Plus `listWithTypes`, `identifyType`, `listWorkerTenants`, and
  `endo list --types` (out of dispatch scope but in the same surface).

This is the same user-facing verb the dispatch directs me to build,
on the same base branch (`llm`), modifying the same two CLI files
(`packages/cli/src/endo.js` and a new
`packages/cli/src/commands/inspect.js`). Opening a second
`feat/cli-inspect-verb` PR would:

1. Duplicate the `endo inspect <name>` CLI verb.
2. Conflict on `packages/cli/src/endo.js` (the new `program.command('inspect <name>')` block).
3. Conflict on `packages/cli/src/commands/inspect.js` (filename
   collision; #129 added the file).
4. Race PR #129's review queue (`CHANGES_REQUESTED` already on file
   from a maintainer; the design's prescribed `InspectorHub.lookup`
   route may be exactly the change request, but I do not have
   visibility into the review thread from the dispatch).

The builder norm in `roles/builder/AGENT.md` § Operating norms is
explicit: "Verify no open PR already implements the issue before
opening a worktree... Skip and surface the existing PR number if a
duplicate would result."

## Design vs PR #129: architectural difference

The design `designs/formula-inspector.md` is specific about the
**mechanism**: "via the existing `InspectorHub.lookup(petName)` API
which already returns formula-type-specific metadata (endowments,
source, worker, hub, path, etc.)". The body cites
`InspectorHubInterface` in `packages/daemon/src/interfaces.js` (line
485) and the existing `makePetStoreInspector` in
`packages/daemon/src/daemon.js` line 5309, which already maps each
formula type to a curated metadata object (resolving referenced
formulas to their inspector facets via `provide(...)`).

PR #129 takes a different route: a brand-new `host.inspect()` method
that bypasses `InspectorHub` entirely, returning the raw formula
JSON (with referenced formulas still as opaque
`FormulaIdentifier` strings, not resolved to inspector facets). The
design notes the InspectorHub "may or *may not* be useful for this"
so #129's deviation is within the design's stated latitude, but it
*is* a different shape from what the design's body prescribes.

Three plausible orchestrator responses:

1. **Subsume the design into #129's review.** Treat #129 as the
   Phase-1 implementation of `designs/formula-inspector.md` (despite
   the architectural divergence). Bump the design's Status to "In
   Progress" referencing PR #129, document Phase 2/3 deferrals and
   the #284 retention-path facility, and let #129's existing
   `CHANGES_REQUESTED` review drive convergence. No new code PR; the
   work is a Status-only design PR (or a comment on #129
   surfacing the design link, if external-repo etiquette
   authorizes it).
2. **Wait for #129 to merge or close before re-dispatching.** If
   #129 is moving (last touched 2026-05-14), give it time. The
   builder dispatch can re-fire against `llm` once the verb is in
   tree, doing only the bits #129 left undone (the design's
   `InspectorHub`-shaped path, if the maintainer wants both routes;
   or any Phase-1 work the design lists that #129 missed).
3. **Direct #129's branch into the design's `InspectorHub` shape.**
   If the `CHANGES_REQUESTED` review is asking for the
   `InspectorHub.lookup` route the design prescribes, the natural
   follow-up is a **fixer** dispatch on #129, not a fresh builder
   PR. Per the orchestrator vocabulary table in
   `garden/CLAUDE.md` § Orchestrator vocabulary, that maps to
   *fix #129* (or, if the existing branch's commit shape needs to
   be re-laid against per-package commits plus a separate
   `chore: Update yarn.lock`, *retcon #129*).

The choice between (1), (2), and (3) is an orchestrator call (it
turns on whether the maintainer's `CHANGES_REQUESTED` on #129 is
addressable in-flight or whether the design wants a distinct
implementation). The builder cannot adjudicate from the dispatch
prompt alone, and the dispatch's stated Phase-1 scope is *fully
covered* by #129's existing diff, so there is nothing for a builder
to safely add right now.

## Pre-flight gate outcomes

| Gate | Result |
| --- | --- |
| Open-PR slug check (`formula-inspector OR endo-inspect OR inspect-verb`) | PASS (no matches), but the in-flight PR uses neither slug. **The slug list missed the actual verb's PR title.** |
| Design-status drift check (Status: `Not Started`) | PASS |
| Existing-symbol check (`ls packages/cli/src/commands/inspect*.js`; `grep "endo inspect\|inspectFormula" packages/cli/src/`) | PASS on disk (the bot's `llm` checkout is at 68246ad92 and does not yet contain #129's diff) |
| **Broader open-PR scan** (manual, after slug check passed) | **FAIL**: #129 implements `endo inspect <name>` on base `llm` |

## No code authored, no branch pushed

I did **not** create the `feat/cli-inspect-verb` branch; I did **not**
modify any project files; I did **not** open a PR. The dispatch
worktree is clean at the `llm` HEAD (68246ad92).

## Out-of-scope deferrals (carry-forward from dispatch)

- Chat UI panel (Phase 2).
- Edit / `E(agent).revise(petName, patch)` (Phase 3).
- Retention-path facility: separately shipped as
  `daemon-retention-paths` Phase 1, PR **#284**.
- Syntax highlighting of `eval` source.
- Clickable links to referenced formulas (UI-only).

## Self-improvement

The builder's open-PR slug check is only as good as the slug list the
orchestrator hands it. The dispatch's slug list named the design's
slug (`formula-inspector`) and two plausible PR-title slugs (`endo-inspect`,
`inspect-verb`), but the actual in-flight PR title uses neither: it
calls the feature "formula-type introspection". The orchestrator's
duplicate-check vocabulary should grow a **verb-level slug**: when a
dispatch directs implementation of a specific CLI verb (`endo
inspect`, `endo locate`, `endo follow`), include the verb name as a
search term alongside the design slug. That single addition would
have surfaced #129 (whose body contains the literal string `endo
inspect`) before any worktree was prepared.

Self-improvement: orchestrator slug-list convention. When
dispatching builder work for a named CLI verb, include the verb
literally (`"endo inspect"` quoted in the `gh pr list --search`) in
the slug list, not only the design-document slug. The PR-title and
PR-body indexers both pick up the verb literal; the design slug
alone does not.
