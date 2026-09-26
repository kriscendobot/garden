Done. #127 is now CLOSED with its branch `feat/mount-extensions` intact (no `--delete-branch` flag used). This was a pure GitHub lifecycle operation, so no garden-repo commits were needed.

---

## Completion report

**Job:** Close PR #127 (final step of the mount-extensions reconstruction) on `endojs/endo-but-for-bots`.

**Precondition check (passed):** Verified all four reconstruction PRs are OPEN before acting —
- `feat/mount-revocation` → **#650** (PR A)
- `feat/mount-glob` → **#653** (PR B)
- `feat/mount-grep` → **#655** (PR C)
- `feat/mount-json` → **#657** (PR D)

Design PR **#648** (`design/mount-extensions-reconstruction`) also confirmed OPEN. #127 was OPEN prior to action.

**Authorization confirmed:** The maintainer's 2026-07-09 review on #127 (`pullrequestreview-4659737674`) explicitly directs: *"Please divide out the revocation, glob, grep, and JSON file read/write features into separate pull requests. Create fresh PRs and close this."* Self-authorizing per the project's standing lifecycle authorizations.

**What I did:**
1. Posted a closing comment on #127 cross-linking all four replacement PRs (#650/#653/#655/#657) and design PR #648, quoting the review directive — `issue-comment 4929571839`.
2. Closed #127 **without** deleting its branch (`feat/mount-extensions` remains). Verified final state: `CLOSED`.

**Changed:** GitHub PR state only (comment + close). No garden-repo or project-repo file changes.

**Follow-ups:** None. The four replacement PRs now carry the work forward independently.
