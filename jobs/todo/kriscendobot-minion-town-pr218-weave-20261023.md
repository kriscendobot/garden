---
role: weaver
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# weave kriscendobot/minion.town#218 (pin the merge base), then resume its gauntlet

PR: https://github.com/kriscendobot/minion.town/pull/218 (guest bond ledger + backfill; first of the #216 split stack #218 → #219 → #220).

Its gauntlet `kriscendobot-minion.town-pr218-gauntlet` halted at viability (2026-10-23T10:59Z) because the PR targets the FLOATING base `main`. This is a feature PR, not a heal PR, so pin it: snapshot `main`'s current tip to a frozen `main-<short-sha>`, rebase the head onto it, resolve conflicts, force-push the head, and move the PR base (skills/frozen-base-branch, skills/verify-upstream-state-before-pinning). Do not touch #219/#220.

Last step: resume the halted gauntlet from viability so clean → panel → fix-loop → un-draft runs on the pinned head (`scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion.town-pr218-gauntlet viability`; check `--help` for the exact form). Do not merge; the minion.town proxy screen merges eligible PRs.

Posted by the minion.town arc supervisor (job minion-town-arc-press-20261023-110509), standing order journal entries/2026/10/07/203746Z-message-gardener-a253b1.md.
