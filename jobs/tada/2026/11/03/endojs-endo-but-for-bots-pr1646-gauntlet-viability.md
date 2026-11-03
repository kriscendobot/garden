**viability=proceed:** PR #1646 hasn't been superseded and its motivating failure still holds, so the gauntlet may begin. I spent no clean, panel, fix, CI-wait or un-draft budget and changed nothing.

Deciding question: Is `llm` still on floating `lts/*`, with `test-xs` still failing there and passing under this PR's one-line pin to Node 24, and with no newer change handling the Node 26 flip?

Answer: yes.

Evidence:
- **PR state:** #1646 is open, draft and mergeable, with no comments or reviews and no linked issue that it closes. Its head is `224852cb18`, and it changes only `.node-version`, from `lts/*` to `24`.
- **Not superseded:**
  - `llm` is identical to the PR's frozen base `llm-48d6f3e`, so there is no newer base history.
  - `.node-version` on `llm` is still `lts/*`, and its last change was `01bbaccc1f` (2026-05-20).
  - A PR search on `node-version`, `Node 26` and `ThrowTypeError` found no competing pin or fix, and titles of PRs opened since 2026-11-01 show none either.
  - An issue search on `Node 26` and `ThrowTypeError` returned nothing, and the local job board has no matching job.
- **Need still holds:**
  - The latest `llm` CI run (41370492445, attempt 2, at `48d6f3e08b`) failed only in `test-xs`, job 125718398161.
  - PR #1633, one of the PRs #1646 says is blocked, also shows `test-xs` failing.
  - The newest LTS on nodejs.org is v26.13.0, matching the PR's description of what `lts/*` now resolves to.
- **The pin works:** `test-xs` passes on this PR's run 41584227374, whose base is the same commit where `llm` fails. The diff is only the pin, which points to the Node version as the cause.
- **Not confirmed directly:**
  - My search of the `llm` `test-xs` log returned nothing, so I couldn't read the Node version or the failing test from it. The specific `intrinsic-metadata.js` failure rests on the PR description and the passing run above.
  - That CI run was still in progress at the check: 8 jobs pending, none failed so far. CI wait belongs to later gauntlet stages.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1646-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (163610 cached reads)
- Output: 3549 tokens
- Cost: $0.455678
- Wall-clock: 137s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
