---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/comment-source-gh.sh

Surface 1 (`repos/<repo>/issues/comments`, line 158) 404s permanently on any repo with the Issues feature disabled — the GitHub default for forks. Failure signature in the journal blob:

```
WARN: gh api repos/kriscendobot/agoric-3-proposals/issues/comments?since=…&per_page=100 failed (definitive, rc=1); not retrying: gh: Not Found (HTTP 404)
FETCH INCOMPLETE for kriscendobot/agoric-3-proposals: one or more comment surfaces failed to enumerate
FATAL: comment source failed for kriscendobot/agoric-3-proposals (rc=1)
```

`repo_is_definitively_gone()` (line 347) does not catch it: `gh api repos/<repo>` returns 200, so the tail block takes `exit 1` and the unit fails on every tick in perpetuity. Confirmed on the live repo: repo 200 / `has_issues:false`, repo-wide `issues/comments` 404, `pulls/comments` 200 `[]`, and per-PR `issues/<n>/comments` **200 with real data**.

Change:

1. In the surface-1 `else` branch, before `note_fetch_failure`, classify a *definitive 404* on this endpoint by asking the authoritative question the gone-probe asks for repos: does the repo exist **and** is `has_issues` false? Fetch `repos/$repo --jq '.has_issues'` on the already-failed path only (a healthy tick pays nothing, matching the existing probe's discipline). If the repo answers and `has_issues == false`, this is **surface-not-enabled, legitimately empty** — not a lost fetch. Do **not** set `fetch_failed`; log once at info level and fall through to the fallback below. Keep every other 404/transient path exactly as-is (a 404 with `has_issues:true`, or an unreadable probe, must still freeze the cursor — never guess a state).
2. Preserve the `pr-comment` surface via a per-PR fallback: when surface 1 is skipped as not-enabled, enumerate conversation comments through `repos/$repo/issues/<n>/comments?since=$since` over the open-PR list section 3 already builds, emitting the identical TSV rows with `surface=pr-comment` (the `/pull/` html_url test still classifies correctly). A failure of *that* fallback is a genuine lost fetch and must call `note_fetch_failure`. `surface=issue-comment` is correctly unreachable on such a repo — no true issues can exist — so nothing is dropped.
3. Regression test in `scripts/jobs/test/comment-source-*-test.sh` (alongside the existing `gh-wrapper-fail-closed` / `gh-api-retry` fixtures) with a stubbed `gh`: (a) repo 200 + `has_issues:false` + `issues/comments` 404 → **exit 0**, cursor-advancing rows from the per-PR fallback, no FETCH INCOMPLETE; (b) repo 200 + `has_issues:true` + `issues/comments` 404 → still **exit 1**, cursor frozen; (c) repo 404 → unchanged REPO-GONE `exit 0` + throttled alert.
4. Also harden the producer: `scripts/jobs/fork-watch-provisioner.sh` arms these watches automatically and never checks the surface, which is why 11 of 17 armed watches share this defect. Nothing needs to *block* arming (the fix above makes such repos work), but note the `has_issues:false` fork case in the arming record's rationale or provisioner header so the next reader isn't surprised. Do not change the sender-gate semantics.

Note for the implementer: the per-PR fallback is the right fix rather than enabling Issues on the forks — enabling Issues opens a new untrusted-text surface on public forks and would need maintainer authorization per the monitoring safety constraint, whereas this fix is read-only and keeps the existing gate.
