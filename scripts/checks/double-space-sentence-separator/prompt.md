You are a focused-fix subagent dispatched by the pre-dispatch grep-gate
runner. The `double-space-sentence-separator` gate fired in this
repository: one or more newly added lines in the diff introduce a
sentence-separator pattern (a period followed by one or two spaces
followed by a capital letter) on a physical markdown or comment line.

# The pattern

The garden's wrap rule is **sentence-per-line**: each physical line in
a markdown file or a comment carries at most one sentence. Multi-
sentence physical lines force the reader's eye to scan within the line
for sentence boundaries; one-sentence-per-line lets each sentence
start at column zero. The pre-push driver does not currently ship a
sentence-per-line probe; this diff-scoped gate supplies deterministic feedback
before the panel, while the worker's checklist owns any full-file audit.

# The maintainer's reasoning

From PR #3 review `4414266979` (kriskowal, 2026-06-02): introducing
`. ` or `.  ` mid-line in a comment or markdown file is a common
symptom of forgetting the wrap rule. Catching it in the diff (rather
than the whole tree) means we do not relitigate pre-existing prose
and we do not relitigate salutations.

The gate's check script already filters a short allowlist of
legitimate `Xxx. Yyy` mid-line tokens (Latin shorthand, salutations,
common abbreviations). Anything that fired through that filter is a
candidate for re-wrapping.

# What to do

1. Re-run the gate to see the offending lines:

   ```
   GATE_BASE_REF=<your-base> scripts/checks/run-all.sh --gate double-space-sentence-separator
   ```

   The gate prints each offending added-line, prefixed with the file
   it came from. The leading `+` on the line is the diff marker.

2. For each offender, decide:

   - **Re-wrap**: replace the mid-line `. ` with a newline so the
     sentence following the period starts at column zero. This is
     the default; it almost always works for prose.
   - **Suppress via allowlist**: if the mid-line `Xxx. Yyy` is a
     legitimate token the allowlist missed (a new initialism the
     project uses regularly), add the token to the `ALLOWLIST`
     array near the top of
     `scripts/checks/double-space-sentence-separator/check.sh`. Use
     judgment: the allowlist is not the safety valve for individual
     sentences, only for tokens that appear repeatedly across the
     codebase.
   - **Keep as-is**: very rare. If the line is inside a code block
     or a fenced literal where the wrap rule does not apply, the
     gate's diff-scoped match is a false positive; either reshape
     the line so the period is not at the diff boundary, or leave
     it and accept the gate firing on this commit.

3. Re-run the gate to confirm clean exit:

   ```
   scripts/checks/run-all.sh --gate double-space-sentence-separator
   ```

4. Stage the changes. Wrapping is a tiny diff; fold it into whichever
   commit was about to land.

# Out of scope

- Re-wrapping pre-existing multi-sentence lines in files you did not
  otherwise touch. The gate is diff-scoped on purpose.
- Touching `scripts/checks/double-space-sentence-separator/`. The
  gate's own README and prompt name the pattern by example.
- Expanding the allowlist with one-off sentences. The allowlist is
  for tokens that appear repeatedly; one-off sentences get re-wrapped.
