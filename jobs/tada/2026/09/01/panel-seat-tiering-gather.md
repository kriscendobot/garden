Completed the panel seat evidence gather.

- Landed `reports/panel-seat-tiering/evidence.md` on `journal2` at commit `806db45a7ab58c5ed9dbe0d88119d02986a387fa`.
- Analyzed the exact 54-run/172-file snapshot from the job’s promotion commit, including all 35 specified seats, inclusive finding parsing, confirmed misses, cost limitations, error causes, deterministic-gate coverage, confidence grades, and unanswerable questions.
- Found 31/54 verdictless terminations, only 24 confirmed review misses, no design-panel executions at the cutoff, and no available seat-level cost/model attribution.
- The eight-seat lowering hypothesis did not fully hold: typist had two attributed misses, and several candidates lacked comprehensive deterministic coverage.
- Verified the pushed evidence blob exactly matches the local report. No `main2` changes were required.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/panel-seat-tiering-gather.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 453s
- Model(s): claude-opus-4-8 ×5

<!-- garden-usage-end -->
