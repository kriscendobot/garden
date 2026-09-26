This job was already fully resolved by prior work that has since landed on `origin/main2`; there is nothing left to implement.

## Completion report

**Finding:** The job asks to change `keep_clone()` in `scripts/jobs/clone-keeper.sh` so a missing/not-a-git-repo tracked bare clone is HEALED or ESCALATED rather than silently WARN-and-skipped, extend the `GARDEN_TRACKED_CLONES` row format with an optional `|<url>` field, default the endo entry to its known upstream, and cover both the re-clone-succeeds and re-clone-fails-then-escalates paths in the test. Every one of those requirements is **already present** on `origin/main2` (my worktree HEAD `3e51f3f35` equals it, 0 commits behind), landed across the commit chain `1bfbc1087` → `05a261e5e` → `88a025089` → `c46fdfe5e` → `7cf55fc46` → `5c919e8f6` → `f8fdc05c4`. The job was posted against an earlier state that these commits have since superseded.

**Verified against the current tree:**
- `keep_clone()` no longer has a bare "missing … skipping" WARN branch. A genuinely-missing clone is re-created via `bounded_clone` (timeout+retry, staged into a sibling temp path and atomically `mv -T`'d into place), logging `REPAIRED`/`provisioned missing clone`; a present-but-corrupt dir is surfaced as `STALE` without clobbering.
- The row format `<dir>|<remote>|<branch>` is extended with the optional fourth `|<clone-url>` field (authoritative re-clone source), with precedence: explicit `<clone-url>` → `<remote>` if it's a URL/path → URL derived from the dir basename.
- The shipped default now tracks the real fork clone `worktrees/endojs-endo-but-for-bots.git|origin|master|ssh://git@github.com/endojs/endo-but-for-bots.git` (not the phantom `endojs-endo.git`), pinning the known upstream explicitly because that basename is the ambiguous derive case.
- Re-clone failure and the no-derivable-source case both `alert_maintainer` (throttled/deduped per clone), so a persistently-unreachable or unrecreatable clone escalates to a human instead of a forever-WARN.
- `scripts/jobs/test/clone-keeper-test.sh` covers all paths: re-clone-succeeds (`RECLONE`, `CLONE-URL FIELD`, `PROVISION`) and re-clone-fails-then-escalates (`MISSING+UNREACHABLE`, `MISSING+NO-URL`), plus the shipped-default regression.

**Test result:** `clone-keeper-test.sh` → **45 passed, 0 failed**.

**Changes made:** None — no code change was needed; the requested end state already exists and is verified. Working tree is clean; no commit/push performed.

**Follow-ups:** None. (If a live host still shows the clone physically absent, the next ~30m `garden-clone-keeper` tick will re-clone it from the pinned upstream or escalate — the intended behavior is already deployed.)
