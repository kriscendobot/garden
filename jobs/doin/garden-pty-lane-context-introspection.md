---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder

# Experimental PTY lane with context-usage introspection

Build, against **this garden repo** (`kriscendobot/garden`, base `main2`), an
**experimental alternate execution lane** for a job: instead of running the
handler as a headless `claude -p`, run the session **enclosed in a pseudo-terminal**
so that Claude Code's status line actually fires — and use the status line as a
side channel that persists the session's context-window figures where the agent
itself can read them.

## Why

Claude Code hands the model's runtime a real context-window measurement in exactly
one place: the JSON blob it pipes to the `statusLine` command on stdin, carrying
`.context_window.{used_percentage,total_input_tokens,total_output_tokens}`. That
channel is normally write-only to the terminal and is **absent entirely under
`claude -p`** — which is precisely the population (the gardener fleet on long jobs)
whose context exhaustion we care about. Enclosing the session in a pty is what makes
the measurement exist at all; the persist-to-a-state-file trick is what makes it
readable by a skill or hook.

Prior art / the trick, from FUDCo (Chip Morningstar):
https://gist.github.com/FUDCo/8aeb2b0c60bd871c2e3b1d5f99b89631
Two steps: (1) a `statusLine` command script that prints the status line to stdout
*and* writes `used_percentage=` / `input_tokens=` / `output_tokens=` to a state file
outside the repo (in-tree would dirty `git status` on every refresh); (2) a skill or
hook that reads that state file.

## Requirements

1. **Opt-in, per job.** The pty lane is gated by explicit job frontmatter (pick a
   name in the existing style, e.g. `lane: pty`) and defaults **off**. The existing
   headless `claude -p` lane must be untouched for every job that does not opt in —
   no regression in claim, handler-timeout, requeue, or completion behavior.
2. **Per-lane state, keyed on the job.** ~20 gardeners run concurrently on a host and
   a single shared state file would be clobbered on every status-line refresh. Key
   the state file on the job — `GARDEN_JOB_BASE` is already exported through the
   worker spine and is the natural lane discriminator — so each concurrent session
   writes its own file. Site the files under `GARDEN_STATE`, not the repo, and make
   sure they are **cleaned up on job completion**: per-id journal clones under
   `GARDEN_STATE` have already wedged a host at zero free inodes twice, and an
   unpruned per-job file rewritten on every refresh is the same failure shape.
3. **Staleness must be detectable.** The state file carries at minimum a timestamp
   and the owning job base/session id, so a reader can tell "78% ten seconds ago"
   from a leftover file belonging to a session that ended yesterday. A reader that
   cannot prove freshness should treat the figure as absent rather than trust it.
4. **A reader.** Ship the consuming half too — the skill (or hook) a gardener uses to
   read its own lane's figure. Without it the lane persists numbers nobody reads.
   Keep the consumer's contract narrow and documented.
5. **Settings propagation is a known trap — solve it explicitly.** `statusLine` lives
   in `.claude/settings.json`, which is **gitignored and masked by the container's
   bind mount**, so the image cannot seed it (this is exactly why the container guard
   propagates via CLAUDE.md instead of a SessionStart hook — see CLAUDE.md
   § Container guard). Say in the PR how the lane's settings reach a worker session,
   and prefer a mechanism that does not depend on a human hand-editing a gitignored
   file on every host.
6. **Evidence.** Demonstrate the lane actually working: a real job (or a faithful
   stand-in) run through it, with the captured figure shown, plus two concurrent
   lanes proven not to clobber each other. State plainly what you did not verify.

## Deliverable — a PR, deliberately

Open this as a **pull request** against the garden repo. CLAUDE.md § Conventions says
the garden does not generally open PRs against itself; **the maintainer explicitly
asked for a PR here** (this is an experimental lane worth reviewing before it lands),
so this is an authorized deviation, not an oversight — do not "correct" it by landing
bare on `main2`. Use the [frozen-base-branch](skills/frozen-base-branch/SKILL.md)
mechanics the design-with-open-questions carve-out uses: snapshot the commit
immediately before your work as the base, put the change on a head branch, open the
PR against it.

Scope this as an **experiment**: a lane that can be tried and discarded, not a
rewrite of the worker spine. If the pty enclosure turns out to require invasive
changes to the spine, say so in the PR and stop at the smallest honest slice rather
than widening.

<!-- garden-transient-elapsed: kind=signature through=0 values=2 -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-03T01:30:21Z
