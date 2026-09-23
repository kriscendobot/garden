Done. Here is my completion report.

---

**Job: harden clone-keeper to self-heal a missing bare clone**

**What I found (job partially overtaken by events).** The job was written against the original WARN-and-skip version of `clone-keeper.sh` (it cites "lines 78–81" logging `missing or not a git repo … skipping`). Two peer commits already landed the core self-heal before I claimed this: `1bfbc1087` (re-clone a genuinely-missing tracked bare clone) and `05a261e5e` (derive the URL from the dir basename). So "re-clone the missing clone, set the fetch refspec, log a repair line, fall through to fetch+fast-forward, keep every failure path logged-and-return-0" were already present and tested.

**What was genuinely still missing — and what I delivered.** The job's headline enhancement, the **explicit fourth `clone-url` field**, was *not* present. The existing code derives owner/repo by splitting the hyphenated basename on the first `-`, which is ambiguous for a hyphenated owner (`a-b/c` and `a/b-c` both map to `a-b-c.git`). I:

- Extended the `GARDEN_TRACKED_CLONES` line format from `dir|remote|branch` to `dir|remote|branch|clone-url` (fourth field optional, fully backward-compatible).
- Made re-clone source precedence: **explicit `clone-url` → URL-shaped `remote` → basename derivation** (now documented as the ambiguous last resort).
- Updated the default row to pin the endo URL explicitly and moved the fetch `remote` back to the bare name `origin` (`worktrees/endojs-endo.git|origin|master|https://github.com/endojs/endo.git`).
- Added rtrim on the last field so a trailing space/CR can't corrupt the URL.
- Updated the header narrative and the format comment block accordingly.
- Added a `CLONE-URL FIELD` test that deletes the clone, gives a bare-name `remote` plus an unreachable derivation base so the explicit field is the *only* viable source, and asserts the clone is re-created from that URL with the fetch refspec set. Suite: **36 passed, 0 failed** (was 31).

**Deliberate divergence from the job text (surfaced, not silently applied).** The job also asked to change present-but-not-a-git-repo dirs from the current `STALE`/never-clobber behavior to `scratch_cleanup`/rm-then-reclone. I did **not** apply that: the current code makes STALE-never-clobber a documented, deliberate safety decision ("may hold un-pushed local state; manual reconciliation is safer") with a locking `CORRUPT` test. Reversing a peer's guarded safety property based on an OBE spec would be a regression from their standpoint, so I preserved it and am flagging it here rather than proceeding unilaterally.

**Follow-up for the maintainer/liaison.** If you *do* want corrupt/partial dirs (non-git-repo leftovers under `worktrees/`) to self-heal by clobber-and-reclone — closing the last "skip forever" path — that's a one-more-commit change bounded strictly to `$GARDEN_ROOT/worktrees`, but it needs a call on whether to overturn the existing STALE-never-clobber safety choice and update the `CORRUPT` test. I left it as-is pending that decision.

Committed as `88a025089` and pushed to `main2` (fast-forward, no rebase needed).
