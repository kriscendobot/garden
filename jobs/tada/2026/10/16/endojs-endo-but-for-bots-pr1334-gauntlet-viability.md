Deciding question: Does `llm` at its current head still corrupt ava snapshot reads under `@endo/init`, with no other fix already landed? (Answering yes means the PR is neither superseded nor based on a premise that has gone away.)

Answer: **yes, so the gauntlet may proceed.**

Evidence:
- **PR state:** #1334 is open, unmerged and still a draft. Head is `29c4591f`, on branch `llm-fix-lockdown-ava-snapshot-uint8array`. Its base is the frozen `llm-61cd656`. It has no reviews or comments, so no maintainer has pushed back or redirected it.
- **The base is current:** the `llm` head SHA is `61cd656cb8d9…`, which is the PR's base exactly, and a compare of `61cd656...llm` shows nothing ahead or behind. The PR description says it was rebased and verified locally on this base today (2026-10-16): the regression test passes and fails without the patch. No newer `llm` history could have displaced it.
- **The bug is still on `llm`:**
  - `packages/ocapn/test/snapshots/api-surface.test.js.snap` is still the corrupt 6008-byte file. The PR shrinks it to 811 bytes.
  - `packages/ocapn/test/api-surface.test.js` on `llm` still carries the #475 workaround, which writes and compares the `.md` report by hand because ava's binary snapshot reader fails.
- **Not superseded:** `llm` has no `.yarn/patches` directory, and its root `resolutions` pins only `"ava": "8.0.1"`, with no patch. A PR search for "ava snapshot Uint8Array" turns up no competing fix. The nearest related work, #1349 (SES TextEncoder/TextDecoder encapsulation), is a different subject.

I spent no clean, panel, fix, CI-wait or un-draft budget.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1334-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (171771 cached reads)
- Output: 1815 tokens
- Cost: $0.41886219999999996
- Wall-clock: 25s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
