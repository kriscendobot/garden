I ran panel round 2 on kriscendobot/minion.town PR #154 and the verdict is **must-fix**. `panel.sh` exited 0 with that disposition.

**Run.** I gave the PR head `chore/javascript-only-scripts-part-3` (`e877678`) its own checkout. The base was the PR's `baseRefOid`, `2ca6c15`, and the diff against it matches GitHub's 59-file list. The panel ran in single-round mode with `GARDEN_YARN=npm`, detached so a reap couldn't kill it, and finished in about 20 minutes.

**Seats.** Of 33 seats, 11 requested changes, 7 left comment-only and 15 approved. The phase/evidence pre-pass is still BLOCKED, and that alone forces must-fix.

**Posted.** The review is https://github.com/kriscendobot/minion.town/pull/154 review 5407987771, against `e877678`. GitHub refuses a request-changes review on the bot's own PR, so it went up as COMMENTED. It starts with a hand-written summary, carries the marker `<!-- garden-panel-verdict: must-fix round=2 -->`, and then gives each seat's review trimmed to fit GitHub's size limit.

**Fixed since round 1:** the restore rollback window, the header-strip test, the `db` → `database` rename, the dead `UNIT_B64` key, the siwe exemption marker, and the pin regex in the vendor script and drift test.

**Must-fix items for the fixer:**
1. **Phase/evidence ledger.** Add the machine-readable ledger block to the PR body: both designs, phases 1–6 marked not-applicable, and an acceptance line.
2. **Node version gate.** The on-box gate accepts any v22, but the new ESM files on the box need Node 22.7 or later. Tighten the gate to the repo's `>=22.15.0` floor, or ship the files as `.mjs`.
3. **Reaper can block daemon start.** Change the unit line to `ExecStartPre=-+…` so a reaper failure can't stop `endo-daemon` from starting.
4. **Template renderer passes bad input silently.** `renderRemoteProgram` returns these unchanged instead of throwing; I reproduced both:
   - an unterminated `${HOST`
   - the `${#HOST}` and `${!HOST}` forms
5. **Root drop-in written through `/tmp`.** `endo-federation-box.js` writes the root-installed drop-in to a predictable `/tmp` file before `sudo install`. The shell original piped through `sudo tee`.
6. **Backup lock bypass.** In `npm-registry-backup.js`, passing `--locked` as the first argument skips the lock, so a restore can race a cron backup.
7. **PR body trims.** Drop the per-file bullet list and the "no command was sent to the live box" disclaimer.

The review also lists the should-fix items, including EXDEV on cross-filesystem backups, an endless wait on a non-numeric timeout, the SHASUMS line no longer anchored, a third pin reader still unanchored, and shell quoting done with `JSON.stringify`.

**Possible follow-up for garden development:** integrator suggests the phase-evidence gate should ignore design edits that only rename paths. That case made this PR need an all-not-applicable ledger.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part3-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1048788 cached reads)
- Output: 8761 tokens
- Cost: $1.0279455999999998
- Wall-clock: 1478s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
