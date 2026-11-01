## Viability report: endojs/endo-but-for-bots PR #1622

**Result:** `viability=proceed`. The gauntlet can start.

**PR facts:** The PR is open, unmerged and still a draft. Title: "docs(designs): ironhorse in-crank string garbage and the chunk ceiling". The head branch is `design/ironhorse-in-crank-string-garbage` at `6dc4e56`. The base is the frozen `llm-9a14ddf`, which is identical to the current `llm` tip. The PR was opened at 2026-11-01T16:12Z and has no comments or reviews yet.

**Deciding question:** Do about 820 test262 RegExp rows still halt `HeapExhausted` on the 256 MiB chunk ceiling because concatenation garbage isn't collected inside a crank, with no newer design or implementation on the base that addresses this?

**Answer:** Yes.

**Evidence:**
- **Base is current:** comparing `llm-9a14ddf...llm` shows `ahead_by=0`, so no newer base history exists that could have displaced the design.
- **No competing design on the base:** `designs/` on `llm` contains `ironhorse-quiescent-gc.md`, which this PR proposes to amend, but no design on in-crank or safepoint collection, ropes, or string garbage.
- **No other PR covers it:** a search of all PRs for string garbage, chunk ceiling, safepoint and HeapExhausted turns up only #1622. The related PRs either merged earlier on different scopes (#1457 charges side storage against the ceiling; #1456 adds a wasm memory model) or address a different gap (#1364 makes the abort policy configurable).
- **The motivating problem still holds:** #1618, the ratchet PR that named this follow-up, is still open. The `skip:ironhorse-aborted-limit` rows it describes remain, and the PR is about one hour old.

No budget was spent on the clean, panel, fix, CI-wait or un-draft stages. Nothing was changed; this job only read PR and repository data.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1622-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (158913 cached reads)
- Output: 1483 tokens
- Cost: $0.3706106
- Wall-clock: 165s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
