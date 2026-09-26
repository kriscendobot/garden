CI is green — the shepherd job is complete.

## Completion report

**Job:** shepherd endojs/endo-but-for-bots PR #980 → drive CI to green.

**State on re-derivation:** PR #980 (`feat(ascii): add strict decoding and adopt for OCapN`, base `llm-a54c3ad`, head `6c17ff9ab`) was already `OPEN`, undrafted, `MERGEABLE`/`CLEAN`. A prior attempt's tada report showed it had fixed a missing `OcapnLocation` annotation lint failure; the head has since advanced past that push and remained green.

**What I verified/did:**
- All **28** CI checks pass — build, lint, rust, test-xs, test-hermes, test-ironhorse, both Node 22.x and 24.18.0 `test`/`cover` legs (ubuntu + macos), test262, ocapn guile/python interop, zizmor, check-action-pins, viable-release, sandbox-drivers, etc. No pending or failing required checks.
- Confirmed no completion summary existed for the current head (the last bot comment was this job's 05:12 ack), so posted a concise shepherd summary: https://github.com/endojs/endo-but-for-bots/pull/980#issuecomment-5338033484

**Changes:** none needed to the PR branch — CI was already green at the current head. No garden-repo changes.

**Follow-ups:** The triggering comment said "Please conduct." — the PR is mergeable and ready to conduct/merge, but that is a separate `conductor` directive, not this shepherd job's scope.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr980-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s) (4 unmetered)
- Input: 11 tokens (244300 cached reads)
- Output: 3996 tokens
- Cost: $0.5590399999999999 (4 engagement(s) unpriced)
- Wall-clock: 1327s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
