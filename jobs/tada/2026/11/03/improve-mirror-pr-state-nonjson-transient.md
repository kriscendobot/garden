`mirror-pr-state-gh.sh` no longer dies FATAL on a non-JSON `gh` body, and `garden-mirror-closer` no longer goes to `failed` when that is the only failure in a tick. It's pushed to `main2` as `9f6cb390ae0` and takes effect on the next deploy.

**What changed**
- **Retry classifier (`scripts/jobs/common.sh`):** the transient signature only matched `'<'`. It now matches `invalid character <any> looking for beginning of value`, so these failures get the jittered retries. The different decoder error `invalid character 'x' after top-level value` stays definitive.
- **New helper (`gh_api_exhausted_on_nonjson_body`):** it looks only at the final give-up line onward. A non-JSON blip on an early attempt therefore can't hide a later 404 or 401.
- **State handler (`handlers/mirror-pr-state-gh.sh`):** once retries run out on a non-JSON body, it exits `GARDEN_TRANSIENT_RC` (75) with empty stdout and no FATAL. No state is guessed, and other failures, including exhausted 5xx and 401, still die loud.
- **Closer (`mirror-closer.sh`):** rc 75 is now its own transient class.
  - The first cause is relayed to the log, and the tick reports one aggregate WARN.
  - The second transient failure stops further queries, because each one costs a full retry ladder.
  - Mappings stay unresolved, and the next tick retries them all.
  - A transient-only tick exits 0; a real failure in the same tick still exits 1.

**Tests**
- **Added:**
  - classifier and helper cases in `gh-api-retry-test.sh`
  - K2 in `mirror-closer-test.sh`: the real handler under the real closer with the `'b'` error, covering exit 0, no FATAL, the breaker and the next-tick retry
  - K3 in the same file: a transient plus a real failure stays unhealthy
- **Updated:** case K, which used to expect a loud die on persistent HTML.
- **Results:**
  - `mirror-closer-test.sh --no-e2e`: 100 passed. The end-to-end part against real `gh` was not run.
  - `gh-api-retry-test.sh`: 75 passed.
  - `api-cooldown-test.sh`: 32 passed.
  - `pages-watcher-test.sh`: 38 passed.
- **Not finished:** `tests/checks/run.sh` hit my 280-second limit (rc 124). No failures appeared in the part that ran, but the full suite did not complete.

**Other effects**
- The wider signature also feeds `is_transient_gh_source_error` and every other `gh_api_retry` caller, so they now retry or skip the tick on any non-JSON body.
- `unblock.sh` also uses this handler. It treats any nonzero exit as "leave parked", so it behaves the same, and it now logs no FATAL line for this case.
- If something like a misconfigured proxy returned non-JSON permanently, the unit would stay healthy with only a WARN each tick. Mirrors would quietly stop closing until someone reads the log. That follows from the requested quiet degrade, and I did not add an alert for it.

**Possible follow-up:** exhausted 5xx and truncated-body (`unexpected end of JSON input`) failures still go down the loud path, since the job named only this signature. They could use the same degrade if they turn out to be noisy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-mirror-pr-state-nonjson-transient.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (608508 cached reads)
- Output: 18452 tokens
- Cost: $1.2973336000000002
- Wall-clock: 613s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
