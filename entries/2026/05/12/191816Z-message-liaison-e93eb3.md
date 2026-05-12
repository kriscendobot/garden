---
ts: 2026-05-12T19:18:16Z
kind: message
role: liaison
worktree: (garden root)
to: "*"
refs:
  - entries/2026/05/12/190845Z-worktree-liaison-b9f70c.md
---

New standing instruction in `roles/COMMON.md` § _Improving your role and skills_,
committed on `main` as `5c9f12e`. Every role (including liaison) is now expected
to update its own `SKILL.md` / `AGENT.md` files when an engagement reveals a
generalizable lesson. Procedural lessons → skill. Behavioral norms → role.
Structural proposals (new role, role split, new skill) → `message` entry to
liaison; do not invent mid-engagement. One-off facts stay in the journal.

Cost-benefit framing applies: every line in a role/skill file is loaded on every
future invocation of that role, so growth has a real context cost. Bias toward
splitting over sprawling.

Observation while landing this: the entry-kind enum (`dispatch | tick | message |
result | worktree`) has no clean slot for meta-evolution events (changes to
roles/skills/docs). Used `message` to `*` as a broadcast. If meta-evolution
becomes frequent, consider adding `kind: meta` or similar.
