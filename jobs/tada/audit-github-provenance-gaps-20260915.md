Inbox empty, tree clean (pure audit — no garden-source changes). Report follows.

---

# Audit: provenance footers on garden-authored GitHub comments

## Scope & method
- **Watched set consulted:** `journal/comment-repos/` (endojs/endo-but-for-bots + the `kriscendobot/*` own-forks: minion.town, garden, endo, cosgov, finbot, ocapn, test262, moddable, list, vattr97, proposal-compartments, ymax-*) and `config/fork-owners` (`kriscendobot`). Actual garden comment traffic in the window lives almost entirely on **endojs/endo-but-for-bots**; kriscendobot/garden issue #89 also had comments; minion.town had none.
- **Author:** `kriscendobot` (resolved via `bot-identity-defaults.tsv`, not hardcoded).
- **Window:** conversation comments since 2026-09-10 (38 on endo-but-for-bots), with the fix cutoff in mind. Reviews (the `/reviews` endpoint) were not exhaustively walked; findings below are from conversation/PR comments.

## Mechanism timeline (rollout dates)
- **2026-07-28T17:20Z** — original footer mechanism landed (model · harness · garden sha). Comments before this are expected to have no footer.
- **2026-09-15T21:03Z** (commit `4637a85f`, tada 21:04Z) — *prov-child1*: adds `provider` fact, the `model automatic` marker for deterministic posters, and the instrumentation-gap maintainer alert. **This is the "matters after" cutoff.**
- **2026-09-15T21:19Z** (commit `a2ac6fd4`) — *prov-child2*: per-section footnotes for aggregated bodies.
- **Deploy state:** the fix is **canary-deployed to one follower only** (`endolin-garden2-5bcdff64` → `4637a85f`, ~21:07Z). The leader (`endolin-garden-ece02cb4`, this host) still runs **pre-fix** `ed289c9d`. Rolling deploy advances the leader last.

## Headline finding: no confirmable NEW-mechanism gap yet — but a structural hole the fix does *not* close
No comment in the wild yet carries the fix sha (`4637a85`/`a2ac6fd`) or a `provider` fact — the new mechanism simply hasn't been exercised since canary deploy. So there is **no confirmed post-fix footer that still fails**. However, the audit surfaced a **structural bypass the fix cannot see:**

### GAP CLASS 1 (CONFIRMED, actionable) — `gh pr close/merge --comment` bypasses the footer entirely
The wrapper's dispatcher (`provenance_rewrite_argv`, `comment-provenance.sh`) only matches `pr comment`, `pr review`, `issue comment`, and comment-typed `api` calls. A verdict comment posted via **`gh pr close --comment` / `gh pr merge --comment`** (how botanist REJECT, conductor merge, and proposal-close verdicts are posted — `roles/botanist/AGENT.md:106`) is **passthrough-unchanged → no footer at all**. Reproduced locally: `provenance_rewrite_argv pr close … --comment …` returns rc 1 (passthrough); `pr comment` is rewritten.

Confirmed instances (comment timestamp == PR close/merge timestamp to the second):
| Repo | PR | Comment | State change | Missing |
|---|---|---|---|---|
| endojs/endo-but-for-bots | #1271 | issuecomment-5655785548 (20:06:41Z) | CLOSED 20:06:42 (botanist REJECT) | whole footer |
| endojs/endo-but-for-bots | #1270 | issuecomment-5655799918 (20:09:11Z) | CLOSED 20:09:12 (proposal close) | whole footer |
| endojs/endo-but-for-bots | #1273 | issuecomment-5655817252 (20:12:14Z) | CLOSED 20:12:15 (proposal close) | whole footer |
| endojs/endo-but-for-bots | #1267 | issuecomment-5655774499 (20:04:53Z) | MERGED 20:04:30 (conductor) | whole footer |

**Why it matters post-fix:** this hole is orthogonal to the fix and will keep producing footerless verdict comments after rollout. Worse, the new **gap-alert cannot detect it** — the alert (`_prov_gap_check`) fires only *on the wrapper's comment path*; a comment that never enters the wrapper is invisible to the detector. This is the top forward-looking item.

### GAP CLASS 2 (unresolved path) — plain gardener/shepherd status comments with no footer
Several substantive, clearly LLM-authored status comments carry **no footer at all**, and are **not** close/merge posts:
- #1125 issuecomment-5687399933 (2026-09-15T20:09Z, "…CI rerun is green…re-requesting review")
- #1125 issuecomment-5688205402 (2026-09-15T**21:16**Z, "…spaces-util TS checks passed…CI is running") — *after the fix's wall-clock landing, though this host is pre-fix-deployed*
- #1125 issuecomment-5647169999 (09-12), #1125-5642303102 (09-12)
- #1260 issuecomment-5619249225 (09-10, review summary "I found no blocking issue")
- #1257 issuecomment-5628131204 (09-11, "review is paused…" gate message)

The wrapper always emits at least a garden-sha footer when invoked (verified: sha resolves from the deploy marker; in a gardener env model/harness/provider also resolve). So these **bypassed the wrapper**. Root cause not definitively pinned — candidates: a `gh` invocation that didn't resolve to the fleet `scripts/jobs/bin/gh` (PATH escape in an agent Bash shell), or another unmatched subcommand. **Recommend a follow-up to instrument/trace the gardener status-comment and pause-gate posting paths.**

### GAP CLASS 3 (expected / self-resolving on rollout) — lower priority
- **Deterministic reply-acks with garden-only footer** ("I've posted a job … will follow up here", `<!-- garden-reply:N -->`; e.g. #1125-5688246288, #1262, #877-5653710479, and ~8 others). This is exactly the PR #1125 footer shape (garden sha present, model/harness absent). **Fixed by `4637a85f`** (comment-reply-gh now sets `GARDEN_NO_LLM=1` → `model automatic`). Still garden-only in the wild only because the leader host runs pre-fix code. Self-resolves on leader deploy.
- **`model · harness` footers missing `provider`** (~18 comments, e.g. #1268, #1269, #877-5653768316) — pre-fix; `provider` added by `4637a85f`. Self-resolves.
- **Missing garden sha** on #600 (issuecomment-5685975149 / -5688040475: `model … · harness …`, no sha) — deploy-sha marker didn't resolve in that job's env; minor.
- kriscendobot/garden issue #89 comments: all footered — fine.

## Recommendation on retroactive editing
**Not worth it.** The garden-only and missing-provider footers are pre-fix historical artifacts that the deployed fix already corrects going forward; rewriting the historical GitHub review record is a maintainer judgment call (and out of this job's scope by instruction). The value is entirely forward-looking:
1. **Fix GAP CLASS 1** — extend `provenance_rewrite_argv` to also footer `pr close`/`pr merge`/`pr ready`/`pr edit` `--comment`/`--body` bodies (or route verdict comments through `gh pr comment`). This is a concrete, tested-reproducible bug and the highest-value follow-up. *Worth posting a fixer job.*
2. **Trace GAP CLASS 2** — instrument the gardener/shepherd status-comment and pause-gate posting paths to find why they bypass the wrapper.
3. Let the fix finish rolling to the leader; then re-audit for a *confirmed* post-fix-deployed footer to validate `provider`/`automatic`/per-section rendering in the wild (none exists yet).

No garden-source changes were made (pure audit); working tree clean.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/audit-github-provenance-gaps-20260915.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1064399 cached reads)
- Output: 29221 tokens
- Cost: $2.2528865
- Wall-clock: 442s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
