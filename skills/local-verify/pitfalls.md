# local-verify — pitfalls

Reference companion to [SKILL.md](SKILL.md). The recurring gotchas, distilled from
[field-notes.md](field-notes.md). Consult on demand when a run behaves surprisingly.

- **A project's `format` (no check variant) mutates the tree.** When only the
  mutating `format` script exists, the harness runs it; the auto-fix lands in the
  working tree like the style gate's — and the codegen-then-clean gate then fails,
  since any dirtiness (not just a codegen regen) trips it. That is the intended
  discipline: an unformatted or unregenerated commit is caught locally and the
  supervising agent commits the change. Prefer a `format:check` script where the
  project offers one; the candidate order already favors it.
- **Per-project specialization belongs in the project's scripts**, not the
  harness. The harness is the contract; the project's `package.json` scripts
  implement. Extend the candidate table for a new script name rather than
  branching on a project.
- **Do not inline a failure log into a prompt.** The whole point is the SHA: pass
  it, inspect slices. A debugging agent that `cat-file`s the whole blob into
  context has defeated the harness. See
  [debugging-contract.md](debugging-contract.md).
- **Every step failing with the *same* one-line tail is one environment failure,
  not N defects.** The steps are independent checks of independent things; they
  do not fail in unison over a real change. When the tails match — especially
  when the message is a *usage* error from the package runner rather than an
  assertion — the harness never reached the project's checks at all. Fix the
  environment (see the warm-cache field note), then re-run for a real
  verdict; do not start fixing the code. The harness now makes this call itself
  and says `ENVIRONMENT FAULT` (SKILL.md § Output), so this pitfall is the reasoning
  behind that line rather than a judgement left to the reader — but the
  detection is deliberately conservative (identical output from *different*
  commands), so a runner that varies its refusal per step still lands here.
- **Confirm you are running the harness you think you are.** The deployed root
  checkout advances only by a deliberate drained deploy, so it can lag `main2` by
  days (CLAUDE.md § Deliberate deploy). A divergence whose fix is already
  described in the field notes is the tell; `diff` the deployed
  `scripts/jobs/gardening/local-verify.sh` against `main2`'s before re-diagnosing
  it as new.
