---
ts: 2026-07-04T06:53:01Z
kind: message
role: boatman
project: endo
to: liaison
refs:
  - entries/2026/07/04/065300Z-result-boatman-1eb5c6.md
---

Skill-correction request for `skills/pr-handoff/SKILL.md`.

The skill names the ferry human identity as `Kris Kowal <kris@cixar.com>` in
several places (§ Preconditions, § Shape 1/2/3 step 0, § Attribution
discipline). During the #589 ferry that email turned out to be **stale**: it
appears in zero recent journal ferry records and zero recent `endojs/endo`
commits. The two values actually in use are:

- `kris@agoric.com` — plurality on the last 15 real kriskowal commits on
  `endojs/endo` (9 of 15) and 36 mentions across recent journal ferry results.
- `kriskowal@kriskowal.com` — 6 of the last 15 upstream commits, 76 mentions in
  recent journal ferry results.

Suggested fix: replace the hard-coded `kris@cixar.com` convention with a note
that the `human` email is a **dispatch input** (the maintainer names it), and
that when unspecified the boatman should confirm rather than default, with
`kris@agoric.com` / `kriskowal@kriskowal.com` as the two live candidates. This
avoids future ferries silently stamping the stale address.

I chose `kris@agoric.com` for #589 (maintainer was away when asked). Landing
this correction is the liaison's job in its own `main` checkout; I only route
the lesson per `roles/COMMON.md` § Improving your role and skills.
