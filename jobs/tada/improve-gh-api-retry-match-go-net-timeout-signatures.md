No work to commit — the job's intent is already in `origin/main2`. Here is my report.

---

**Completion report: `improve-gh-api-retry-match-go-net-timeout-signatures`**

**Outcome: no-op — already landed, via a more careful approach than the spec requested. Verified, nothing to commit.**

The exact fix this job targets shipped 5 minutes before I claimed it, in HEAD commit `0139625cc` ("jobs/common.sh: classify Go net/http transient timeouts in gh-api retry set"). The endojs/endo#3137 crash (`dial tcp 140.82.116.5:443: i/o timeout` misclassified DEFINITIVE → garden-mirror-closer exit 1 → systemd Failed) is resolved.

**What's in place** (`scripts/jobs/common.sh:791`): the Go net/http transient phrasings — `i/o timeout`, `dial tcp`, `context deadline exceeded`, `net/http: TLS handshake timeout`, `no such host`, `server misbehaving`, word-bounded `\bEOF\b` — are in `GARDEN_TRANSIENT_GH_API_SIGNATURES`, the gh-api classifier set consumed by `_gh_api_stderr_is_transient` / `gh_api_retry`. The captured #3137 stderr now matches as transient, so the blip rides out the bounded full-jitter retry instead of killing the unit.

**Deliberate divergence from the job spec — and why I did not "correct" it:** the spec asks to add these strings to the *shared* `GARDEN_OFFLINE_SIGNATURES` (line 732), reasoning they "belong in the same retry class as the existing curl/git phrasings." The landed fix instead scopes them to the gh-api-only set and explicitly documents (common.sh:788–790) that they must **not** go into `GARDEN_OFFLINE_SIGNATURES`, because that set classifies git's curl/SSH transport for clone/fetch and would spuriously absorb a Go-only string like a bare `EOF` as a git outage. The landed approach is strictly safer: it heals the gh-api path (the actual failure site) without weakening git transport classification. Implementing the spec literally would have been a regression against a considered decision made minutes earlier, so I declined to do so.

**Verification:** ran `scripts/jobs/test/gh-api-retry-test.sh` — 25/25 pass, including the explicit assertion of the exact `Get "https://api.github.com/repos/endojs/endo/pulls/3137": dial tcp 140.82.116.5:443: i/o timeout` signature as transient (line 56), plus a guard that `\bEOF\b` does not match mid-word (`GEOFFREY` stays definitive). This is exactly the unit check the job requested.

**Follow-ups:** none. Inbox drained (empty). The worktree has no changes to push.
