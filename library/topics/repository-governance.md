# Topic: repository-governance

> Abstract: Project-level governance documents: contribution guidelines, security policies, commit and code-review conventions, and repository structure rules. Distinct from `agent-conventions` (agent-specific operating rules) and from `security-disclosure` (specifically the vulnerability-reporting process).

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--agents--overview](../sections/endo--agents--overview.md) | endo AGENTS.md | Top-level frame for endo's agent conventions. |
| [endo--agents--repository-structure](../sections/endo--agents--repository-structure.md) | endo AGENTS.md | Yarn workspaces monorepo layout; tooling overview. |
| [endo--agents--commit-conventions](../sections/endo--agents--commit-conventions.md) | endo AGENTS.md | Conventional commits with package scope. |
| [endo--docs-security--overview](../sections/endo--docs-security--overview.md) | endo docs/security.md | Top-level frame for endo's security policy. |
| [endo--docs-security--supported-versions](../sections/endo--docs-security--supported-versions.md) | endo docs/security.md | Latest-branch-only security-fix policy. |
| [endo--docs-get-started--resources-next-steps](../sections/endo--docs-get-started--resources-next-steps.md) | endo docs/get-started.md | Pointers to docs/, key READMEs, SES spec, talks, issue filing. |
| [endo--contributing--overview](../sections/endo--contributing--overview.md) | endo CONTRIBUTING.md | Top-level contributor onboarding frame. |
| [endo--contributing--initial-setup](../sections/endo--contributing--initial-setup.md) | endo CONTRIBUTING.md | Node, yarn, dependency install, action pinning. |
| [endo--contributing--validation](../sections/endo--contributing--validation.md) | endo CONTRIBUTING.md | yarn test, yarn lint, yarn lint:types; CI gates. |
| [endo--contributing--creating-a-new-package](../sections/endo--contributing--creating-a-new-package.md) | endo CONTRIBUTING.md | Procedure for adding a new package, with style guides. |
| [endo--contributing--rebuilding-ses](../sections/endo--contributing--rebuilding-ses.md) | endo CONTRIBUTING.md | How to rebuild the SES shim from source. |
| [endo--contributing--using-changesets](../sections/endo--contributing--using-changesets.md) | endo CONTRIBUTING.md | The changeset workflow: adding, editing, deciding need, release. |

## See also

- [`agent-conventions`](agent-conventions.md): agent-specific operating rules within a repository.
- [`security-disclosure`](security-disclosure.md): vulnerability disclosure process and timelines.
