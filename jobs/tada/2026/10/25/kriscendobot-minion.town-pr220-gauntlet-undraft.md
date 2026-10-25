Undraft stage complete: kriscendobot/minion.town PR #220 ("feat(settings): protect Log out and add resumable guest account deletion") is now ready for review.

**Gate checks**
- Before the change, `gh pr view` returned state=OPEN, isDraft=true and headRefOid=`2d726c5e96c71291b183a5e6404dbe0b01a27c91`. That is exactly the head the passing panel covered.
- I ran `gh pr ready`, and it succeeded.
- Checked again afterwards: isDraft=false and headRefOid is still `2d726c5e96c71291b183a5e6404dbe0b01a27c91`.

**Advisory appellate pass (does not block the un-draft)**
I ran one `claude -p` (sonnet) review. The full diff is about 420 KB, so it only saw the first 150 KB and never reached `src/`. That means it did not review the `DELETE /api/guest` handler or `closeGuestBonds`. It found no data-loss or auth-bypass defect in what it saw. Its points worth a follow-up:
- **Audit gate can be silently skipped.** In `deploy-app.sh` the credential audit only runs if `endo.sock` exists. If the socket is missing, for example during a daemon restart, the deploy goes ahead with no audit, even though the comment says the check "fails closed".
- **Users can get stuck on "Finish deleting".** If bond cleanup keeps being rejected, every request returns 409 and only an operator editing the ledger can fix it. Two ways this happens:
  - a `GUEST_RECOVERY_KEY` rotation;
  - the window between deploying the app and running the `retired` pass.

  There is no runbook or admin escape hatch for this.
- **Server-supplied redirect isn't checked.** `settings.js` passes the `signOut` response straight to `location.assign` in the top-level page. It should require a same-origin path starting with `/` but not `//`.
- **Log-out check can go stale.** `recoveryBonded` is read when the menu opens. It should be re-read just before `storage.clear()`, in case another browser removed the bond in between.
- **Smaller points:**
  - the audit misses guests that have neither a handle nor an `-agent` name;
  - the backfill parses AWS CLI text output, which could break on another CLI version;
  - the app's IAM role can reopen a closed ledger (already acknowledged in the PR);
  - account deletion needs only the bearer guest URL.

I made no garden repository changes. If the maintainer wants the first two points fixed, a fixer job could take them on.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr220-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (230475 cached reads)
- Output: 2099 tokens
- Cost: $0.443187
- Wall-clock: 91s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
