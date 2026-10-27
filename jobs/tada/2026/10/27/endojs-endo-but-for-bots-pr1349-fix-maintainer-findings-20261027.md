**Completion report: endojs-endo-but-for-bots-pr1349-fix-maintainer-findings-20261027**

I settled the open conditional-taming question in favor of naugtur's review request. PR #1349 now replaces a host codec only on hosts where lockdown can't harden it. CI is 16/16 green on the new head `b43f86c0d3`, and fresh review is requested.

**How the decision was made**
- naugtur asked on r4229750056 that taming happen only when the host codec has an own `arguments` property. An earlier commit (`d2736bcdd8`) did that, but `f1770005a9` made the replacement unconditional again.
- The reason given for that reversal was the design in #1431. That design is an unreviewed bot draft with no human reviews. kriskowal's earlier "minor findings only" review came before naugtur's request and didn't address it.
- No maintainer had answered the question: the foreman's M2 blocker message about it has been sent 15 times and is still unread. So I followed naugtur, who as a human reviewer made the only explicit call.

**What changed (one commit, `b43f86c0d3`)**
- **Source:** `tame-text-codecs.js` returns early when `getOwnPropertyDescriptor(HostCodec, 'arguments') === undefined`. Node, xst and Chromium 138+ have no such property, so they keep their original constructors.
- **Tests:**
  - The "encapsulated" identity tests became "unaffected host constructors are retained".
  - The native-presentation test moved into the restricted-properties test file.
  - The one-codec-missing and primitive-prototype tests now set up the affected property shape before `lockdown()`.
  - The xst fixture and the Playwright spec each now cover both the replaced and the kept path in one run.
- **Docs:** the changeset (still `major`, because of the XS compartment change), `tender-lions-tickle.md`, both SES guides and `docs/reference.md` now say replacement happens only on affected hosts. I also updated the PR body to match.

**Verification**
- `yarn workspace ses test`: 549 passed, 2 known failures, 2 skipped.
- `yarn workspace ses test:xs` and `yarn workspace ses lint` passed, Prettier is clean, and the probes-only pre-push gates passed.
- The Playwright `text-codecs.spec.js` passed on Chromium 148.
- Both regression checks went red as expected: making the replacement unconditional again breaks the retained-identity test, and removing the primitive-prototype guard breaks its test.
- The full root `yarn lint:fix` ran out of memory locally, as in earlier rounds, which is why I ran the narrower checks above instead.

**On the PR**
- Replied on naugtur's thread: https://github.com/endojs/endo-but-for-bots/pull/1349#discussion_r4392435669
- Top-level summary: https://github.com/endojs/endo-but-for-bots/pull/1349#issuecomment-6449972128
- Re-requested review from naugtur and kriskowal.

**Follow-ups**
- Staged a fresh panel gauntlet, `endojs-endo-but-for-bots-pr1349-gauntlet-20261027-conditional`, so the new head gets reviewed.
- Posted job `endojs-endo-but-for-bots-pr1431-align-conditional-codec-taming` to update the draft design #1431 to the conditional approach.
- Messaged the maintainer that the M2 blocker question is settled, and that they can say so on the PR if they'd rather keep unconditional replacement.
- Not changed: moving the XS absent-codec test into hardened262 (kriskowal's r4214715885) still needs a merge base that includes hardened262. The PR thread already offers "pin the merge base" for that.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `4c315e84c021efcf6e0a20f3cb3bb5fac0deca5b`; this job presented `b43f86c0d3470b01603643fc538397cbeebbf366`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-fix-maintainer-findings-20261027.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 102 tokens (5205359 cached reads)
- Output: 25859 tokens
- Cost: $2.5299558
- Wall-clock: 1040s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
