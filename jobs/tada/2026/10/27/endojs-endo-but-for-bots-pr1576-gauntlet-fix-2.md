Fix round 2 for endojs/endo-but-for-bots#1576 is applied and pushed, and CI is green: `ci-wait-merge` returned rc 0 with 30 checks and 0 failures.

**What I fixed:** I worked from the latest panel verdict, review 5667492749 on head `bcf5e1eb`. All edits are in `designs/hardened-text-codecs-shim.md`.

- **Permits table (must-fix: ergonomist, copyeditor, archivist, pedant; should-fix: novice, decomplector):** restored the missing `|---|---|---|---|` delimiter row, so the table renders again.
- **Execution-boundary evidence (must-fix: skeptic, decomplector):** the audit no longer treats a Node-builtin import as proof that a module runs in the start compartment. I rewrote the criterion to say such imports show what authority a module needs, not where it runs. I added a **Loaders** subsection based on reading the code:
  - **Daemon worker (`worker.js`):** confined caplets load through `parseArchive` with a fixed globals list (`assert`, `console`, `E`, `Far`, `makeExo`, `M`, `TextEncoder`, `TextDecoder`, `URL`) and no exit modules. So they get neither `Buffer` nor any Node builtin.
  - **Other in-repo compartment loaders:** import-bundle, agent-tools code-mode, Fae, preact-container, thixotrope and exo-npm take endowments from their callers or pass `modules: {}`. No caller in `packages/*/src` endows `Buffer` or grants a Node builtin.
  - **Unconfined caplets, the CLI and the daemon's Node powers** load through Node's own loader.
- **Per-site sources:** each of the 22 sites now records where its `Buffer` comes from: the host global, an import of `node:buffer`, or a socket chunk from `node:net`. None of the in-repo compartments supplies any of these, so all 22 can only run in the start compartment. I also stated the scope limit: a compartment built outside the repo could grant `Buffer`, and it would then have the codecs available to migrate to.
- **Status section (should-fix: novice):** split "Remaining items" into "Completed follow-up" (the Phase 3 audit) and "Open items".

**Change:** one follow-up commit, `6b5f262545` ("docs(designs): ground the codecs audit in loader evidence"). It was pushed with `safe-push-pr-head.sh` as a fast-forward from `bcf5e1ebe6`, and Prettier passes on the file.

**Follow-ups:** none from this stage. I did not re-run the panel; the gauntlet driver re-posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1576-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1539763 cached reads)
- Output: 10621 tokens
- Cost: $1.0792606
- Wall-clock: 763s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
