# Build a deterministic, silent-by-default local pre-PR verification harness (offload CI; hash-captured output)

Wear the **mentor** role. Expand the garden's ability to **automatically and deterministically
run local verification BEFORE submitting a change for a pull request** — format, lint, build,
test, and document-generation — so work is **offloaded from the CI server**, shepherding
sessions are shorter, and fewer tokens are spent on testing. Infrastructure on `main2` (bot
identity; isolated worktree off `origin/main2`; route scratch through `$GARDEN_SCRATCH`).

## Goal

A **deterministic, no-claude** harness a builder/fixer runs in the project worktree right before
pushing a PR change. If everything passes, the change is submitted with confidence and CI is far
more likely green on the first push (short or no shepherd loop). If a step fails, the failure is
**captured into the git content store** and only its **hash** is surfaced, so a debugging agent
inspects it selectively — never flooding context with raw test/build output.

## 1. The verification steps (deterministic, per-project)

Run, in order, the project's real commands for: **format → lint → build → test → document
generation**. Discover the actual commands per project/package (from `package.json` scripts, the
repo's CI workflow, and existing skills `pre-pr-checklist`/`pre-push-gates`), since they vary;
do not hardcode one project's commands. Default to running the project's full evaluation suite
(false positives fine, false negatives NOT — mirror the gardening-state-machine "evaluation gate
(always)" discipline). No LLM in this harness — pure shell + the project's commands.

## 2. Silent by default + git-content-store failure capture (the token-efficiency core)

For each step:
- Run it, capturing **combined stdout+stderr** to a temp file.
- **`git hash-object -w <file>`** the output into the project worktree's object store → a blob
  SHA (content-addressed, immutable, inspectable, tiny to pass around).
- **On SUCCESS: emit nothing** (silent) — record the step passed; the blob can be discarded/GC'd.
- **On FAILURE: emit only** `STEP <name> FAILED — output blob <sha>` plus a one-line tail, and
  hand the **SHA** to the caller — NOT the full output.
- The **debugging agent contract**: given the blob SHA, inspect selectively with
  `git cat-file -p <sha> | tail/grep/sed/cat` (the failing test, the first error, the relevant
  hunk) — reading only what it needs into context. Document this contract so debugging agents use
  it (generalizes the gardening-state-machine's diverted `GARDEN_TRACE` and the
  `prompt-on-failure-capture` skill; reuse/extend a shared capture helper from the
  `audit-self-healing-wrappers` work if it has landed).

## 3. Integrate into the pre-PR flow (offload CI)

- Wire the harness into the **gardening state machine's evaluation gate** (`scripts/jobs/gardening/`)
  and the builder/fixer pre-push path, so a change is locally pre-verified before the PR push.
- On a failure, run the **capture → hash → debugging-agent → fix → re-verify loop** locally until
  green (or escalate), so CI sees a pre-vetted change. The shepherd's job shrinks to confirming CI,
  not discovering failures.
- Make it a single entry point (e.g. `scripts/jobs/gardening/local-verify.sh <worktree>`) callable
  by roles and testable in isolation.

## Tests & verification

- A passing run emits **nothing**; a failing step emits **only** the step name + a blob SHA (no raw
  output), and `git cat-file -p <sha>` returns the captured output. Steps are discovered correctly
  for a sample package. The harness is deterministic and re-runnable. `shellcheck`/`bash -n` clean.

## Definition of done

A deterministic local pre-PR verification harness (format/lint/build/test/docgen), silent on
success, git-hash-capturing failures for selective debugging-agent inspection, wired into the
gardening/pre-push flow to offload CI — committed/pushed to `origin/main2`. Report the SHA, the
entry point + per-step discovery, the capture/inspect contract, and how it plugs into the
shepherd/builder flow. If blocked, report diagnosis + ready-to-apply change.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 89
  claimed_at: 2026-06-25T18:40:20Z
