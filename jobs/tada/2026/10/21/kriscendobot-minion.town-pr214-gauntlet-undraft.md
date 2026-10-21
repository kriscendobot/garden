## Completion report: kriscendobot-minion.town-pr214-gauntlet-undraft

PR #214 (https://github.com/kriscendobot/minion.town/pull/214) is now marked ready for review.

**What I did**
1. **Pre-mutation check:** fresh metadata showed `state=OPEN`, `isDraft=true` and `headRefOid=0e644c0c2a57f4c95491cf8c78c9c37566c886e5`, which is the head the passing panel covered.
2. **Un-draft:** ran `gh pr ready`. A re-fetch afterwards showed `isDraft=false` with the head unchanged at `0e644c0c…`.
3. **Advisory appellate pass** (does not gate the un-draft): one `claude -p` review using Sonnet. It only saw the first 150 KB of the diff, which stops partway through `guest-web-router.ts`. Its notes:
   - **Leftover references:** check that no importers remain for the deleted exports (`GuestDeletedError`, `connectBrowserGuestDirectory`, `appendDurably`, the `DaemonHost` methods that were dropped). Running `tsc` and the full test suite would confirm this.
   - **Production state isn't reverted:** the `guest-formula-fingerprint` index, the bond ledger rows (which will show up as blank accounts in `set-account-role.sh list`), and the leftover deleted or pending-deletion guests all stay. The live IAM role only narrows again when `deploy-accounts-store.sh` is re-run.
   - **Stale file:** check that `deploy-www.sh` removes the old `settings.js`.
   - **CSP hash:** the Caddy config's inline-script hash must still match the restored `index.html`.
   - **Security-relevant restoration:** the reveals of the guest formula id and locator in the top-level document are back, as is the hard-coded Cognito client id.
   - **Edits that may not belong to the revert:** a one-line `waitlist` import in `http.ts`, and a doc line dropped from `closed-beta-waitlist.md`.

   The PR body says the resulting tree is byte-identical to `a84d6d6`, the last revert whose deploy succeeded. If so, the code-level concerns are probably moot, but the production-state cleanup points still stand.

**What changed:** only the draft state of minion.town PR #214. I made no garden commits.

**Follow-ups:** none were posted. When #200/#213 is re-landed, whoever owns it should handle the production cleanup notes above (bond ledger rows, the index, IAM drift).

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr214-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (153487 cached reads)
- Output: 1913 tokens
- Cost: $0.3649654
- Wall-clock: 144s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
