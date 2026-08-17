---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
`scripts/jobs/handlers/comment-source-gh.sh` fails permanently on every fork whose Issues tab is disabled (GitHub's default for forks). Section 1 (line ~158) calls `gh_api_retry --paginate "repos/$repo/issues/comments?since=$since&per_page=100"`; when `repos/$repo` has `has_issues:false` that repo-level endpoint returns a definitive **404 Not Found**, so `note_fetch_failure "issues/comments"` fires, the tail block at line ~368 logs `FETCH INCOMPLETE`, and the source exits 1 — the watcher logs `FATAL: comment source failed` and systemd restarts it forever. `repo_is_definitively_gone()` (line ~347) does not catch this because `gh api repos/$repo` answers normally: the repo exists, only its issues surface is disabled.

Failure signature (self-heal blob 3809cc47, unit `garden-comment-watcher@kriscendobot-proposal-compartments`):
```
FETCH-FAIL: surface issues/comments failed to enumerate — freezing cursor
WARN: gh api repos/kriscendobot/proposal-compartments/issues/comments?since=…&per_page=100 failed (definitive, rc=1); not retrying: gh: Not Found (HTTP 404)
FETCH INCOMPLETE for kriscendobot/proposal-compartments …
FATAL: comment source failed for kriscendobot/proposal-compartments (rc=1)
```

Verified facts to build on (re-verify before coding):
- `gh api repos/kriscendobot/proposal-compartments` → `fork=true has_issues=false`, `archived=false`; `pulls?state=open` returns #4 and #2 — the repo is alive and readable.
- The **per-PR** endpoint works on the same repo: `repos/…/issues/4/comments` → `200 []`, while `repos/…/issues/999/comments` → 404, proving the 200 is a real enumeration and not a masked error.
- 11 of the 15 armed `comment-repos/` watches are `has_issues=false` forks (agoric-3-proposals, agoric-sdk, cosgov, endo, endo-but-for-bots, list, moddable, ocapn, proposal-compartments, test262, vattr97, ymax-stdio-mcp); 7 of those units are in `failed` state now. `kriscendobot/minion.town` is `has_issues=true` yet also failed — treat as a possibly distinct cause, do not fold it into this fix without evidence.

Required change: when surface 1 fails with a **definitive 404** AND a `repos/$repo` probe answers with `.has_issues == false`, do **not** treat it as a lost fetch, and do **not** treat it as an empty surface either. Instead **fall back to per-PR enumeration** — `repos/$repo/issues/<n>/comments?since=$since&per_page=100` over the open-PR list section 3 already builds — emitting the same TSV rows section 1 emits (all rows classify as `pr-comment`, since a repo with Issues disabled can hold no true-issue comments, so nothing is lost and the PR-only-mode filter is unaffected). Only if that fallback itself fails should `fetch_failed` be set, preserving the LOST-FETCH invariant. Simply skipping the surface would silence the restart loop while making the fleet permanently blind to PR conversation comments on every own-fork — a silent drop of exactly the kind the invariant was written to stop (cf. the r3566529028 drop documented at lines ~117-130); that outcome is not acceptable.

Ordering note: section 1 runs *before* section 3 computes the open-PR list, so the fallback must be deferred until that list exists (compute the open-PR list once, up front or lazily, and share it) rather than re-paginating `pulls` a second time. Cache the `has_issues` probe for the tick — one extra API call at most, and only on the 404 path.

Also: reuse the existing `_gh_api_stderr_is_transient` / definitive-404 classification rather than adding a new ad-hoc string match, so a 5xx or rate-limit on the same surface still freezes the cursor as it does today.

Tests: extend `scripts/jobs/test/comment-watcher-test.sh` (near the existing `FETCH INCOMPLETE` / gone-repo cases at ~1469 and ~1669) with a fixture where the repo-level `issues/comments` 404s and `repos/<repo>` reports `has_issues:false` — assert the source exits **0**, emits the PR conversation comments recovered from the per-PR endpoint, and advances the cursor; plus a companion case where the per-PR fallback itself fails and the tick must still exit nonzero with the cursor frozen; plus a regression case that a 404 with `has_issues:true` (or an unreadable probe) still freezes rather than falling back.

After landing, deploy and `systemctl --user reset-failed 'garden-comment-watcher@*'`, then confirm the issues-disabled forks tick clean. Expect a burst of re-polled comments on first healthy tick — the cursors have been frozen — which is idempotent by design (verify_posted + identity dedup).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-17T14:17:06Z
