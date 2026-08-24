Done. Committed `fbeb79c48d` and pushed to `main2`.

## What I did

`scripts/jobs/mentor.sh` fed a fresh `WARN` to the journal on **every** tick during a sustained transient provider outage (a claude quota cut, an Anthropic overload/5xx, an api.github.com blip). Because the transient branches deliberately leave `$SEEN`/`$JSINCE` unadvanced so the next tick retries, the same inputs were reprocessed and one root cause screamed once per tick — violating silent-until-error and burying the eventual real signal.

**Changes:**
- Added `$OUTAGE_STATE` (`mentor/transient-outage`) persisting the outage episode as a consecutive-transient-tick counter, plus a `GARDEN_MENTOR_OUTAGE_BACKOFF_CAP` knob (default 32, validated like the reject threshold).
- `note_transient_outage` records each transient tick and emits a WARN only on a **bounded exponential backoff** (ticks 1, 2, 4, 8, … until the gap hits the cap, then every cap ticks). The counter increments on *any* consecutive transient tick rather than a matching digest SHA — a long outage's digest drifts (the WARN itself feeds back into the next `journalctl` read), and the episode being throttled is "the provider is down", not one exact blob.
- `note_transient_recovery` emits **one** recovery notice when the outage clears, then removes the state; it's a no-op when no episode is open.
- Wired into all three outcome branches: recovery on handler success and on reaching a real (non-transient) verdict; backoff on the empty-capture and signature/offline transient branches.
- **Retry behavior is unchanged** — markers stay unadvanced on a transient, so the next tick still retries. Only the duplicate noise is suppressed.

**Test:** new `scripts/jobs/test/mentor-transient-backoff-test.sh` asserts the handler runs on all 10 ticks with markers never advanced, exactly 4 backed-off warnings over 10 ticks (cap=8 → 1,2,4,8), exactly one recovery notice with markers then advanced and state cleared, and no false recovery when no outage was open. Both the new test and the existing `mentor-rejection-backstop-test.sh` pass; `bash -n` and `shellcheck -S warning` are clean (the sole shellcheck note, `GARDEN_TAG` SC2034, is pre-existing).

**Follow-ups:** none required. Like the existing mentor test, the new one isn't wired into `checks.yml` CI (which shellchecks a fixed subset and runs the grep-gate suite); it's runnable standalone and covered by the repo-wide `bash -n` sweep.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-mentor-transient-outage-backoff.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 53 tokens (1701370 cached reads)
- Output: 19049 tokens
- Cost: $1.9253289999999998
- Wall-clock: 285s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
