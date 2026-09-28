I applied the same fix the foreman got in f3e5ea54007 to the mentor. It is pushed to `main2` as 2c3c6bc4a6e, and `mentor-provider-order-test.sh` passes (49/49).

**What changed**
- **`scripts/jobs/handlers/mentor-claude.sh`:**
  - The default `GARDEN_MENTOR_PROVIDER_ORDER` is now `openai,anthropic` instead of `openai,local,anthropic`, so the mentor no longer tries the retired Ollama/hermit lane on every run.
  - `provider_order()` now accepts only `openai` and `anthropic`. A `local` entry makes the handler fail at startup with an error saying the lane was retired on 2026-09-13 (job `retire-local-qwen-hermit-lane`) and telling you to remove it from the garden-mentor drop-in. Other unknown names still get the "invalid provider" error, which now lists only `openai` and `anthropic`.
- **`scripts/jobs/test/mentor-provider-order-test.sh`:** a mentor test file already existed, so I updated it rather than adding one.
  - Subtests 2 and 3 no longer use `local`.
  - New subtest 2b checks that the orders `openai,local`, `local,anthropic` and `openai,local,anthropic` are each rejected before any provider is tried, and that the error mentions the retirement.
- **`scripts/systemd/garden-mentor.service`:** the commented example order is now `openai,anthropic`, with a note that `local` is rejected.
- **`context/operations/foreman-providers.md`:** the page now says both the foreman and the mentor reject `local`, and the mentor's normal order is `openai,anthropic`.

**Checks:** `foreman-provider-order-test.sh` still passes (28/28), `mentor-transient-backoff-test.sh` passes, and `bash -n` on the handler is clean.

**Follow-up:** `mentor_codex_attempt` still has code for the `local` provider (it maps it to hermit with model qwen3.6). Nothing can reach that code any more, and I left it alone to match what the foreman fix did. It can be removed whenever the hermit lane is torn out for good. This host's rendered `garden-mentor.service` only mentions `local` in a comment, which is harmless. Any real drop-in on another host that still sets `local` will now fail loudly instead of quietly wasting a probe.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-mentor-provider-order-reject-retired-local.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (504814 cached reads)
- Output: 5313 tokens
- Cost: $0.6935028000000001
- Wall-clock: 105s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
