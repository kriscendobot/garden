The inbox drain is offline (SSH clone timeout, matching the host's connectivity condition) — nothing retrievable, and my push to `main2` already landed. The work is complete.

## Completion report

**Job:** `weave-base-update-and-pin-alias` — fold "pin the merge base" into `weave` as an alias and correct weave's documented definition.

**Verification first (per the job's IMPORTANT note):** confirmed the base-update behavior already exists in `skills/frozen-base-branch/SKILL.md` § *Rebase: move both base and head* (new frozen `<base>-<sha>`, rebase head onto it, force-push, move the PR's `base` field, both refs together). No implementation drift — this was a documentation correction plus a comment-watcher reframing, exactly as the job anticipated.

**Notable discovery:** the comment-watcher *already* recognized "pin the merge base" (as an internal `pinbase` verb → role `weaver`), but the docs (README/CLAUDE.md) and a code comment framed it as *"a distinct, stronger op than rebase/weave"* — the precise drift the 2026-08-16 maintainer clarification reverses. So the fix was to reframe, not to add recognition.

**Changes (committed `ed1ceba5b59`, pushed to `origin/main2`):**
- **README.md** § Key vocabulary — folded the two rows into one `weave #N` / `pin the merge base #N` row stating the base update (new frozen `<base>-<short-sha>`, rebase, resolve, force-push, move base field) and calling pin-the-merge-base an alias.
- **CLAUDE.md** § Orchestrator vocabulary — same fold, with the maintainer decision and the provenance quote from endojs/endo-but-for-bots#282.
- **roles/weaver/AGENT.md** — the base update is now in the role's stated purpose (first paragraph), with the alias statement and provenance; corrected the old "strong form of this op" line to "alias … not a stronger one."
- **scripts/jobs/comment-watcher.sh** — reframed the `pinbase` code comment from "distinct/stronger op" to "alias for weave"; generalized the job-body action text from the endo-specific "llm-<sha>" to "update the merge base to the current base-branch hash." Recognition and mapping to the weaver base-update job are unchanged (imperative-position gated, detected before the single-word loop so the trailing "and rebase" doesn't shadow it).
- **scripts/jobs/test/comment-watcher-test.sh** — added PMB1/2/3: imperative alias mints exactly one weaver (`pinbase`) job with `role: weaver`, base-update semantics, and no shadow `rebase` job; the phrase as subject matter mints nothing (verified against an untrusted sender, where a branch-op mis-fire would still post); the embedded "merge" in "merge base" mints no conductor/finalize job.

**Tests:** full `comment-watcher-test.sh` suite **398 passed, 0 failed** (including the 3 new PMB blocks). Note: the suite requires an isolated `GARDEN_ROOT` to run — this host's profile exports `GARDEN_ROOT=/home/kris/garden`, whose live `.garden-state` currently holds an active journal-outage cooldown latch that makes `cursor-get` short-circuit; running with a fresh temp `GARDEN_ROOT` (hermetic, as CI would) passes clean. I did not touch the deployed root's state.

**Recommendation surfaced (not acted on, per job scope):** `rebase #N` and `weave #N` are now semantically distinct — rebase keeps the existing base, weave updates it. The comment-watcher already mints separate `rebase` vs `pinbase`(weave) weaver jobs, so the code matches. Only the README/CLAUDE `rebase #N` row still reads as a plain "rebase on its base" and could be tightened if the maintainer wants the distinction sharpened in the vocabulary tables.

**Follow-up (informational, not blocking):** the live host has an active journal-outage latch and inbox SSH clones are timing out — an existing fleet condition unrelated to this job (there are already `improve-*-outage-*` sessions in flight).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/weave-base-update-and-pin-alias.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 12 on 2 host(s) (11 unmetered)
- Input: 112 tokens (7234048 cached reads)
- Output: 58927 tokens
- Cost: $6.823818999999999 (11 engagement(s) unpriced)
- Wall-clock: 1548s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
