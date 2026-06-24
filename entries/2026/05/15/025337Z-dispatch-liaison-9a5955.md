---
ts: 2026-05-15T02:53:37Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
---

# Dispatch: investigator surveys node-20-macos test flakes and files an issue

Dispatch root: `dispatches/investigator--9a5955/`. Project worktree on `endojs/endo-but-for-bots@llm` for read access to CI history.

Maintainer directive (2026-05-15): *"We have noticed that the node 20 test on Mac has flaked a number of times. Please dispatch a subagent to inspect the entry logs to find the affected CI failures and file an issue on endo-but-for-bots."*

The specific check name is `test (20.x, macos-15)` (per recent journal entries — e.g., #226's CI rollup earlier today flagged a FAILURE on this exact check that was deemed unrelated flake). The investigator surveys recent failures, identifies the pattern, files an issue.

## Per-action authorization

Standing on endo-but-for-bots: read CI logs, create an issue. READ-ONLY on `endojs/endo`.

## Task

1. **Survey recent failures of `test (20.x, macos-15)`** across endojs/endo-but-for-bots PRs in the last 24-48 hours. Methods:
   - `gh api repos/endojs/endo-but-for-bots/actions/runs?per_page=100` to list recent workflow runs.
   - Filter for the `CI` workflow's `test` matrix job, `20.x, macos-15` variant.
   - For each FAILURE, pull the failing-step's log tail via `gh run view <run-id> --log-failed`.

2. **Cluster the failures** by error signature. Common shapes to expect:
   - Test-specific failure (a single test consistently failing).
   - Daemon-related (UNIX socket, timing, process cleanup).
   - Resource exhaustion (memory, file handles).
   - Network/external-service (rare).
   - True infra (macOS-15 runner issue).

3. **Compute the flake rate** if possible: count of `20.x, macos-15` FAILURE vs total `20.x, macos-15` runs over the window. Cite the denominator.

4. **Read relevant journal entries** for cross-reference: today's #226 fixer carry-feedback, the #244 prettier-fix dispatch (where this check was first flagged as unrelated to the diff), today's other failures.

5. **File a single issue** at https://github.com/endojs/endo-but-for-bots/issues/new with:
   - Title: `CI: test (20.x, macos-15) flaking — investigation`
   - Body: cluster table (signature → count), example run links, links to journal entries citing the same flake, proposed next steps (mitigate vs investigate root cause).
   - Use the bot identity (standing comment authorization on this repo permits issue creation).

## Out of scope

- No code changes (the investigator authors no fix; the issue is the deliverable).
- No comment on upstream `endojs/endo`.
- No dispatch of follow-up roles (the issue becomes the queue's marker; future work dispatches as separate engagements).

## Report

≤ 400 words: flake rate, cluster shape, issue URL, top-2 representative failure signatures, one-line `Self-improvement: ...`.
