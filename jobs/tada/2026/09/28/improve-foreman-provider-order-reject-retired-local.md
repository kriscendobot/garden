The foreman now refuses the retired `local` provider as soon as it reads its provider order, and I've messaged the maintainer about this host's stale setting. The fix is pushed to `main2` as f3e5ea54007. The foreman test suite passes (28 passed, 0 failed).

**What changed**
- **`scripts/jobs/handlers/foreman-claude.sh`:** `provider_order()` now rejects `local`, following the same pattern as the existing Moonshot rejection. The error names the 2026-09-13 retirement and the job `retire-local-qwen-hermit-lane`, and says to remove `local` from the `garden-foreman` drop-in. The allowed providers are now `openai` and `anthropic`. The header comment is updated to match.
- **`scripts/jobs/test/foreman-provider-order-test.sh`:** the fallback subtests now use `openai,anthropic`. The old local-inference subtests are replaced by one that tries `openai,local`, `local,anthropic` and `openai,local,anthropic`. For each, it checks that the handler fails, that the error names the retirement, and that no provider is tried first.
- **`scripts/systemd/garden-foreman.service`** (commented example) and **`context/operations/foreman-providers.md`:** the temporary order is now `openai,anthropic`, with a note that the foreman rejects `local` and how to fix a stale drop-in.

**Stale setting on this host**
I sent the maintainer inbox a message about `GARDEN_FOREMAN_PROVIDER_ORDER=openai,local` in `garden-foreman.service` on `endolin-garden-ece02cb4`. It asks them to change it to `openai,anthropic` or delete the line, then reload systemd and restart the foreman timer. Until that's done, the foreman on this host will fail on every tick with the new message once this commit is deployed. It already produces nothing, so no throughput is lost, but it now fails with a clear error.

**Follow-ups (not done, outside this job's scope)**
- The mentor still defaults to `openai,local,anthropic` (`mentor-claude.sh:28`), so it probably wastes a probe on the same dead endpoint each run. Rejecting `local` there too, and changing that default, would be the matching fix.
- In `foreman.sh:287`, a `local` entry still turns on the provider-fallback path. It does no harm now because the handler fails right after, but the `local` case there could be removed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-foreman-provider-order-reject-retired-local.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (564445 cached reads)
- Output: 6319 tokens
- Cost: $0.7162050000000001
- Wall-clock: 74s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
