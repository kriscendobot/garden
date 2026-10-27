## Completion report: endojs-endo-but-for-bots-depcheck-tred-alternative

**Recommendation: get `tred` from the separate `graphviz-tools` package; there's no need to write our own.** A peer's draft PR, endojs/endo-but-for-bots#1566 (`fix/ci-runner-bwrap-and-graphviz` → `llm`), already does this and passes depcheck on the new Ubuntu image. I opened no PR, because it would have duplicated #1566.

**What I found**
- **Why it broke:** `ubuntu-latest` now runs Ubuntu 26.04 (the failing run logs show `Image: ubuntu-26.04`). Its graphviz 14.1.2 moved `tred` into a separate `graphviz-tools` package and no longer packages `acyclic` at all. Current depcheck runs on that image fail with `tred: command not found` (exit 127), for example run 40560562750.
- **What `tred` is used for:** `scripts/graph.sh` uses it only to draw the simplified (transitively reduced) graph as `packages-graph-tred.{png,svg}`. The cycle check in `check-dependency-cycles.sh` counts only the output of `acyclic`/`comm`, so the CI pass/fail result never depends on `tred`.
- **Evidence that #1566 works:**
  - It installs `graphviz-tools` only when `tred` is missing, so older images keep working unchanged.
  - It replaces `acyclic` with the coreutils `tsort` command.
  - Its depcheck run 40550054472 on `ubuntu-26.04` passed: it installed `graphviz-tools 14.1.2-1ubuntu1` and found `/usr/bin/tred`.
  - All of #1566's checks are green.
- **Options I set aside:**
  - **conda, brew or a pinned Graphviz build:** more setup with no benefit, since the system package now provides `tred`.
  - **Our own JS transitive reduction:** not needed for the gate.
  - **Cheaper fallbacks if the extra install time matters:** it took about 3 minutes, mostly recommended Qt/GTK packages. Adding `--no-install-recommends`, or not drawing the pictures inside the cycle check, would cut that.
- **No unpin to do on `llm`:** `depcheck.yml` on `llm` still says `runs-on: ubuntu-latest`. The `ubuntu-24.04` pin exists only in #1349, which targets `master-6ee3fda`.

**What changed**
- I replied on the maintainer's thread with these findings: https://github.com/endojs/endo-but-for-bots/pull/1349#discussion_r4392690888.
- I made no code changes and did not touch #1349.

**Follow-ups**
- #1566 needs to go through its gauntlet and land on `llm`.
- After that, the fix has to reach #1349's base (`master-6ee3fda`), for example by weaving #1349 onto a base that includes #1566. Then #1349 can drop its `ubuntu-24.04` pin.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-depcheck-tred-alternative.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (416006 cached reads)
- Output: 4248 tokens
- Cost: $0.5794652
- Wall-clock: 75s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
