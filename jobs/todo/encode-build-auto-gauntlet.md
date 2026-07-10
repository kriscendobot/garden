# Encode: a build job auto-runs the gauntlet — make it airtight and liaison-legible

**Garden's own repo** (`kriskowal/garden`, `main2`): build in an isolated
worktree off `origin/main2` and push directly, no PR (garden-infra convention;
precedent `journal/jobs/tada/issue-kriskowal-garden-13.md`).

## Why

The maintainer's standing directive (2026-07-10): **"Builder should always
automatically hand off to gauntlet."** This is *already* the design — a `build`
job is the opening stage of the gauntlet, and the supervising gardener runs the
gardening state machine (`scripts/jobs/gardening/garden-pr.sh` + `panel.sh`, which
terminates by un-drafting on a clean panel). See `roles/builder/AGENT.md` lines 9
& 42 and `roles/gardener/AGENT.md` lines 23-24.

The gap is **not** the builder/gardener behavior; it is that the **liaison**
misrepresented it to the maintainer — telling them a build "won't auto-run the
gauntlet" and that they must separately say *run the gauntlet #N*. Close that gap
so the liaison never again tells a user to manually gauntlet a build-produced PR.

## What to change

1. **Liaison brief (`roles/liaison/AGENT.md`)** and, if it clarifies the
   vocabulary, the **`run the gauntlet` / `build` rows** context (README § Key
   vocabulary and/or CLAUDE.md § Orchestrator vocabulary): make explicit that
   - a **`build`** job (and a **design→build**) **already carries its PR through
     the gauntlet automatically** under the supervising gardener — no separate
     dispatch is needed;
   - **`run the gauntlet #N`** is for a PR that did **not** come through a build
     job (e.g. a maintainer-authored PR, or a probe the maintainer now wants
     promoted), or to **re-run** the chain on demand — it is not a required
     follow-up to a build.
2. **Preserve the one genuine exception explicitly:** a **probe**
   (`gap-revealing-build`, triager `probe #N`) is a DRAFT PR that **stays draft**
   — the cleaner/panel/fixer/un-draft chain deliberately does **not** run. The
   "always hand off to gauntlet" invariant is for **mergeable-feature** builds,
   not probes. Word the encoding so it cannot be read as forcing a probe through
   the gauntlet.
3. Keep it tight — this is a clarification of existing behavior, not new
   machinery. Do not add a redundant auto-gauntlet mechanism; the state machine
   already does it. If, while reading the scripts, you find the auto-handoff is
   actually **not** wired for some build path (a real behavioral gap, not just a
   doc gap), stop and report that up as a `message` to `liaison` rather than
   papering it with prose.

## Skills

- [self-improvement](../../skills/self-improvement/SKILL.md),
  [context-library](../../skills/context-library/SKILL.md),
  [em-dash-style](../../skills/em-dash-style/SKILL.md),
  [no-latin-shorthand](../../skills/no-latin-shorthand/SKILL.md),
  [relative-paths](../../skills/relative-paths/SKILL.md).

## Done

The liaison brief (and vocabulary context, if touched) state plainly that a build
job auto-runs the gauntlet and that `run the gauntlet #N` is for non-build-produced
or on-demand re-runs, with the probe exception preserved. Committed and pushed to
`main2`. The `tada` report gives the SHA, the files touched, and — if any build
path was found to NOT actually auto-gauntlet — the behavioral gap raised to
`liaison`.
