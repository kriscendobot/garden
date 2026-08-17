---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
`scripts/jobs/handlers/comment-source-gh.sh` crash-loops permanently on any watched repo whose Issues feature is disabled (the GitHub default for a fresh fork). Failure signature, from the self-heal blob for `garden-comment-watcher@kriscendobot-ocapn`:

```
WARN: gh api repos/kriscendobot/ocapn/issues/comments?since=…&per_page=100 failed (definitive, rc=1); not retrying: gh: Not Found (HTTP 404)
FETCH INCOMPLETE for kriscendobot/ocapn … exiting nonzero
FATAL: comment source failed for kriscendobot/ocapn (rc=1)
```

Cause: section 1's repo-level `repos/<repo>/issues/comments` list returns a definitive 404 when the repo has `has_issues:false`. That sets `fetch_failed`, and the tail's REPO-GONE degrade does not fire because `repo_is_definitively_gone()` probes `repos/<repo>`, which answers 200 — the repo exists, only its Issues feature is off. Control reaches the unconditional `exit 1`, so the unit fails on every tick in perpetuity. `kriscendobot/ocapn` is a live fork of `ocapn/ocapn`; the arming is legitimate and must NOT be tombstoned.

Affects 10 of 17 armed comment watches (`comment-repos/`): agoric-sdk, cosgov, endo, endo-but-for-bots, list, moddable, ocapn, proposal-compartments, vattr97, ymax-stdio-mcp.

Substance of the fix, in `scripts/jobs/handlers/comment-source-gh.sh`:

1. Add an ISSUES-DISABLED classification alongside the existing REPO-GONE degrade: when the section-1 `issues/comments` fetch fails with a definitive 404 **and** `repos/<repo>` itself answers, this is a disabled Issues feature, not a lost fetch. Do not set `fetch_failed` for it.
2. Do NOT simply treat the surface as empty. That endpoint also carries **PR conversation comments** (split by `html_url | test("/pull/")`), so swallowing the 404 while advancing the cursor would silently drop maintainer PR-conversation directives — exactly the LOST-FETCH invariant the file's header defends. Instead fall back to a per-PR walk: for each open PR already enumerated by section 3, fetch `repos/<repo>/issues/<n>/comments?since=$since&per_page=100` and emit those comments with the same `pr-comment` classification, bot filter, and `created_at >= $since` filter as section 1. Verified working: that per-PR endpoint returns OK on issues-disabled forks (`endo`, `endo-but-for-bots`, `moddable`, `list`) while the repo-level list 404s.
3. Because the fallback needs section 3's open-PR list, defer it to run after section 3 — the same deferral section 2's inline review-comments already uses. Keep emission ordering/dedup consistent with section 2.
4. If the per-PR fallback itself fails to enumerate for any open PR, set `fetch_failed` as normal so the cursor still freezes. Only the repo-level list 404 is forgiven.
5. True-issue comments genuinely cannot exist on an issues-disabled repo, so emitting none of the `issue-comment` surface is correct and needs no alert. Log the degrade once per tick at INFO so it stays diagnosable, and do not `alert_maintainer` — this is a normal steady state for a fork, not an actionable condition.
6. Do NOT gate the behavior on a `has_issues` precheck. It is not reliably predictive: `kriscendobot/test262` and `kriscendobot/agoric-3-proposals` both report `has_issues:false` yet their `/issues/comments` returns 200. Key strictly on the observed definitive 404 plus a live repo probe.

Tests, in `scripts/jobs/test/comment-watcher-test.sh` (extend the existing gone-live/FETCH-INCOMPLETE fixtures, which already stub `*"/issues/comments"*`):
- repo-level `/issues/comments` 404s while `repos/<repo>` answers → source exits 0, does not log FETCH INCOMPLETE, and does not alert.
- same fixture with an open PR carrying a non-bot conversation comment newer than `since` → that comment is emitted as `pr-comment` via the per-PR fallback (the regression guard for the silent-drop hazard).
- per-PR fallback fetch fails → `fetch_failed` still set, still exits nonzero, cursor still frozen.
- unchanged: a definitive repo-level 404 on `repos/<repo>` still takes the REPO-GONE exit-0 path with its alert.

<!-- garden-reaped: 2 -->
