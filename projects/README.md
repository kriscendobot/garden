# Projects

Per-project context for the projects this garden has touched. Each subdirectory carries a `README.md` that the garden's agents read when they need to know "what is project X, what may I do with it, where do I push, what identity do I use." Per-topic detail (technical sub-areas, recurring decisions, specific subsystems) accumulates as sibling `<topic>.md` files alongside the README; the [scholar](../../roles/scholar/AGENT.md) on the `main` branch grows the topic set over time.

The structure follows the [context-library](../../skills/context-library/SKILL.md) discipline on the `main` branch: each README opens with a specific prose abstract, children partition the topic cleanly, and an agent walking the tree decides whether to descend at every level by matching its query against each abstract.

## Index

| Project | Upstream | Abstract |
|---------|----------|----------|
| [endo](endo/README.md) | [endojs/endo](https://github.com/endojs/endo) | Hardened-JavaScript and SES platform. Routine garden work happens on `kriscendobot` forks; upstream pushes use the `kriskowal` identity. |
| [endo-but-for-bots](endo-but-for-bots/README.md) | [endojs/endo-but-for-bots](https://github.com/endojs/endo-but-for-bots) | The endo fork the garden actively develops. Most PR backlog rows live here. Roadmap lives at `designs/README.md` on the `llm` branch. |
| [agoric-sdk](agoric-sdk/README.md) | [agoric/agoric-sdk](https://github.com/agoric/agoric-sdk) | Agoric SDK. Passive standing watch (no active engagement yet); routine activity, when it begins, will happen on the `kriscendobot` fork. |
| [cosgov](cosgov/README.md) | [dcfoundation/cosmos-proposal-builder](https://github.com/dcfoundation/cosmos-proposal-builder) | DC Foundation's cosmos-proposal-builder. Observation-only standing watch with a contributor allowlist; routine activity is driven by the maintainer directly. |
| [garden](garden/README.md) | [kriskowal/garden](https://github.com/kriskowal/garden) | The garden itself. This is the meta library of roles, skills, and the journal you are reading. Driven by the maintainer and the in-session liaison. |
| [ocapn](ocapn/README.md) | (the upstream OCapN protocol repository) | Reference-only fork at `kriscendobot/ocapn`. **Unusually strict engagement rules**: no comments, no cross-references, oblique references in outward-facing artifacts only. Read the project README before acting. |

---

Conventions: each project README's abstract is specific enough to skip when the query does not match it. Per the context-library skill, prefer adding a per-topic file alongside the README to making the README itself long.
