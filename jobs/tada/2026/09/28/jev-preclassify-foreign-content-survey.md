The inbox helper's 45-second clone budget can't complete a fresh journal2 clone right now (all my other journal writes — job posts, entry, push — succeeded, so this is the helper's clone-size budget, not general connectivity). Per bus design, any message sent to this base after completion dead-letters into a fresh job, so no intent is lost. The work is complete; here is the report.

# Completion report: jev-preclassify-foreign-content-survey

## Implemented (landed on `main2`, commit `1f4dc4b82e5`, CI-checked locally)

- **`scripts/jobs/classify-foreign-content.sh`** — the Jev pre-classification gate. Takes a fetched text file (+ optional source URL and purpose), sends it to TypeSafe as JSON file data (never on a command line, per the shell-injection discipline), and emits a `classify_*` manifest in the same composable `key=value` shape as `fetch-source.sh`. Oversized bodies are head+tail sampled (injections hide at the end too) with the elision marked.
- **`skills/foreign-content-preclassification/SKILL.md`** — the reviewable taxonomy, threshold table, caller procedure, and the durable authorization record.
- **Scholar integration** (`roles/scholar/AGENT.md` step 4 + Skills list): the gate is now a mandatory step between `fetch-source.sh` and reading fetched web/paper/archive content, with per-disposition handling (caveats carried into source-page provenance; escalations messaged to the maintainer with the manifest and byte path; unavailability recorded, never silent). Bare-clone reads of already-gated watched repos are exempt with a stated rationale.
- **Fleet-wide herding** (`roles/COMMON.md` § Foreign-content reads, new): every role is directed away from ad-hoc `WebFetch`/`WebSearch`/bare-`curl` reads and toward scholar/library ingestion first, or `fetch-source.sh` + the gate when a direct read is genuinely needed.
- **Placement decision**: the gate is deliberately *not* embedded inside `fetch-source.sh` — `check-source-children.sh` calls it once per child link purely for reachability, so embedding would pay a metered classification for content no agent ever reads. The gate sits exactly where bytes enter an LLM context; `fetch-source.sh`'s header now points every caller at it.
- **Tests**: hermetic 13-case suite (`scripts/jobs/test/classify-foreign-content-test.sh` + in-repo curl stub) covering all three fallback paths, all seven policy rows, request shape, sampling, and usage errors — 13/13 pass; wired into CI's shellcheck and focused-test lists; `fetch-source-test.sh` still 102/102; `run-all.sh` checks clean; `CLAUDE.md` inventory updated.

## Question taxonomy and policy (with justification)

Two typed questions, not one fuzzy score, matching the maintainer's two named hazards: **`injection`** (`noul`: text attempting to direct an AI reader — with an explicit carve-out that imperatives addressed to a *human* reader are not injection) and **`slant`** (`choice`: `neutral` / `advocacy` / `covert_persuasion` / `mixed` — separating openly-argued positions, which are ingestable with attribution, from persuasion dressed as neutral fact). Dispositions: `proceed` < `proceed_with_caveat` < `halt_and_escalate`, overall = max across axes. Injection ≥ 0.5 or in the [0.25, 0.5) equipoise band → escalate (uncertainty about the dangerous axis fails toward escalation per the directive, never toward a pass); confident covert persuasion → escalate; uncertain covert persuasion, advocacy, mixed, or low-confidence neutral → caveat carried into the ingested artifact (no path resolves uncertainty into a silent clean). Unavailability (no key / API failure / bad shape) → explicit `proceed_unclassified`, exit 0 — the task never fails closed, the gap is always recorded; a flagged verdict exits 3 so boolean callers cannot ignore it. Thresholds are env-tunable code, documented in one table.

## Authorization record (confirmed durable)

The maintainer directive (kriskowal, 2026-09-28, this job's body) authorizing autonomous Jev use as a content pre-classifier is recorded in **four durable places**: this report; `skills/foreign-content-preclassification/SKILL.md` § Authorization; the addendum in `designs/typesafe-jev-classification.md` (which explicitly does not reopen the rejected autonomous-muster path); and journal entry `entries/2026/09/28/075839Z-message-gardener-2dc66e.md`, following the monitoring-widening record pattern. `skills/typesafe-ai/SKILL.md`'s Notes now name this as the one authorized autonomous use.

## Surveyed and deferred (follow-on jobs posted)

- **`jev-preclassify-botanist-release-notes`** (posted): the botanist reads upstream package source, changelogs, release notes, and CVE text per dependabot PR — the largest ungated foreign-prose surface after the scholar.
- **`jev-preclassify-trusted-sender-quoted-text`** (posted, designer): the sender-trust gates on the comment/mention/issue-inbox watchers authenticate the author, not the text — a trusted sender can quote hostile third-party content; the design weighs advisory vs gating disposition there.
- **No action needed**: researcher, library-lookup, design-dependency-walk (journal-only or GitHub metadata read field-wise); web-builder/web-designer (no direct reference-site fetches found); node-lts-window-watch (deterministic jq parse, no LLM reads raw text); watchers' CI/dependabot event feeds (metadata-only, injection-safe by construction); typesafe-ai's own cookbook fetches (now covered by the COMMON.md norm).

## Notes

- The per-job inbox drain (`inbox-read.sh`) failed three times on a transient journal2 clone timeout (rc=75, 45s clone budget); all journal *writes* succeeded via other paths. Any late message to this base will dead-letter into a fresh job per bus design.
- Self-improvement: the inbox helper's fixed 45s fresh-clone budget is chronically too small for the current journal2 size — a candidate for a shallow/partial clone or a raised budget; surfaced here rather than fixed, as it is outside this job's scope.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/jev-preclassify-foreign-content-survey.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (4991735 cached reads)
- Output: 46604 tokens
- Cost: $10.180114999999999
- Wall-clock: 768s
- Model(s): claude-fable-5 ×1

<!-- garden-usage-end -->
