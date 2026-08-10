# Gate: double-space-sentence-separator

Catches newly added markdown / comment lines that contain a mid-line
sentence separator (`. ` or `.  ` followed by a capital letter),
violating the garden's sentence-per-line wrap rule.

## What this gate catches

Any line newly added in the diff against `GATE_BASE_REF` (default:
the merge-base against `main`) in a file matching
`*.md *.js *.mjs *.cjs *.ts *.tsx *.sh *.py` that, after a small
allowlist of legitimate `Xxx. Yyy` tokens, still contains the regex
`\.  ?[A-Z]`.

The gate is **diff-scoped on purpose.** Pre-existing multi-sentence
lines in the tree are out of scope; the rule applies only to changes
the diff introduces, so authors are not asked to relitigate prose
they did not write.

## The historical incident

The wrap rule is older than this gate; it lives in CONTRIBUTING /
style guides on the upstream `endojs/endo` repo. The pre-push driver does not
currently ship a sentence-per-line probe; this diff-scoped check is its
deterministic enforcement. The gate exists because PR #3 review `4414266979` (kriskowal,
2026-06-02) asked for pre-dispatch coverage of "common symptoms of
forgetting the line wrapping rules, like the introduction of `. ` or
`.  ` in a comment or markdown file." The worker's full-file checklist audit
and this gate are complementary: the audit catches old surrounding offenders
in a file being edited; this gate catches just the newly added offenders.

## Allowlist policy

The check script ships with a short allowlist of initialisms,
salutations, and abbreviations that legitimately appear as
`Xxx. Yyy` mid-line. The current set is enumerated in `check.sh`.

Adding to the allowlist is a judgment call:

- A token used **repeatedly across the codebase** (a new project
  initialism, a recurring abbreviation): add it.
- A token used in **one or two sentences**: re-wrap those sentences
  instead. Each one-off sentence is cheaper to re-wrap than to teach
  the gate about.

## When the gate fires

The runner ships the agent the focused brief at
`scripts/checks/double-space-sentence-separator/prompt.md`. The brief
tells the agent to re-run the gate, re-wrap each offender (default)
or extend the allowlist (rare).

## How to disable

If a project legitimately uses a different wrap convention (paragraph-
per-line rather than sentence-per-line), the gate's subdirectory can
be moved out from under `scripts/checks/` so `run-all.sh` no longer
enumerates it. Disabling for one PR while keeping it for others
requires a wrapper or a temporary commit; the gate is intentionally
global.
