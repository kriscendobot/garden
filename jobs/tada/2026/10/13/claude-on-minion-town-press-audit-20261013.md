I audited issue 89 against GitHub's current data, and none of the seven checkboxes needed to change. Eight pieces of evidence in the body were wrong (four timestamps and four PR/issue states), and I corrected them in one edit. I left the architecture text, the item specifications and the running log as they were, did no implementation work, posted no jobs, and made no garden commits.

**The three PRs you named:**
- **kriscendobot/minion.town#87:** merged into `main` on 2026-09-22 at 03:13:57Z, approved, not a draft, and its CI run (`test (typecheck + vitest)`) passed. This matches the issue.
- **endojs/endo-but-for-bots#1015:** merged into `llm` on 2026-09-29 at 06:09Z as `1706e63247fb`, not a draft. kriskowal approved it at 05:11Z. CI shows 27 passed and 8 skipped. This matches the issue. GitHub's overall review-decision field is empty, but the approval itself is recorded.
- **endojs/endo-but-for-bots#1125:** closed without merging on 2026-09-17 at 21:50Z. It was still a draft, had changes requested, and its last CI run had one failure. This matches the issue calling it the "retired monolith."

**Other PRs:** I checked about 46 more PRs and one issue across both repos. Everything else matches the issue, including:
- kriscendobot/minion.town#167, #171 and #183 are still open drafts.
- kriscendobot/minion.town#182 and endojs/endo-but-for-bots#1403 and #1412 are merged.
- endojs/endo-but-for-bots#1404, #1406, #1408, #1409 and #1369 are still drafts.

**Designs:** every design the arc names exists:
- On the garden's `main2`: `claude-harness-provisioning.md`.
- On minion.town `main`: `claude-agents-capability.md`, `claude-agent-credential-reauth.md` and `claude-on-minion-town-evaluation.md`.
- On endo `llm`: `endo-guest-stdio-mcp.md`, `daemon-guest-bot-incarnation.md` and `endo-claude-inference-backends.md`.

The only recent design changes came from PRs the issue already records: the item 4 design was updated by #1412 on 2026-10-12, and the item 5 design by #1407 on 2026-10-05.

**Checkboxes:** items 1 and 5 stay checked, and items 2, 3, 4, 6 and 7 stay unchecked. None of the PRs or recent comments contain new proof that would change a box; that proof still waits on #167's root canary and #183.

**Corrections made to the issue body:**
1. kriscendobot/minion.town#98 merged at 00:39Z on 2026-09-22, not 01:11Z. Fixed in item 7 and in the blockers list.
2. endojs/endo-but-for-bots#1228 closed at 01:28Z on 2026-09-22, not 02:33Z (02:33Z is when it was last updated). Fixed in item 4 and in the blockers list.
3. kriscendobot/minion.town#163 merged at 15:08Z on 2026-10-06, not 15:12Z. Fixed in item 4.
4. endojs/endo-but-for-bots#1340 was still called a design draft in item 5. It merged into `llm` on 2026-10-02 at 16:43Z, so I added that.
5. kriscendobot/minion.town issue #149 was described as still open: in item 5 as a refinement "remains open and tracked there", and in item 4 as a gap the maintainer must still accept. It was closed as not planned on 2026-10-06 at 05:19Z, together with #160. I added that to both places.

I checked that the issue hadn't changed since I read it (last updated 09:10:25Z) before saving, and confirmed afterwards that the edits are in place.

**Left alone (possible follow-up):** item 5 says endojs/endo-but-for-bots#1404 has a "gauntlet running" and #1409 has a "gauntlet staged". Neither PR has had any activity since 2026-10-02/03, so both phrases look stale. I didn't change them because I couldn't confirm what state those review runs are actually in.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/claude-on-minion-town-press-audit-20261013.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1070135 cached reads)
- Output: 9235 tokens
- Cost: $0.9602869999999999
- Wall-clock: 256s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
