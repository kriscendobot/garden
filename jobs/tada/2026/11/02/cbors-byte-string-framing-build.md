**No PR opened, no code changed: the design is already built and merged, so this job was a re-mint from a stale plan record.**

**Evidence**
- `designs/cbors.md` no longer exists on `llm`. It was renamed to `designs/cbor-frame.md`, whose status is Implemented.
- The package landed as `@endo/cbor-frame` through #288, merged 2026-10-19, after the maintainer asked for the rename.
- It's on `llm` at `48d6f3e08`, and I ran its test file there: 34 tests pass.
- `packages/ocapn` already uses it. The daemon migration the job mentions is out of this design's scope and is in progress separately in #711 (design) and #1505 (phase 1).

**Why the remaining difference isn't a gap:** the design still describes a `tagged` writer option and a reader that accepts plain frames, while the code requires tag 24 on every frame. kriskowal asked for that on #288 ("Let's make the tag 24 mandatory"). Building the design's text would undo that decision, so I didn't.

**What changed**
- **Plan record:** `plan/designs/endo-but-for-bots/cbors.md` on `journal2` now has status `Complete` and `pr: endo-but-for-bots#288`, plus a note about the rename and mandatory tag 24. I confirmed it landed on origin; this should stop the build being minted again. The generated `plan/README.md` wasn't re-rendered by this edit, so it still counts the old status until `bulletin.sh` next regenerates it.

**Follow-ups (not done, all outside this job)**
- **Stale design text on `llm`:**
  - `designs/cbor-frame.md` still describes the optional `tagged` form and lists tag 24 as an open question.
  - `designs/README.md` lines 565 and 1274 still say "In Progress (PR #288 open)".
  - These suit the next grooming pass.
- **Possible second stale record:** `ocapn-tcp-syrups-framing` is still `Not Started` with the same May import, yet `packages/syrup-frame` exists and `tcp-test-only.js` already uses it. I didn't check its full scope, so I left it alone. Someone should check it before it gets minted as a build too.
- **Checkout timeout:** `ensure-project-worktree.sh` failed again at the 120s git limit and needed `GARDEN_REPO_GIT_TIMEOUT=900`. The durable fix is still to exempt or extend `worktree add` there.

Self-improvement: memory `duplicate-build-report-pr-citation.md`; added this renamed-design case and the rule to read the implementing PR's reviews before treating a difference from the design as unbuilt.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/cbors-byte-string-framing-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (729478 cached reads)
- Output: 8441 tokens
- Cost: $0.9825716000000001
- Wall-clock: 1348s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
