I judged this review a **minor review miss** and recorded it. No improvement job was dispatched, because the cluster is still below the dispatch floor.

**Starting state:** nothing was recorded for this retro (`review-misses/{misses,dismissed}/…-b786506c.md` did not exist), so I started from scratch.

**What the review said** (paraphrased, a design ask with no inline comments): the maintainer wants fewer formula types. They suspected the PR's dedicated `readable-directory` formula type could instead be an eval formula that takes a hub and calls `readOnly()` on it.

**What I checked myself** (not relying on the primary job's report):
- The primary's expanded-window child made exactly this change in commit `42bad92360` ("express read-only directory as eval"). It removed the formula type and its formula-record, type, manager and inspector wiring. The follow-on slice #1304 merged on that basis. #1125 itself is closed.
- The `readOnly()` attenuation already existed on `llm` for mounts and files before #1125, and eval formulas are long-standing. So the simpler version needed nothing new.
- The six gauntlet panel/fix rounds reviewed the `readable-directory` type and polished it instead of questioning it:
  - fix-4 renamed `formulateReadOnlyDirectory` to `formulateReadableDirectory` to match the type;
  - purist documented the attenuation unwrap;
  - panel-5's prover asked for coverage of that unwrap branch;
  - fix-1 listed `readOnly()` memoization as a follow-up.

  No seat asked whether a new durable formula type was needed at all.

**Verdict:**
- **Severity:** minor. No written rule says to minimize formula types, and the "minimum viable abstraction" check that would ask this only runs on the design panel, not the code panel.
- **Category:** `correctness-bug`, to match the cluster's existing category.
- **Evaluator gaming:** ruled out.

**What I recorded** (pushed to `journal2`, confirmed on origin):
- The record is `review-misses/misses/endojs-endo-but-for-bots-pr1125-review-b786506c.md`.
- It joined the cluster `vestigial-mechanism-unquestioned`, which now holds 2 misses, both from #1125, and stays open.

**Threshold:** held below the floor.
- Dispatch needs at least 3 misses across at least 2 PRs; this cluster has 2 misses from one PR.
- The shortcut for a single major miss doesn't apply.

I wrote the reasoning into the cluster file. It also notes that the cluster `design-bespoke-mechanism-over-existing-path` (#1226) has the same shape: together the two span 3 misses across 2 PRs. If a third PR adds another instance, merge the clusters and dispatch. The likely fix is to run the "minimum viable abstraction" question on the code panel too, with a panel-hints probe that fires when a PR adds a new daemon formula `type`.

**Follow-ups:** none dispatched.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1125-review-b786506c-retro.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 44 tokens (1520820 cached reads)
- Output: 9245 tokens
- Cost: $1.085248
- Wall-clock: 127s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
