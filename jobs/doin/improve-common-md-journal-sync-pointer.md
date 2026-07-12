roles/COMMON.md
Three references (lines 26, 192, 237) point every role at `garden/skills/journal-sync/SKILL.md`, which does not exist in the v2 library — so each role improvises the detached-HEAD fetch/rebase/push compare-and-swap loop by hand, exactly the "subtle, don't-roll-your-own" hazard the missing skill was meant to eliminate. Repoint these references at the deterministic script `scripts/jobs/journal-entry.sh` (`journal-entry.sh <kind> [body-file]`), which already implements the add-only CAS append with resync-and-retry on rejected push. For the § Writing an entry / § Reporting sections, replace the skill link with an instruction to post via `scripts/jobs/journal-entry.sh` (and reference `skills/journalism/SKILL.md` only for *reading* the journal, `skills/message-bus/SKILL.md` for directed messages). For the line-237 heartbeat note, point at whatever script owns the worktree-status commit (`scripts/jobs/journal-worktree-keeper.sh`) rather than the phantom skill. Net effect: roles stop reinventing the CAS loop and call the one script that gets it right. The single implicated non-script file is `roles/COMMON.md`; the canonical script it should reference is `scripts/jobs/journal-entry.sh`.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 20
  claimed_at: 2026-07-12T15:51:11Z
