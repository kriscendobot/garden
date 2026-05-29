---
ts: 2026-05-29T02:47:00Z
kind: result
role: steward
host: endolinbot
to: "*"
project: endo
refs:
  - jobs/claimed/20260529T023943Z--endolinbot--steward--94a0--a3be00--backfill-mirror-cross-links.md
  - entries/2026/05/29/021300Z-result-steward-c4d5e6.md
prs:
  - repo: endojs/endo
    pr: 3256
    role: target
  - repo: endojs/endo
    pr: 3257
    role: target
  - repo: endojs/endo
    pr: 3262
    role: target
  - repo: endojs/endo
    pr: 3263
    role: target
  - repo: endojs/endo
    pr: 3264
    role: target
  - repo: endojs/endo
    pr: 3265
    role: target
  - repo: endojs/endo
    pr: 3268
    role: target
  - repo: endojs/endo
    pr: 3273
    role: target
  - repo: endojs/endo
    pr: 3274
    role: target
  - repo: endojs/endo
    pr: 3275
    role: target
  - repo: endojs/endo
    pr: 3276
    role: target
  - repo: endojs/endo
    pr: 3277
    role: target
  - repo: endojs/endo
    pr: 2901
    role: target
  - repo: endojs/endo
    pr: 3231
    role: target
---

# Mirror cross-link backfill: upstream side complete, garden side deferred

Claimed job `a3be00` (`backfill-mirror-cross-links`). Executed per
`skills/mirror-cross-link-backfill/SKILL.md` with `recent` scope. Found
a real semantic gap that warrants gardener attention before completing
the garden side.

## Enumeration

- **25 ferry-shaped journal entries** parsed (boatman or liaison
  `result` with an `Upstream PR:` line). After dedup by upstream PR
  (newer record per re-ferry wins): **14 unique ferries**, all on
  `endojs/endo` from `endojs/endo-but-for-bots`.

## Scope filter (recent: OPEN or merged/closed within 30 days)

All 14 ferries are in scope:

- **6 OPEN**: #3263, #3264, #3275, #3276, #3277, #3231.
- **8 MERGED within 30 days**: #3256, #3257, #3262, #3265, #3268,
  #3273, #3274, #2901.

## Coverage check (existing canonical `Mirror of ...` cross-links)

**Upstream side**: all 14 ferries had **no** existing canonical or
otherwise tagged comment from `kriscendobot` whose body starts with
`Mirror of `. Confirmed by `gh api repos/endojs/endo/issues/<N>/comments
--jq '.[] | select(.user.login=="kriscendobot" and (.body | startswith
("Mirror of ")))'` returning empty on all 14.

**Garden side**: all 14 ferries had **no** canonical `kriscendobot
"Mirror of ..."` comment, but **every one had a kriskowal-authored
descriptive cross-link** (free-form, naming the upstream PR). Example
from PR #64: kriskowal at `4514157889` says *"Ferried upstream as
endojs/endo#3277 ..."*. These pre-norm cross-links are the historical
practice from the liaison-via-kriskowal era; they predate the
2026-05-22 commit (48593e34) that landed the canonical bot-bookkeeping
two-way norm on the boatman role.

## Backfill executed: upstream-side only

Posted 14 canonical `Mirror of <garden-PR-URL> (head <short-SHA>).`
comments on `endojs/endo` under `kriscendobot`. Comment IDs:

```yaml
backfill_actions:
  - upstream_repo: endojs/endo
    upstream_pr: 3256
    garden_pr: 109
    head_sha: da5a9b48e
    upstream_side: created
    upstream_comment_id: 4570013900
    garden_side: skipped-deferred
  - upstream_pr: 3257
    garden_pr: 223
    head_sha: dd45f4a7f
    upstream_side: created
    upstream_comment_id: 4570013950
    garden_side: skipped-deferred
  - upstream_pr: 3262
    garden_pr: 255
    head_sha: 407d25c5b
    upstream_side: created
    upstream_comment_id: 4570013998
    garden_side: skipped-deferred
  - upstream_pr: 3263
    garden_pr: 244
    head_sha: 512438a27
    upstream_side: created
    upstream_comment_id: 4570014059
    garden_side: skipped-deferred
  - upstream_pr: 3264
    garden_pr: 258
    head_sha: c89593c5c
    upstream_side: created
    upstream_comment_id: 4570014120
    garden_side: skipped-deferred
  - upstream_pr: 3265
    garden_pr: 73
    head_sha: 337d16a89
    upstream_side: created
    upstream_comment_id: 4570014168
    garden_side: skipped-deferred
  - upstream_pr: 3268
    garden_pr: 280
    head_sha: 6d007fa9e
    upstream_side: created
    upstream_comment_id: 4570014231
    garden_side: skipped-deferred
  - upstream_pr: 3273
    garden_pr: 329
    head_sha: 761ea4ff9
    upstream_side: created
    upstream_comment_id: 4570014284
    garden_side: skipped-deferred
  - upstream_pr: 3274
    garden_pr: 67
    head_sha: e153a5afa
    upstream_side: created
    upstream_comment_id: 4570014328
    garden_side: skipped-deferred
  - upstream_pr: 3275
    garden_pr: 68
    head_sha: 4d8ed6be7
    upstream_side: created
    upstream_comment_id: 4570014382
    garden_side: skipped-deferred
  - upstream_pr: 3276
    garden_pr: 336
    head_sha: f4aad15aa
    upstream_side: created
    upstream_comment_id: 4570014514
    garden_side: skipped-deferred
  - upstream_pr: 3277
    garden_pr: 64
    head_sha: 6a173b061
    upstream_side: created
    upstream_comment_id: 4570014571
    garden_side: skipped-deferred
  - upstream_pr: 2901
    garden_pr: 332
    head_sha: 69ca27c20
    upstream_side: created
    upstream_comment_id: 4570014618
    garden_side: skipped-deferred
  - upstream_pr: 3231
    garden_pr: 79
    head_sha: c6a779d0c
    upstream_side: created
    upstream_comment_id: 4570014682
    garden_side: skipped-deferred
```

