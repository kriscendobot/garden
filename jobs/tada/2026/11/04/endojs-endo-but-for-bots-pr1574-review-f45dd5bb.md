---
handed-off: endojs-endo-but-for-bots-pr1574-close-moved-endolin
deliverable-complete: false
---
The design now lives in kriscendobot/minion.town#238, but endojs/endo-but-for-bots#1574 is still open. Its inline reply, closing comment and close all returned 403 from this host's bot PAT, so I handed them to a relay job.

**Done**
- **Preflight:** it exited 0, so I went ahead with the work. The review had one body and one inline comment, and both ask for this move.
- **New PR:** kriscendobot/minion.town#238 is a draft against frozen base `main-9196892`, head `d94936ff`, and contains only `designs/api-key-agent-workbench.md`.
- **Design edits:**
  - Links to Endo designs and bare Endo PR numbers now name endojs/endo-but-for-bots.
  - The provider-design link is pinned to `069b429c16`, because that design isn't on `llm` yet.
  - Links to the chat Clip and git-remote designs are now relative.
  - I added a "Moved from" row, and the rest of the design text is unchanged.
- **New open question 7:** W1-W5 still change Endo packages. It asks whether each must first be proposed as an Endo design that doesn't name minion.town, or whether this design is enough. I added this; the maintainer didn't ask for it.
- **Companion PR:** kriscendobot/minion.town#228 (`2b94d6e7`) and its body now point to #238.
- **Parked build job:** `build-claude-api-agent-workbench-20261027` was `blocked_on` #1574, and `unblock.sh` treats a closed PR as done, so closing would have queued the build. I re-gated it to `awaiting-maintainer` on question 7 and added a note pointing it at #238.
- **Memory:** I recorded the closed-PR promotion trap for future jobs.

**Not done**
- **#1574 writes:** `endojs-endo-but-for-bots-pr1574-close-moved-endolin`, pinned to `endolin-garden-ece02cb4`, now owns the reply on thread 4462157174, the closing comment, and the close. The texts are in its job body; I kept the head branch so existing links still work.
- **Correction to the relay:** the job body's closing comment has a bare `#238`, which would link to the wrong PR on endojs. I staged a correction in its inbox, which it drains when claimed, but the job body itself still has the old text.
- **Not run:** this was a docs-only move, so I ran no tests or mermaid validation; the mermaid block was not edited.

## Follow-ups
- The maintainer needs to answer question 7 on #238. The other open questions and the merge of endojs/endo-but-for-bots#1543 also still gate the parked job.
- The maintainer may want to check endojs/endo-but-for-bots#1543, the approved provider design. It names minion.town throughout, so the same objection could apply. I left it alone because this review didn't cover it.
- Endolin claims can stall for an hour or more under its budget ramp, so #1574 may stay open for a while.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1574-review-f45dd5bb.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1898249 cached reads)
- Output: 25313 tokens
- Cost: $1.7927498000000002
- Wall-clock: 1423s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
