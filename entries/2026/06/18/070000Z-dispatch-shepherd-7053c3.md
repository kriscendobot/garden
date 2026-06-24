---
ts: 2026-06-18T07:00:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: shepherd
dispatch_root: /home/kris/dispatches/shepherd--7053c3
model: sonnet
prs:
  - repo: endojs/endo-but-for-bots
    pr: 462
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/462
  - https://github.com/endojs/endo-but-for-bots/pull/462#issuecomment-4738882512
---

# dispatch: shepherd — #462 lint (kriskowal directive)

kriskowal at 06:58:22Z: "@kriscendobot shepherd lint." — direct
directive to drive CI lint to green on PR #462 (kumavis's
"Export exo-stream APIs from daemon package" coexistence PR).

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#462`, DRAFT, base `llm`,
  head `claude/compassionate-wozniak-oaeptu` at `5d9f21c31`.
- **Failing check**: `lint` (run url
  https://github.com/endojs/endo-but-for-bots/actions/runs/27739412143/job/82063143449).
- **PR author**: kumavis. The bot has push access to
  endo-but-for-bots → can push to this branch under the
  shepherd dispatch (authorized by kriskowal's @-mention).

## Task

In your `project/` worktree at `5d9f21c31`:

1. Read `garden/roles/shepherd/AGENT.md` and
   `garden/skills/ci-failure-classification-loop/SKILL.md` as
   needed.
2. Pull the failing lint job log via `gh run view <id> --log-failed`
   or equivalent.
3. Classify the failure per the four classes
   (A expected / B structural / C tractable / D regression).
4. If tractable (C): apply minimal fix, commit, push.
5. If regression (D): bisect to find offending commit + apply
   targeted fix.
6. If structural impasse (B): surface to liaison, do not push.
7. If expected (A): mark as such in the PR.
8. Run `pre-push-gates` after any commit.

## Authorizations

- Push commits to `claude/compassionate-wozniak-oaeptu` (append
  only; the bot has push access to endo-but-for-bots; kriskowal
  authorized the shepherd dispatch on this PR).
- Top-level summary comment on PR #462 at-mentioning
  @kriskowal and @kumavis.

## Out of scope

- Do NOT rebase or force-push.
- Do NOT touch the substance of kumavis's coexistence shape
  (the dual-export pattern); only fix lint findings.
- Do NOT touch #461, #449, #442, #460, #463, #464, #465, #466.

## Deliverable

A `result` entry under `journal/entries/2026/06/18/` per the
standard shepherd shape:
- Pre/post head SHAs.
- Failure classification.
- Fix substance (if any).
- Pre-push-gates result.
- PR comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: depending on outcome — `next:
  liaison` (if shepherd resolved cleanly) or `next: fixer`
  (if needs fixer escalation).

End your turn with a concise summary back to the orchestrator.
