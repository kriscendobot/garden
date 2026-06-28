# Comment-watcher: a trusted comment must NEVER be silently dropped — always reactji-ack + log every slide

Map: **build** (garden infra) on branch main2. Isolated worktree off origin/main2;
explicit-pathspec commits; push HEAD:main2 via git-rebase CAS. Touches
`scripts/jobs/comment-watcher.sh` (and apply the same hardening to
`scripts/jobs/issue-inbox-watcher.sh`, which shares the slide-past-cursor pattern).

## Observed failure (endojs/endo-but-for-bots #405, 2026-06-28)
kriskowal's trusted comment 4825162435 (06:48Z: "Getting closer. 1. … 2. Let's aggregate
Handles … 3. Let's manually order … 4. Remove … 5. … indent") was **silently dropped**: the
watcher logged only `advanced comment cursor … to 2026-06-28T06:48:40Z (acted on 0; failed=0)`
— NO reactji, NO job, NO drop reason. The maintainer noticed the missing reactji and asked
"is the watcher working?". A sibling comment from the same sender on the same PR (07:18Z,
4825226375) WAS handled (reacted + job), so the watcher is alive — the drop is a
classification + silent-slide bug, not an outage.

## Root cause (in comment-watcher.sh action loop)
Two branches slide the cursor (`hw="$created"; continue`) with **no `log` and no reactji**:
- the `rc -eq 1` "not actionable" branch (deterministic verb/classify gate said no), and
- the fallback `VERB=skip`/empty branch.
The 06:48 comment's "Getting closer / Let's aggregate / Let's manually order" phrasing was
classified NOT ACTIONABLE by the deterministic verb gate, so it took the silent `rc==1`
slide. Nothing logged why.

## Required fixes
1. **A trusted, in-scope comment ALWAYS gets a reactji** (👀) acknowledging receipt — even
   when the classifier deems it non-actionable and posts no job. The reactji is the
   maintainer's "I saw this" signal and must not depend on actionability. (Keep the existing
   no-reactji rule only for genuinely unreactable surfaces like pr-review-body.)
2. **Never slide the cursor past a trusted comment without LOGGING the explicit reason.** Add
   a `log` line to BOTH silent branches (the `rc==1` not-actionable slide and the
   `VERB=skip` slide) naming which gate dropped it and the comment id/url — so a future drop
   is diagnosable from the journal, never silent (cf. the no-silent-caps / blindness lessons).
3. **A trusted sender's non-obviously-actionable comment routes to the claude FALLBACK**
   (rc=2 path) rather than the `rc==1` silent drop. The deterministic verb gate cannot catch
   every phrasing of a directive ("Let's aggregate…", "Let's manually order…", "Remove…",
   "increase the indent"); for a TRUSTED sender, prefer fallback-triage over dropping, so
   clear maintainer directives aren't missed. (Apply the same to the issue-inbox watcher.)
4. **Secondary — reduce per-tick latency.** Each tick currently takes ~40–87s wall (≈5s CPU;
   the rest is I/O: the journal VERIFY clone/fetch + gh polling), which delays the reactji by
   up to ~1.5 min and is what made the maintainer think the watcher was down. Reuse/cache the
   journal clone across ticks instead of re-cloning each tick (and any other cheap latency
   win), so acknowledgment is prompt.

## Tests / verification
Extend the watcher tests: a trusted comment the verb gate scores non-actionable still gets a
reactji AND a logged reason (no silent slide); a trusted ambiguous comment reaches the claude
fallback rather than rc==1; mention-only and untrusted drops still log as today. Stub gh/the
classifier deterministically.

## Deliverable
comment-watcher.sh (and issue-inbox-watcher.sh) never silently slide past a trusted comment:
always reactji-ack it, always log the drop reason, route trusted ambiguous comments to the
fallback, plus the per-tick latency reduction — with tests pinning the no-silent-drop property.

---
claim:
  host: endolinbot
  gardener: 40
  claimed_at: 2026-06-28T07:27:23Z
