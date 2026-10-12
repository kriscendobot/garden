# Gauntlet undraft report: kriscendobot/minion.town PR #174

PR #174, "feat(credits): meter clip publishing against an interim credit ledger (no ERTP)", is now ready for review. Its head is still `08a0f45ce35b4a660c93643aecfde7705dca0fb3`, the commit the panel passed.

**Head check before undrafting:** fresh metadata showed `state=OPEN`, `headRefOid=08a0f45ce35b4a660c93643aecfde7705dca0fb3`, `isDraft=true`. That matched the required head, so I ran `gh pr ready`. A second fetch confirmed `isDraft=false` and the same head.

**Advisory appellate pass:** I ran one `claude -p` review over the PR diff. It is advisory only and did not block the undraft; it is recorded only in this report, not on the PR. It flagged these possible gaps for a follow-up review round:
1. **Shared ledger directory:** the credit ledger defaults to `$GATEWAY_STORE_DIR/credits`, which is shared with the endo-gateway user's group. If that directory is group-writable, anyone in the group could append a forged `grant` or corrupt the ledger. Corruption makes every metered publish fail closed. Suggested fix: a directory only `minion-mcp` can write to, with its mode set explicitly.
2. **Free re-publishing:** the settlement key is `owner:contentRoot` and leaves out the site and powers. After paying once for some content, an owner can publish it to unlimited new sites, or with different powers, for free.
3. **Log corruption on a failed write:** a failed append is rolled back by truncating to a size read with `stat` beforehand. A concurrent CLI `grant` landing in between can defeat that rollback and leave a torn line in the middle of the log, which then reads as corrupt at the next boot.
4. **Possible account-key mismatch:** the CLI funds accounts keyed by `identityKey(issuer, subject)`, but `reservePublish(owner)` charges whatever string is passed as the owner. The reviewer could not confirm the real callers pass `identityKey` output. If they don't, every metered publish is refused as unfunded.
5. **Failed charges are never retried:** if settling fails after a publish succeeds (a full disk, for example), the publish goes unbilled and the only trace is a log line. There is no alert and no retry.
6. **Grants need a restart:** the gateway reads the ledger only at boot, so a new grant has no effect until a restart. Meanwhile the CLI's `balance` shows credits the gateway can't see. The PR documents this.

**Follow-ups:** none were posted. Points 1–4 are the ones worth checking in the next review.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr174-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (171062 cached reads)
- Output: 1646 tokens
- Cost: $0.4043164
- Wall-clock: 54s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
