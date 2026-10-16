---
role: builder
requires: host=endolin-garden-ece02cb4
arc: minion-town-mcp-ocapn
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Open the draft PR for the ocapn-tcp-syrup-framing status update (successor to endo-but-for-bots-ocapn-tcp-syrups-framing-build)

The predecessor builder job found that the ocapn-tcp-syrup-framing design had
already shipped on `llm` (`@endo/syrup-frame` at 38fe6787d; default syrup framing
on the `tcp-testing-only` netlayer at bdb9ddc50). Only the design doc's stale
"Not Started" header remained. It pushed a docs-only commit, but host
oros-studio-garden-ce242c49 cannot create PRs on endojs (PAT 403 on
createPullRequest), so this job only opens the PR.

Already pushed to endojs/endo-but-for-bots:
- frozen base `llm-61cd656` (= origin/llm 61cd656cb)
- head `docs/ocapn-tcp-syrup-framing-status` at c5bcbca27 (one commit, touching
  `designs/ocapn-tcp-syrup-framing.md` and `designs/README.md`)

Task: get a project checkout of that head with
`scripts/jobs/ensure-project-worktree.sh <this-job-base> endojs/endo-but-for-bots docs/ocapn-tcp-syrup-framing-status`,
cd there (the phase-evidence gate resolves design paths from cwd), save the PR
body below to a file, and run this command. Pass the PREDECESSOR's base as the
first argument so the `garden-job` marker stays the same:

    scripts/jobs/gardening/ensure-pr.sh endo-but-for-bots-ocapn-tcp-syrups-framing-build \
      endojs/endo-but-for-bots docs/ocapn-tcp-syrup-framing-status llm-61cd656 \
      --title 'docs(designs): mark ocapn-tcp-syrup-framing Complete and record what shipped' \
      --body-file <file>

Open the PR as a draft, then name it in your completion report so the gauntlet
is staged. Do not change the commit unless the head has drifted.

## PR body

## Description

This PR updates `designs/ocapn-tcp-syrup-framing.md`, whose header still says **Not Started**. The work shipped on `llm` on 2026-05-20:

- 38fe6787d added `@endo/syrup-frame`, the comma-less `<length>:<payload>` framer this design proposes.
- bdb9ddc50 made syrup framing the default for the `tcp-testing-only` netlayer. `makeTcpNetLayer({ framing })` defaults to `'syrup'`, so each `handleMessageData` call gets one whole message even when TCP splits a record across chunks. `packages/ocapn/test/netlayer-tcp-syrup.test.js` covers this.

The stale header caused an automated builder job for the M4 Networking milestone to be queued against a finished design. No feature code was left to write, so this docs-only PR records what shipped. That way the header matches `designs/README.md`, which already marks the design **Complete**.

Changes:

- **`designs/ocapn-tcp-syrup-framing.md`**: sets the status to Complete and adds an *Implementation Status* section. It covers the two departures from the design text:
  - The package is named `@endo/syrup-frame`, not `@endo/syrups`.
  - Framing went on the existing `tcp-testing-only` netlayer, with a `'none'` setting kept for the Python test suite. No separate `tcp-syrups` identifier was added.

  The section also lists the remaining pieces and where they belong: the chunk-loop removal waits on #242 and on ocapn-tcp-for-test-extraction, and Phase 4 is an upstream proposal.
- **`designs/README.md`**: corrects the M4 milestone row, which named a `tcp+syrups` identifier that was never built, and bumps the Updated date.

This overlaps with #741, which edits the old `designs/ocapn-tcp-syrups-framing.md` path. That file has since been renamed to `designs/ocapn-tcp-syrup-framing.md`, so #741 no longer applies cleanly there.

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: `designs/ocapn-tcp-syrup-framing.md`
Disposition: deliverable
Phase 1: satisfied | `@endo/syrup-frame` landed on `llm` at 38fe6787d with the ported netstring tests plus adversarial chunk-boundary tests (`packages/syrup-frame/test/syrup-frame.test.js`)
Phase 2: superseded | instead of netstring framing, bdb9ddc50 made syrup framing the default of `tcp-testing-only`, closing the chunk-boundary bug; `'none'` remains only for the Python suite (#242 moves that suite to syrup framing)
Phase 3: superseded | the comma-less framing shipped on the existing `tcp-testing-only` identifier (bdb9ddc50) rather than a new `tcp-syrups` identifier; two Endo peers round-trip over it in `packages/ocapn/test/netlayer-tcp-syrup.test.js`
Phase 4: not-applicable | the design marks the upstream OCapN proposal as opportunistic and outside Endo's roadmap
Acceptance: satisfied | `netlayer-tcp-syrup.test.js` asserts `<length>:<payload>` frames with no trailing comma on the wire and an end-to-end round trip; this PR records that evidence in the design doc
<!-- /garden-phase-evidence-ledger -->

### Security Considerations

None. This PR only changes documentation.

### Scaling Considerations

None.

### Documentation Considerations

The design index and the design doc now agree on the design's status and on the shipped package name.

### Testing Considerations

No code changed. Prettier passes on both files.

### Compatibility Considerations

None.

### Upgrade Considerations

None.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
