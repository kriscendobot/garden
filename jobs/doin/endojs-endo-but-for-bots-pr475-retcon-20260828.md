---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-28T03:25:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# retcon endojs/endo-but-for-bots PR #475

Maintainer directive (kriskowal, pr-comment 5447969981, 2026-08-28): "Retcon and conduct." This is the retcon half.

Repo: endojs/endo-but-for-bots
PR: https://github.com/endojs/endo-but-for-bots/pull/475
Head branch: feat/narrow-bytearray-to-uint8
Base branch: llm-e22e67a (frozen-base snapshot)

Run the retcon per skills/retcon/SKILL.md as the fixer step of the gardening state
machine: reset the head branch to its base and restage the SAME net diff as a
sensibly grouped history — one commit per affected package, a separate
`chore: Update yarn.lock` commit, conventional-commit messages. Absorb the visible
`fixup!` commits currently at the branch tip (e.g. 9a4fdb1b2, d4c308872) into the
per-package commits they amend. Net diff MUST be byte-identical (verify
`git diff <pre-retcon-sha> HEAD` is empty). Force-push with --force-with-lease.

Do the project work in an isolated per-job worktree (ensure-project-worktree.sh).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-28T03:25:24Z
