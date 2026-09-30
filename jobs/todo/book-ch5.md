---
tier: mentor
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-30T03:46:48Z cleared=none -->

---
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Garden book, chapter 5: Roles reference (exacting detail)

One chapter of a multi-part "book" (orchestration `garden-book-orch`). Write
to `journal/projects/garden-book/ch5-roles-reference.md` as Markdown.

## Ground this in real sources — every role file, actually read

Read `roles/COMMON.md` first (the standing instructions every gardener reads
before its own role file). Then read **every** `roles/<name>/AGENT.md` file —
the current inventory is listed in `CLAUDE.md` § Current inventory
(`americanizer`, `appellate`, `assayer`, `barrister`, `boatman`, `botanist`,
`builder`, `cleaner`, `conductor`, `designer`, `deslopper`, `fixer`,
`foreman`, `gardener`, `groom`, `journalist`, `judge`, `justice`, `liaison`,
`librarian`, `mentor`, `monitor`, `orchestrator`, `pages-shepherd`,
`prosecutor`, `proxy`, `researcher`, `scholar`, `shepherd`, `solicitor`,
`sysop`, `triager`, `watchman`, `weaver`, `web-builder`, `web-designer` —
confirm this list against the live directory listing, since it may have
changed). Note which are non-postable stubs (`judge`, `monitor`, `sysop`)
and what they redirect to. Also cover the juror seats under
`roles/jurors/<seat>/AGENT.md` (dispatched only by the scripted panel, never
posted/claimed directly) — list every seat with a one-line purpose, without
expanding each to full detail (the panel skill in chapter 7 covers how
they're used).

## What this chapter should cover, per role

For each top-level role, an entry with:

- **Purpose**, in the role's own words (don't paraphrase away precision).
- **How work reaches it** (a specific job basename pattern, a watcher, a
  scripted state-machine stage — be concrete).
- **Skills it uses**, by name, with a one-line note on why each matters to
  this role specifically (not just a repeated link list).
- **Operating norms or bounds** worth knowing — what it must NOT do, any
  authority limits, anything that would surprise someone who assumed it
  worked like a generic role.
- **Definition of done**, if the file states one.

Organize the chapter so it's actually navigable: group related roles
together (the PR-lifecycle chain: builder/assayer/cleaner/fixer/weaver/
shepherd/conductor; the judicial/panel-adjacent: solicitor/barrister/
justice/appellate/prosecutor and the juror seats; the meta/library roles:
scholar/librarian/journalist/mentor; the fleet-operation roles: liaison/
triager/watchman/orchestrator/proxy/boatman; the specialized fixers:
americanizer/deslopper/pages-shepherd/web-builder/web-designer). A reader
should be able to jump straight to the role they care about.

## Budget and scope

This is the largest chapter. If you cannot cover every role at full depth in
one cycle, do the PR-lifecycle chain and the liaison/triager/watchman/
orchestrator group first (the ones a new user is most likely to need), write
what you have, and post a follow-on job named
`book-ch5-roles-reference-part2` (plain `post-job.sh`, same output file
appended to, not overwritten) naming exactly which roles remain. Do not
silently truncate — a thin one-line entry for a role you didn't have budget
to cover properly is worse than an honest "remaining: X, Y, Z" note plus a
follow-on job.
