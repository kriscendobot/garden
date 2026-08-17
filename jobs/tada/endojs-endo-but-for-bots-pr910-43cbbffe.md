---
handed-off: endojs-endo-but-for-bots-pr910-pinbase-20260817
deliverable-complete: false
---
Done. Summary of the work and handoff.

## Completion report

**Directive:** endojs/endo-but-for-bots#910 comment `5320970648` (kriskowal): "Please fix."

**Preflight:** `pr-feedback-preflight.sh` returned exit 2 (HINT). Corroborated rather than closing as no-op — the only correlated prior work (the `pr910-review-4941452327-resolution` orchestration) is **halted**, not resolving.

**Diagnosis.** The PR is approved and every check is green **except** `test (24.x, ubuntu-latest)`, which fails with a non-deterministic `@endo/genie#test` exit-leak (`Exiting due to SIGINT`, all assertions pass, a *different* test file on each run). This is **not attributable to the PR diff** (ReadableBlob range attenuation in platform/daemon/git — genie is untouched):
- node-22-ubuntu and node-24-**macos** are green; only node-24-**ubuntu** fails — node+OS selectivity, the signature of a runtime exit-leak, not diff logic.
- I re-ran the failed job **3×**; it reproduced the genie SIGINT exit-leak every time (petname-autocomplete → CLI/CapTP → Chat/js — different each run).
- Root cause is **CI node-version drift**: PR 910's frozen base `llm-a3064e1` floats `node-version: [22.x, 24.x]`, which now resolves past 24.18 into a Node-24 patch carrying the leak. The `llm` tip already fixed this with `a59021f8ae fix(ci): pin Node 24 matrix to 24.18.0` — verified **not** an ancestor of the frozen base; the `llm` tip's full suite (genie included) is green on `test (24.18.0, ubuntu-latest)`.

**Action taken.**
- Retried the failed CI job 3× (deterministic flake-clearing) — persistently red; retry alone cannot fix it because the base predates the node pin.
- Posted a weaver successor job **`endojs-endo-but-for-bots-pr910-pinbase-20260817`** (now in `journal/jobs/todo/`) to pin the merge base onto a fresh `llm-<sha>` that includes `a59021f8ae`, rebase the six head commits, resolve conflicts, and confirm CI goes green on `24.18.0`. It owns all remaining work.
- Messaged the maintainer with the root cause and offered the alternatives (retry-only, or merge despite the environmental node-24 flake).

**No PR diff was touched** (correct — the fix belongs to the base pin on `llm`, not to this feature's diff).

**Follow-ups:** the weaver pinbase job drives the fix; a broader item worth noting is that other open PRs on pre-`a59021f8ae` frozen bases will hit the same node-24 drift until re-pinned.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr910-43cbbffe.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (2410585 cached reads)
- Output: 24896 tokens
- Cost: $2.5802084999999995
- Wall-clock: 1702s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
