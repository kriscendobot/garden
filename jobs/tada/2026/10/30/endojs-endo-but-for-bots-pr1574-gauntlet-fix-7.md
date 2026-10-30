Fix round 7 for endojs/endo-but-for-bots#1574 is pushed, and CI is green (30 checks, 0 failed).

No deterministic pre-pass block was attached, so I worked from the latest panel verdict, review 5711780453 ("Must-fix before merge": skeptic, decomplector, ergonomist, copyeditor, thesaurus, pruner). The changes are in commit `22f68da58e` on `design/api-key-agent-workbench`, pushed with `safe-push-pr-head.sh` as a fast-forward from `02a43f6ed5`. It touches `designs/api-key-agent-workbench.md` and `designs/README.md`.

**The one hard must-fix (decomplector): the read-only workbench.**
- I checked the base code first, and the reviewer is right. `provideSubMount(mount, path, name, { readOnly: true })` in `interfaces.js`/`host.js` already returns a durable read-only mount that can still be searched. `readOnly()` is the only thing that cuts it down to a plain listing view.
- I removed the companion facet `endowments/workbench-read` and the future `readOnlySearchable()` from the design. The workbench's mount is now derived with `provideSubMount`; a read tier passes `readOnly: true`.
- Children get a narrower workbench through a new `E(workbench).narrow(subpath, { readOnly })` method.

**Skeptic**
- **Reserve pause:** the design now says how it is undone. `resume()` always succeeds. If the parent is still inside its reserve, the subagent waits for budget instead of being paused again. Pausing the whole child subtree, including innocent siblings, is stated as deliberate.
- **W3 gate:** W3 does not start until the provider design (#1543) on `llm` names the per-owner single-vat admission queue. The W3 builder records the commit it checked.
- **Unverified claims:** the daemon's exclusive state-directory lock is now listed as unverified. A new "Gating checks" step runs before every phase, replacing the old checks that sat inside W2.
- **Open question 6 (spending another agent's grant by forwarding it)** now gates acceptance, alongside question 3.
- **Minimum budget:** a spawner needs at least four worst-case reservations; below that it is refused with `budget-below-minimum`.
- **Tests added:** resume after a reserve pause, the 72-hour bound under a reserve pause, replacing a workbench while a turn is running, and W6 step 5 recording browser and receipt observations rather than API return values.

**Ergonomist**
- One noun throughout: `SubagentControl`, `SubagentSummary`, `listSubagents`.
- `SubagentSummary` is now a discriminated union, so impossible state combinations can't be written.
- On a revoked subagent, `pause`, `resume` and `revoke` are no-ops; only `resize` throws.
- The tool descriptions now say "inherit" for `spawn` and "keep" for `resize`. A `budget` passed to `resize` is taken whole.
- The UI shows one **Remove** action for every endowment, which hides the two-verbs-to-add, one-to-remove asymmetry.
- The owner's subagent tree is cross-referenced, and `glorp` is described as "glob plus grep".

**Copyeditor**
- "The provider design" now names #1543 wherever "parent" meant the design rather than a parent agent.
- "Clip" is defined where it first appears.
- I fixed the line 207 sentence and the two grammar slips.
- The README's W6 row now says W6 spans minion.town and Endo, matching the design.

**Pruner and thesaurus**
- Cut the repeated "unverified" asides, the repeated note about the provider-design edit, the restatements of forwarded authority, the narration of the reuse table, and the duplicate refusal table.
- Moved the "why pause is a state" rationale into Design Decisions and trimmed that list to the entries that add something.
- PR body: removed the "seams" metaphor and cut it from 399 to 249 words.

**Follow-up:** the companion minion.town design (kriscendobot/minion.town#228) may still use the old names `DelegationControl` and `DelegationSummary`, and may still refer to the removed `workbench-read` companion. It should be updated to match.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1574-gauntlet-fix-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (2593510 cached reads)
- Output: 26877 tokens
- Cost: $2.015394
- Wall-clock: 808s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
