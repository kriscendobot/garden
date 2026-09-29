---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Decide: should the Claude-only completion nudge and same-session `continue` extend to other handlers?

Open question from a 2026-09-23 liaison-followup (report `fix-finished-but-not-completed-requeue`):
after the requeue fix, the headless-mode note now reaches every handler
(`cleric-codex`, `opencode`, `mystic-kimi`), but the monk handler's bounded
in-process **completion nudge** and same-session **`continue`** prompt for an
unfinished end-turn remain Claude-only (`skills/job-board/SKILL.md`
§ Dispatch and headless completion). Decide whether that's an intentional,
irreducible capability gap or something worth closing.

## Task

For each non-Claude handler (`cleric-codex`, `opencode`, `mystic-kimi`),
determine whether its CLI actually supports an analogous mechanism: resuming
the *same* session/process to nudge it toward finishing, rather than only a
fresh requeue. If a handler's tool has no equivalent (no session-resume
primitive at all), that's a genuine capability gap — document it plainly and
don't force a workaround. If one or more do support something equivalent,
scope extending nudge/continue to them and say whether it's worth the
implementation cost relative to the plain-requeue fallback that already
exists and already works.

This is a scope/feasibility decision, not a mandate to implement — land a
design doc either way (even a short one concluding "capability gap, no
action" is a valid, complete answer) so the open question in the 2026-09-23
followup is closed rather than sitting indefinitely.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-29T06:08:03Z
