**Viability report: endojs/endo-but-for-bots PR #1517**

PR #1517 should go ahead into the gauntlet. It is open, unmerged and still a draft, and its base pin `llm-f02cd81` matches the current `llm` tip (0 commits behind). The PR is design-only: it adds `designs/invitation-enclosures.md` and updates `designs/README.md`. It was opened at 2026-10-21T04:55Z.

Deciding question: Is the generic `InvitationFormula.enclosures` daemon mechanism still unbuilt and undesigned on `llm`, and does the maintainer still want it designed?

Evidence:
- **The maintainer asked for this design.** During review of kriscendobot/minion.town#144 (the guest-coupons design), kriskowal asked for more words on the enclosure hook and then said "Post a follow-up design job." The bot then posted `design-endo-invitation-enclosures`, which is the job that produced this PR (the `garden-job` marker matches). minion.town#144 is still open and approved by kriskowal ("please conduct and continue the build"), so the coupon consumer this mechanism serves is still active.
- **Nothing has displaced it.**
  - No other endo-but-for-bots PR, open or closed, mentions enclosures.
  - The earlier invitation work is the foundation this PR builds on, not a replacement: #1116 (design), #1305 and #1310 (implementations), and #1416 (editorial pass) are all merged.
  - #1277 (retention labels) was closed, but it covered a different topic.
  - In `packages/daemon/src/types.d.ts` on `llm`, `InvitationFormula` (line 649) has no enclosures field.
  - `designs/` on `llm` only has `guest-native-invitations.md` and `familiar-deep-link-invitations.md`, and neither is an enclosures design.
- **Its starting assumption still holds.** The minion.town coupon design says `endo://` locators need a generic daemon hook to carry a coupon, and that hook does not exist yet.

I spent no clean, panel, fix, CI-wait or un-draft budget, and I changed nothing in any repo.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1517-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (203043 cached reads)
- Output: 2093 tokens
- Cost: $0.39173260000000004
- Wall-clock: 42s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
