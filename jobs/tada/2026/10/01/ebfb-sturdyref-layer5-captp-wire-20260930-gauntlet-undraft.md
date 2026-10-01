---
handed-off: ebfb-sturdyref-layer5-captp-wire-20260930-undraft-endolin
deliverable-complete: false
---
I could not un-draft endojs/endo-but-for-bots PR #1394 from this host, so I've handed the un-draft to a successor job that will run on an endolin host.

- **Still a draft:** the PR is OPEN and still a draft. I tried `gh pr ready` again and it failed the same way: `Resource not accessible by personal access token (markPullRequestReadyForReview)`. On host `oros-studio-garden-ce242c49` the bot's token isn't allowed to write PRs on endojs.
- **Advisory review:** the light `claude -p` pass ran in an earlier attempt. It is advisory and not a gate. It found five things the panel may have missed:
  - The new `s±N` CapTP slot kind is unknown to older peers. The changeset doesn't say both ends must upgrade.
  - There are no tests that dropping or garbage-collecting an imported SturdyRef releases its export on the other side.
  - A peer can make the origin `enliven` dial addresses the peer chooses (OCapN `hints`). There is no policy hook or rate cap.
  - Decoding an OCapN SturdyRef received over the wire is barely tested.
  - The changeset doesn't say `@endo/sturdyref/shim.js` is required, and nothing tests what happens without it.
- **Successor posted:** `ebfb-sturdyref-layer5-captp-wire-20260930-undraft-endolin` is now in `jobs/todo/` on `journal2`; I confirmed it in a fresh fetch. It is pinned to `endolin-garden-ece02cb4`, a host that has opened endojs PRs before. It checks the PR is still a draft and OPEN, refuses to un-draft if the head commit has changed since the panel passed, then runs `gh pr ready` and confirms the result. The advisory notes are in its body.
- **Earlier posting failures:** previous attempts to post that job timed out on journal push races and a busy journal clone lock on this host.
- **Gauntlet will likely stop:** the job asked for `undraft=done` as the last line. I wrote `undraft=handed-off` instead, because the PR has not been un-drafted. The gauntlet driver only accepts `done` for this stage, so it will probably mark this gauntlet as halted. The successor job still does the un-draft.

**Follow-ups:**
- Give the bot token "Pull requests: write" on endojs for oros-studio, so these stages stop needing a hand-off.
- Consider letting the gauntlet's undraft stage ask for an endojs-capable host up front.
- `post-job.sh` keeps losing push races and timing out on this host even though a plain `git fetch` of the journal takes about 2 seconds. That's worth looking into.

<!-- gauntlet-stage-result: undraft=handed-off -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer5-captp-wire-20260930-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 42 tokens (1023093 cached reads)
- Output: 8188 tokens
- Cost: $2.0422228
- Wall-clock: 2630s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
