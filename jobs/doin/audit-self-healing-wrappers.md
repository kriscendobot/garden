# Audit: self-healing wrappers on every script + git-content-store failure capture

Wear the **mentor** role (`roles/mentor/AGENT.md` — the self-improvement role). Two
related audits of the garden's automation, delivered as one report on `main2` plus
scoped follow-up jobs for the concrete gaps.

## Part A — does every script have a self-improvement / debugging outer wrapper?

The garden's posture is "every automation is supervised and shells out to `claude -p`,
silent until an error." Verify that posture is **universal**: each script that runs
deterministic automation should have an **outer wrapper** that, on failure, captures
the failure and drives a `claude -p` self-improvement/debugging responder — wearing
**skills and roles specific to that self-healing task** — rather than just dying and
relying solely on the central mentor service.

1. **Inventory** every script under `scripts/` (especially `scripts/jobs/*.sh`,
   `scripts/jobs/handlers/*.sh`, the gardening state machine under
   `scripts/jobs/gardening/`, and anything in `scripts/systemd` that execs a script).
2. **Study the exemplars** of the pattern done right, to set the bar: `scripts/jobs/mentor.sh`
   (+ `handlers/mentor-claude.sh`), and the gardening state machine
   (`designs/gardening-state-machine.md` + `scripts/jobs/gardening/garden-pr.sh`) —
   especially its **diverted tracing** (`GARDEN_TRACE` → a trace file handed to a
   dedicated debugging subagent so trace noise never enters the supervisor's context).
3. **Classify each script**: has-wrapper / partial / missing — does a failure get
   captured and handed to a `claude -p` debugging/self-improvement responder with a
   relevant role/skill, or does it just `die`/exit and lose the chance to self-heal?
4. **Verify the supporting roles/skills exist and are used consistently:** the
   **mentor** role, the **prompt-on-failure-capture** skill (translate from
   `v1/skills/prompt-on-failure-capture` if it has not landed in v2), the
   diverted-tracing technique, and any dedicated "debugging subagent" role. If there
   is no single canonical **self-healing-wrapper** skill that scripts reference,
   recommend authoring one (a reusable playbook: capture-on-failure → hand to
   `claude -p` debugger → propose/post a fix) so the pattern stops being copied
   ad hoc.

## Part B — apply the git-content-store failure-capture pattern more thoroughly

Generalize the diverted-tracing idea using the **git object store** as the capture
buffer. The pattern:

- A deterministic automation that may fail produces output (stdout, stderr, traces,
  build artifacts) that can be **large**.
- On failure, instead of reading it all into the responder's context, **capture it
  into the git content store**: `git hash-object -w <file>` (or stream into a blob),
  which writes an immutable, content-addressed blob and returns a **hash**.
- **Pass only the hash** (and the repo path) to the `claude -p` subprocess
  responsible for responding to the failure.
- That responder uses `git cat-file -p <hash>` plus ordinary shell utilities
  (`grep`, `sed`, `awk`, `tail`, `wc`) to **inspect the failure selectively** —
  pulling only the relevant slices into its context, never the whole blob.

Search the scripts for **opportunities** to adopt this: deterministic automations
whose failure output is currently (a) dumped wholesale into a `claude -p` prompt,
(b) written to a temp file that the responder reads in full, or (c) lost on failure.
For each, recommend converting to hash-capture + selective inspection. Note where a
shared helper in `scripts/jobs/common.sh` would let every script capture-and-hash
uniformly (e.g. `capture_blob <file> -> hash`, `inspect note for the responder`).

## Deliverable

- A structured **audit report** committed to `origin/main2` (bot identity) — e.g.
  `designs/self-healing-audit.md` — with: a per-script coverage table (has-wrapper /
  partial / missing) for Part A; the supporting-role/skill gaps; and a prioritized
  list of Part-B capture-via-hash opportunities (script, what fails, what output,
  the recommended change). Ground each finding in the actual script (path + line).
- **Post scoped follow-up jobs** (idempotent basenames, e.g. `self-heal-<script>`)
  for the clearly-actionable gaps — adding a missing wrapper, authoring the canonical
  self-healing-wrapper skill, adding the `common.sh` capture helper, or converting a
  specific automation to hash-passing. **Leave design-level or judgment-call changes
  as recommendations in the report for maintainer review** rather than auto-posting
  them. List in the report exactly which follow-up jobs you posted.
- `shellcheck`/`bash -n` clean for any helper you add; the audit itself writes no
  code beyond an optional `common.sh` capture helper if you judge it the right
  foundation (otherwise recommend it).

Report the report SHA, the coverage summary (N scripts: X covered / Y partial /
Z missing), and the follow-up jobs posted. If a write/push is blocked, report the
diagnosis and the ready-to-apply content rather than claiming completion.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 24
  claimed_at: 2026-06-24T19:52:26Z
