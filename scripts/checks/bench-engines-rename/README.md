# Gate: bench-engines-rename

Catches references to the (incorrect) `.bench-engines` path. Endo's
canonical path is `.engines`.

## What this gate catches

Any literal occurrence of `.bench-engines` anywhere in the tree
(source, tests, scripts, docs, YAML, JSON), excluding this gate's own
documentation under `scripts/checks/bench-engines-rename/`.

## The historical incident

On 2026-06-02 the steward attempted twice to rename `.engines` to
`.bench-engines` on PR #387 (kriskowal/endo-but-for-bots). The first
attempt landed and the second attempt followed before the maintainer
intervened; reverting the second cost a force-push. The discussion
that crystallized the wrong: `endojs/endo#3294` thread `r3342643104`.

The maintainer's reasoning, paraphrased: nothing limits us from using
the `engines` directory for non-bench workflows. Hyphenating the path
as `.bench-engines` conflates the directory with one of its workflows
and forecloses reuse.

## When the gate fires

The runner ships the agent the focused brief at
`scripts/checks/bench-engines-rename/prompt.md`. The brief tells the
agent to re-run the grep, replace `.bench-engines` with `.engines`
everywhere it appears (with a carve-out for this gate's own files),
and commit the reversal.

## How to disable

If a future project legitimately needs a `.bench-engines` directory
(rare; the maintainer's reasoning argues against it), the gate's
`check.sh` can be edited to add path exclusions, or the gate's
subdirectory can be moved out from under `scripts/checks/` so
`run-all.sh` no longer enumerates it.
