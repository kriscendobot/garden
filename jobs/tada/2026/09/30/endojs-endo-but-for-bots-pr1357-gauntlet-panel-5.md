Panel round 5 on endojs/endo-but-for-bots PR #1357 ran to completion and the verdict is **must-fix**. I posted the review; nothing was fixed and the PR is still a draft.

**The run:** I ran the panel in single-round mode on a separate checkout of the PR head (`design/endo-claude-inference-backends` at `a1c7088f0c`). I passed the PR's exact base commit (`47f6965d88`, branch `llm-47f6965`) so the review covered only the PR's own changes. Its record (`panel-runs/endojs-endo-but-for-bots-1357/2abaf449677d.md`) shows `exit_code=0` and `disposition=must-fix`, and all 10 seats reported ok.

**Seat verdicts:**

| Verdict | Seats |
| --- | --- |
| Request changes | skeptic, decomplector, ergonomist, pedant, pruner |
| Comment only | critic, novice |
| Approve | copyeditor, orthographer, thesaurus |

**Review posted:** GitHub rejected request-changes because the bot cannot request changes on its own PR, so I posted it as a comment instead. The body is headed "Panel review — round 5 (design panel, single round): **must-fix**", matching rounds 2–4, and includes each seat's full findings.

**Main blockers this round:**
- **skeptic:** Decision 7 says one credential never runs two turns at once, but no gate tests a second concurrent `acquire()` on the same credential.
- **skeptic:** The design doesn't say whether the guard's `promptOrigin` field is a closed enum or an open string. If it is a closed enum, the enricher's "missing or unknown origin" branch can never run.
- **decomplector:** Two layers still claim to classify outcomes. The prompt-origin gate writes `needs-containment` itself, although the design says the plugin alone classifies outcomes.
- **decomplector:** Containment is still routed by a label the caller sets, while credentials are chosen by which backend instance is held. It suggests using backend instances for containment too.
- **ergonomist:** The `limit-exceeded` arm has no `retryAfterMs` field, though Decision 8's prose says it carries one. `AdmissionRefusal` `budget` maps to a different shape than the other two reasons, and the `InferLimits` field names follow two conventions.
- **critic (comment only):** Gate 8 checks only that bad requests are refused. It should also confirm that a genuine root-authored prompt is labeled `root-authored` and runs unsliced. Gate 8 also depends on #1102, which is not marked merged.
- **pedant and pruner:** `##` heading capitalization is inconsistent. The PR body repeats content from the design, and the Resolved Questions section repeats the Design Decisions.

**Next:** The gauntlet driver owns the next fix round. This is the fifth consecutive must-fix. The main issues moved from round 4's `promptOrigin` points to the ones above, so the design is still settling.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1357-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (612284 cached reads)
- Output: 4541 tokens
- Cost: $0.6667487999999999
- Wall-clock: 206s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
