Implemented tier-native dispatch and pushed `aed30a4419` to `main2`.

- Automatic jobs now emit `tier: mentor` and `fallback-tier: minion`; manual jobs emit `tier: mentat` with `dispatch: manual`.
- Claiming resolves tiers to available provider/models and records selected tier/provider/model in claim metadata.
- Retained bounded legacy model migration; unknown tiers/models fail closed.
- Updated handlers, auction reputation resolution, migration, documentation, and routing tests.

Verified: `tier-vocabulary-routing-test.sh` and `model-routing-test.sh` pass.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-tier-native-routing.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 278s

<!-- garden-usage-end -->
