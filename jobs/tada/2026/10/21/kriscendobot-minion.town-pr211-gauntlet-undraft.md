PR #211 (kriscendobot/minion.town, "Revert #200 (heal production: missing guest-formula-fingerprint index)") is now marked ready for review. The un-draft is done.

**Head check.** Just before the change, the PR was OPEN and still a draft, and its head was `87cebebffcdef56038c22ce9ba9c819db168cbfe`, the exact commit the panel passed. I ran `gh pr ready`. A fresh fetch afterwards shows `isDraft=false` with the same head.

**Advisory review (did not block the un-draft).** I had `claude -p` (Sonnet) give the full 5,824-line revert diff a light read for things a review panel tends to miss. It only read the diff and searched none of the code, so these are things to check, not confirmed bugs:
- **Deploy order.** Running the reverted `deploy-accounts-store.sh` while the #200 build is still live narrows the IAM policy under it, and that build then gets AccessDenied. Roll the app back first, and check whether CD runs that script automatically. Ship the web assets (`index.html`, `home.js`, `shell.js`) before the Caddy change. In the other order, the old `home.js` asks for `settings.js`, the request falls to the gated route, and the landing page goes blank.
- **Leftover DynamoDB state.** The revert leaves the `guest-formula-fingerprint` index and the guest-bond-ledger rows in place. Those rows will then show up as blank accounts in `set-account-role.sh list`.
- **Security fixes undone:**
  - The restored `open()` ignores the deletion markers, so a guest whose deletion is pending or finished can be reopened.
  - `open()` again accepts any formula ID, not just guest-agent ones.
  - The "Copy guest URL" and other credential-reveal UI in the privileged overlay comes back.
- **Leftovers to search for:**
  - Symbols #200 introduced may still be referenced outside the files in this diff. The full list is in the review output.
  - `accounts-store-iam.test.ts` is deleted, so nothing now checks that the IAM policy matches what the store code requests.

No garden files changed.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr211-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (248726 cached reads)
- Output: 2401 tokens
- Cost: $0.40112519999999996
- Wall-clock: 153s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
