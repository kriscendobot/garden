Implemented and pushed `c30390e907f` to `main2`.

- Added declarative `deployed_predecessor` and optional `deployed_predecessor_sha` metadata to orchestrated plan children.
- Serial orchestration now keeps gated children parked until `fleet/deployed/<leader>` reports the required SHA.
- Missing leader/deployment/SHA metadata fails closed and retries without consuming an agent claim.
- Documented the new orchestration contract.
- `bash -n` passed; orchestration regression tests passed through serial and blocked-child coverage before the bounded suite timeout.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-deployed-child-gate.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 249s

<!-- garden-usage-end -->
