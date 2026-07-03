---
created: 2026-07-03
updated: 2026-07-03
author: gardener
---

# Fixer sub-roles

A **sub-role** is a project-keyed specialization of a base role. It layers
project-specific skills and norms onto the base role when the job's target repo
matches, without duplicating the base role file. The base role stays
project-agnostic and small (the garden's standing shape, `roles/COMMON.md`
§ Project context); the project-specific knowledge accumulates in a sub-role that
the base role reads *in addition to* its own brief when the job's repo calls for
it.

This is the first home of the sub-role concept (maintainer directive on
kriskowal/garden#22, 2026-07-03: "these all fall under debugging, which is a
dimension of the fixer, and the subrole should be keyed on whether working on
relevant projects"). Other roles may grow a `subroles/` directory of the same
shape as the pattern proves out.

## Selection

The fixer picks a sub-role from **its job's target repo** (the `repo:` /
`project:` the job carries, or the fork it is dispatched into):

| Job's project | Sub-role to also read |
| --- | --- |
| `agoric/agoric-sdk` / `kriscendobot/agoric-sdk` | [agoric-sdk](agoric-sdk.md) |
| `endojs/endo`, `endojs/endo-but-for-bots`, `xs2rust-endor` | [endojs](endojs.md) |

No matching sub-role means the base fixer brief is the whole of it. A sub-role is
**additive**: read `roles/fixer/AGENT.md` first, then the sub-role. The sub-role
never overrides a base norm; it points at the extra skills the project's work
needs and records project-specific gotchas.

## Dimensions

A sub-role groups its skills by **dimension**, the kind of work within the
project. The first dimension is **debugging** (diagnosing a failure before fixing
it), which is where the XS value-stack and slog discoveries from kriskowal/garden#9
live. A sub-role may grow other dimensions (build, upgrade, migration) as the
garden accumulates project knowledge.

The debugging dimension's cross-project envelope is
[xs-debugging](../../../skills/xs-debugging/SKILL.md): XS engine knowledge that is
not specific to one repo and is therefore referenced from **both** the agoric-sdk
and the endojs sub-roles.

## Reachability from other roles

The debugging skills are role-neutral: any role doing a debugging pass on these
projects (a builder investigating a failing build, a shepherd chasing a red CI
signal) reaches the same [xs-debugging](../../../skills/xs-debugging/SKILL.md),
[slog-debugging](../../../skills/slog-debugging/SKILL.md), and
[agoric-chain-snapshot](../../../skills/agoric-chain-snapshot/SKILL.md) skills. The
sub-role directory lives under the fixer because debugging is primarily the
fixer's dimension, but the skills it points at are the garden's, not the fixer's.
