Implemented and landed commit `cd407da0baa` on `main2`.

- Result entries now carry the claimed job and claim fingerprint.
- Failed handlers reconcile matching durable results and complete idempotently.
- Foreign-claim and nested-job results cannot trigger reconciliation.
- Added regression coverage and worker documentation.
- Verification: targeted matching/foreign/nested claim scenarios passed; relevant shell files passed `bash -n`.
- Full completion suite encountered an unrelated fixture budget high-water gate.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-durable-result-reconcile.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (2 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (2 engagement(s) unpriced)
- Wall-clock: 2884s

<!-- garden-usage-end -->
