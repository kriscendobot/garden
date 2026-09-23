---
ts: 2026-05-14T23:01:31Z
kind: result
role: liaison
project: garden-library
refs:
  - entries/2026/05/14/175638Z-result-liaison-b796b7.md
  - entries/2026/05/14/175822Z-result-liaison-35ecd8.md
---

# Library efficacy A/B test (round 2) — report

24-subagent fresh-context A/B test of `journal/library/` against
WebSearch+forks for 12 design-derived research questions. Methodology
locked in the round-2 proposal entry (175822Z); this entry captures
the run, the per-question grading against pre-dispatch ground truth,
and the synthesis.

## Run details

- 24 `general-purpose` subagents dispatched in a single parallel
  batch.
- Treatment (12): permitted to read only `/home/kris/garden/journal/library/`.
- Control (12): permitted WebSearch + WebFetch + read from
  `worktrees/{endojs-endo, kriscendobot-agoric-sdk,
  kriscendobot-ocapn, endojs-endo-but-for-bots}.git`. Forbidden from
  `journal/library/`.
- Ground-truth notes authored pre-dispatch at
  `/tmp/c-r2-ground-truth.md` (reproduced inline in the round-2
  proposal entry).

Library state at run time: 100 sources, 451 sections, 25 topics, 18
concepts, ~140 keywords (post-cycle-51 — *significantly* more covered
than at round-2 question-drafting time; see Confound section).

## Raw measurements

| Dimension | Treatment (library) | Control (web+source) | Δ |
|---|---|---|---|
| Total tokens (sum of 12 agents) | **411,538** | 343,708 | Treatment **+19.7%** |
| Tool uses (sum) | 113 | 178 | Treatment **−36.5%** |
| Per-agent avg duration | **33.5 s** | 54.3 s | Treatment **−38.3%** |
| Files / fetches (self-reported avg) | ~6 files/agent | ~10 files/agent | Treatment **fewer** |
| Pace (self-reported modal) | fast | fast / medium | Treatment **faster** |

**Surprising finding**: treatment uses *more* tokens than control,
even though it is faster wall-clock and uses fewer tool calls. The
explanation is structural — library section files are
context-dense (Markdown prose with frontmatter + cross-references +
the relevant code snippet inline), so a treatment agent reading 3-5
sections often consumes more tokens than a control agent doing
10-20 small grep / show operations across source. The library is
**fast but token-expensive**.

## Quality grading (per ground-truth notes)

Per-question: `full` = touches all underlined points; `partial` =
some but not all; `wrong` = misses the central concept or contradicts.

| Q | Topic | Treatment | Control |
|---|---|---|---|
| 1 | `@endo/netstring` API shape | partial (missed Reader/Writer naming) | full |
| 2 | `@endo/stream` + framers adapter | full | full (+`mapReader`/`mapWriter` extra) |
| 3 | `op:start-session` fields | full | full (+JS field names) |
| 4 | Crossed-hellos resolution | full | full (+exact line numbers) |
| 5 | `OcapnLocation` Syrup rename compat | **wrong** | full |
| 6 | Netlayer ↔ CapTP contract | full | full (+concrete API) |
| 7 | Daemon policy persistence | partial (SQLite confusion) | full |
| 8 | Concurrent-request coalescing | full | full (+SES module-loader exemplar) |
| 9 | Capability revocation primitive | **full** (named *withdrawal of constructor*) | partial (named only dot-membrane) |
| 10 | `graph.js` retention edges | full | full |
| 11 | `reverseLookup` API | full | full (+code-level detail) |
| 12 | Typed return, consumer-rendered | **full** (named the convention) | partial (different abstraction level) |

**Totals**:
- Treatment: 9 full / 2 partial / **1 wrong**
- Control: 10 full / 2 partial / 0 wrong

Control wins narrowly on aggregate quality (10 vs 9 full), with one
notable miss each side.

### Notable per-question observations

**Q5 (treatment WRONG)**: The treatment agent claimed renaming a
Syrup record field is a wire-format change because "the field name
is part of the canonical record on the wire." This is **incorrect**:
the JS field names in `makeOcapnRecordCodecFromDefinition` are
purely positional bindings — only the record label (`ocapn-peer`)
and the field *order* are on the wire. Renaming `transport` →
`network` is a source-only refactor that is wire-compatible across
implementations. Control got this right by reading the codec
source. The library's `endo-but-for-bots--llm-designs-ntsep--*`
sections discuss the rename but do not surface the
field-positionality-on-the-wire fact clearly enough that the
treatment agent didn't generate the incorrect conclusion. **This is
a library bug worth fixing.**

