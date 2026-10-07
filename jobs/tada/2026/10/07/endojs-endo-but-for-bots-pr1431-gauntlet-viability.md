**Viability report: endojs/endo-but-for-bots PR #1431**

PR #1431 passes the viability gate. I re-checked it this session and nothing has changed since the first pass: it is still open and a draft, head `45c4913` on base `llm-fda1ff5`. It adds 94 lines of documentation to `designs/hardened-text-codecs-shim.md`, describing the encapsulation revision for endojs/endo#3369.

Deciding question: Does `llm` (or any newer PR) already record the encapsulation remedy for endojs/endo#3369 in `designs/hardened-text-codecs-shim.md`, or has the companion implementation #1349 been dropped?

Answer: no on both counts.

Evidence:
- **Base is current.** `llm` has 0 commits beyond the frozen base `fda1ff5`.
- **Nothing on `llm` covers this yet.** The design file on `llm` has no mention of encapsulation, #3369, `caller`/`arguments`, or the Chrome 137/138 boundary.
- **The companion PR is still live.** #1349 ("fix(ses): encapsulate TextEncoder and TextDecoder behind SES-owned constructors") is open and not a draft.
- **The motivating bug is still open.** Issue endojs/endo#3369 is open. The rejected alternative, endojs/endo#3371 (permit the bogus props), is also still open.
- **The overlapping PR does not supersede it.** #1381 also edits the same design file, but it only adds a "mark implemented" status section and the permits table.
- **No reviews or comments so far.**

Follow-up: #1381 and #1431 both edit the same design file. Whichever lands second may need a weave to resolve a merge conflict. The status section in #1381 may also need to mention the encapsulation revision.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1431-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (270257 cached reads)
- Output: 2461 tokens
- Cost: $0.8362028
- Wall-clock: 33s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
