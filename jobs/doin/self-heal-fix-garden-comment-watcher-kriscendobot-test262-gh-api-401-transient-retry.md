---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Absorb spurious GitHub `HTTP 401 Bad credentials` under the existing bounded retry instead of classifying it DEFINITIVE.

Signature: `scripts/jobs/handlers/comment-source-gh.sh` → `gh api repos/<owner>/<repo>/issues/comments?since=…` → `gh: Bad credentials (HTTP 401)` → `WARN: … failed (definitive, rc=1); not retrying` → `FETCH INCOMPLETE` → `FATAL: comment source failed` → unit exit 1 → self-heal `claude -p` spawn.

Change: in `scripts/jobs/common.sh`, add a narrow `HTTP 401|Bad credentials` alternative to `GARDEN_TRANSIENT_GH_API_SIGNATURES` (the gh-api set ONLY — never `GARDEN_OFFLINE_SIGNATURES`, which classifies git's curl/SSH transport), and extend the block comment above it with this third precedent alongside the `i/o timeout` and HTML-decoder cases.

Why this is safe, and the one caveat to state in the comment: a genuinely revoked/expired token still fails every attempt and the call still fails LOUD (nonzero, empty stdout) after `GARDEN_GH_API_ATTEMPTS`, so "never guess a state" is preserved — exactly the argument the HTML-page precedent already makes. The difference worth noting is that unlike a 5xx, a real bad-credential state persists forever, so a genuinely broken host pays the bounded full-jitter backoff on every tick; that cost (milliseconds-to-seconds) is far below the current cost of failing the unit and spawning an LLM self-heal responder per tick, and the failure remains just as visible.

Evidence to cite in the commit body: on `endolin-garden2-5bcdff64`, `garden-comment-watcher@kriscendobot-test262` ticked ~26 times between 07:22 and 08:01 on 2026-08-14 with exactly 2 401s (07:42, 08:00); `gh auth status` reported the `hosts.yml` token invalid at 07:59 and valid at 08:01 with no change to the file (mtime 2026-07-02), and a fleet-PATH read succeeded at 08:01.

Tests: add a case to `scripts/jobs/test/gh-api-retry-test.sh` mirroring the existing HTML-page pair — (a) 401 on the first attempt then success → one retry, clean stdout, rc 0; (b) 401 on EVERY attempt → exactly `GARDEN_GH_API_ATTEMPTS` calls, nonzero rc, EMPTY stdout (so a truly dead credential still fails loud and the caller's `|| die` fires).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-14T08:02:49Z
