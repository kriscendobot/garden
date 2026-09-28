---
tier: mentat
dispatch: manual
---
role: builder
handler-timeout: 14339

# Build: autonomous Ironhorse test262 ratchet (per-crank PRs, mentat merge watcher)

Repo: kriscendobot/garden, main2 (garden's own repo; land directly). The maintainer requested this on 2026-09-28. Authorization of record: journal `entries/2026/09/28/201230Z-message-gardener-aa49da.md`. Read it first. Its scope binds this job; do not widen it.

**What the maintainer asked for:** the Ironhorse test262 ratchet (tracker https://github.com/kriscendobot/garden/issues/51, target endojs/endo-but-for-bots base `llm`) should run autonomously:
- one PR per crank (per failure/abort cluster), not an omnibus;
- each PR runs a gauntlet, grows coverage, loses nothing, passes CI under a shepherd, and covers all its new code;
- a mentat-tier watcher then decides the merge, and the ratchet moves to the next crank.

**Today this is blocked in two places. Build both, as narrowly as the dependabot precedent:**

1. **Delegated merge authority in the conductor spine.** `scripts/jobs/gardening/ci-wait-merge.sh` requires an allowlisted maintainer APPROVED review. The only exception is `--dependabot-auto-merge`, which substitutes a criteria gate for the signature and keeps every other guard. Add an analogous, equally narrow path for ratchet PRs, for example `--ratchet-delegated-merge`. It must mechanically check all of the following, and fail closed if any cannot be read:
   - repo `endojs/endo-but-for-bots`, base `llm`, and the PR author is the bot;
   - the PR carries the ratchet arc's marker;
   - an active, unrevoked authorization record exists in the journal. Design a small machine-readable record, for example `config/delegations/ironhorse-test262-ratchet`, with a revocation path, and seed it by reference to the entry above;
   - a watcher attestation exists for the exact head SHA, covering gauntlet complete, coverage grew, zero lost, and new code covered.
   It must keep CI freshness on the exact head, the maintainer CHANGES_REQUESTED veto, dismissal handling, the rebase-restarts-the-wait loop, and the downstream-branch retention rule. Add tests alongside the existing dependabot-path tests.

2. **A standing mentat watcher.** The model-selection rule says the mentat tier runs only on manual dispatch, and no automatic producer may reach it (`skills/model-selection/SKILL.md`, and the claim and handler gates in `monk-claude.sh` / `cleric-codex.sh`). Add a scoped carve-out, honored only when the delegation record above is active, so that a scheduled "crank the ratchet" tick can run at mentat tier. Suggested cadence: every 2h, via `set-schedule.sh`. Each tick reads the arc's state and advances exactly one step:
   - no open ratchet PR: post the next crank's builder job. Ranked queue: the refined `ironhorse-aborted:*` reasons in report.json, starting from the round-3 branch-point sweep. Tell it to open one draft PR with the arc marker, its own dual-run regression suite, and a refreshed `baseline/refresh-<date>/` floor;
   - a draft PR without a finished gauntlet: run the gauntlet;
   - CI red: post a shepherd;
   - all criteria met on the head: independently verify them (re-derive covered.txt no-loss and growth against the enforced floor from the PR's own sweep artifacts, check new-code coverage, check gauntlet disposition), write the head-pinned attestation, and post the conductor merge job using the delegated path;
   - merged: update the tracker issue, then start the next crank.
   Make it idempotent across ticks (date-suffixed basenames per the job-board recurring-verb rule), make it halt and surface to the maintainer inbox when it is stuck or a criterion fails twice, and make it stop entirely when the delegation is revoked.

**Also:**
- Update `roles/conductor/AGENT.md`, the orchestration/model-selection skill docs, and `context/operations/` (a short page on the ratchet autopilot, plus how to pause or revoke it) so the new authority is documented where the approval rule is.
- Coordinate with the running job `ironhorse-test262-ratchet-round3-20260928`. The liaison has told it to deliver just the first crank as a single draft PR with the arc marker. That PR is the watcher's first subject. Use the same arc marker string it uses; message that job over the bus to agree on one if needed.
- Do not arm the schedule until the delegated path and its tests land and pass. Report the exact commands used to arm it, pause it and revoke it.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-28T20:13:17Z
