Inbox is empty. Job complete.

## Completion report

**Job:** Make `clone-keeper.sh`'s missing-clone branch self-heal a vanished bare clone instead of skipping forever.

**Context found:** The script had already evolved past the state the job describes. A commit from ~9h ago (`1bfbc1087`) added a repair path that re-clones a missing clone *from its tracked source* — but only when that source is a URL/path, and it still **skipped forever when the source is a bare remote name** (`origin`). That bare-name skip is the exact remaining silent-missing gap the job targets, so I closed it by integrating the requested basename-derivation on top of the existing repair path rather than duplicating or ripping it out.

**What changed (`scripts/jobs/clone-keeper.sh`):**
- Added `derive_clone_url()`: reverses the garden's `worktrees/<owner>-<name>.git` naming (splitting the basename on its first `-`, stripping `.git`) into `<GARDEN_CLONE_URL_BASE>/<owner>/<name>.git`. Returns non-zero when the basename doesn't fit the shape.
- Added `GARDEN_CLONE_URL_BASE` config (default `https://github.com`), overridable so tests can point at a local `file://` mirror.
- Rewrote the missing-clone branch: an explicit URL/path source still wins (logs `REPAIRED`); a bare-name source now derives the URL from the basename and provisions (logs the required `provisioned missing clone <dir> from <url>`). The clone uses the existing `bounded_clone` (same `timeout GARDEN_FETCH_TIMEOUT` + backoff/retry as `bounded_fetch`, so a hung clone is reaped like a hung fetch). After cloning, it sets `remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'` exactly as `ensure-project-worktree.sh` prescribes, then falls through to the normal fetch + fast-forward. WARN-and-skip remains only as the fallback when the URL can't be derived or the clone fails (offline).
- Updated the header comment, the tracked-clones doc comment, and the `is_remote_location` comment to reflect the new behavior.

**Tests (`scripts/jobs/test/clone-keeper-test.sh`):**
- Replaced the now-obsolete `MISSING+BARE-NAME → skip` case (it asserted the old behavior) with a `PROVISION` case: a bare-name-tracked, deleted clone gets provisioned from a basename-derived `file://` URL, offline; asserts the repo is created, master matches upstream, the `provisioned missing clone` line is logged, and the fetch refspec is set.
- Added a `MISSING+UNDERIVABLE` case: a basename with no `-` can't be derived → WARN-and-skip, no clone attempted, offline.
- All 31 assertions pass, including the pre-existing FRESH / FAST-FORWARD / DIVERGED / OFFLINE / RECLONE / CORRUPT / MISSING+UNREACHABLE cases.

**Pushed:** `05a261e5e` on `main2` (one rebase-CAS retry over a concurrent push).

**Follow-ups:** None required. Note for the maintainer: the derivation assumes the GitHub `owner/name` split falls on the *first* hyphen of the dir basename, which is correct for owners without hyphens (all current tracked clones); a hyphenated owner would need an explicit URL/path source in its tracked-clone row — already documented in the config comment.
