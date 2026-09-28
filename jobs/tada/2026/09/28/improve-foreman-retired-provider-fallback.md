The foreman no longer shuts down when its provider list still names the retired `local` provider. It drops `local`, logs one warning, and carries on with the providers that are left. It only fails if nothing but `local` is configured. This is pushed to `main2` as `e036bb8e065`. The foreman provider-order test passes, 35 checks with 0 failures.

**What changed**
- **`scripts/jobs/handlers/foreman-claude.sh`**: `provider_order()` used to stop the whole run the moment it saw `local`, which is why the foreman was down at 18:09, 18:14 and 18:19. It now:
  - skips `local` and keeps going with the other providers;
  - logs a WARN naming the 2026-09-13 retirement (job `retire-local-qwen-hermit-lane`). It logs this only once per distinct setting, using a small marker file at `$GARDEN_STATE/foreman/retired-local-warned`, so it doesn't repeat every 5-minute tick. The marker is removed once the setting no longer includes `local`.
  - still fails for a setting of just `local`, with a message saying so.

  I also stopped the main loop from sending `local` to the Codex call.
- **`scripts/jobs/test/foreman-provider-order-test.sh`**: the old check that expected `local` to be rejected now covers the new behaviour instead:
  - `openai,local`, `local,anthropic` and `openai,local,anthropic` all run with the first remaining provider.
  - The warning appears on the first run and not the second.
  - A clean setting removes the marker file.
  - A setting of just `local` fails without trying any provider.
- **Docs**: `context/operations/foreman-providers.md` and the comment in `scripts/systemd/garden-foreman.service` now describe the new behaviour.

**Follow-ups**
- The host whose foreman was failing still has the old setting in its `garden-foreman` override file. The foreman will run again once this change is deployed, but the file should still be changed to `openai,anthropic` or removed, or it will warn again after each restart.
- The mentor (`mentor-claude.sh`) still stops outright on `local`. The docs now note that difference. If you want it to behave the same way as the foreman, that's a small separate change.
- `foreman_codex_attempt` still contains unused handling for `local`. It does no harm and I left it in place.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-foreman-retired-provider-fallback.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (449339 cached reads)
- Output: 6509 tokens
- Cost: $0.6806158000000001
- Wall-clock: 64s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
