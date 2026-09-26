Pushed to main2.

## Completion report

**What the job asked:** Add `unexpected end of JSON input` to the curated `GARDEN_TRANSIENT_GH_API_SIGNATURES` set so a truncated/dropped GitHub response body is classified transient (retried + WARN-skip) instead of crashing the garden-ci-watcher unit.

**What I changed** (`scripts/jobs/common.sh`, `scripts/jobs/test/gh-api-retry-test.sh` — committed `cd75de28f9`, pushed to `main2`):

1. **Signature set (`common.sh:3163`)** — inserted `unexpected end of JSON input` between the existing HTML-decoder (`invalid character .<.…`) and http2 (`stream error:…`) signatures. This one line repairs every consumer of the shared classifier: `gh_api_retry`, `handlers/ci-pr-source-gh.sh`, dependabot-watcher, approval-reconciler, dependabotany-preflight, and mirror-closer.

2. **Documentation** — added a comment block mirroring the existing EOF/HTML/http2 rationale ("same class a fourth time"), naming the observed garden-ci-watcher crash and noting it's likelier under `--paginate`, and reaffirming "never guess a state" (still fails loud past `GARDEN_GH_API_ATTEMPTS`).

3. **Test (`gh-api-retry-test.sh` SUBTEST 1)** — added `assert_transient "unexpected end of JSON input" "truncated/empty response body"` with a regression comment.

**Verification:**
- Confirmed the new case would classify **DEFINITIVE before** the change (reproduced against the pre-change signature string) and classifies **transient after**.
- `gh-api-retry-test.sh`: **47 passed, 0 failed** — including the unchanged `assert_definitive` 404 / malformed-slug cases, confirming the set was not widened beyond this class.
- `ci-watcher-test.sh`: **49 passed, 0 failed** — source-failure paths still die loud on structural errors.
- `bash -n` clean.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-ci-watcher-kriscendobot-minion-town-unexpected-end-of-json-input.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (664002 cached reads)
- Output: 4667 tokens
- Cost: $0.8410299999999999
- Wall-clock: 81s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
