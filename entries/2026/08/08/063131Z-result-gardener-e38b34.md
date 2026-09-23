---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-08T06:31:34Z
---
---
kind: result
role: purist
repo: endojs/endo-but-for-bots
project: endo
---

# purist — PR #969 (full-test262 sweep: JSON + static HTML report)

Diff base `origin/llm`, head `31450507c`. Read the whole diff in
`project-wt-ironhorse-full-test262-automation-gauntlet-panel-3-98bb3aed`.

**Verdict: request-changes**

## Findings

**1. must-fix — the run-identity gate is three gates with two different
leniency rules, and the disagreement wedges the sweep.**
`pending_batches_checked` (`src/report.rs:947-951`) treats an **unstamped**
batch (`run_id == ""`) as matching the expected identity, so it is never
pending. `aggregate_plan` (`src/report.rs:841`) rejects that same batch
(`"" != expected`). `command_validate` (`src/bin/ironhorse_262_report.rs:135`)
sides with `pending`. Failure scenario: a results dir holds one batch file
written before `--run-id` existed (or by a bare `ironhorse-xst --json`).
`full-run.sh` plans it as complete, the post-sweep completeness gate passes
with `remaining=0`, and then `aggregate --plan` warns and the CLI hard-fails
("refusing to publish"). Re-running never clears it: `plan` keeps reporting
zero pending. The operator gets an unrecoverable state and no message naming
the file to delete. One family, one rule: make all three treat "unstamped, but
an identity was expected" the same way (reject is the honest choice), or drop
the `!run_id.is_empty()` guard from `pending_batches_checked`.
[rule: `roles/jurors/purist/AGENT.md` § Family-consistency across related
symbols]

**2. must-fix — the identity binding fails open, and the doc comment claims it
does not.** `aggregate_plan` only enforces identity when
`provenance.run_id` is non-empty, and `read_provenance`
(`src/report.rs:685-697`) returns `Provenance::default()` on a missing or
unparseable file. So `aggregate --results DIR --plan FILE` with `--provenance`
omitted, misspelled, or truncated silently degrades to "merge every planned
batch, whatever it was stamped with" while the doc comment at
`src/report.rs:815-816` still asserts it "binds the report to the run
identity". Either require a non-empty `run_id` when `--plan` is given, or have
`read_provenance` distinguish absent (default) from unreadable (fatal).
[proposed-rule: a trust gate must fail closed; a gate that silently disables on
missing input is not a gate, and its doc comment must not claim otherwise]

**3. should-fix — `completion` and the whole-corpus claim are still unverified
operator strings, the exact class round-2 must-fix #4 removed.** The PR
correctly promoted `scope` / `oracle_mode` off the human `config` prose into
typed fields. Two claims did not make the trip. (a) `completion` is a literal
`"complete"` in the `full-run.sh` heredoc (`scripts/full-run.sh:282`) that
`to_html` renders verbatim (`src/report.rs:1037`); the aggregator already knows
the truth (it computed `warnings` and holds the plan) and should derive it
rather than echo it. (b) `scope` is set to `"whole-corpus"` purely from the
absence of `--subtree` (`scripts/full-run.sh:175`), so the lede publishes "The
complete authoritative TC39 test262 corpus" even when `test262_sha` is
`unknown`/`unverified` or `-dirty` — a partial export under `--test262-dir`
renders a full-corpus authority claim. Gate `is_whole_corpus()` on a verified
corpus identity too.
[proposed-rule: an authority claim in a published report is derived from a
verified fact, never from an operator-supplied field the emitter did not check]

**4. should-fix — the untrusted twins are retained for callers that do not
exist, and one of them is still a reachable CLI surface.** `report.rs` is new
in this PR, yet it ships `batch_json` alongside `batch_json_with_id`,
`pending_batches` alongside `pending_batches_checked`, and `aggregate`
alongside `aggregate_plan`, each documented as "legacy" / "unbound".
`batch_json` and `pending_batches` have zero non-test callers (grepped across
`rust/`); their only effect is to let tests exercise a shape production never
emits. `aggregate` is worse: `ironhorse-262-report aggregate` **without**
`--plan` (`src/bin/ironhorse_262_report.rs:184`) is a documented subcommand
that directory-globs the results dir — precisely the behavior must-fix #1 was
raised to remove — and it is the default when `--plan` is omitted. There is no
legacy to be compatible with. Collapse each pair to the strict member and make
`--plan` required.
[rule: `roles/jurors/purist/AGENT.md` § Minimum viable abstraction]

**5. should-fix — single-sourcing was applied to the cap and skipped for the
two other cross-language contracts it shares a drift class with.** Round-2
must-fix #2 single-sourced `BATCH_CASE_LIMIT` through `batch-size`, and the
code says so. But the *case predicate* is now written a third time:
`discover_into` (`src/report.rs:891-903`) re-implements `.js` + `is_file()` +
`_FIXTURE.js` + `staging/` rather than calling `collect_js_flat`, and its own
comment concedes it "mirrors `collect_js_flat`'s predicate exactly" — an
assertion nothing enforces except one corpus-dependent test that silently
returns when the subset is absent (`src/report.rs:1852-1857`). And
`batch_filename`'s `/`→`__` mapping is re-implemented in shell at
`scripts/full-run.sh:229`. Both are the same drift the cap fix closed: a
counter and a lister that must agree, and a name written on one side of a
language boundary and read on the other.
[rule: `roles/jurors/purist/AGENT.md` § Family-consistency across related
symbols]

**6. comment-only — derived data on the wire.** `to_json` emits
`cases[].category` (`src/report.rs:502`), but `case_from_yaml` ignores it and
re-derives via `classify`. Harmless today; it means a consumer reading
`report.json` and a consumer re-aggregating it can disagree the day `classify`
changes, with nothing flagging the skew. Either drop it or version it with the
schema string.

## Not flagged

Passability, frozen-prototype hygiene, and side-channel closure have no
surface here: this is a Rust reporting crate, nothing crosses a vat or endo
boundary, and no primordial is touched. `escape_html` and `json_str` cover
their contexts (the hostile-input round-trip at `src/report.rs:1321` is real
evidence, not a claim). No hand-rolled `@endo/*` primitive: hex/base64/bytes
are not in play, and the JSON emitter's no-serde choice is stated and matches
the sibling YAML emitter.

**Not verified:** I did not build or run the crate; every finding above is read
from the diff, and findings 1 and 2 are traced through the exact conditionals
cited rather than reproduced.

Self-improvement: the purist brief's inquiry axes are all ocap-shaped
(passability, frozen prototypes, side channels), so on a non-ocap diff like
this one the seat leans entirely on its three general axes (family-consistency,
minimum viable abstraction, invariant-claim integrity). That worked, but only
because those three happen to generalize. Worth a line in
`roles/jurors/purist/AGENT.md` § Operating norms saying so explicitly, so the
seat does not read a Rust/tooling diff as out of scope and return a thin block.
Sent as a message to `liaison`.
