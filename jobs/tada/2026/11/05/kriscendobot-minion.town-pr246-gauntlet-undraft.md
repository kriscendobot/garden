**Gauntlet undraft: kriscendobot/minion.town PR #246 is now ready for review.** https://github.com/kriscendobot/minion.town/pull/246

**Un-draft**
- Before the change: state OPEN, `headRefOid` `93329d9faf0564a579182194209e7d3c89e97245` (the panel-passed head), `isDraft` true.
- I ran `gh pr ready`, which succeeded.
- After the change: `isDraft` false, same head, state OPEN.

**Advisory appellate pass (not gating)**

I ran a light `claude -p` review on the PR diff only, with no tools, so it could not search the rest of the repo. I did not verify its findings, and nothing was changed as a result.
1. **Design doc wrap:** `designs/clip-shell-framework.md` § Failure has one over-long line. The sentence saying a refused clip "stays in the pane as the browser rendered the refusal" is worth checking against real behavior.
2. **Refused frames:** a refused frame gives the user no accessible explanation and no recovery action. The maintainer's removal ask makes the missing link deliberate, but the review suggests an `aria-live` status or recording it as a known gap.
3. **Browser gate coverage:** `countDirectNavigationControls === 0` and the unit-test regex are negative checks. The review suggests adding positive assertions, such as the frame being visible and the blocked clip's script count being 0. The PR's regression note does show these checks catching an injected `<a>`.
4. **"No controls" selector:** it omits `input`, `select`, `summary`, `[tabindex]` and inline handler attributes, so the "capability class" comment overstates what it covers.
5. **Possible leftovers:** the review could not confirm that nothing outside the diff still reads `clip-open` or `clip-caption` (CSS, other tests, docs).

**Follow-ups:** none posted. These findings are for the maintainer to weigh at review. I changed no garden files.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr246-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (165312 cached reads)
- Output: 1991 tokens
- Cost: $0.4034744
- Wall-clock: 69s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
