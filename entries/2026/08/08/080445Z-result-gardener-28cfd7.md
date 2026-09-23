---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-08T08:04:48Z
---
kind: result
role: jurors/wire-watcher
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
pr: 970

Panel-2 code-panel seat `wire-watcher` on endojs/endo-but-for-bots PR #970
(`feat/ironhorse-262-language-completion`, head 75e9b5e02, diff base `llm`).

### wire-watcher

**Verdict:** request-changes

**Findings:**

- `rust/engine/ironhorse-snapshot/src/machine.rs:101,150` - `CAS_TMP_NAME` is the
  fixed name `.snapshot.tmp`. The peer this surface forks verb-for-verb
  (`rust/endo/xsnap/src/lib.rs:737-745`) uses a pid+sequence-unique name with a
  comment naming this exact hazard: "a fixed name would let two processes (or two
  machines in one process) snapshotting into a shared CAS directory interleave
  writes and corrupt each other". Two suspends into one `cas_dir` interleave: A's
  `File::create` is truncated by B, then A's `rename` at `machine.rs:154` publishes
  B's (or torn) bytes under `hash_A`, so the store holds a blob whose content is
  not its content hash. xsnap also removes the temp on a write error
  (`lib.rs:753`); `suspend_to_cas` leaks it. [rule: skills/panel-review/SKILL.md
  section Pitfalls, "Sibling-package forks miss recent peer fixes"]

- `machine.rs:215-224` - `resume_from_cas` opens `{cas_dir}/{sha256}` and feeds the
  bytes to `read_machine` without ever computing a digest. `Sha256` appears only on
  the write path (`machine.rs:127`); the sole digest comparison in the crate is
  inside a test (`machine.rs:379`). The CAS key is the only integrity claim for
  bytes that become live arenas, stack, and meter, and it is unchecked, so finding 1's
  corruption is undetectable. Verify before `image_to_interp`.
  [rule: roles/jurors/wire-watcher/AGENT.md section Check before trust]

- `machine.rs:221` - `cas_dir.join(sha256)` with no format validation. An absolute
  key replaces the whole path under `Path::join`; a `..` key escapes the store. Pin
  the key to 64 lowercase hex characters at the boundary.
  [rule: roles/jurors/wire-watcher/AGENT.md section Identifier discipline]

- `rust/engine/ironhorse-262/src/xst.rs:642` (new at HEAD) - `oracle_parse_rejected`
  now ORs in `oracle_negative_ok`, whose RangeError arm (`xst.rs:355`) returns true
  on an **empty** `oracle_error`. `oracle_host_aborted` (`xst.rs:561-562`) reads that
  same empty marker with the opposite meaning ("XS host-aborted, not a rejection").
  So for a `phase: parse, type: RangeError` negative, an XS host abort reads as a
  parse rejection and an ironhorse `Accepted` scores `Fail` - the oracle-limit
  misattribution ad5805a58 set out to close. Narrow the disjunct to the RegExp
  error-stub shape it was added for rather than any expected-type abort.
  [rule: roles/jurors/wire-watcher/AGENT.md section In-band-marker trust-bypass]

- `rust/engine/ironhorse-snapshot/src/atom.rs:78-97,126` - `parse_atoms` accepts
  repeated top-level tags and `find` takes the first; `AtomReader::parse` silently
  drops every byte past the envelope's declared `size`. The docstring at
  `atom.rs:103` asserts "the grammar has at most one of each top-level atom" but
  nothing enforces it, so `read_machine`'s `find(HEAP)` and any consumer walking
  `atoms()` can read one blob two ways. No test covers a duplicate tag or trailing
  bytes. [rule: roles/jurors/wire-watcher/AGENT.md section Parser divergence]

**Notes (out of scope but worth flagging):**

- `rust/engine/ironhorse-compile/src/parser.rs:1278` (new at HEAD) - the
  duplicate-`__proto__` early error fires inside `object_expression`, which is also
  the cover-grammar path for assignment patterns (`parser.rs:449` converts
  afterwards via `object_binding_from_expression`). ECMA-262 B.3.1 exempts an
  `ObjectAssignmentPattern`, so `({__proto__: a, __proto__: b} = obj)` and the
  arrow-parameter form should parse. The new test (`parser/tests.rs:272`) covers only
  must-fire cases. Not verified by execution: no cargo on this host.
  [rule: roles/jurors/wire-watcher/AGENT.md section Failure-mode test catalog]

- `rust/engine/ironhorse-snapshot/src/format.rs:158` - `Signature` is a version
  string compared for equality, not a MAC. The name reads as a cryptographic claim
  the type does not make. [proposed-rule: a type named `Signature` should carry an
  authentication claim, or be named for what it actually gates (for example
  `CallbackTableVersion`)]

Self-improvement: the wire-watcher brief should name the sibling-package-fork
check explicitly. Findings 1 and 2 came from diffing the new `ironhorse-snapshot`
CAS surface against the `xsnap` surface it advertises verb-for-verb parity with,
where the peer already carried the fix and a comment explaining it. That is
`skills/panel-review/SKILL.md` section Pitfalls today, not in the seat's inquiry
axes; adding "when the PR forks a peer's security-relevant surface, diff against
the peer for fixes that landed before the fork point" to the wire-watcher's
Operating norms would make it a first-class axis for this seat rather than a
pitfall a seat may or may not recall.
