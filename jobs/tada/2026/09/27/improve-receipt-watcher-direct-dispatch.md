The inbox drain hit a transient clone timeout (no messages retrievable, not a real message). The work is complete and pushed. Here's my report.

---

## Completion report: `improve-receipt-watcher-direct-dispatch`

**Problem.** `receipt-watcher.sh` posted each completion-receipt as an LLM-dispatched job (`tier: mentor`, `fallback-tier: minion`) whose body merely instructed an agent to run `pr-receipt.sh` — a script that is explicitly deterministic, plain-code, "NO `claude -p`". That round-trip was pure waste and self-defeating: `kriscendobot-oros-ckm-data-readiness-pr1-receipt` burned a kimi-k3 attempt then an opus fallback, both exiting rc=1 in a constant ~3s with no output, tripped the gardener elapsed-constancy overrun-suspect detector, and was doomed `requeue-exhausted`.

**What I changed.**
- **`scripts/jobs/receipt-watcher.sh`** — the per-PR receipt step now invokes `pr-receipt.sh` **directly in-process** on the common path (`pr-receipt.sh <repo> <num> --dir <clone>`), reusing the freshly-synced journal clone the watcher already holds. No LLM dispatch. This mirrors how ci/comment/dependabot watchers call their deterministic generators straight.
  - The direct call is wrapped in a bounded `timeout` (`GARDEN_RECEIPT_GENERATE_TIMEOUT_SECS`, default 300s) so a hung `gh` call can't wedge the tick.
  - Failures are classified via the existing `shared_availability_failure`: a **transient** failure (rc=124/137/network) cools down and retries next tick, posting nothing wasteful; a **structural** failure (a genuine `pr-receipt.sh` bug) falls back to the job-board post so the doom machinery surfaces the persistent failure to the maintainer inbox rather than the watcher retrying silently forever.
  - Added a `GARDEN_RECEIPT_GENERATE` indirection (default `pr-receipt.sh`) for test stubbing, alongside the existing `GARDEN_RECEIPT_POST` (now the fallback path only). Header comments, pipeline doc, and the final summary log line updated to match.
- **`scripts/jobs/test/receipt-watcher-test.sh`** — added a garden-worked PR fixture and three tests: (1) in-process success (generator called directly, no LLM, no fallback post), (2) structural failure (falls back to a post, diagnostic preserved), (3) transient failure (cools down, posts no fallback).

**Verification.** `bash -n` clean on both files; shellcheck shows only 2 pre-existing info-level notes (not on new lines). Test suite: **15 passed, 1 failed** — the single failure (`fresh-clone outage lost its warning/cooldown`) is **pre-existing**, confirmed by stashing my changes and running the baseline (12 passed, 1 failed, same failure). It lives in the journal-prerequisite path, unrelated to this change.

**Committed & pushed** to `main2` as `cf5fe8e849` (rebased cleanly onto the concurrently-advanced origin/main2 after a wedged first attempt that I aborted with no damage).

**Notes / follow-ups.**
- The pre-existing `fresh-clone outage` test failure is likely environment-specific (this host, user `dom`, is not the canonical `/home/kris` bot host) and out of scope here, but worth a look if it also fails on a real bot host.
- To run this test on a non-canonical host, note it hardcodes `mktemp -d /home/kris/...`; I created/removed that dir via sudo only for local verification and restored the host to its prior state.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-receipt-watcher-direct-dispatch.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 3 host(s) (2 unmetered)
- Input: 78 tokens (3575743 cached reads)
- Output: 31450 tokens
- Cost: $3.6316515000000003 (2 engagement(s) unpriced)
- Wall-clock: 558s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
