# PR #1543 fix round 4: panel-4 findings applied, CI green

No deterministic pre-pass block was attached, so I worked from the latest panel verdict: review 5625616451, filed against head `6a83f1f22`. I applied every must-fix and should-fix item from its seven jurors in one follow-up commit, `07904eb4d`. I pushed it to `design/claude-api-key-agents` with `safe-push-pr-head.sh` (advance mode). CI came back green on that head: 30 checks, 0 failed (`ci-wait-merge` rc 0).

## Changes

**`designs/api-key-inference-providers-and-pinned-agents.md`**
- **novice:** added an "Actors and capabilities" section before the UI flow. It separates the owner guest from the dedicated agent guest, responder, harness and broker, with a table of what each holds. I also standardized "owner guest" wording across the document.
- **critic, grant identity:** added "Durable grant identity". Grant records live in the registry under the preallocated id, and `AgentInference` becomes a revivable formula holding only that id. After a restart it rebinds to a fresh issuer endpoint on first call. A generation counter blocks retirement, deletion and reattachment from reviving a grant (the critic's "fencing"), and reconcilers clean up leftover records. Creation step 3 now refers to these records.
- **critic, request checks:** the broker-side wrapper now checks every request before admission, not the harness adapter:
  - the route against a per-kind allowlist;
  - a strict body schema, refusing unknown fields;
  - the model against a per-agent allowlist (the issuer only checks the account catalog);
  - a required `max_tokens` no larger than the agent's cap, refused rather than clamped;
  - credential headers.
  
  Phase 2 adds tests that send raw requests around the adapter.
- **ergonomist:** fully specified **Reattach provider**: which providers are offered, how the model is chosen, how limits are clamped and shown, the confirmation text, and what is kept (including the transcript). A running turn finishes on the old provider. It lists the error codes and the success announcement, and adds `reattach` and `set-limits` agent operations.
- **skeptic should-fix:** added an unknown-outcome flow for provider creation. **Check status** reports `committed`, `in-progress`, `key-needed` or `not-found`; re-entering the key reuses the same idempotency key; a pending row on the Providers page survives a reload and can be resumed or cancelled. Tests are added.
- Phase 7 now uses the legacy authority mapping. The three copyeditor wording fixes are in, and a `## Prompt` section was added.

**`designs/claude-bare-course-correction.md`**
- **archivist:** the `--bare` claim is now qualified and reconciled with the earlier 2.1.280 observation that `ANTHROPIC_AUTH_TOKEN` worked. It says plainly that 2.1.296 was not retested with a real token, and that the retirement rests on the documented mode contract.
- **skeptic must-fix:** added a "Legacy authority mapping" table. Every delegated record is owned by the principal at the root of its delegation chain, delegated sub-factories lose their authority to spend, and unresolvable chains go to an operator report. Open question 3 is narrowed to whether a bulk-attach action is needed.
- Replaced "ships dark" with "behind the disabled feature flag" and added a `## Prompt` section.

**`designs/endo-claude.md`:** the blockquote became a proper `## Status` section naming the successor and what was built.

**`designs/endo-claude-inference-backends.md`:** added a dated note that its credential conclusion is superseded, and bumped Updated to 2026-10-23.

**`designs/README.md` (pedant):**
- The dependency graph marks `endo-claude` SUPERSEDED and adds both new designs with their edges.
- The M3 table, M3 text and exit criterion are updated.
- New estimate rows: course correction S, 3–5 days; providers L, 2.5–3 weeks. Both are Endo-side only.
- M3 goes from 8–11 to 10–13 weeks, every later milestone target moves out about two weeks, and the Gantt chart's M3 bar goes to 13 weeks. Both Mermaid diagrams pass parse validation (flowchart and gantt OK).

## Follow-ups
- **Prompt sections are reconstructions.** The verbatim prompt for `design-claude-bare-retreat-api-key-agents-20261023` isn't in the journal record, so both sections say so and rebuild it from the completion report and PR body.
- **Schedule estimates are my own judgement.** The M3 change and the two-week shift are hand-derived, not a velocity re-fit; the README says this.
- **Not addressed:** the pedant's note that some table rows run past 80–100 columns. It was a note, not a finding, and the existing design tables have the same width.
- **Next stage:** the driver should post panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1543-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (3907759 cached reads)
- Output: 33713 tokens
- Cost: $2.5597078
- Wall-clock: 1174s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
