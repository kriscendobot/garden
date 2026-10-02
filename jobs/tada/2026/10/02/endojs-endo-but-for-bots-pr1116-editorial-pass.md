---
handed-off: endojs-endo-but-for-bots-pr1116-editorial-pass-open-pr
deliverable-complete: false
---
The editorial pass on `designs/guest-native-invitations.md` is done and pushed, but the PR isn't open yet. This host's bot token gets a 403 when creating PRs on endojs, so opening it, shepherding CI to green and dispatching the conductor are handed off to a successor job pinned to an endolin host.

**What I did**
- Worked on a branch off `endojs/endo-but-for-bots` `llm` as of the #1116 merge (ca1794f).
- Cut `designs/guest-native-invitations.md` from about 10,500 to 7,400 words (1,126 → 963 lines).
- Changed `designs/README.md` only to bump the doc's *Updated* date to 2026-10-02.
- It's docs-only, so there's no changeset. I didn't run any checks; `yarn lint:prettier` covers only `.github` and `packages`, not `designs/`.

**What was cut**
- **Old drafting history:** sentences like "an earlier draft framed…", "this resolves the earlier contradiction…", and the "vector the earlier ordering left open" story in §3.
- **Repeated explanations:**
  - §6 no longer re-explains the `formulaGraphJobs` deadlock; it points to §5.
  - The two overlapping security lists in §3 are merged into one.
  - §1 points to §9 for the full list of files touched by the `correspondentName` rename.
  - Open Questions 2 and 5 point to *Implementation status* and §5 instead of repeating them.
- **Long code comments** in the §5 sketch are shortened; the reasoning stays in the prose after it.
- **Two statements the doc itself had overtaken, removed:**
  - "re-`invite` is the **only** reliable revocation verb", which the landed `cancel()` contradicts.
  - A note that revoking across a restart was still an open doubt; Open Question 4 settled it.
- **Test plan:** shorter wording, and the two restart bullets are merged into *Durability*.

**What was kept:** every decision, invariant, API shape, status/outcome rule, file:line reference and cross-reference. The *Implementation status* table, the #1277 retirement, all seven Open Question resolutions and the original Prompt are kept; the Prompt is unchanged. The PR body has a table showing where each essential fact now lives.

**Pushed to endojs/endo-but-for-bots**
- Head `design/guest-native-invitations-editorial` (commit 9a054a55f).
- Frozen base `llm-ca1794f`. `ensure-pr.sh` refuses a bare `llm` base, so the PR targets this snapshot.

**Successor job:** I posted `endojs-endo-but-for-bots-pr1116-editorial-pass-open-pr` (shepherd role, `requires: host=endolin-garden-ece02cb4`). It carries the full PR body, which links #1116 and the review and includes this job's marker, so a retry adopts the existing PR rather than opening a duplicate. Its tasks:
1. Open the PR with `ensure-pr.sh` against `llm-ca1794f`.
2. Shepherd it to green CI.
3. Dispatch the conductor to merge, without naming a merge method.

**Follow-up:** the inbox was unreachable when I started (journal clone timed out), so any messages to this job went unread.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1116-editorial-pass.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1168848 cached reads)
- Output: 40409 tokens
- Cost: $1.9125896
- Wall-clock: 1836s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
