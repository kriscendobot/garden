---
ts: 2026-06-02T21:01:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: conductor
dispatch_root: /home/kris/dispatches/conductor--e1621d
prs:
  - repo: endojs/endo-but-for-bots
    pr: 358
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/358
---

# dispatch: conductor — merge #358 to llm per kriskowal APPROVED directive

kriskowal APPROVED #358 at 20:48:19Z with the body:
"Please conduct to llm branch and dispatch builder."

#358 is `design(daemon): importLocation from EndoMount with
npm-registry-proxy + Go-like MVS`, head `affa19d32`, base `llm`,
design-only PR (paths under `<project>/designs/`).

Merge #358 to its base branch `llm` per conductor's standing norms.
After merge succeeds, a separate builder dispatch will follow to begin
implementation per the maintainer's directive.

## Per-action authorizations

- All conductor-standard merge operations. Authorized.
- No PR comments beyond what the conductor role normally posts on merge.

## Not authorized

- Naming a merge method in this dispatch prompt (per memory rule
  `feedback_no_merge_method_in_conductor_prompts.md`; conductor has
  canonical "Always --merge" norm).
- Force operations.

## Dispatch protocol

Read in order:
1. garden/roles/COMMON.md
2. garden/roles/conductor/AGENT.md
3. Skills referenced just-in-time.

Project worktree on `design/daemon-worker-import-from-mount` (head
`affa19d32`).

## Report

A `result` journal entry. Include: merge outcome, the merged commit
SHA on `llm`, the source branch's post-merge state, and any deviations.
