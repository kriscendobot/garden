<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-02T09:52:26Z -->

---
model: fable
---
# Rewrite the garden README as a graduated usage tutorial

Rewrite the garden's top-level **`README.md`** (on `main2`) into a **comprehensive, graduated tutorial in
the USAGE of the garden**, from the point of view of a developer who wants to **quickly get it running**
and then **interact with it from each control surface**. **Mine common interactions from experience** with
each plane (read the roles/skills/journal, the actual workflows) to produce a *streamlined* tutorial — not
a feature dump.

**Voice:** terse, direct, to the point. May occasionally be funny. Graduated: getting-started first, then
each control surface, then "how it works" last.

## Introduction
- Open with the slogan: **"the garden mostly grows by itself, but to get what you want, you have to pull
  weeds"** (a.k.a. **you reap what you sow**).
- Frame the core idea: the **design→build workflow keeps the garden busy until every measure has been
  taken to anticipate the maintainer's feedback** — a broad set of automatic + agentic steps in an **OODA
  loop**. Note the **appellate** tunes the tail end of the loop (ensuring anything that *can* be done, gets
  done), and the **proxy** keeps agents busy when they'd otherwise pose a common judgment call to the
  maintainer that heuristics can readily anticipate.

## Getting started
- **Docker dependency** and how to enter with the **`./garden`** command.
- **Set up a bot GitHub account** like `kriscendobot`, and how to **put that bot account's SSH key into the
  garden's `.ssh` directory**.
- **Authenticating claude**: how to use `claude` to authenticate, and that this workflow is **most
  practiced with a Claude subscription, from inside the Docker container**.
- **Point at the workflow for obtaining a Personal Access Token** for the **GitHub Pages Bulletin**.
- **Key vocabulary for the Liaison** (the shorthand verbs — ferry, shepherd, judge, build, design, weave,
  retcon, conduct, promote/defer, etc.); focus on the ones a user actually reaches for.

## Control surfaces (interaction planes) — mine common interactions for each
1. The **claude CLI** (the liaison, in the container).
2. **GitHub issues and pull requests** (driving the garden by filing/commenting; @-mentions).
3. **The same for other repositories** (the fork model).
4. A **special permissioned claude CLI for ferrying** (the boatman / kriskowal-credentialed path — its
   preconditions and why it's separate).
5. The **bulletin GitHub Pages** (what it shows, replying to the liaison from it).

## How it works + accumulated design principles (at the very end)
- **self-healing, self-improvement, reflection.**
- the **growing context library** — its design for optimizing content for research and **token-efficient
  queries**.
- Two articles: **"The life of a pull request"** and **"The life of an issue"** — noting we use **separate
  pull requests for the design and build phases**.
- **Key user interactions with all the garden's services**: scheduling jobs, posting jobs, grooming the
  designs, the backlog, the milestone, and **calibrating time estimates and delivery dates**.
- The **new bidding mechanism**, and the **plans for the next metamorphosis** (which will improve the
  **bidding and indexing of jobs**).

## Constraints / mechanics
- Land on `main2` via an **isolated worktree off origin/main2** (the README is a shared root file — commit
  the explicit pathspec, push `HEAD:main2`).
- Ground every claim in the real garden (roles/, skills/, scripts/jobs/, designs/, the journal) — verify
  commands/paths exist before documenting them; don't invent. If it exceeds one cycle, land a coherent
  first pass and **post a follow-on** naming the remaining sections rather than truncating silently.
- Supersedes the standing "refresh the garden README once services settle" note.

---
claim:
  host: endolinbot2
  gardener: 2
  claimed_at: 2026-07-02T09:52:31Z
