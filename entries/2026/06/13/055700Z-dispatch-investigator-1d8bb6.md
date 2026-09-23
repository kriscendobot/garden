---
ts: 2026-06-13T05:57:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: investigator
dispatch_root: /home/kris/dispatches/investigator--1d8bb6
prs:
  - repo: endojs/endo-but-for-bots
    pr: 438
    role: predecessor
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/438
  - https://github.com/endojs/endo-but-for-bots/pull/438#issuecomment-4697671329
---

# dispatch: investigator — isolate the tsgo Go-runtime panic per kriskowal directive

Maintainer directive (kriskowal on PR #438 at
2026-06-13T05:55Z, issue comment `4697671329`):

> Please also, separately, dispatch an agent to isolate the
> tsgo defect and report through the journal.

This is a journal-only investigation. The output is a
report suitable for filing as an upstream
`microsoft/typescript-go` (or equivalent) issue.

## Context

PR #438 introduced a tsgo-based migration. The unified
`typecheck-all` script crashes with a Go runtime panic on
tsgo `7.0.0-dev.20260611.2`. The per-package
`typecheck-packages` does NOT panic — only the unified
check does. The crash signature is in tsgo's "relater"
(per the builder's diagnosis at
`journal/entries/2026/06/12/052621Z-result-builder-4ef77c.md`).

The parallel fixer dispatch `6beb46` is pinning a
known-good earlier nightly as a tactical workaround. This
investigator's job is the structural understanding +
minimal reproduction.

## Task

In your `project/` worktree at endo-but-for-bots master
(`4a04d078b`):

1. **Reproduce the panic locally**:
   - Install `@typescript/native-preview@7.0.0-dev.20260611.2`
     globally or in a workspace.
   - Run `tsgo --noEmit -p tsconfig.json` (or whatever
     `typecheck-all` invokes) against the project.
   - Capture the full Go panic stack trace.
2. **Bisect the failing input**:
   - Start with the full project tree. Confirm the panic.
   - Reduce: exclude packages from `tsconfig.json`'s
     include set one at a time until the panic disappears.
     Note which package, when excluded, makes the panic go
     away. That's the "trigger" package.
   - Within the trigger package, narrow further: exclude
     files until the smallest input that still panics is
     identified.
   - Within the smallest file, narrow to the smallest
     source construct that triggers the panic.
3. **Produce a minimal reproduction**:
   - A small standalone `.ts`/`.js` file (or pair of files
     if cross-module is required) that triggers the panic.
   - The exact tsgo invocation.
   - The full panic stack trace.
4. **Identify candidate root causes**:
   - Read the panic stack trace; identify the Go function
     that panics (the "relater" per builder's diagnosis).
   - Examine the source construct that triggers — is it a
     specific JSDoc shape? A type-import chain? A
     re-export pattern? A specific TypeScript feature?
   - Hypothesize what tsgo's relater is mishandling.
5. **Write a journal report** suitable for filing upstream.
   Include:
   - Title: "tsgo Go-runtime panic on relater when
     <minimal-trigger-description>" (or similar).
   - Reproduction steps (the bisected minimal repro).
   - Panic stack trace (verbatim).
   - Hypothesis on the root cause.
   - Why this matters for our project (workaround in place;
     unified-check capability blocked).

## Authorizations

- **Read-only on the project**. No commits, no pushes to
  the bot fork.
- **Write the investigation report to the journal**
  (under `journal/entries/2026/06/13/`).
- **Do NOT post to PR #438** — the fixer handles
  PR-side comms. Your output is journal-only.
- **Do NOT file the upstream issue yourself**; the report
  is for the maintainer to file (or to authorize a future
  boatman dispatch).

## Out of scope

- Do NOT try to fix tsgo itself.
- Do NOT touch the project source.
- Do NOT report inside PR #438.

## Deliverable

A `result` entry under `journal/entries/2026/06/13/` naming:

- Reproduction: minimal failing input + tsgo invocation.
- Panic stack trace.
- Bisect path: from full project → trigger package →
  trigger file → trigger construct.
- Hypothesis on root cause.
- An "upstream issue draft" section (title + body suitable
  for filing).
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
