## build-cbors: no new PR. The design is already built in #288

I didn't open a new PR because the work already exists. The job asked for the `cbors` design. That design was renamed to `designs/cbor-frame.md` in the 2026-07-20 grooming pass, and its own Status line says it is implemented in endo-but-for-bots #288, "feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing".

**What #288 looks like now:**
- It is open against `llm` and is not a draft. Its head branch is `feat/cbors-package`.
- It contains the full package (`packages/cbor-frame/`) with its tests, plus the ocapn TCP CBOR netlayer wiring.
- `designs/README.md` lists cbor-frame as "In Progress (PR #288 open)".
- The head was last updated on 2026-08-15. Since then `llm` has moved a long way.
- 26 checks pass and 1 fails: `test (24.x, ubuntu-latest)` in run 31871033358, from that August run. The log shows socket "write after end" and ECONNRESET errors. I didn't work out whether that's a flaky test or a real failure.
- `ensure-pr.sh --find-only` found no PR carrying this job's marker, so no earlier attempt at this job opened anything.

Writing the package again would have produced a competing duplicate PR, so I opened none and made no commits to the garden or the project.

**Follow-up posted:** `shepherd-endo-but-for-bots-288-20261019`, a shepherd job at mentor tier. It will rebase #288 onto the current `llm` tip, resolve conflicts with `yarn.lock` in its own commit, re-run CI, and fix any real failures.

**Notes:**
- The board line "cbors, Not Started" is out of date. The design was renamed to cbor-frame and is In Progress through #288. Whoever posts M4 builds should update that entry.
- A related open PR, #711 (design: netstring to cbor-frame migration), depends on #288 landing.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-cbors.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (650714 cached reads)
- Output: 4240 tokens
- Cost: $0.6201668
- Wall-clock: 637s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
