The deployed root is clean of my edits, inbox is empty, and the change is on `origin/main2`. Job complete.

## Completion report

**What I did**

Added a **PR-comment auto-clear** standing behavior to the proxy, per the maintainer directive (kriskowal, 2026-07-11), landed directly on `main2` (commit `2824963665`).

**What changed** (3 files, +212 lines)

- **`scripts/jobs/proxy.sh`** — new deterministic pre-pass `clear_pr_comment_messages()` (plain code, **no `claude -p`**) plus a `pr_comment_ref()` detector, wired in at the invocation site **after** `clear_watchdog_messages` / `park_blocked_jobs` and **before** the gating enumeration. It archives every unread **non-gating** maintainer message that references a PR (unread→read, one atomic `proxy: auto-clear N PR-comment message(s)` commit, one deduplicated tally line, never re-posts). Detection is case-insensitive: PR URL, `PR #n`/`PR#n`/`PR n`/`pull-request-n`/`pull request`, and PR-scoped `from:`/`reply_to:` job bases (`…-pr<n>-…`, `…-pull-request-<n>-…`, covering `shepherd-*`/`gauntlet-*`). A bare `#<n>` is deliberately **not** a signal. Guardrails: live gating questions preserved (same live-doer test), `blocked_on:` left to `park_blocked_jobs`, non-PR senders untouched.
- **`roles/proxy/AGENT.md`** — new § **PR-comment auto-clear** (sibling to § Watchdog auto-clear) citing the directive, criterion, guardrails, and the auditable tally.
- **`scripts/jobs/test/run-test.sh`** — new **SUBTEST 15b** covering (a) PR-URL + `PR #n` + `shepherd-*-pr<n>-*` archived, (b) a live PR gating question preserved, (c) self-heal/finbot-progress/`garden#33`/README `#2` preserved, (d) dedup tally logged and nothing re-posted.

**Verification**

- Detector unit test: **14/14** cases pass (all PR forms detected; bare `#n`, garden issues, self-heal, finbot, triager preserved).
- Full **`proxy.sh` end-to-end** hermetic test against a throwaway journal: **7/7** pass, including second-tick idempotency. Tally observed: `cleared 3 PR-comment messages: kriskowal/garden#42×1, pr5×1, pr58×1`.

**Follow-ups / notes**

- The shared-state `run-test.sh` suite is **pre-existing-red in this environment** at SUBTEST 6 (`maintainer-reply … has no reply_to`, `head -1` picks a stray earlier maintainer message) — the committed baseline (before my change) fails identically (44 PASS / 0 FAIL then FATAL, exit 1). It halts the run before my SUBTEST 15b, so I validated the feature hermetically instead. Worth a separate test-robustness fix (SUBTEST 6 line ~381 should select the `reply_to: maint-demo` message, not `head -1`); out of scope here.
- One fixture note carried into the test: `message-user.sh` runs `check-issue-refs.sh`, which rejects bare `#77`, so the live-gating fixture uses a full PR URL (a valid ref and a strong PR signal).
- Correctness incident during this run: my first Edit pass mistakenly targeted the **deployed garden root** instead of the worktree; I transferred the changes into the worktree via patch and **restored the root to clean** (verified), so the deployment was left undirtied and the commit came only from the job worktree.
