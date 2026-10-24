---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Fix depcheck `build` on ubuntu-26.04: graphviz `tred` missing

Repo: endojs/endo-but-for-bots, base `llm` (open a PR against the current `llm`; PRs on frozen `llm-*` bases will need a weave afterward).

Since `ubuntu-latest` moved to the ubuntu-26.04 image (first failure about 2026-10-23T11:47Z), the `build` job in `.github/workflows/depcheck.yml` ("Test project mutual dependency versions") fails on EVERY PR that touches packages. The job runs `sudo apt install -y graphviz`, which installs graphviz 14.1.2 and provides `dot`, but then `scripts/check-dependency-cycles.sh 0` → `scripts/graph.sh` line 32 fails with `tred: command not found` (exit 127). On ubuntu-24.04 (graphviz 2.42) the same job passed.

Evidence: job https://github.com/endojs/endo-but-for-bots/actions/runs/40060852432/job/120773874012 (PR #1545). Earlier failures in runs 39962424431, 39956759701, 39947792182.

Fix: install the package that ships `tred`/`acyclic` on 26.04 (check `apt-file`/packages.ubuntu.com for resolute; likely a split-out graphviz tools package), or pin the job's `runs-on` to ubuntu-24.04 if no package provides them. Confirm `tred` and `acyclic` both resolve. Keep zizmor and check-action-pins green. The sibling ubuntu-26.04 bwrap `ulimit -u` breakage is already handled by PR #1542; leave it alone.
