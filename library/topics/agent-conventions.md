# Topic: agent-conventions

> Abstract: Repository-specific instructions written for AI agents working in a project. Covers what an agent must do or avoid in this repo (testing commands, file-naming, commit messages, type-definition placement), as distinct from cross-repository agent norms in the garden's role library. The endo project's AGENTS.md is the canonical example; the same shape is expected to recur in other agent-aware upstreams.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--agents--overview](../sections/endo--agents--overview.md) | endo AGENTS.md | Frame for the rest of the AGENTS.md sub-rules. |
| [endo--agents--repository-structure](../sections/endo--agents--repository-structure.md) | endo AGENTS.md | Yarn workspaces monorepo; packages/; ava + tsd; eslint per-package. |
| [endo--agents--typescript-usage](../sections/endo--agents--typescript-usage.md) | endo AGENTS.md | Six sub-rules for TS in a `.js`-runtime + `.ts`-consumer repo. |
| [endo--agents--exo-this-context](../sections/endo--agents--exo-this-context.md) | endo AGENTS.md | Single-facet vs multi-facet `this` shapes for Exo methods. |
| [endo--agents--testing](../sections/endo--agents--testing.md) | endo AGENTS.md | `yarn test`, `yarn lint:types`, `yarn lint`; run lint before commit. |
| [endo--agents--commit-conventions](../sections/endo--agents--commit-conventions.md) | endo AGENTS.md | Conventional commits with package scope; `!` for breaking. |
| [endo--docs-errors--overview](../sections/endo--docs-errors--overview.md) | endo docs/errors.md | Agent-relevant framing of the SES error/assert/console system. |

## See also

- [`repository-governance`](repository-governance.md): contributing rules, security policy, commit conventions (overlap on the `endo--agents--commit-conventions` row).
- [`typescript-conventions`](typescript-conventions.md): TS-specific rules consolidated here from `endo--agents--typescript-usage`.
- [`testing`](testing.md): test infrastructure topic.
- [`exo`](exo.md): Exo class definitions, `this`-context shapes.
