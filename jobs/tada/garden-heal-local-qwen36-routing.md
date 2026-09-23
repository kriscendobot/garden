All confirmed. The work described by this job was **already fully landed** on `main2` by commit `77f84c97a8` (an ancestor of current `origin/main2` HEAD `8c5971b8bb`). Nothing remains for me to commit or push. Report follows.

---

## Completion report — heal the local-inference model pin (`qwen3:0.6b` → `qwen3.6`)

**Status: already resolved on `main2`; verified complete. No new commit needed.**

### Finding
The fix this job requests was already landed by commit **`77f84c97a8`** *"fix(routing): heal the local model pin — qwen3:0.6b is a phantom"*, which is an ancestor of current `origin/main2` HEAD **`8c5971b8bb`**. That commit replaced `qwen3:0.6b → qwen3.6` across all 16 files (the routing/tier TSVs, `common.sh` probe fallback + inline built-in table, the cleric/foreman/mentor handler defaults, `reputation.sh`, the fake-curl/serve test payloads, and the design/context prose) — the full known-occurrences list in this job plus the additional hits it flagged as "not a closed set." I independently re-grepped the tree: **zero `qwen3:0.6b` occurrences remain** anywhere outside `.git/`.

### Verification performed (read-only, this worktree off `origin/main2`)
- **Shell syntax**: clean on every edited script (`common.sh`, `reputation.sh`, the four handlers).
- **`model-routing-test.sh`: 32 passed, 0 failed** — including `built-in fallback default = qwen3.6` and the `model_routing_default local` assertion.
- Related suites: `tier-vocabulary-routing-test` PASS, `worker-spine-kinds-test` 147/0, `hermit-ollama-self-heal-test` 28/0.
- **Read-only probe against the fixed tree** (`GARDEN_ROOT=$PWD`): `model_routing_default local → qwen3.6` and `tier_model_for_provider myrmidon local → qwen3.6`. ✅
- Local row correctly kept in **`myrmidon`** (closed inventory; unlisted → undispatchable).

### One nuance worth flagging (not a defect)
Probing with the default `GARDEN_ROOT=/home/kris/garden2` (the **deployed** root) still returns `qwen3:0.6b`. I traced this: it is **not** a lingering journal override — `journal/config/model-routing` does not exist, so resolution falls through to the tracked TSV, and the *deployed* root's `model-routing-defaults.tsv:38` still reads `qwen3:0.6b` because the deploy hasn't advanced it yet. This is exactly the predicted pre-deploy state: **both hosts converge on this fix only at their next deliberate deploy** (`scripts/jobs/deploy-garden.sh`, drained, signal-triggered by `garden-upgrade-monitor` and supervised by the liaison's deploy-on-upgrade Monitor). No journal action is needed.

### Tag establishment
The written string is the bare tag **`qwen3.6`**, derived from the on-disk manifest path `library/qwen3.6/latest`. I could **not** confirm the live `ollama list` output verbatim: the garden daemon at `127.0.0.1:11435` is not running on this host, and the job forbids starting it or pulling. This is safe because the probe's unqualified-name path (`codex_local_model_present` accepts `.id == model` **or** `model+":latest"`), so `qwen3.6` resolves whether `ollama list` reports `qwen3.6` or `qwen3.6:latest`. **Remaining unestablished:** the exact live `ollama list` string on a running daemon — to be confirmed during host-local provisioning, which is out of scope here.

### Unrelated observation
`auction-reputation-test.sh` shows 2 failures ("gardener arm wrong", "reducer churned a wallclock-estimated event set") — timing/wallclock-sensitive, in a file the heal commit never touched. Pre-existing and independent of this fix; noting only so it isn't mistaken for regression.

### Deploy / activation
No new revision to land — the fix is already at `main2` (`77f84c97a8`). Activation on each host is its next `deploy-garden.sh` run; no manual journal or systemd step is required by this job.

**No `qwen3:0.6b` occurrence remains in the tracked tree.**
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-heal-local-qwen36-routing.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 68 tokens (1906831 cached reads)
- Output: 23459 tokens
- Cost: $2.4876644999999993
- Wall-clock: 529s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
