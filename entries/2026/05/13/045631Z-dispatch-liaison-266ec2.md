---
ts: 2026-05-13T04:56:31Z
kind: dispatch
role: liaison
project: garden
to: "*"
---

# Dispatch: gardener adds a fifth standing monitor for kriskowal/garden, dispatched-as-liaison

Dispatch root: `dispatches/gardener--add-garden-issue-monitor--20260513-045631--266ec2/`.

The maintainer asked for a monitor on the garden repo itself, with issue activity surfaced to a subagent running as a proxy of the liaison rather than as a `monitor`. This is a structural variation on the existing four standing monitors: the daemon side is unchanged (one more `scripts/monitor-poll.sh` invocation polling `https://api.github.com/repos/kriskowal/garden/events`), but the LLM side dispatches a liaison-proxy because the events are about the garden's own meta-evolution, which is liaison work, not project-monitor work.

Task scope:

1. **Standing-worktree setup**. Create `worktrees/kriskowal-garden/watch-garden--monitor--<UTC-ts>/` as a detached worktree of `main` off the garden's shared admin tree at `/home/kris/.git/`. Add `.garden/` to `/home/kris/.git/info/exclude` so the daemon's polling state directory does not appear in `git status`. The garden does not need a separate bare clone (we are the repo); the shared admin tree is the source of worktrees.
2. **Per-project skill** `skills/monitor-garden/SKILL.md`. Issue-focused (`IssuesEvent` and `IssueCommentEvent` on issues are the headline classes); most other classes silent because the maintainer (and the in-session liaison) drive non-issue activity directly. Explicitly note: the steward's dispatch on `NEW` lines from this daemon runs the `liaison` role, not `monitor`. Sibling-but-distinct from the other four per-project skills.
3. **Role-and-doc interlocks**. `roles/monitor/AGENT.md` § Per-project skills: add the garden mapping. `roles/steward/AGENT.md` § Standing monitors: add the fifth row and footnote the asymmetric dispatch role. `CLAUDE.md` § Current inventory: add `monitor-garden` to Skills if you treat the per-project monitor skills as listed; otherwise leave alone (the existing four are not listed individually).
4. **Journal index**. Write `journal/worktrees/endolinbot/watch-garden--monitor--<UTC-ts>.md` with the standard schema (host, worktree, path, repo, branch, role, status, created_at, last_heartbeat, task, prs:[]). Update `journal/worktrees/README.md`'s Current entries table to include the new row. Update `journal/README.md` *Active worktrees* and *Open monitors* sections to reflect the now-five standing monitors.
5. **Launch the daemon**. From an absolute-path invocation (so it survives the dispatch root's teardown): `nohup bash /home/kris/scripts/monitor-poll.sh kriskowal/garden /home/kris/worktrees/kriskowal-garden/watch-garden--monitor--<ts> 60 > /tmp/garden-monitor-kriskowal-garden.log 2> /tmp/garden-monitor-kriskowal-garden.err & echo $! > /tmp/garden-monitor-kriskowal-garden.pid; disown`. Verify with `kill -0 $(cat /tmp/garden-monitor-kriskowal-garden.pid)` and a 60-second wait + `tail` for the first `NEW <count>` batch.

Out of scope:

- Do not invent a new role for garden-issue-handling. Liaison-by-proxy is the contract; the existing `roles/liaison/AGENT.md` already covers the work.
- Do not touch the four existing monitor skills.
- Do not dispatch a liaison-proxy subagent in this engagement to process current open garden issues. Future steward cycles fire those dispatches when `NEW` lines arrive.

Report on return: commit SHAs on main and journal, daemon PID, first-poll `NEW` line confirmation, the dispatch-role asymmetry (one sentence on how the steward picks liaison vs monitor for which standing-monitor's NEW lines).
