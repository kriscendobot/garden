# garden-infra: role→model policy — designer on Fable, builder on latest Opus

**Garden-infra change on `main2`.** Isolated worktree off `origin/main2` per the hard rule
(`garden/roles/COMMON.md` § Per-subagent worktrees). Land with explicit-pathspec commits, push `HEAD:main2`.

## Directive (kriskowal, 2026-07-02, via the liaison)

**Switch the `designer` role to use Fable going forward. The `builder` role continues on the latest Opus.**

## Current mechanism (verify, then extend)

Models are resolved **per job** by `scripts/jobs/handlers/gardener-claude.sh` from a job's leading
`model:` YAML frontmatter (short tiers: `fable`→`claude-fable-5`, `opus`→`claude-opus-4-8`,
`sonnet`, `haiku`; a concrete `claude-*` id passes through; absent/unknown → fleet default, no `--model`).
The Agent-dispatch path (liaison/steward) is supposed to pass a `model` tier per the dispatch contract.

Gaps to resolve as part of this job (confirm each against main2 before acting):
- **`skills/model-selection/SKILL.md` is referenced by `CLAUDE.md` as the canonical role→model tier table
  but does NOT exist in the tree.** Either restore it as the single canonical role→model map that both the
  scripted fleet and the Agent-dispatch path consult, or correct `CLAUDE.md` to describe the real mechanism.
  Do not leave the top-level doc pointing at a non-existent skill.
- There is **no central role→model map** and no design-queue producer that stamps `model:` on designer jobs.
  So today a designer job only runs on Fable if the poster happens to set `model: fable`. The policy must be
  applied **by default for the role**, wherever designers/builders are dispatched.

## Task

Encode the policy so it holds **wherever a designer or builder is dispatched**, on both paths:
1. **Scripted fleet path.** Make a designer job default to `claude-fable-5` and a builder job to
   `claude-opus-4-8` when the job does not carry an explicit `model:` field. Pick the cleanest integration
   (a canonical role→model map that `gardener-claude.sh` and any design/build producer consult, and/or a
   role-aware default in the handler). An **explicit per-job `model:` must still override** the role default.
2. **Agent-dispatch path.** Ensure the dispatch contract's model tier for `designer` is Fable and for
   `builder` is Opus (update the canonical table the contract points at).
3. Reconcile `CLAUDE.md` / the `model-selection` reference with whatever mechanism you land on.

Scope note: this is `designer` (the design-only role) and `builder` (the mergeable-feature role). Leave the
web variants (`web-designer`/`web-builder`) and every other role UNCHANGED unless the maintainer says otherwise.

## Definition of done

A designer dispatch/job resolves to `claude-fable-5` and a builder to `claude-opus-4-8` **by default**, on
both the scripted-fleet and Agent-dispatch paths, with an explicit `model:` still overriding; the
`CLAUDE.md` model-selection reference matches the real mechanism (no dangling pointer to a missing skill).
Cite the resolved code path (file+line) and show a worked example for each role per
`garden/roles/COMMON.md` § Reporting. Land on `main2` from an isolated worktree; journal a `result` entry.
