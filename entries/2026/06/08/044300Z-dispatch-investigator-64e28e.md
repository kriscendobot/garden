---
ts: 2026-06-08T04:43:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: investigator
dispatch_root: /home/kris/dispatches/investigator--64e28e
prs:
  - repo: endojs/endo-but-for-bots
    pr: 106
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/106
  - https://github.com/endojs/endo-but-for-bots/pull/106#issuecomment-4445655934
---

# dispatch: investigator — Browser exo profile/persona partitioning per kriskowal directive (RSVP)

User RSVP directive (2026-06-08T04:42Z) on `endojs/endo-but-for-
bots#106` comment 4445655934 (kriskowal, 2026-05-13T22:22:37Z):

> Please investigate whether the Browser exo, driving Playwright,
> can emit browsers that control partitioned profiles or personas,
> such that browser exos do not share cookies or history.

PR #106 is `feat(daemon): Browser exo with structural origin
allowlist`, source-touching (12 files), base `llm`, head
`feat/endoclaw-browser` at `709ffed`, CHANGES_REQUESTED.

## Task

In your `project/` worktree on `feat/endoclaw-browser`:

1. **Read the existing Browser exo implementation** (the PR's
   diff against `llm` is the surface). Understand how the exo
   currently constructs Playwright instances. Files likely
   include `packages/daemon/src/browser*.js`, `packages/daemon/
   src/playwright*.js`, or wherever the exo is wired.
2. **Investigate Playwright's profile/persona-partitioning
   mechanisms**:
   - `browserContext` — Playwright's primary isolation
     primitive; each context has its own cookies, storage,
     cache, but shares the browser process.
   - `launchPersistentContext` — uses a user-data directory; the
     directory is the persona's persistent state. Distinct
     directories partition state across runs.
   - `userDataDir` argument — separates browser profiles at the
     OS level.
   - Cross-browser-instance isolation — separate Playwright
     `launch` calls produce independent browser processes with
     independent state.
3. **Map each mechanism to the Browser exo's shape**: which is
   the most natural fit for "browser exos do not share cookies
   or history"? Consider:
   - One-exo-one-context: each exo holds a `BrowserContext`;
     the shared browser process is the daemon's. Lightweight
     but the contexts may leak metadata (process-shared
     features, GPU state, etc.).
   - One-exo-one-persistent-context: each exo has its own
     user-data directory. Heavier but the persistence is
     stronger.
   - One-exo-one-browser-process: full isolation including
     process. Heaviest; suitable for high-trust separation.
4. **Surface trade-offs** in your investigation result:
   resource cost (RAM, file descriptors, disk), isolation
   strength (cookies, storage, GPU, hardware fingerprint),
   API surface impact on the existing exo design.
5. **Reply on PR #106** with a synthesis comment: name the
   mechanism(s) Playwright provides, the recommended fit for
   the Browser exo's structural-origin-allowlist shape, and
   any out-of-scope implications (daemon-side state directory
   layout, persistence-revocation discipline). The reply is
   the visible answer to the maintainer's investigation ask.
6. **Write a `result` journal entry** with the per-mechanism
   findings, the recommendation, and any follow-up items (e.g.,
   a builder dispatch to implement the chosen partitioning
   mechanism in the Browser exo).

## Authorizations (per-action, forwarded by steward)

- **Read Playwright's documentation** and the bot fork's
  existing Browser exo source. No code change.
- **Post a reply comment** on PR #106 with the investigation
  findings (`endo-but-for-bots` standing broad-comment
  authorization).
- **No code changes**: investigator's deliverable is the journal
  result + the reply comment; any concrete implementation hands
  off to a follow-on builder dispatch.

## Out of scope

- Do NOT modify the Browser exo's implementation; surface the
  recommended change for a follow-on builder.
- Do NOT touch other PRs.
- Do NOT trigger panel/judge.

## Deliverable

A `result` entry under `journal/entries/2026/06/08/` naming:

- The Playwright partitioning mechanisms (with one-line
  description each).
- The recommendation for the Browser exo's shape.
- Resource/isolation trade-offs.
- The reply-comment URL.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator.
The orchestrator tears down your dispatch root on return.
