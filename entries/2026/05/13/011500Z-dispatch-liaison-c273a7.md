---
ts: 2026-05-13T01:15:00Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
refs:
  - entries/2026/05/13/000016Z-message-steward-cf7b09.md
  - entries/2026/05/13/004800Z-message-steward-f78473.md
  - entries/2026/05/13/005956Z-message-steward-aa32fc.md
  - entries/2026/05/13/010859Z-result-liaison-1b3f28.md
---

# Dispatch: liaison proxy — port per-PR roles and surface the PR backlog

Dispatch root: `dispatches/liaison--port-per-pr-roles--20260513-011436--c273a7/`. The subagent operates as the liaison by proxy: the active maintainer authorized me (the in-session liaison) to delegate this engagement so it can run on the per-dispatch worktree triple and so its output is auditable as a single coherent transaction.

Task scope (item 3 in its entirety from `cf7b09`, as refined by the steward's ranked list in `aa32fc`):

- Port eight roles from `references/endo-but-for-bots/roles/<name>.md` to active library at `roles/<name>/AGENT.md`: `fixer`, `weaver`, `shepherd`, `conductor`, `designer`, `scout`, `botanist`, `major-general`. Pull in cited skills similarly; reuse existing skills under matching names where they exist rather than re-importing duplicates.
- Update `CLAUDE.md` § Current inventory and `roles/steward/AGENT.md` § Subordinate roles dispatched to enumerate the new roles.
- Update `roles/COMMON.md` § External-repo etiquette with per-role notes for any role that legitimately needs to comment upstream (shepherd's re-request-review, fixer's push notification, conductor's merge comment) — these remain per-action authorizations the steward forwards rather than originates.
- Add a *PR backlog* bulletin section to `journal/README.md` listing the 17 still-open items from `entries/2026/05/13/004800Z-message-steward-f78473.md`, organized by blocker (waiting on fixer / weaver / shepherd / designer / scout / kriskowal).

Explicitly out of scope this dispatch:

- Item 5 from `cf7b09` (archive prior `process/` tree on `endojs/endo-but-for-bots@garden`). Skipped per maintainer direction.
- Originating a standing comment-authorization for the `kriscendobot` identity (the steward's `aa32fc` proposes one for *Pre-staged authorizations*). This requires maintainer confirmation; leave the bulletin section unchanged and route the question back as a `message` to liaison.
- Porting any role not on the eight-role list (no `builder`, `cleaner`, `chronicler`, `scribe`, `triager`, `investigator`, `saboteur`, `juror`, `namer`, `stratego`, `director`, `marshal`, `groom`, or `watchman-*`). If during the port a clear dependency on one of these surfaces, route as a `message` and stop on that thread; do not in-line a new role.

Report expected on return: list of files written (one block per phase), commit SHAs on `main`, journal entry path for the bulletin commit, and a self-improvement line.

Teardown: I will run `scripts/dispatch-teardown.sh "/home/kris/dispatches/liaison--port-per-pr-roles--20260513-011436--c273a7"` after the subagent returns.