## Why garden side is deferred (gardener question)

The skill's existing-comment grep filters on
`.user.login=="kriscendobot" and (.body | startswith("Mirror of "))`.
On garden-side PRs, the historical kriskowal-authored descriptive
cross-links do not match (different identity, different prefix). If
the skill posts canonical bot-bookkeeping comments on the garden side,
every garden-side PR with a historical kriskowal cross-link ends up
with **two cross-link comments**: the historical descriptive one
(kriskowal identity, freeform body, full context) and the new
canonical one (kriscendobot identity, mechanical body, head-SHA
exact).

Two reasonable dispositions:

1. **Co-existence**: the canonical bot-bookkeeping comment is for
   future re-ferries (the bot-side editable record); the historical
   kriskowal cross-link is human-authored context. Different
   identities, different purposes; co-existence is fine and the
   backfill posts canonical on both sides regardless.
2. **Skip when kriskowal cross-link present**: broaden the
   existing-comment grep to detect either identity's
   cross-link-shaped body; treat the garden side as "covered" when
   the kriskowal cross-link exists, even though the format isn't
   canonical.

Neither option is wrong; the choice is a gardener-level decision about
the dual-comment-per-side tradeoff. The steward does not edit skills
and defers the garden-side backfill until the gardener decides.

In the meantime: every NEW ferry from the boatman role since 48593e34
correctly produces the two-way canonical norm (the steward verified by
inspecting boatman result entries since the commit landed). The
historical gap is one-shot; once decided, the gardener (or a future
backfill job) closes it for the historical set.

## Concurrency observation from the claim mechanism

The claim of `a3be00` via `skills/job-board/claim-job.sh` resulted in
the claim-frontmatter (`claimed_by_role`, `claimed_by_host`,
`claimed_by_session`, `claimed_at`) being stripped from the file on
origin. The `git mv` from `jobs/open/` to `jobs/claimed/` landed, but
the awk-stamping of claim fields was reset by a concurrent process's
`git reset --hard origin/journal` between the claim-job.sh's awk step
and its `git commit` (or between commit and push). The file at
`jobs/claimed/20260529T023943Z--endolinbot--steward--94a0--a3be00--
backfill-mirror-cross-links.md` is path-stamped (the steward identity
is in the filename) but the YAML frontmatter shows the open-form
fields only.

This is the same class of race the cycle 2 result entry
(`c4d5e6.md`) surfaced for steward's own commits: producer/consumer
skill scripts (`post-job.sh`, `claim-job.sh`, the job-board-poll
daemon) all run `git reset --hard origin/journal` as part of their
resync, and any in-flight uncommitted edit on the shared `/home/kris/
journal` worktree is exposed. The steward's standing "pause the
daemon" discipline protects against the daemon's reset but not
against concurrent claim/post scripts. The structural fix is
gardener-level; flagged in cycle 2's result and re-confirmed here.

## Job completion

This result entry transitions job `a3be00` from `claimed/` to `done/`
via the next bash step. The garden-side backfill becomes a follow-up
the gardener (or a re-posted job) handles after the dual-comment
disposition decision.

Self-improvement: nothing new beyond cycle 2's concurrency
observation, plus the substantive new lesson that the skill's
existing-comment detection logic needs broadening to consider
historical kriskowal-authored cross-link comments (cross-identity,
cross-format detection); flagged for gardener via this result entry
and the resulting `done/` job state.
