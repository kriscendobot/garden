# Research the garden's evolution and write HISTORY.md

Research the history of how the garden evolved and write **`HISTORY.md` at the
garden root** (on `main2`, bot identity) describing each stage of its metamorphosis.
Do thorough research first; ground every claim in evidence (commit SHAs, dates,
design docs, journal entries) and **flag any stage you cannot substantiate rather
than inventing detail.** Wear the **journalist** role (`roles/journalist/AGENT.md`)
for the narrative voice; this is a research-heavy writing task.

## The metamorphosis arc (authoritative spine — from the maintainer)

Use these as the ordered stages; fill each with researched evidence, dates, and
architectural detail:

1. **Genesis — the shepherd.** It began with a **shepherd skill for getting CI to
   pass for a pull request**. The garden's earliest capability was driving a PR's CI
   to green.
2. **Containment — Docker + a bot identity.** Later stages introduced a **Docker
   container and a bot account on GitHub** so the garden could run freely with
   **minimal risk of escaping containment**. This involved **eliminating public pull
   requests and issues on the repositories the bot monitors** (the prompt-injection /
   monitoring-safety posture), which led to a **general preference to work on the
   garden's own forks** of other repositories.
3. **Supervision — many sessions under tmux.** A phase where **multiple Claude
   sessions were supervised under tmux** on an **always-online server**.
4. **Metamorphosis — automation between layers of cognition.** The most recent
   pivot: a **hybrid of automation sandwiched between two layers of cognition** — an
   **outer layer for self-improvement** and an **inner layer for doing the work**.

## Where to research (mine these; cite what you find)

- **Git history across branches:** `git log` on `main`, `main2`, `journal`,
  `journal2`, and the archived **`journal-v1`** branch. The commit timeline is the
  backbone — date each stage from first-appearance commits.
- **The v1 corpus** still in the `v1/` worktree: `v1/README.md`, `v1/CLAUDE.md`,
  `v1/WORKTREES.md`, `v1/proposal.md`, and the v1 `roles/`/`skills/` (the genesis
  shepherd skill/role, the monitor and monitoring-safety posture, the boatman /
  own-fork preference).
- **The design corpus:** `designs/job-board.md`, `designs/gardening-state-machine.md`,
  `designs/driver.md`, `designs/v1-migration-manifest.md` — each marks an
  architectural phase; the **gardening-state-machine** design is the clearest
  articulation of stage 4 ("automation that shells out to `claude -p` only for
  decisions").
- **Role/skill genesis & evolution:** when shepherd, monitor, boatman, steward,
  gardener, mentor, triager, watchman first appear; the retirement of the steward
  and general-contractor; the gardener fleet + job board (v2).
- **The constraints that shaped containment:** `CLAUDE.md` § Monitoring safety
  constraint, the bot identities (`kriscendobot`, `endolinbot`), the
  `garden` Docker script, and `endojs/endo-but-for-bots` as the owned fork.

## Anchors for the stages (verify, do not assume)

- Stage 1 ↔ the shepherd skill/role (drive CI to green).
- Stage 2 ↔ Docker `garden` script + bot accounts + the monitoring-safety constraint
  + own-fork preference (`endo-but-for-bots`, the boatman ferry model).
- Stage 3 ↔ the tmux-supervised multi-session era on an always-online host (find the
  evidence in journal/git history; if thin, say so).
- Stage 4 ↔ the `journal2` job board + message bus + the **gardener fleet** (inner
  work layer) sandwiched under the **self-improvement layer** (mentor / watchman /
  gardener meta-evolution). Cross-reference `designs/job-board.md` and
  `designs/gardening-state-machine.md`.

## Style & shape

- One clearly-titled section per stage: what it was, what prompted the change from
  the prior stage, what the architecture/workflow looked like, the key artifacts,
  and an approximate date range from the commit timeline.
- A short opening that frames the garden as a system that has repeatedly
  re-architected itself, and a closing that names the current (stage-4) shape and
  what is still in flight.
- House style per `roles/COMMON.md` (em-dash, no Latin shorthand, relative paths).
- Link to the in-repo evidence (design docs, role files) with relative paths so a
  reader can follow the trail.

## Definition of done

`HISTORY.md` committed and pushed to `origin/main2` under the bot identity (garden
convention: direct push for the garden's own docs, no self-PR), with each of the
four metamorphosis stages substantiated from the repo's own history. Report the SHA
and a one-paragraph summary, and call out any stage where the evidence was thin so
the maintainer can fill the gap. If a write/push is blocked, report the diagnosis
and the ready-to-apply file rather than claiming completion.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 65
  claimed_at: 2026-06-24T19:49:57Z
