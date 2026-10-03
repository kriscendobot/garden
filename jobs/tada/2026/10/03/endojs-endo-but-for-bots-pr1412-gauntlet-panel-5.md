**Gauntlet panel round 5 — endojs/endo-but-for-bots PR #1412: must-fix**

I ran one single-round panel on PR head `b1dd5c8a71` against the pinned base `80054c34533c` (`llm-80054c3`). All 33 seats returned `ok`, and `panel.sh` ended with `code-panel single-round — must-fix`. I ran it detached so it would survive a reap, which means I didn't capture its exit code directly. The verdict line printed normally, so I'm treating this as a real verdict, not an infrastructure error. The run is recorded at `journal/panel-runs/endojs-endo-but-for-bots-1412/4bba9971221f.md`.

**Posted reviews** (same two-part shape as rounds 2–4):
- **Part 2/2** (approve and comment-only seats): review `5399491121`.
- **Part 1, the must-fix disposition**: review `5399491277`, posted last so it is the latest. GitHub refused request-changes because the bot owns the PR, so it went up as COMMENTED, as in earlier rounds.

**Request-changes seats:** assessor, stylist, archivist, saboteur, breaker, purist, engine-realist, integrator, benchmarker. The main must-fix findings:
- **Credential grant can leak:** both backends build the limit enforcer (and, in the SDK backend, an abort controller) after acquiring the credential grant but outside the `try/finally` that releases it.
- **Credential text can reach the usage record:** error messages from `query()`, `buildMcpServer`, scratch setup and spawn errors go into the `unavailable` detail without redaction. A NUL byte in a credential can get through to the spawn-error path.
- **Abbreviated name:** `lang` in `constructed-environment.js` and its type should be spelled out as `language`.
- **Unbenchmarked claim:** commit `cd60db6671` says the line decoder now runs in linear time, but no benchmark or decision to skip one was ever posted.
- **Must stay in draft:** the integrator says this PR must not be un-drafted while #1403 (phase 1) is still an open draft. The gauntlet un-drafts automatically after the fix-loop, so whoever runs the next stages needs to know this.

I didn't fix anything, un-draft, or loop, as the stage requires.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1412-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (760813 cached reads)
- Output: 4311 tokens
- Cost: $0.7087586
- Wall-clock: 668s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
