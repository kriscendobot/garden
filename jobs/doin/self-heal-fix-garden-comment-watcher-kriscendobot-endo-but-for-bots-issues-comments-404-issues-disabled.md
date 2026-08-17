---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
`scripts/jobs/handlers/comment-source-gh.sh:158` fetches the repo-level `repos/$repo/issues/comments?since=…` list, which GitHub answers with a permanent HTTP 404 on any repo whose Issues feature is disabled — the default for forks. `gh_api_retry` rightly classifies 404 as definitive, so `note_fetch_failure "issues/comments"` fires, the handler exits nonzero ("FETCH INCOMPLETE … freezing cursor"), and `comment-watcher.sh` dies FATAL on every tick. Confirmed on `kriscendobot/endo-but-for-bots` (`fork=true has_issues=false`; the 404 reproduces directly), and it affects 11 of the 17 repos in `journal/comment-repos` — every `kriscendobot/*` fork armed by the own-fork auto-provisioner — all of which are currently in systemd restart loops. Beyond the failing unit, `surface=pr-comment` (a PR's conversation comments, the comment-watcher's unique surface) has never been enumerated on any of them.

Fix, in priority order:

1. **Recover the surface with no coverage loss — do NOT merely skip it.** With Issues disabled, the repo-level list 404s but the **per-PR** path still returns 200 (verified: `repos/kriscendobot/endo-but-for-bots/issues/1/comments` → 200, empty). When the repo-level surface is unavailable, enumerate PR-conversation comments per open PR via `repos/$repo/issues/<n>/comments?since=…`, reusing the existing activity-bounded open-PR walk in section 3 (`pulls?state=open&sort=updated&direction=desc`, with the same `updated_at < since` early-stop) so no extra PR-list call is added. Emit these as `surface=pr-comment` exactly as the repo-level branch does — the `html_url` `test("/pull/")` split still classifies correctly, and `issue-comment` is genuinely absent on such a repo (no issues can exist), so nothing is lost.
2. **Detect the disabled state, don't pattern-match the 404 blindly.** Gate on `has_issues` from `repos/$repo` (cache it per tick) rather than treating any 404 on this surface as "issues disabled" — a 404 from a deleted/renamed repo or a token-scope loss must still freeze the cursor and fail loud. Log the degraded mode once per tick (`issues disabled on <repo>; enumerating pr-comment per open PR`) so it stays diagnosable in the journal. Keep the existing freeze-the-cursor behavior for every other definitive failure; this must not become a blanket `|| true`.
3. **Second call site — the self-test probe.** `scripts/jobs/comment-watcher.sh:379` and `:381` probe the same repo-level `issues/comments?per_page=1` endpoint under `|| true`, so on this whole cohort the probe yields empty → "transient, inconclusive" forever, silently disabling the jq-blindness guard that exists to prevent a repeat of the 2026-06-24 16h silent-empty outage. Point the probe at a surface that exists when Issues are off (e.g. the newest open PR's `pulls/<n>/comments` or `issues/<n>/comments`), preserving its `timeout 10s --kill-after=5s` budget and the 20s `TimeoutStopSec` margin documented there.
4. **Same latent shape, no fix required now:** `scripts/jobs/handlers/issue-source-gh.sh:117` uses the identical repo-level endpoint. It is not failing today because the issue-inbox watches only `config/garden-repo` (`kriscendobot/garden`, `has_issues=true`), but it will 404 the same way if the inbox is ever pointed at a fork — note it in a comment there, or share whichever helper item 2 introduces.

Regression tests belong in `scripts/jobs/test/comment-watcher-test.sh` (which already covers the FETCH-FAIL/freeze path) using the existing `GARDEN_GH` stub seam: (a) `has_issues=false` + repo-level 404 → handler exits **0** and emits the `pr-comment` rows gathered per open PR; (b) a 404 with `has_issues=true` (or an unreadable `repos/$repo`) → still freezes the cursor and exits nonzero.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-17T13:35:51Z
