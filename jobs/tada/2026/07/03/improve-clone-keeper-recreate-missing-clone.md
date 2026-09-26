Inbox is empty. Work is complete and pushed.

## Completion report

**Job:** Make `clone-keeper.sh` remediate a *missing* tracked bare clone instead of warning-and-skipping forever.

**Starting state (important):** Most of the job's asks were already landed on `main2` by commit `88a025089`: the row format already carries the optional fourth `<clone-url>` field (the endo row defaults to `https://github.com/endojs/endo.git`), and a missing clone is already recreated via `git clone --bare "$url" "$abs"` + `git -C "$abs" config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'`, plus a basename-URL derivation fallback. The tests already covered the recreate paths (RECLONE, CLONE-URL FIELD, PROVISION).

**The remaining gap I closed:** the one terminal path where a vanished clone still could not self-heal — bare-name remote, no explicit `<clone-url>`, and an underivable basename — still drained into a silent WARN-and-skip, i.e. the exact "invisible for weeks" failure mode the keeper exists to prevent.

**What changed:**
- `scripts/jobs/clone-keeper.sh`: the un-recreatable missing-clone branch now logs a `STALE:` line **and escalates** via `alert_maintainer` (available from `common.sh`) with a per-clone dedup key (`clone-keeper-missing-nourl-<dir>`) and an actionable message (add a `<clone-url>` to the row or re-clone by hand). `alert_maintainer` is throttled and never fails its caller, so the step stays self-contained. Updated the header comment to distinguish the transient-unreachable path (WARN, retries next tick) from the no-source path (escalate).
- `scripts/jobs/test/clone-keeper-test.sh`: added a `GARDEN_ALERT_CMD` capture stub (wired into `run_keeper`), and rewrote the former "MISSING+UNDERIVABLE → skip" case into "MISSING+NO-URL → ESCALATE," asserting the maintainer escalation fired with the expected dedup key while nothing was clobbered. The recreate-when-missing path stays covered by the existing RECLONE/CLONE-URL/PROVISION cases.

**Verification:** `bash -n` on both files; full suite green — **38 passed, 0 failed**.

**Pushed:** to `main2` (rebase CAS, first attempt).

**Follow-ups:** none. (The failed-reclone path deliberately stays a WARN, since it is transient/offline and retries every tick; only the truly un-remediable no-source case escalates.)
