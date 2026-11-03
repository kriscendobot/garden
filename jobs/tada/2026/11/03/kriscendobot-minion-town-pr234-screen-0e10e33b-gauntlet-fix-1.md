Fix round 1 for kriscendobot/minion.town#234 is pushed and CI is green (7/7 checks). I applied the prover and packager items. I did not apply the decomplector's two must-fix items, because they would redesign the PR rather than fix it.

There was no deterministic pre-pass block, so I worked from the latest panel verdict (review 5757517339, with packager, prover, corner-prober and decomplector findings). Two commits went onto `probe/invitation-roundtrip` with `safe-push-pr-head.sh`, moving the head from 0e10e33b to 42712293:

- **`c558da48` test(web):** answers the prover's must-fix and should-fix and corner-prober items 1–2. The existing HTTP replay tests only ever hit the forget route's cleanup, never the separate name check behind it. Three new unit tests in `test/web/local-invitations.test.ts` call the invitation registry directly:
  - A replay is refused when the name disappears without the forget route's cleanup. If I disable that name check, two tests now fail, so the guard is actually covered.
  - The cleanup removes only that guest's record under that name. Another name's record, another guest's record, and a pending invitation are left alone.
  - An accept still in progress survives the cleanup.
  
  The touched test files pass locally (25 tests).
- **`42712293` docs:** answers packager items 1–2. It adds `.changeset/guest-forget-dismiss.md` (`minion-town: minor`, with `New:` and `Changed:` lines) and rewraps the "Invitation probe guests" paragraph in DEPLOYMENT.md.

**Not applied:**
- **Decomplector items 1–2** ask to cut the probe's round trip down and remove the two new guest routes in favor of throwaway guests. The PR's title names those routes, so this is a scope decision for the PR's owner. My PR comment explains this and gives my view that the routes are low-risk: each only touches the caller's own contacts and mail, and both are explicitly listed in the route config.
- **Left open:** the replay's name check only confirms the name exists, not that it still points at the original inviter (corner-prober 1, decomplector 3). The path-parameter edge-case tests (corner-prober 3) and the mail-dismiss error cases (corner-prober 4) are also not written yet.

I posted all of this on the PR: https://github.com/kriscendobot/minion.town/pull/234#issuecomment-6612310120. Panel-2 will decide whether the declined items block the PR.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr234-screen-0e10e33b-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1239716 cached reads)
- Output: 9922 tokens
- Cost: $1.0000072000000002
- Wall-clock: 486s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
