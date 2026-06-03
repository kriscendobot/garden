---
created: 2026-06-02
updated: 2026-06-02
author: builder
---

# Skill: prompt-on-failure-capture

The capture-by-SHA pattern that lets a deterministic bash script
(driver, watcher, helper) escalate an unresolvable step to an
ephemeral `claude -p` subagent without inlining a large failure log
into the prompt. The log is hashed into the journal's git object
database; the prompt names the SHA; the subagent reads the blob on
demand via `git cat-file blob`.

See [`designs/driver.md`](../../designs/driver.md) § Prompt-on-failure
capture pattern for the design rationale and the four-slot brief
shape.

## When to use

- A driver tick reaches a state whose deterministic predicate cannot
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
  state machine state).
- A one-paragraph human-authored reason for the escalation (the
  context line the prompt template fills).

## State

The capture writes a blob to `$GARDEN_JOURNAL`'s object database
via `git hash-object -w --stdin`. The blob is unreferenced; `git gc`
collects it after the journal's grace window (default 14 days)
unless an operator or agent anchors it:

```sh
git -C "$GARDEN_JOURNAL" update-ref refs/captures/<role>/<pr>/<short-id> <sha>
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
`journal/drivers/<host>/<lane>.classifications` may also map
capture SHA → classification verdict so identical bodies reuse the
prior verdict without re-invoking the LLM.

## Procedure

1. **Capture.** Write the relevant output to the journal as a blob:

   ```sh
   LOG_SHA=$(some_command 2>&1 | git -C "$GARDEN_JOURNAL" hash-object -w --stdin)
   ```

   The blob's content is content-addressable: identical inputs
   produce identical SHAs. This is the foundation of the known-SHA
   short-circuit below.

2. **Promote (optional).** When the failure is one we want to
   survive `git gc`, anchor it:

   ```sh
   SHORT_ID=$(printf '%s' "$LOG_SHA" | head -c 7)
   git -C "$GARDEN_JOURNAL" update-ref \
     "refs/captures/<role>/<pr>/${SHORT_ID}" "$LOG_SHA"
   ```

3. **Known-SHA short-circuit.** Before constructing the prompt,
   consult the per-lane classifications table:

   ```sh
   CLASSIFICATIONS="$GARDEN_JOURNAL/drivers/$GARDEN_HOST/$LANE.classifications"
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

4. **Prompt construct.** Write a prompt file that fills the four
   named slots plus the capture SHA and the failure context:

   ```
   You are a subagent classifying an escalation from driver lane $LANE.

   PR:        $DRIVER_PR
   Design:    $DESIGN_PATH                  # or "(none)"
   Role:      $ESCALATING_ROLE              # builder, fixer, etc.
   State:     $DRIVER_STATE
   Capture:   $LOG_SHA

   Context: $FAILURE_CONTEXT_PARAGRAPH

   Read the capture on demand via:
     git -C "$GARDEN_JOURNAL" cat-file blob $LOG_SHA

   Reply with a structured JSON verdict naming the classification and,
   when applicable, the action the driver should take next.
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
   in the per-lane classifications table so the next identical
   capture short-circuits.

## Output

- The capture blob's SHA (written to the journal's object DB).
- (Optional) An anchored ref under `refs/captures/<role>/<pr>/<short-id>`.
- The LLM's classification or patch.
- An updated `journal/drivers/<host>/<lane>.classifications` row when
  the SHA was unseen.

## Notes

- **Identical SHAs short-circuit.** The whole point of the
  capture-by-SHA pattern is that recurring operational flakes (a
  test-xs esvu-download failure, an esbuild bundling error with a
  stable error trail) hash to the same blob and reuse the prior
  classification.
- **The prompt stays small.** Inlining the log defeats the
  capture's purpose and reintroduces the per-cycle token cost the
  driver design eliminates. The prompt names the SHA and lets the
  subagent decide if it needs to read the capture.
- **Sensitive content.** Captures persist in the journal repo
  until `git gc` collects them. Secrets that leaked into a
  transcript stay readable until the grace window passes. Do not
  anchor a capture (`refs/captures/...`) unless its content is
  safe to retain indefinitely.
- **No promotion to a tracked file.** Captures live as blobs only;
  there is no `journal/captures/` tree of committed snapshots.
  The `git hash-object -w` plus optional `update-ref` shape is
  the contract.