**Q7 (treatment partial — SQLite confusion)**: Treatment claimed
the daemon's policy state lives in a "SQLite-backed formula store."
The retention design uses SQLite (one specific table for cross-peer
retention edges), but the formula store itself is JSON files on
disk (`<statePath>/formulas/<head>/<tail>.json`). The treatment
agent conflated the retention storage with the formula storage —
both are in the library, but the library does not foreground the
distinction. **Another library bug.**

**Q9 (treatment WINS)**: Treatment named "revocation by withdrawal
of the constructor" as a fourth revocation primitive (alongside
caretakers / revocation lists / expiry), citing the cycle-50
`revocation-by-withdrawal` concept page and the Formula Persistence
design. Control found the dot-membrane primitive in
`packages/marshal/src/dot-membrane.js` — correct but at a different
abstraction level, missing the design-level framing the library
captures. The new concept page directly produced this win.

**Q12 (treatment WINS)**: Treatment named the
"producer-typed-shape / consumer-rendering" convention from the
cycle-50 concept page. Control found a correct lower-level answer
(`makeTagged` + `CopyTagged` from `@endo/pass-style`) but did not
name the design-level convention. Another concept-page win.

### Cross-cutting patterns

- **Where the library shipped a dedicated concept page, treatment
  reliably wins on framing** (Q9, Q12). Concept pages turn out to
  be the unit a researching agent most efficiently retrieves.
- **Where the library's section abstracts don't surface specific
  technical claims, the body's text can be missed by an agent
  navigating from the abstract** (Q1, Q5, Q7). This is the same
  pattern round 1 saw with the smallcaps sigil table.
- **Control wins on code-level specificity** (line numbers, exact
  field names, exact factory signatures) because it reads source
  directly (Q3, Q4, Q11). The library encodes design-level
  knowledge faithfully but does not (and should not) duplicate
  per-line implementation detail.

## Synthesis

The round-2 result is **mixed**, which is the right outcome for the
methodology:

1. **Quality**: control 10/12 full, treatment 9/12 full. Control
   slightly wins. The treatment's one *wrong* answer (Q5) is the
   most serious result — a library reader was actively misled.
2. **Efficiency**: treatment is **38% faster wall-clock**, **37%
   fewer tool calls**, but **20% MORE tokens**. The token premium
   is the cost of dense context-rich section files; the tool-call
   savings are the value of pre-built cross-references.
3. **Design-level concepts are the library's clearest win**. Both
   Q9 and Q12 produced clear treatment wins via concept pages.
   Both ground-truth answers had clear design framings that the
   library surfaces and control had to derive from scratch.

The library is **clearly net-positive for design-level questions**
(framings, conventions, patterns) and **net-neutral or slightly
negative for implementation-detail questions** (line numbers, exact
field names). This matches the predicted distribution — but with
two failure modes worth fixing (Q5 wrong, Q7 partial).

## Library bugs to fix (sourced from this run)

1. **Q5 — Syrup record field positionality**: add a one-line
   clarification to `endo-but-for-bots--llm-designs-ntsep--*` (or to
   a new concept page on Syrup record wire encoding) that field
   names in `makeOcapnRecordCodecFromDefinition` are *positional
   bindings*, not on-the-wire field names. This is the kind of
   precise-yet-subtle fact that warrants its own concept page or
   prominent section bullet — without it, a researching agent will
   keep generating the wrong wire-compat conclusion.
2. **Q7 — Formula store vs retention SQLite distinction**: the
   library has both pieces but does not foreground that the
   `formula store` is JSON files while the `retention` table is
   SQLite. A short addition to `formula-graph` concept page (or to
   `dcpg/persistence-and-graph` section) explicitly contrasting
   the two storage substrates would prevent this confusion.
3. **Q1 — `@endo/netstring` Reader/Writer naming**: the section
   abstract for `endo--pkg-netstring-readme--overview` does not
   surface the `makeNetstringReader` / `makeNetstringWriter`
   factory names or the `@endo/stream` `Reader<Uint8Array>`
   typed shape; lifting these into the abstract would close the
   gap.

