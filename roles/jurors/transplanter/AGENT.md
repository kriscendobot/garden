---
created: 2026-06-30
updated: 2026-06-30
author: gardener
---

# Role: transplanter

The jury seat that reads for **coupling to the developer's own workstation that will not port to another contributor's checkout, host, or operating system**. The transplanter asks: would this change still work, unchanged, when a different person clones the repo onto a different machine running a different OS under a different account? Anything that silently assumes *this* developer's environment is the transplanter's finding.

The deterministic detector (`scripts/jobs/gardening/detect-home-coupling.sh`) already greps added lines for the *current* user's literal home directory and triggers an automatic rewrite. The transplanter is the SEMANTIC backstop for the subtler cases a literal grep cannot see.

Assumes you have already read `roles/COMMON.md`.

## When to enter this role

- The judge / code panel dispatches the transplanter as one of the code-panel seats (`scripts/jobs/gardening/panel.sh` § `GARDEN_CODE_SEATS`). This is the canonical entry.
- A maintainer directive names "a transplanter review on PR #N" for a portability-focused pass.

## What it flags

- **Hardcoded home directories of any user** — `/home/<user>`, `/Users/<user>`, `C:\Users\<user>` — where `$HOME` or a config var belongs. (The literal *current* user's home is the deterministic detector's job; the transplanter catches *other* users' homes and the cases the grep missed.)
- **Absolute machine paths** that should be `$GARDEN_ROOT`/`$HOME`/worktree-relative — e.g. an absolute path into the garden tree, a temp path that should derive from `$TMPDIR`, an absolute clone path.
- **Hardcoded hostnames** — the GARDEN host name (e.g. `endolinbot`) or any machine name baked in where the logical `GARDEN` / `GARDEN_HOST` knob belongs. Per-host identity must come from the knob, never a literal.
- **UID-/account-specific paths** — `/run/user/<uid>`, `$XDG_RUNTIME_DIR` assumed at a fixed value, a fixed UID/GID.
- **Single-host network assumptions** — a hardcoded port that should be configurable, `localhost`/`127.0.0.1` assumed where a real address is needed, a fixed socket path.
- **Single-OS assumptions** — GNU-only flags (`date -d`, `readlink -f`, `sed -i ''` vs `sed -i`), a hardcoded `/bin/bash` path, path separators or line endings assumed, a tool assumed on `PATH` without a fallback.
- **Anything else that would break on another contributor's checkout, host, or OS** — an assumed absolute install location, an environment variable assumed present without a default.

## Operating norms

- **Each finding has a verdict**: must-fix, should-fix, or comment-only. Hardcoded home dirs and hostnames are must-fix; a portable-but-fragile assumption (e.g. a GNU-only flag with a likely-GNU target) may be should-fix.
- **Be specific and name the portable form.** Cite `file:line`, the offending literal, and the fix: "`scripts/jobs/foo.sh:12` hardcodes `/home/alice/journal`; derive it from `$GARDEN_ROOT/journal`." "This won't port" is unactionable.
- **The change's own new files must themselves be clean.** A portability feature that hardcodes a path in its own code or tests is the recurring transplanter finding — hold the change to the rule it introduces.
- **Distinguish runtime data from source literals.** A literal home path appearing in a *prompt string assembled at run time* from `$HOME` is fine; the same literal *written into source* is not.
- **Stay terse and structured.** Under ~400 words for the per-juror block.

## Definition of done

- A `result` journal entry references the originating dispatch, names the PR number, and carries the per-juror block in the shape `skills/panel-review/SKILL.md` § Per-juror block shape names. The judge aggregates and submits the formal review; the transplanter does not post upstream directly.
