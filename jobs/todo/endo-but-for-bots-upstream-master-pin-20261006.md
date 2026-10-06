---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Pin a branch to upstream endojs/endo's master on endo-but-for-bots, for CI shepherding

Maintainer (kriskowal, liaison 2026-10-06): "Upstream endojs/endo is failing
CI on master. Please create a pinned branch to master on endo-but-for-bots
and shepherd."

**Confirmed before posting this job** (don't rediscover): upstream
`endojs/endo`'s `master` at `356d6e70affc5adfd35cd65adda758119521ec5f` has
real check-run failures right now:
- `viable-release`: failure
- `test (22.x, macos-15)`: failure
- `lint`: failure
(everything else — browser-tests, build, test262, test-xs, test-ocapn-python,
test-hermes, cover, zizmor, release, deploy, update — is green on that same
commit.)

Note `endojs/endo-but-for-bots` is **not** a GitHub-linked fork of
`endojs/endo` (`fork: false`, no parent) — it's this garden's independent
bot-authorized sandbox repo, and its own `master` branch is a stale,
unrelated snapshot. There is no existing tracking relationship to lean on;
set one up explicitly for this task.

## Task

1. Fetch upstream `endojs/endo` at `master`
   (`356d6e70affc5adfd35cd65adda758119521ec5f`) and push it to
   `endojs/endo-but-for-bots` as a new frozen branch, following this repo's
   normal frozen-base-branch naming (`skills/frozen-base-branch/SKILL.md`):
   `master-356d6e7`.
2. Branch a working head off that frozen base (e.g.
   `fix-upstream-master-ci`) and open a **draft** PR on
   `endojs/endo-but-for-bots`, head = the working branch, base =
   `master-356d6e7`, via `ensure-pr.sh` (one PR per job,
   `skills/pr-creation-flow/SKILL.md`). The PR starts with no diff against
   its base — that's expected; the shepherd stage adds the fix commits.
3. Confirm CI actually dispatches on this PR (Actions workflows trigger on
   `pull_request` regardless of base-branch identity in every other PR this
   fleet has opened on this repo, but verify rather than assume, since this
   base has no history here). If CI does **not** dispatch at all, that's a
   real impasse — report it plainly rather than guessing around it.
4. Hand off to the shepherd job already parked behind you
   (`endo-but-for-bots-upstream-master-ci-shepherd-20261006`, blocked on this
   job) with the PR URL and head SHA in your completion report.

## Scope

This is explicitly about getting upstream's own `master` green on a fork
branch the fleet can push to — not a design change, not new feature work.
Do not touch `llm` or any of its in-flight work. No ferry/upstream-push
authority here; once green, carrying anything back to `endojs/endo` itself is
a separate, later, explicitly-authorized decision.
