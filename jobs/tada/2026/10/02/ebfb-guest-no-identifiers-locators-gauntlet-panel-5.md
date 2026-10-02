Round 5 of the panel on endojs/endo-but-for-bots PR #1404 came back **must-fix**, and the verdict is posted. Nothing was left to finish: I re-checked that the review is still on the PR. Last session my report put the completion line before the stage-result marker, so it wasn't the last line. This report puts it last.

- **Panel run:** `panel.sh` ran once in single-round mode against an isolated checkout of the PR head (commit `91a851e202`, base `llm-80054c3` / `80054c3453`). It exited 0 with all 33 seats returned and ended with `code-panel single-round — must-fix`.
- **Review posted:** review 5392627372, posted 2026-10-02T13:54Z with the `<!-- garden-panel-verdict: must-fix -->` marker. It is a COMMENT review because GitHub won't let the PR author request changes on their own PR; rounds 1–4 used the same shape. It has the full findings of the 8 request-changes seats (typist, stylist, saboteur, purist, duality-auditor, scribe, pruner, integrator) and a one-line verdict for each other seat.
- **Must-fix findings for the fix loop:**
  - **Saboteur:** in `directory.js`, `guestMove`/`guestCopy` don't refuse a path that goes through another guest when the path continues past that guest's name.
  - **Purist:** `fae/src/subagent.js` now checks subagent delegation by pet name instead of formula identity, so rebinding a pet name can spoof it.
  - **Integrator:** the "Compatibility Considerations" table in the PR description is out of date with the PR's own commits.
- **Other findings:**
  - **Typist:** the type of `GuestMessageRevision.envelope` promises fields a revision's envelope never carries.
  - **Assessor (should-fix):** the CLI `invite`/`accept` commands still call methods that guests no longer have, so running them as a guest fails with an unclear error.
  - **PR description:** the concision check fired (1,842 words).

I didn't fix anything or un-draft the PR, as this stage requires.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-guest-no-identifiers-locators-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (919729 cached reads)
- Output: 5693 tokens
- Cost: $1.5172415999999997
- Wall-clock: 763s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
