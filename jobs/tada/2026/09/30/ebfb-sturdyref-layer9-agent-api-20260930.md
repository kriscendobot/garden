I've opened the layer-9 design as a new draft PR, endojs/endo-but-for-bots#1399, and posted the build plan and #871's disposition options on #695 and on arc kriscendobot/garden#47. I did not close or change #871.

**The design** (`designs/sturdyref-agent-api.md`, plus one row in `designs/README.md`) takes a new PR instead of new commits on #695. #695's branch is based on `llm-387ea66` and built on the old `'sturdyref'` record from #737, so stacking on layer 8 (#1398) shows only the change against the real substrate. The PR's base is a new frozen snapshot of layer 8, `build/sturdyref-daemon-formula-1d4d84b`, and the body carries the layer 1–9 stack index.

The design proposes three changes to the daemon's Agent API:
- **Produce:** a formula-creating method called without a pet name returns a SturdyRef instead of a live value, and the formula is only started when someone enlivens the ref. Calls with a name behave as today.
- **Accept:** any argument that names an existing formula also takes a SturdyRef. A ref from another peer is accepted only where a live value already is.
- **Retain:** sending a ref to a worker records that the worker keeps the formula alive; the worker dropping the ref (via GC) or terminating releases it. The daemon keeps one ref per formula so the release is counted correctly.

It also has a table saying what happens to each part of #695, a 5-commit build plan, and 5 open questions.

**One thing I found while writing it:** the retention part won't work on today's code. The daemon's worker connections never notice when a worker's GC drops a reference (`@endo/captp`'s `gcImports` defaults to off, and the daemon keeps that default). The design calls for a small CapTP option that does this only for SturdyRefs. Whether it lands on layer 5 (#1394) or in the layer-9 build is open question 5.

**#871, recommendation: close as superseded**, after carrying its escrow test (`sturdyref-escrow.test.js`) into a tool-layer follow-up. It is the top of the old bridge stack (#737 → #541 → #698 → #700–#704), and its only commits of its own are the `@endo/agent-tools` escrow and its wiring in lal/fae/genie. Rebasing it onto layer 8 isn't viable because everything under it is replaced.

**The deciding question for #871** (open question 4): should the Lal/Fae/agent-tools handling be its own follow-up design on top of layer 9, or part of the layer-9 build? If it's separate, close #871. If it's part of the build, its escrow commit gets rewritten as the build's last commit.

**Follow-ups:**
- Once the maintainer answers the open questions, a layer-9 build PR should be posted on top of #1399.
- The design is a first round: I did not run a panel review on it.
- The maintainer still has to decide on closing the old bridge PRs and #871.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer9-agent-api-20260930.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1894754 cached reads)
- Output: 19959 tokens
- Cost: $1.4621227999999997
- Wall-clock: 243s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
