Diagnosed Ubuntu 26.04/Graphviz 14 packaging changes: `tred` moved to `graphviz-tools`, while `acyclic` is unavailable.

Pushed commit `d8b86e158d` to `build/hardened-text-codecs-shim`, installing `graphviz-tools` when needed and replacing `acyclic` cycle detection with coreutils `tsort`.

Verified formatting, shell syntax, and GitHub CI. PR #1349 is mergeable/CLEAN with all 14 checks passing, including the mutual-dependency build.

Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-shepherd-20261029.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 682s

<!-- garden-usage-end -->
