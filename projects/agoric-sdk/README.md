# Project: agoric-sdk

Agoric SDK. Upstream is [agoric/agoric-sdk](https://github.com/agoric/agoric-sdk). The garden's relationship to this repo is **passive standing watch**: a monitor daemon polls the events feed, the journal accumulates a transcript, but the LLM monitor does not dispatch any reactive work because the garden has no active engagement here yet. The monitor's per-class rules (`skills/monitor-agoric-sdk/SKILL.md` on `main`) collapse the entire table to "journal a tick, do not dispatch."

## Rules of engagement

- **Passive standing watch.** Until this garden opens its first PR against `agoric/agoric-sdk` (or one of its forks), every observed event class resolves to *journal one `tick` entry per `NEW` batch and stop*. Do not dispatch. Do not emit further `message` entries proposing per-class rules; the rule table is intentionally uniform. Upgrade to per-class rules at the point an active engagement begins.
- **Routine work, when it begins, happens on a `kriscendobot` fork.** Default identity for clones, branches, draft PRs. Fork name presumed `kriscendobot/agoric-sdk`; confirm before cloning.
- **Upstream pushes require the `kriskowal` identity.** Same shape as endo. The escalated identity is reserved for direct upstream landings.

## Identity and credentials

Same shape as endo. See `journal/projects/endo/README.md` § Identity and credentials for the two-identity protocol.

## Upstream

- Repo: <https://github.com/agoric/agoric-sdk>
- Default branch: `master`
- Standing monitor on this host: `worktrees/agoric-agoric-sdk/watch-agoric-sdk--monitor--20260512-233309/`; daemon cadence 60s.

## Per-topic detail

(None yet; the scholar grows this set when the project moves out of passive standing watch.)

Source entries to consult when growing this directory:

- [`../../entries/2026/05/12/193700Z-message-liaison-5f675d.md`](../../entries/2026/05/12/193700Z-message-liaison-5f675d.md): initial project-context message naming upstream, fork identity, and the read-only-from-the-bot-identity posture.
- [`../../entries/2026/05/13/023600Z-message-monitor-926d77.md`](../../entries/2026/05/13/023600Z-message-monitor-926d77.md): the monitor's "passive standing watch" rule proposal, consolidated across event classes.
- [`../../entries/2026/05/13/023818Z-result-gardener-b86896.md`](../../entries/2026/05/13/023818Z-result-gardener-b86896.md): the rule landing on `skills/monitor-agoric-sdk/SKILL.md`.
