## Gauntlet fix round 4: kriscendobot/minion.town#177 (`designs/git-remote-served-clip.md`)

I applied the panel-4 items to the design, pushed one follow-up commit to the PR head, and CI is green. The head moved from `7513e22` to `25ac27a`.

**The two blocking votes (copyeditor and pedant):**
- **Serial comma:** added "and" before `manifest` in the `link[href]` rel list.
- **Cost figure:** "about 2 s an hour" now reads "about 2 seconds of total work per hour".
- **Not changed, as the panel supervisor ruled:** "a attenuation" already read "an" (false positive). The headings are already sentence case (false positive). "1 (merged) added" stays in the past tense because that increment is finished.

**The should-fix items, which I also took:**
- **Why Model S is recommended (critic 1):** § 1 and § 12 Q1 now say it rests on link stability, not on coherence, and that Model P is the more coherent of the two.
- **Atomicity (skeptic 1):** a new paragraph in § 3 says each request reads one snapshot of the vhost record.
- **Stale rewrites (skeptic 3):** the write-side state gains a `projectionVersion` stamp, built from the rewrite-rules tag, the parse5 version and the rewrite size limit. The full sweep re-projects when the stamp differs.
- **Idempotence (critic 5):** the rule for updating the retention list is spelled out, so re-projecting an unchanged tip writes an identical record.
- **Threat model (skeptic 4):** it now covers old retained roots with known vulnerabilities, and recommends `purge-root` after a security fix.
- **Expired roots (skeptic 2):** the doc says what a visitor sees when an asset 404s past retention, and recommends that a long-lived page reload on a `/.content/` 404.
- **Reserved path (ergonomist 3):** a pushed `.content` path now records a status warning instead of being skipped silently.
- **Operator verbs (ergonomist 1):** the operator subcommand `unserve` is renamed `unpublish`, matching the partition object. `purge-root <id> <root>` gets its arguments, and `status` lists the retained roots to copy from.
- **Glosses (novice 1–2):** one-clause explanations for #88 Q1/Q7/Q8, #142 Q8 and the #85 thread, and a gloss of `contentRoot`, `entryRoot` and `roots` right after the § 3 JSON.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0 with all 3 checks green (Claude harness amd64 and arm64, and test). The first foreground wait went over the tool's 10-minute limit, so I re-polled with short bounded calls until it finished.

**Follow-ups:** none from this stage. The driver re-posts panel-5. The skipped items are optional or comment-only: novice 3–4 (a Model P walk-through and splitting § 5.1), critic 3 (costing a hybrid alias), and decomplector 1 (comparing against the zero-mechanism alternative).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr177-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (1083006 cached reads)
- Output: 10121 tokens
- Cost: $1.0656132
- Wall-clock: 879s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
