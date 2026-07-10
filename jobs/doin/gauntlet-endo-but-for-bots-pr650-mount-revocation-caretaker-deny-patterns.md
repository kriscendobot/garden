Run the gauntlet on endojs/endo-but-for-bots PR #650 (`feat/mount-revocation`, PR A of the #127 daemon-mount split — the revocation caretaker + deny patterns that all stacked mount PRs build on): it is CI-green and mergeState CLEAN but still DRAFT, so drive the full PR-creation chain (clean → panel review → fix-loop → un-draft) to make it a ready, mergeable PR and unblock the stacked mount cluster (#653/#655/#657/#652/#654).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  claimed_at: 2026-07-10T01:12:33Z
