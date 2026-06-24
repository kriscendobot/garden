---
created: 2026-06-02
updated: 2026-06-24
author: builder
---

# Skill: prompt-on-failure-capture

The capture-by-SHA pattern that lets a deterministic bash script
(a job-board service, a watcher, a worker helper) escalate an
unresolvable step to an ephemeral `claude -p` subagent without
inlining a large failure log into the prompt. The log is hashed into
the journal's git object database; the prompt names the SHA; the
subagent reads the blob on demand via `git cat-file -p`.

In v2 the primitive lives in `scripts/jobs/common.sh` as
`capture_blob` / `inspect_note` / `anchor_blob`; this skill is the
playbook that wraps them into the full escalation flow. See
[`designs/self-healing-audit.md`](../../designs/self-healing-audit.md)
(Part B) and [`designs/driver.md`](../../designs/driver.md) §
Prompt-on-failure capture pattern for the design rationale and the
four-slot brief shape.

## When to use

- A service tick reaches a state whose deterministic predicate cannot
  resolve the next transition (the canonical example: a panel
  verdict body that says "almost-approve with one footnote" and the
  predicate cannot tell if that is `approve` or `must-fix-loop`).
- A watcher hits a feed event whose classification the regex
  filter cannot resolve.
- A helper script (cleaner skeleton, fixer's retcon wrapper) fails
  in a way the surrounding bash cannot interpret.

When the deterministic predicate succeeds, this skill is not used:
the script advances on its own. The skill is the escape hatch, not
the default.

## Inputs

- A failure context (a log file, a JSON payload, a diff, a verdict
  body) the script captured during its own run.
- The four-slot brief metadata (PR identifier, design path, role,
  state-machine state).
- A one-paragraph human-authored reason for the escalation (the
  context line the prompt template fills).

## State

The capture writes a blob to a journal clone's object database via
`capture_blob` (a thin wrapper over `git hash-object -w --stdin`).
The blob is unreferenced; `git gc` collects it after the journal's
grace window (default 14 days) unless an operator or agent anchors it
with `anchor_blob` (which pushes a `refs/captures/<suffix>` ref to the
shared remote):

```sh
anchor_blob "$LOG_SHA" "<role>/<pr>/<short-id>" "$DIR"
```

Captures under `refs/captures/` survive indefinitely until explicitly
pruned. Most one-off failures do not need this. Anchoring is
appropriate when:

- The failure shape is one we want to revisit (a recurring CI
  flake we want to round-trip into a regression test).
- The escalation produced a non-trivial classification we want to
  reuse on identical SHAs (see *Known-SHA short-circuit* below).
- An operator's triage flagged it.

A small lookup table at
`journal/captures/<host>/<service>.classifications` may also map
capture SHA → classification verdict so identical bodies reuse the
prior verdict without re-invoking the LLM.

## Cross-host reachability

`capture_blob` writes the blob into the *local* object DB of the clone
it is handed (each v2 service hashes into its own
`$GARDEN_STATE/<service>/journal` clone). The blob is reachable by any
reader **on this host** but is **not** on origin and **not** visible
to a responder on another host (the central mentor may run elsewhere).
For a failure a different host must inspect, make the SHA reachable on
the shared remote, in order of preference:

1. Write the SHA into a *committed* board or inbox file (a job body,
   an inbox-error report via
   [`gardener-inbox-error-reporting`](../gardener-inbox-error-reporting/SKILL.md))
   and push it the normal CAS way — the commit references the tree, so
   `git push origin HEAD:journal2` carries the blob with it.
2. `anchor_blob` the loose blob under a ref and push that ref, when you
   want the capture available before/without a committed escalation.

A capture that only ever feeds a same-host responder needs neither.

## Procedure

1. **Capture.** Hash the relevant output into the service's journal
   clone:

   ```sh
   LOG_SHA=$(capture_blob /path/to/failure.log "$DIR")
   ```

   The blob's content is content-addressable: identical inputs
   produce identical SHAs. This is the foundation of the known-SHA
   short-circuit below.

2. **Promote (optional).** When the failure is one we want to
   survive `git gc` or inspect off-host, anchor it:

   ```sh
   SHORT_ID=$(printf '%s' "$LOG_SHA" | head -c 7)
   anchor_blob "$LOG_SHA" "<role>/<pr>/${SHORT_ID}" "$DIR"
   ```

3. **Known-SHA short-circuit.** Before constructing the prompt,
   consult the per-service classifications table:

   ```sh
   CLASSIFICATIONS="$DIR/captures/$GARDEN_HOST/$SERVICE.classifications"
   if [ -f "$CLASSIFICATIONS" ]; then
     KNOWN=$(grep "^$LOG_SHA " "$CLASSIFICATIONS" | head -1 | cut -d' ' -f2-)
     if [ -n "$KNOWN" ]; then
       # apply the known disposition and skip the LLM call
       apply_classification "$KNOWN"
       return 0
     fi
   fi
   ```

   The match is exact; near-misses (a CI log with one timestamp
   different) hash to a different SHA and re-escalate.

4. **Prompt construct.** Write a prompt that fills the four named
   slots plus the capture SHA and the failure context, and hands the
   responder the exact read command from `inspect_note`:

   ```
   You are a subagent classifying an escalation from service $SERVICE.

   PR:        $PR                           # or "(none)"
   Design:    $DESIGN_PATH                  # or "(none)"
   Role:      $ESCALATING_ROLE              # builder, fixer, etc.
   State:     $STATE
   Capture:   $LOG_SHA

   Context: $FAILURE_CONTEXT_PARAGRAPH

   Read the capture on demand — narrow with a pipe, never inline it:
     $(inspect_note "$LOG_SHA" "$DIR")

   Reply with a structured JSON verdict naming the classification and,
   when applicable, the action the service should take next.
   ```

   The four-slot brief is the minimum. Some workflows add a fifth
   slot (the design dependency walk's prior-PR list, the conflict
   resolver's parent SHAs).

5. **Invoke.** Pipe the prompt to `claude -p`:

   ```sh
   RESPONSE=$(printf '%s' "$PROMPT" | claude -p --output-format json)
   ```

   The prompt is small (the four-slot brief plus the context
   paragraph); the LLM pulls the capture on demand. Token cost
   stays bounded by the brief, not the capture's length.

6. **Apply.** Read the response (a patch, a directive, or a
   classification), apply it, and record the SHA → verdict mapping
   in the per-service classifications table so the next identical
   capture short-circuits.

## Output

- The capture blob's SHA (written to the journal clone's object DB).
- (Optional) An anchored ref under `refs/captures/<role>/<pr>/<short-id>`.
- The LLM's classification or patch.
- An updated `journal/captures/<host>/<service>.classifications` row
  when the SHA was unseen.

## Notes

- **Identical SHAs short-circuit.** The whole point of the
  capture-by-SHA pattern is that recurring operational flakes (a
  test-xs esvu-download failure, an esbuild bundling error with a
  stable error trail) hash to the same blob and reuse the prior
  classification.
- **The prompt stays small.** Inlining the log defeats the
  capture's purpose and reintroduces the per-cycle token cost. The
  prompt names the SHA and lets the subagent decide if it needs to
  read the capture, narrowing with `| grep` / `| tail` / `| sed -n`.
- **Sensitive content.** Captures persist in the journal repo
  until `git gc` collects them. Secrets that leaked into a
  transcript stay readable until the grace window passes. Do not
  anchor a capture (`refs/captures/...`) unless its content is
  safe to retain indefinitely.
- **No promotion to a tracked file.** Captures live as blobs only;
  there is no committed `journal/captures/` tree of snapshots. The
  `capture_blob` plus optional `anchor_blob` shape is the contract.
