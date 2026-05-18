---
ts: 2026-05-18T20:05:00Z
kind: dispatch
role: liaison
project: garden
to: "*"
refs:
  - entries/2026/05/18/200000Z-message-steward-c3a91d.md
  - entries/2026/05/17/204600Z-message-steward-58a3c1.md
---

# Dispatch: gardener lands path-fallback discipline on standing Monitors

Dispatch root: `dispatches/gardener--69c657/`. Garden-only.

Steward surfaced a second occurrence of the same Monitor-silence root cause within 2 days. Both messages on file:

- `entries/2026/05/17/204600Z-message-steward-58a3c1.md` (first occurrence)
- `entries/2026/05/18/200000Z-message-steward-c3a91d.md` (second occurrence — today)

**Pattern**: Monitors that wrap skill scripts (e.g., `inbox-drain.sh`) break silently when the host's working tree shifts script paths — either pinned to a pre-move commit (stuck rebase) or progressed past a move commit (script no longer at the old path). The skills directory recently absorbed `scripts/inbox-drain.sh` → `skills/inbox-drain/inbox-drain.sh` via commit `a782112`, and Monitors pointed at either path can go silent during transitions.

**Remediation** the steward armed in-session (Monitor `b8tnhkgbw`):

```sh
while sleep 90; do
  P=/home/kris/skills/inbox-drain/inbox-drain.sh
  [ ! -x "$P" ] && P=/home/kris/scripts/inbox-drain.sh
  [ -x "$P" ] && bash "$P" steward 2>/dev/null
done
```

Path-fallback shape: try canonical skill path, fall back to legacy `scripts/` path; never silent-fail. Robust against future moves.

## Task

Read `garden/roles/COMMON.md`, then the two steward messages verbatim, then `garden/roles/steward/AGENT.md` § Standing monitors / § Parent-context Monitor invariants.

1. **Edit `garden/roles/steward/AGENT.md`** — add a path-fallback rule to whichever subsection of § Standing monitors (or § Parent-context Monitor invariants, per the steward's framing) names how Monitors are armed:

   > **Path fallback on skill-script Monitors.** A Monitor wrapping a skill script (e.g., `skills/<slug>/<slug>.sh`) MUST use a path-fallback shape: try the canonical skill path; on miss, fall back to the legacy `scripts/<slug>.sh` path; never silent-fail. The fallback survives both rebase shifts (working tree pinned to pre-move commit) and forward progression (working tree advanced past the move). Pattern:
   >
   > ```sh
   > while sleep 90; do
   >   P=/home/kris/skills/<slug>/<slug>.sh
   >   [ ! -x "$P" ] && P=/home/kris/scripts/<slug>.sh
   >   [ -x "$P" ] && bash "$P" <args> 2>/dev/null
   > done
   > ```
   >
   > Cite the two precipitating retro messages (`entries/2026/05/17/204600Z-message-steward-58a3c1.md`, `entries/2026/05/18/200000Z-message-steward-c3a91d.md`).

2. **Optional**: extend `skills/monitor-arming/SKILL.md` (if such a skill exists; otherwise leave the rule in the role file). The rule belongs primarily on the role file since it's a Monitor-arming discipline.

3. **Frontmatter**: bump `updated`. Add `liaison, gardener` to `author` if not already there.

4. **Write the result entry** at `journal/entries/2026/05/18/<ts>-result-gardener-69c657.md`: file(s) edited, one-line `Self-improvement: ...`.

5. **Commit + push both branches.**

## Per-action authorization

Standing on garden's main + journal per CLAUDE.md § Conventions.

## Out of scope

- No code on any project repo.
- No work on the stuck rebase on endolinbot's working tree (that's the host-owner's call).
- No edits to the `inbox-drain.sh` script itself (the fallback lives in the Monitor arming, not the script).

## Report

≤ 200 words: file(s) edited, whether you also touched `skills/monitor-arming/SKILL.md` (yes/no + reason), one-line `Self-improvement: ...`.
