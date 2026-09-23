---
ts: 2026-06-04T03:18:14Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: shepherd
dispatch_root: /home/kris/dispatches/shepherd--ed2960
prs:
  - repo: endojs/endo-but-for-bots
    pr: 411
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/411
  - https://github.com/endojs/endo/pull/3296
  - https://github.com/endojs/endo-but-for-bots/pull/411#issuecomment-4618214234
---

# dispatch: shepherd — #411 upstream #3296 CI diagnosis

Maintainer directive (kriskowal, #411 comment 2026-06-04T03:17:47Z):

> Please take a look at the CI failure at
> https://github.com/endojs/endo/pull/3296

Despite the fixer's Playwright 1.58.2 pin (multi-mirror CDN
failover) and the weaver's rebase onto fresh master, upstream
endo#3296 is still failing CI. This dispatch diagnoses.

## Target

- Upstream PR: endojs/endo#3296 (boatman-ferried mirror of
  #411).
- Bot-side: #411 head `37440d0e2` on `ci/cache-playwright-browsers`,
  base `master-07aff33`.

## Procedure

1. Inspect upstream endo#3296's failing CI run(s):
   ```
   gh run list --repo endojs/endo --branch <upstream-head-branch> --limit 5
   gh run view <run-id> --repo endojs/endo --log-failed
   ```
   The upstream head will need looking up via `gh pr view 3296
   --repo endojs/endo`.
2. Classify per `garden/skills/pr-ci-watch/SKILL.md`:
   - If Playwright install STILL hanging (mirror failover
     didn't help): real, requires further fixer work (maybe
     bump install timeout further or pin to an even older
     known-good version).
   - If a DIFFERENT failure: classify accordingly.
   - If transient flake: re-enqueue likely won't help if
     it's hit twice; surface verdict.
3. Post a classification comment on bot-side #411 (or
   upstream if appropriate; bot has no upstream credentials —
   bot-side comment is safer).

Per memory `feedback_shepherd_to_fixer_auto_chain.md`,
escalate via `next: <role>` if a code change is needed.

## Per-action authorizations

- Read upstream CI logs. Authorized.
- Post a classification comment on bot-side #411. Authorized.
- Re-enqueue CI (sparingly; CDN-flake re-runs are wasteful).

## Not authorized

- Modifying source files.
- Touching upstream endojs/endo (no credentials).
- Force-pushing.
- Un-drafting / merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/shepherd--ed2960/garden/roles/COMMON.md`
2. `/home/kris/dispatches/shepherd--ed2960/garden/roles/shepherd/AGENT.md`
3. `garden/skills/pr-ci-watch/SKILL.md`

Project worktree at `project/` on `ci/cache-playwright-browsers`
(head `37440d0e2`).

## Report

A `result` journal entry. Include:

- Upstream run URL + failing job(s).
- Per-failure classification with log evidence.
- Action taken (re-enqueue / classification comment).
- Comment ID(s).
- Escalation with `next: <role>` if applicable.
