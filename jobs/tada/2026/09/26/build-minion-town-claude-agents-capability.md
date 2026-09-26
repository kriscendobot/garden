I made no changes and opened no PR, because this job's deliverable already shipped. The job was re-promoted from `plan/` on 2026-09-26, but the same build was finished and merged three weeks ago.

**Already shipped:**
- **[kriscendobot/minion.town#87](https://github.com/kriscendobot/minion.town/pull/87)** ("wire the Claude-agents capability behind ENDO_CLAUDE_ENABLED") merged on 2026-09-03 after 3 panel rounds. It covers everything in this job's spec:
  - the `@claude-account` concierge and the status-only `ClaudeAccountStatus` facet for descendants;
  - the attenuated `@claude-agents` factory, whose `create` never rejects and is an idempotent get-or-create returning a live agent or one of the tagged sentinels (`needs-auth`, `agent-limit-reached`, `unknown-model`, `unavailable`);
  - the `submit` verb and MCP tool (the job's `guest_submit`);
  - the `/account/claude/:nonce` setup-token route;
  - the per-user credential store and the per-user retained-child quota plus inference-slot lease;
  - all of it behind `ENDO_CLAUDE_ENABLED=1`, so a deployment without the flag is unchanged.
- **The maintainer amendment is in the code.** `src/endo/claude/wiring.ts` gives the factory and the full account handle only to accounts listed in `config.rootSubjects` (`ENDO_CLAUDE_ROOT_SUBJECTS`); any other account gets `undefined`. Nothing adds the factory to every new guest. #87's PR body takes the most conservative reading: a root account passes the factory on only by the explicit send-a-capability mail hand-off.
- **The design doc matches.** #87 amended `designs/claude-agents-capability.md`, and #97 (merged 2026-09-08) went further. It is now titled "Claude agent provisioning for the minion.town root account", carries the amendment block, and marks step 6 ("new-guest default") as superseded.
- **Follow-on work is already open:** draft #120 (a root-only `delegate()` sub-factory) and draft #119 (credential-expiry reauth).

**Why it came back:** the journal was cut back to a fresh root on 2026-09-23, so it has no `tada/` report for this base. The parked plan copy was therefore promoted again. `ensure-pr.sh --find-only` found no open PR for this job, and I did not open a duplicate.

**Follow-ups:** none for this job. The remaining steps (step 1 on the endo-but-for-bots #1015 line, the entitlement stop gate, and steps 3–6) are outside this job's scope and are tracked in the design doc. Whoever manages the plan queue may want to check for other parked jobs whose `tada/` reports were lost in the 2026-09-23 cut, so they aren't re-run the same way.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-agents-capability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s) (1 unmetered)
- Input: 18 tokens (423901 cached reads)
- Output: 3433 tokens
- Cost: $0.5412321999999999 (1 engagement(s) unpriced)
- Wall-clock: 2457s
- Model(s): claude-opus-4-8 ×2, claude-opus-5-5 ×1

<!-- garden-usage-end -->
