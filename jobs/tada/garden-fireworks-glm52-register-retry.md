Implemented and pushed `aead286daf` to `main2`.

- Registered `fireworks/accounts/fireworks/models/glm-5p2` as closed-inventory `mentor`.
- Added provider-constrained tier canaries: `post-job.sh --provider-canary fireworks mentor …`; concrete `model:` is rejected.
- Enforced provider constraints fail-closed; updated resolver, docs, catalog, and regression coverage.
- Verified shell syntax; model-routing test (32/32); tier-routing test; secret-safe Fireworks probe returned HTTP 200.
- `worker-spine-kinds-test.sh` still has pre-existing unrelated expectation failures; Fireworks provider-constrained cases passed.

Deploy/activate on leader:

```sh
scripts/jobs/deploy-garden.sh
scripts/jobs/set-fireworkers.sh 1
scripts/jobs/post-job.sh --provider-canary fireworks mentor fireworks-glm52-canary canary.md
# inspect jobs/tada, then:
scripts/jobs/set-fireworkers.sh 0
```
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-fireworks-glm52-register-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (2 engagement(s) unpriced)
- Wall-clock: 511s
- Model(s): kimi-k3 ×1

<!-- garden-usage-end -->
