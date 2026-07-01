# verified-claim-requires-evidence gate

## What it catches

The garden's always-read reporting norm, or one of the juror seats that
encode it, having lost the **verified-claim-requires-evidence**
discipline. A "verified" claim in a report or a PR comment must cite
**real-execution evidence**, and a **UI / browser** acceptance criterion
is satisfied only by an **actual browser run** (a rendered-DOM
observation), never by code inspection or a passing unit test. When a
run was not possible, the honest report says "not verified".

Unlike the project-diff grep gates, this is a **doc-invariant** gate
(the `claude-md-inventory-drift` shape): it fires when the discipline has
drifted *out of the garden's own library*, not when an offending pattern
appears in a project's diff.

## How it fires

Exit non-zero when any of these files is absent, or is present but
missing either anchor phrase (`real-execution evidence` /
`actual browser run`, matched after whitespace normalization so a
markdown line-wrap inside the phrase still matches):

- `roles/COMMON.md` (the fleet-wide `## Reporting` norm).
- `roles/gardener/AGENT.md` (the worker whose completion report burned
  the trust).
- `roles/jurors/saboteur/AGENT.md` (the code-panel rejection check).
- `roles/jurors/skeptic/AGENT.md` (the design-panel analog).

On a fire, `run-all.sh` dispatches `prompt.md` to re-encode the missing
discipline.

## The incident

`endojs/endo-but-for-bots` #58 (2026-07-01): the garden reported three UI
acceptance criteria "all implemented and verified"; the maintainer then
manually verified in Chrome and it failed. Only the message rendered, no
stack trace and no worker chip. The "verified" had been asserted from
code, not from a real browser run. A false "verified" costs maintainer
trust and time; an honest "not verified" costs only a follow-up.

## How to disable if irrelevant

This gate is meaningful only in the garden's own repository (it polices
`roles/`). It self-passes in any tree without a `roles/` directory, so no
action is needed for project checkouts. To retire the invariant
deliberately, remove this gate directory in the same commit that removes
the discipline it protects.
