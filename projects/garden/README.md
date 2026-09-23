# Project: garden

The garden itself. Upstream is [kriskowal/garden](https://github.com/kriskowal/garden). This is the meta library of roles, skills, and the journal you are reading; it is also a *project* in its own right, because the garden's own evolution (new roles, new skills, layout shifts, conventions) is work the garden does on itself. The maintainer and the in-session liaison drive that work; the steward does not (meta-evolution exceeds the steward's authority bounds).

This project README is the agent-facing context-library entry point for "what is the garden project." It is distinct from [`../../README.md`](../../README.md), the journal's maintainer dashboard (bulletin board + ongoing work). The two files serve different readers: this one answers "what is this project and what may an agent do with it?"; the dashboard answers "what items need maintainer attention right now?"[^dashboard]

## Rules of engagement

- **Maintainer and in-session liaison drive non-issue activity directly.** Pushes to `main` and `journal` are routine; no PR workflows for the garden's own repo (per `CLAUDE.md` § Conventions on `main`). The `journal` branch is orphan; it never merges with `main`.
- **Issue activity on `kriskowal/garden` is meta-evolution work.** The standing-monitor daemon on this host (`watch-garden`) polls the events feed at 60s and surfaces `IssuesEvent` and `IssueCommentEvent` activity. Per `skills/monitor-garden/SKILL.md` on `main`, the steward dispatches a **liaison** subagent on a `NEW` line from this daemon, not a `monitor` subagent. This asymmetry is the lone case among the standing monitors; the rationale (the liaison is the only role with authority over meta-evolution) is in the skill.
- **Most non-issue event classes are silent on the daemon side.** The maintainer and the liaison originate `PushEvent`, `CreateEvent`, `DeleteEvent`, and similar; surfacing them again would be a feedback loop. The skill's per-class table marks these as silent.
- **The steward cannot dispatch the gardener.** The gardener is the liaison's deputy for meta-evolution; meta-evolution authority exceeds the steward's bounds. See [`../../../roles/gardener/AGENT.md`](../../../roles/gardener/AGENT.md) § Posture on `main`.

## Identity and credentials

The garden runs under one of the two identities (`kriscendobot` or `kriskowal`) depending on what host it is running on:

- The Docker-hosted bot instance runs under `kriscendobot` and pushes to `kriskowal/garden` directly (the bot has push access; no PR workflow needed).
- The maintainer's primary machine runs under `kriskowal` and pushes the same way.

There is no two-identity switching dance for this project; both identities push to the same upstream and the same branches. The `kriscendobot` vs `kriskowal` distinction matters for other projects (see [`../endo/README.md`](../endo/README.md), [`../agoric-sdk/README.md`](../agoric-sdk/README.md)) but not here.

## Upstream

- Repo: <https://github.com/kriskowal/garden>
- Branches: `main` (the role/skill library + top-level docs) and `journal` (orphan, append-only).
- Standing monitor on this host: `worktrees/kriskowal-garden/watch-garden--monitor--20260513-045844/`; daemon cadence 60s.

## Per-topic detail

(None yet; the scholar grows this set as garden-tagged journal entries accumulate. Likely topic candidates: `meta-evolution-flow.md` (gardener dispatches and self-improvement routing), `bot-vs-maintainer-identity.md` (the two identities on different hosts), `bulletin-ownership.md` (which role owns which section).)

Source entries to consult when growing this directory:

- The full set of `^project: garden$`-tagged entries. As of 2026-05-13, the relevant ones include the rule-elision-test landing ([`../../entries/2026/05/13/001202Z-message-liaison-28a603.md`](../../entries/2026/05/13/001202Z-message-liaison-28a603.md)), the standing-monitor-on-garden dispatch ([`../../entries/2026/05/13/045631Z-dispatch-liaison-266ec2.md`](../../entries/2026/05/13/045631Z-dispatch-liaison-266ec2.md)), and gardener results landing context-library, librarian, scholar, journalism, projects/, scripts-reorg in the dispatch this file is part of.

[^dashboard]: A maintainer who lands here looking for "what needs my attention" should turn to [`../../README.md`](../../README.md) instead; the dashboard is the maintainer's surface. This project README is for an agent answering the question "I have been asked to do something on the garden project; what is the project and what are the rules?".
