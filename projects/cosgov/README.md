# Project: cosgov

DC Foundation's cosmos-proposal-builder. Upstream is [dcfoundation/cosmos-proposal-builder](https://github.com/dcfoundation/cosmos-proposal-builder). The garden's relationship is **observation-only standing watch** with a small contributor allowlist (`kriskowal`, `netlify[bot]`, `Copilot`, `kriscendobot`). Routine activity in this repo is driven by the maintainer directly; the garden does not dispatch reactive work here.

The "cosgov" slug is the garden's short name for this repo; it does not correspond to a directory or branch upstream.

## Rules of engagement

- **Observation-only.** The monitor's per-event-class table (`skills/monitor-cosgov/SKILL.md` on `main`) defines reactions on a `kriskowal | netlify[bot] | Copilot | kriscendobot` allowlist, with everything outside the allowlist routed to a `tick` entry with no further dispatch. Inside the allowlist, the four review/comment classes share a single rule (one shared bullet covers `PullRequestReviewEvent`, `PullRequestReviewCommentEvent`, `IssueCommentEvent`, `IssuesEvent`).
- **No active garden engagement yet.** As of 2026-05-13 the garden has not opened a PR against `dcfoundation/cosmos-proposal-builder`. If that changes, the monitor skill's per-class rules need a refresh (the observation-only stance was not designed for active engagement).
- **`kriscendobot` has forked the repo** as of 2026-05-12 (a `ForkEvent` is in the journal); the fork is on standby for any future active work.

## Identity and credentials

Same two-identity protocol as endo: `kriscendobot` for routine fork work, `kriskowal` for upstream landings. The maintainer is also the upstream's primary contributor here, so the line between "the maintainer's own work on cosgov" and "the garden's work on cosgov" is fuzzier than for the endo/agoric projects.

## Upstream

- Repo: <https://github.com/dcfoundation/cosmos-proposal-builder>
- Default branch: `main`
- Standing monitor on this host: `worktrees/dcfoundation-cosmos-proposal-builder/watch-cosgov--monitor--20260512-233310/`; daemon cadence 60s.

## Per-topic detail

(None yet; the scholar grows this set if and when active engagement begins.)

Source entries to consult when growing this directory:

- [`../../entries/2026/05/13/023047Z-tick-monitor-08f970.md`](../../entries/2026/05/13/023047Z-tick-monitor-08f970.md): cosgov backfill batch showing all the event classes typical of this repo plus the `ForkEvent` from `kriscendobot`.
- [`../../entries/2026/05/13/023400Z-result-gardener-bb97fb.md`](../../entries/2026/05/13/023400Z-result-gardener-bb97fb.md): the monitor skill landing, including the rationale for the hybrid "posture + allowlist + per-class list" shape (the shared-allowlist factoring).
