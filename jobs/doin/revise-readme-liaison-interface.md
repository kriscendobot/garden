# Revise README.md to emphasize talking to the liaison, not what the liaison does internally

The maintainer wants the garden's top-level `README.md` reframed: **emphasize how a
maintainer talks to the liaison to effect various kinds of work** — the
conversation, the phrasings, the verbs — **rather than what the liaison does on
their behalf** (the dispatch mechanics, the roles, the skills). The latter is
documented in `roles/` and `skills/` that maintainers will rarely need to read; the
README should not re-teach it. Revise on `main2` (bot identity; isolated worktree off
`origin/main2` per the infra-job discipline). Direct push, no self-PR.

## The reframing

Keep the README's two-part shape but shift the second part's center of gravity from
*machinery* to *conversation*:

1. **Getting the garden running** — keep (the systemd bring-up, host-uniqueness,
   worker count, maintainer inbox, health checks). Trim only what is pure internals.

2. **Talking to the liaison** (the rewrite focus) — a maintainer-facing catalog of
   *what to say to get a kind of work done*, organized by **intent**, each entry
   showing an **example phrasing** and **what it effects** — not how. Cover the range
   of work the maintainer actually drives, e.g.:
   - "Please design X" / "spec X" → a design proposal for review
   - "Build the next phase of Y" / "finish #N as designed" → an implementation
   - "Fix / rebase / weave / retcon / refresh / shepherd #N" → the corresponding PR work
   - "Ferry #N upstream" → carries approved work upstream under your identity
   - "Fork repo Z" / "ingest Z into the library" → adopt a repo / scholar ingestion
   - "Merge #N" → conduct an approved PR onto its branch
   - reviewing on the PR itself (request changes / @-mention / a verb in a comment)
     as an equivalent surface to talking to the liaison
   - garden-meta requests ("encode this lesson", "fix the monitors", "pause services")
   Fold in the **verb primer** (run the gauntlet / rebase / retcon / refresh /
   shepherd / ferry) as the deterministic vocabulary, but lead with plain-language
   intent — the point is the maintainer should be able to *ask* without learning the
   role names.

3. **Move the internals out of the README.** The dispatch contract, the job-board
   internals, the role/skill enumeration, the per-service architecture — point to
   `CLAUDE.md`, `designs/`, and the `roles/`/`skills/` trees for the curious, but do
   not make the README a tour of them. A maintainer should be able to read the README
   and know *how to talk to the garden*, then stop.

## Notes

- Two equivalent surfaces, stated plainly: talk to the liaison in a `claude` session,
  **or** act on the pull request directly (review, comment a verb, @-mention) — the
  PR-comment watcher now turns those into the same work.
- House style per `roles/COMMON.md`. Keep it crisp; favor example phrasings over
  prose about mechanism.
- A fuller pass reflecting the newest services (journalist bulletin loop, proxy,
  foreman, cross-repo plan) can fold in as those settle; this job's mandate is the
  interaction-emphasis reframing.

## Definition of done

`README.md` revised so its through-line is *how to talk to the liaison to effect
work* (intent → phrasing → effect), with the internals demoted to references,
committed and pushed to `origin/main2` (bot identity). Report the SHA and a one-line
summary of the new structure. If blocked, report the diagnosis and ready-to-apply
content rather than claiming completion.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 18
  claimed_at: 2026-06-24T22:17:47Z
