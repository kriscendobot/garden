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
| [agoric-sdk--agents--overview](../sections/agoric-sdk--agents--overview.md) | agoric-sdk AGENTS.md | Frame for the agents.md-standard agoric-sdk rules. |
| [agoric-sdk--agents--project-structure-and-module-organization](../sections/agoric-sdk--agents--project-structure-and-module-organization.md) | agoric-sdk AGENTS.md | Yarn-workspaces + Lerna-Lite monorepo over packages/* and golang/*. |
| [agoric-sdk--agents--build-test-and-development-commands](../sections/agoric-sdk--agents--build-test-and-development-commands.md) | agoric-sdk AGENTS.md | Command inventory: corepack + yarn install/build/test/lint, typecheck, dprint, prepack/postpack workflow. |
| [agoric-sdk--agents--coding-style-and-naming-conventions](../sections/agoric-sdk--agents--coding-style-and-naming-conventions.md) | agoric-sdk AGENTS.md | ESM, dprint, `@agoric/*` vs `@aglocal/*`, performance.now vs Date.now, ambient-authority discipline. |
| [agoric-sdk--agents--testing-guidelines](../sections/agoric-sdk--agents--testing-guidelines.md) | agoric-sdk AGENTS.md | AVA; per-package vs whole-repo; c8 coverage. |
| [agoric-sdk--agents--async-flow-model-notes](../sections/agoric-sdk--agents--async-flow-model-notes.md) | agoric-sdk AGENTS.md | Durable-lifecycle replay model; await-reordering footgun for `*.flows.*` modules. |
| [agoric-sdk--agents--a3p-container-and-proposal-build-notes](../sections/agoric-sdk--agents--a3p-container-and-proposal-build-notes.md) | agoric-sdk AGENTS.md | A3P Docker container build pattern for proposals. |
| [agoric-sdk--agents--commit-and-pull-request-guidelines](../sections/agoric-sdk--agents--commit-and-pull-request-guidelines.md) | agoric-sdk AGENTS.md | Conventional Commits; issue-number branch prefix; force/bypass integration labels. |

## See also

- [`repository-governance`](repository-governance.md): contributing rules, security policy, commit conventions (overlap on the `endo--agents--commit-conventions` row).
- [`typescript-conventions`](typescript-conventions.md): TS-specific rules consolidated here from `endo--agents--typescript-usage`.
- [`testing`](testing.md): test infrastructure topic.
- [`exo`](exo.md): Exo class definitions, `this`-context shapes.
