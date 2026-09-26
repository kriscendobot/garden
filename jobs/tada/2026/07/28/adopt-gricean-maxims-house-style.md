Inbox empty. Work complete and pushed.

## Completion report

Adopted Grice's maxims as a standing house-style norm on `main2` (direct push, no PR per CLAUDE.md § Conventions). Pushed `c090912036..c67e70c5c7`.

**What I did**

1. **Wrote `skills/gricean-maxims/SKILL.md`** (kept the proposed name; it is accurate). Made it operational, not a restatement: each maxim carries do/don't pairs drawn from the artifacts the fleet actually writes (`tada` reports, PR completion-summary comments, inline review replies, journal bodies, inbox/bus messages, panel findings), and names the specific failure it prevents. Targeted the recurring offenders the job flagged: restating the job body, narrating unrequested process, length-only hedging, and burying the decision under preamble. The required-content boundary leads the skill (§ "HOW, not WHETHER") with a worked example: a fixer's over-brief PR summary that drops the head SHA / change-to-commit mapping / declined items / verification status, rewritten to keep every required element while cutting padding, showing the compact version carries strictly more required content than the padded-but-vague one.

2. **Wired it into `roles/COMMON.md` § House style** and resolved the pre-existing § Style / § House style duplication rather than adding a third copy. § Style now defers to § House style (the single consolidated index) instead of re-listing the four-to-five rules; the stale "The first four rules are also summarized in § Style above" trailer was corrected to state the defer direction. Registered `gricean-maxims` in § House style with its HOW-not-WHETHER framing.

3. **Updated the CLAUDE.md skills name index** (inserted `gricean-maxims` alphabetically between `github-activity-poll` and `issue-inbox`).

4. **Liaison decision: yes, wired it.** The directive says "all communications," which includes the liaison's maintainer-facing prose, and the liaison does not read `roles/COMMON.md` (that file is explicitly the subagent standing brief), so a COMMON.md binding alone would miss the liaison. I added a "## House style" section to `roles/liaison/AGENT.md` pointing at `gricean-maxims` as the rule bearing most on the liaison's running dialogue, plus a one-line pointer to the mechanical rules and the COMMON.md index.

**House-style self-check:** grepped my authored/edited text for em-dashes, en-dashes, arrows, ellipses, curly quotes, comparison signs, and Latin shorthand. The skill file and my liaison addition are clean; the only hits are pre-existing liaison prose I did not touch (not in scope for a sweep).

**Duplicate style sections:** resolved by making § Style defer to § House style, so the rule set is now stated in one authoritative place, not three.

**Follow-ups**

- The pre-existing liaison `AGENT.md` prose carries em-dashes and `e.g.` shorthand throughout. Fix-on-encounter per the existing skills, not a sweep; left untouched here.
- `updated:` frontmatter bumped on `roles/COMMON.md`; `roles/liaison/AGENT.md` and `CLAUDE.md` carry no such frontmatter block, so nothing to bump there.
