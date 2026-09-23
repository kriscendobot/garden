---
ts: 2026-06-17T21:13:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: builder
dispatch_root: /home/kris/dispatches/builder--d583f9
refs:
  - https://github.com/endojs/endo-but-for-bots/tree/kriskowal-iroh-heartbeat
---

# dispatch: builder — open PR for kriskowal-iroh-heartbeat + start gamut

User directive (kriskowal via garden, 2026-06-17T21:11Z):

> Please dispatch a builder to create a PR for the branch kriskowal-iroh-heartbeat and run the gamut.

## State at dispatch time

- **Branch**: `kriskowal-iroh-heartbeat` head `2a15545f0` (commit msg `WIP iroh heartbeat`).
- **Base inferred**: `llm` (parent commit `9a3b5e97f` is at `origin/llm`).
- **Predecessor**: `c3ef34e108 feat(daemon): iroh network transport ("dial keys, not IPs" + TLS) (#446)` — recently merged.

## Task

In your `project/` worktree at `2a15545f0`:

1. **Inspect the WIP commit**: `git show HEAD` to see what kriskowal staged. Read the diff carefully.
2. **Decide whether to extend or finalize**:
   - If the diff is substantively complete (adds heartbeat protocol to the iroh transport, tests included, etc.): finalize the commit message and prepare for PR. Rename `WIP iroh heartbeat` to a proper conventional commit (e.g., `feat(daemon): iroh transport heartbeat for liveness signaling`).
   - If the diff is genuinely incomplete: build out the rest per the design intent (read `designs/iroh*.md` if any; look at what the predecessor PR #446 left as TODO).
3. Read `garden/skills/pr-formation/SKILL.md` and `garden/skills/pre-pr-checklist/SKILL.md`.
4. Add tests if missing.
5. Add a changeset (per repo convention).
6. Run `corepack yarn workspace @endo/daemon test` (the daemon package likely has the iroh transport).
7. Run pre-push-gates.
8. Commit per logical group (suggested):
   - `feat(daemon): iroh transport heartbeat for liveness signaling` (replacing the WIP)
   - `test(daemon): coverage for iroh transport heartbeat`
9. Force-push (or amend + push) to `kriskowal-iroh-heartbeat`.
10. **Open a DRAFT PR**:
    - Base: `llm`
    - Title: derive from the substance (e.g., `feat(daemon): iroh transport heartbeat for liveness signaling`)
    - Body: per pr-formation skill — summary, scope, test plan, design departures, security/scaling/docs/compatibility sections, @-mention @kriskowal.
11. Post a brief top-level comment on the new PR @-mentioning @kriskowal noting:
    - PR opened DRAFT.
    - Substance summary.
    - Ready for the gamut (cleaner → barrister → ...).

## Authorizations

- Push to `kriskowal-iroh-heartbeat` (may amend the WIP commit; force-with-lease).
- Open DRAFT PR.
- Top-level comment.
- Do NOT touch upstream endojs/endo.

## Out of scope

- Do NOT touch other branches.
- Do NOT un-draft (judge does that after gamut).

## Deliverable

A `result` entry under `journal/entries/2026/06/17/` naming:

- WIP-commit substance summary.
- Decision (extend vs finalize).
- New head SHA + commit SHAs.
- New PR number + URL.
- Test results.
- pre-push-gates result.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: cleaner` (gamut stage 1).

End your turn with a concise summary back to the orchestrator. The orchestrator will dispatch cleaner next once the PR is open.