These three are exactly the kind of inline-index-improvement that
the `library-lookup` skill's *Indexing on the fly* writeback
discipline is meant to capture. If a future builder or designer
asked the same question, the skill's writeback procedure would
have them add the relevant keywords and (potentially) draft the
missing concept page.

## The confound (acknowledged in the proposal, materialized in this run)

Between round-2 question-drafting and round-2 dispatch, scholar
cycles 46–51 ingested daemon-cluster and shim-cluster designs that
made the test less adversarial than originally designed:

- Q10, Q11, Q12 had direct library coverage via cycle-42 retention-
  path-notation ingest at drafting time; cycle-50's new
  `producer-typed-shape-consumer-rendering` concept page made Q12 a
  clear treatment win.
- Q9 was a *predicted library gap* at drafting time; cycle-47's
  Formula Persistence ingest and cycle-50's
  `revocation-by-withdrawal` concept page turned it into a clear
  treatment win.
- Q7 was a *predicted library gap* at drafting time; cycle-47's
  Formula Persistence ingest gave the library *partial* coverage
  (enough that the treatment agent had something to say but not
  enough to avoid the SQLite confusion).
- Q4, Q6 became *less adversarial* via cycle-46 daemon-cross-peer-gc
  + cycle-49 daemon-agent-network-identity ingests.

Net effect: the library scored better on round 2 than it would have
scored had round 2 fired *at drafting time*, by roughly 3-4 questions
(Q9 from partial→full, Q12 from partial→full, Q4/Q6 from partial→full
with extra concept-page wins). The treatment's 9 full / 2 partial / 1
wrong would have been more like 5 full / 5 partial / 2 wrong at
drafting time.

This is a **good** confound from the library's perspective — the
intervening cycles materially improved the library's coverage of
design-derived questions. It is a **methodologically muddy** confound
because it makes round 2 not strictly comparable to the
question-derivation pre-state. A round 3 with freshly-derived
questions from un-ingested designs would re-isolate the test.

## Caveats

- **Variance**: 24 trials (12 per condition × 1 question each) is
  better than round 1's two trials but still too few to compute
  per-condition variance with confidence. The numbers above are
  pointwise.
- **Ground-truth bias**: the liaison who graded these answers
  authored much of the library content. The grading rubric is
  inevitably colored by what the liaison knows the library
  *should* be able to do. Round 1 noted the same caveat; round 2
  does not eliminate it. A future round graded by a fresh agent
  (or by a maintainer who is not the library author) would tighten
  this.
- **Per-question token variance is high**: treatment ranges from
  22,860 (Q12) to 54,329 (Q4); control ranges from 21,225 (Q1) to
  35,280 (Q4). The aggregate ratio is sensitive to a few outlier
  questions.

## Cost

Total compute: **~755K tokens** across 24 agents. Estimated upfront
(120-240K) was off by ~3×; the per-agent token range turned out to
be 20-55K rather than the round-1-extrapolation 5-10K. Round 1's
per-question cost was ~5K-per-question only because round 1 had one
agent answering all 12 questions and amortizing setup; round-2's
per-agent setup overhead (orient, read README, find topic page) is
non-trivial for a single-question dispatch.

## Recommendation

Two pieces of action:

1. **Apply the three Library Bug fixes** (Q5 Syrup positionality,
   Q7 formula-store-vs-retention, Q1 netstring Reader/Writer
   naming) as a future scholar cycle. These are exactly the kind
   of fix the `library-lookup` skill's writeback discipline is
   designed to capture inline — but for now they need to be
   manually applied because no caller exercised the writeback this
   run.
2. **Decide whether to run round 3** with freshly-derived
   questions from un-ingested designs. The methodologically muddy
   confound (post-drafting ingest) gives the library more credit
   than the methodology originally intended. A round 3 would
   re-adversarialize and produce cleaner numbers. Cost would be
   another ~755K tokens. Recommendation: defer round 3 unless the
   maintainer wants higher-confidence numbers; the round-2 result
   is directionally clear (library net-positive on framings,
   net-neutral on details).

## Status

- Round 2 run, graded, reported (this entry).
- Three library bugs identified; not yet fixed.
- Round 3 deferred unless explicitly requested.
