## Gauntlet fix round 6: kriscendobot/minion.town PR #193

I applied panel-6's must-fix items in one follow-up commit, `2b88eaa` on `build/ocapn-guest-canary`, pushed it with `safe-push-pr-head.sh` (advance mode, `f96656b..2b88eaa`), and CI came back **green**. The offline suite passes 63/63 locally.

**What changed:**
- **locksmith:** the run now removes both `ocapn-canary-guest-<name>` host bindings at the end, in a `finally`, and records `cleanup-unbind:<name>` under the cleanup deadline. If a binding can't be released, the run fails. The header now says the host holds a guest's authority only for the run.
- **decomplector 1:** send, adopt, dismiss and remove now go through `endo <verb> --as ocapn-canary-guest-<name>`, and guest names are read with `endo list <guest>`. I checked these verbs against Endo's `packages/cli` on the `llm` branch. This removed the generated source templates, the `isMessageNumber` check and the eval'd name listing. `endo eval` is now used only to list messages (`inbox` has no JSON output), to provision the probe (`eval --as <sender> -n <probe>`) and to exercise it.
- **decomplector 2:** the per-pair cleanup queue is gone. One `cleanup-reconcile:<name>` sweep per guest runs at the end under the cleanup deadline.
- **pruner:** I trimmed the header. The sweep note now appears once, on `reconcile`, the probe paragraph is shorter, and the planned-caller reference is gone. I also deleted the `probeSource` and `prebind` comments and "the operator may prune them" in `DEPLOYMENT.md`.
- **procurer (`isRecord`):** no code change, as the review suggested. The PR comment explains why: `@endo/pass-style` needs SES and its check throws on unfrozen `JSON.parse` output.
- **assessor (comment-only, taken):** a `guests` field that is not a list now gives `malformed-guests detail=guests`.
- **Tests:** the fake Endo CLI now maps command-line arguments to results instead of matching eval source. I added tests for releasing host bindings, removing a stale binding left by an earlier run, `canaryNames`, and a non-list `guests` field.
- **scribe (comment-only):** I posted a top-level summary comment on the PR answering this round.

**Follow-ups:**
- None from this stage; the driver re-posts panel-7.
- I couldn't check against a live daemon whether the `--as` verbs reach an adopted federated guest. That will show on the first live run (successor job `minion-town-ocapn-canary-live-run`).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr193-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (2487991 cached reads)
- Output: 32712 tokens
- Cost: $2.1017102
- Wall-clock: 1191s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
