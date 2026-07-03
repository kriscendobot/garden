---
created: 2026-05-12
updated: 2026-05-12
author: liaison
---

# Skill: self-improvement

The final task of every engagement, before reporting back. Turns one-off observations into durable role and skill content so the next engagement starts from a stronger base.

This skill is canonical. The "Improving your role and skills" section in `roles/COMMON.md` defers here.

## When to use

Always, as the last step of any engagement, including the liaison's own turns. The cost is one short scan of your run while context is still fresh; the reward compounds across every future invocation of the role.

## What to look for

While the engagement is fresh, scan the run for any of:

1. **A gotcha that surprised you.** A failure mode the existing skill or role file did not warn about, or that contradicted what it claimed.
2. **A technique you derived from scratch.** A short procedure or command sequence you wrote inline that another role could reuse.
3. **A skill the role did not cite that turned out to be useful.** Add it to the role's `## Skills` list with a one-line "why".
4. **An outdated or wrong example.** A session example whose referenced PR / commit / file no longer matches reality, or where the lesson has shifted.
5. **A new role.** If the engagement felt like a posture none of the existing roles cover, draft a structural proposal (see *Where it goes* below).
6. **Overlap or contradiction between roles or skills.** Two places saying different things about the same operation.

## Where it goes

Route the lesson by what kind of change it implies:

- **Procedural** (the *right way* to do something) → the relevant `skills/<skill>/SKILL.md`. Append to its `## Notes from the field` section, or revise the procedure if the existing one was wrong. If the technique is reusable across roles and not yet a skill, create one at `skills/<slug>/SKILL.md`.
- **Behavioral** (*when* to do something, *whether* to enter a posture) → your `roles/<role>/AGENT.md`. Update operating norms or definition of done.
- **Structural** (a new role is warranted, a role should split, a skill should be retired) → write a `message` journal entry addressed to `liaison`. Do not invent or rename roles/skills mid-engagement; let the liaison gather the proposal and act with the user's confirmation.
- **One-off fact** (a quirk of a specific repo, a user preference, a credential mechanic) → a `message` journal entry tagged with the relevant `project:` slug. Never bloat a shared role or skill with a one-project fact.

Cross-cutting documents (`CLAUDE.md`, `WORKTREES.md`, `roles/COMMON.md`) are touched only when a role is added/removed/renamed, or when a standing instruction itself changes — and the latter case needs explicit user direction.

## Threshold for landing a change

- **One vivid observation** is enough to add a pitfall, a "Note from the field," or an example to an existing skill or role.
- **A pattern across ≥3 engagements** is required to add a new rule or law that constrains future work.
- **Removing or rewriting an existing rule** needs explicit user direction, not just one engagement's evidence.

## Cost-benefit framing

Every line in a role or skill file is loaded into every future invocation of that role. Before adding, ask: is this a pattern others will hit, or a single observation? Roles should stay focused — if responsibilities are growing, propose splitting via a `message` to `liaison` rather than letting the role sprawl. Skills should stay procedural — if a skill is accreting behavior rather than procedure, that behavior probably belongs in a role.

## How to write the change

- Match the voice of the existing file. Terse, imperative, declarative.
- Preserve audit value. Don't delete a session example that's still accurate just because there's a fresher one. Add the fresher one alongside.
- Keep skill files at 1–2 screens. If a skill is growing past two screens, refactor: split into two skills, or move reference material into a sibling note.
- Skill content is canonical; role files cite skills by relative path. Don't copy skill prose into a role file; link to it.

## Output

A one-line entry near the end of your engagement's final report **and** in your `result` journal entry:

```
Self-improvement: <changed file 1>, <changed file 2>; <one-line summary of why>.
```

If nothing was learned, write:

```
Self-improvement: nothing this time.
```

The "nothing this time" line is intentional. It signals that the role considered self-improvement and decided no change was warranted — meaningfully different from forgetting the step.

## Pitfalls

- **Premature rules.** A new "law" added on one engagement's evidence is usually wrong. Wait for the pattern.
- **Skill bloat.** Resist the urge to append every small observation. After a long arc, refactor: split overgrown skills, prune stale examples, consolidate duplicate rules.
- **Voice drift.** Different agents write differently. Match the surrounding text's tone; a role file written terse-imperative shouldn't suddenly contain a chatty paragraph.
- **Ghost references.** When you delete a rule or skill, grep for references to it in role files and other skills. Stale links defeat the indirection.
- **Updating the role you're not in.** If a finding belongs in a sibling role's file, write the change as a recommendation in the engagement report (and as a `message` journal entry if it's structural). The next engagement under that role can apply it.

## Notes from the field

(Terse and dated. Append; do not rewrite history.)

- _2026-05-12_ — Adopted from `references/endo-but-for-bots/skills/self-improvement.md` at commit `cc79140a6`. Carried over: the six "what to look for" cases, the threshold rules, the "nothing this time" meta-signal, the pitfalls list. Adapted for our garden: routing extended with the journal `message` pattern for structural and one-off lessons; the output line is now expected in the `result` journal entry as well as the report; the source's project-specific style rules (em-dash, relative-paths) were not generalized and remain endo-only.
- _2026-07-03_ — Restored on `main2`. The adopted copy was lost in the v2 migration, leaving `roles/COMMON.md` § Improving your role and skills and `roles/mentor/AGENT.md` dangling at this path; the [review-retrospective](../review-retrospective/SKILL.md) double-loop leans on this skill existing (it is the inward, per-engagement loop, distinct from the prosecutor's review-process loop and the mentor's automation loop). V2 routing note: a gardener claims jobs rather than being dispatched into a worktree triple, so "message addressed to liaison" is a `skills/message-bus/SKILL.md` message to `liaison` (structural change) or a `message` entry tagged with the `project:` slug (one-off fact); the gardener never lands a role/skill change itself unless the job is explicitly a garden-infra build on `main2`.
