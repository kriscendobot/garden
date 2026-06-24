---
ts: 2026-06-03T19:55:13Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: cleaner
dispatch_root: /home/kris/dispatches/cleaner--0902fd
prs:
  - repo: endojs/endo-but-for-bots
    pr: 417
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/417
---

# dispatch: cleaner — #417 gamut stage 1 (post-mirror)

User explicit ask:

> Please mirror https://github.com/endojs/endo/pull/3164 and
> run the gamut.

Mirror landed at #417 by fixer `48c1e5`. This dispatch is the
first gamut stage (cleaner) per CLAUDE.md § "the gamut" / §
"run the gamut on #N" — the liaison drives the
PR-creation-flow chain end to end.

## Target

- PR: endojs/endo-but-for-bots#417
- Title: `feat(immutable-arraybuffer): freezable virtual
  typedarrays (mirror of endojs/endo#3164)`
- Branch: `mirror/3164-freezable-typedarrays`
- Head: `59dfbc6d6` (matches upstream verbatim — this is a pure
  mirror at dispatch time).
- Base: `master` (`ba26f4cdb`, bot-master mirrors actual/master
  per recent sync).
- State: DRAFT.

## Cleaner scope

Per `garden/roles/cleaner/AGENT.md`, the cleaner's job is to
sweep the PR for low-friction issues that the rest of the gamut
shouldn't have to relitigate: line-wrap, em-dash style, etc.
This is a MIRROR of an upstream PR — so the cleaner SHOULD
preserve upstream's authored intent where possible (don't
restyle erights's prose against his preferences). But genuine
issues (dead code, missed comments, etc.) should still be
flagged or cleaned.

Use judgment.

## Per-action authorizations

- Read all files in the worktree. Authorized.
- Apply low-friction style fixes (em-dash, line-wrap, etc.).
  Authorized.
- Commit one or more regular-append commits + push to
  `mirror/3164-freezable-typedarrays`. Authorized.
- Post a top-level cleaner-summary comment on #417 if any
  cleaning was applied. Authorized.

## Not authorized

- Substantive code changes (those are fixer/builder scope).
- Force-pushing.
- Un-drafting.
- Modifying base or upstream.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/cleaner--0902fd/garden/roles/COMMON.md`
2. `/home/kris/dispatches/cleaner--0902fd/garden/roles/cleaner/AGENT.md`
3. Other skills referenced just-in-time (likely
   `garden/skills/em-dash-style/SKILL.md`,
   `garden/skills/relative-paths/SKILL.md`).

Project worktree at `project/` on `mirror/3164-freezable-typedarrays`
(refetch — should be at `59dfbc6d6`).

## Report

A `result` journal entry. Include:

- Whether any cleaning was applied (yes/no).
- If yes: new head SHA + per-file summary.
- Cleaner-summary comment ID if posted.
- Verdict: ready-for-panel / needs-fixer (rare for a pure
  mirror).

The liaison drives the next gamut stage (barrister) on return.
