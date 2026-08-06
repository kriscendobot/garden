---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-06T06:26:45Z
---
### copyeditor (prose mechanics)

**PR:** kriscendobot/minion.town#21 (`designs/weblet-gateway.md`, 1035 lines, diff base `origin/main`)

**Verdict:** request-changes

**Findings:**

- **must-fix** `designs/weblet-gateway.md:1020` (§ 10 row 4) introduces the term `owner-conflict` twice ("`owner-conflict` clean result", "`owner-conflict` clean success on a byte-identical re-publish"). The string appears nowhere else in the document. § 7.1, which row 4 summarizes, names the same outcome "**Byte-identical collision is a clean success**" and specifies the return as `{ hash, url, owned: false }` with no `reason` tag, while the taxonomy at :820 enumerates only `reserved-path` / `unfunded` / `over-cap`. A builder reading row 4 would implement a tagged `owner-conflict` reason; a builder reading § 7.1 would implement the `owned` boolean. Pick one spelling and use it in both places. [rule: roles/jurors/copyeditor/AGENT.md § Operating norms, jargon introduced before its first technical use]

- **should-fix** `:848` "Publish therefore returns only `{ hash, url }`" contradicts `:783`, `:788`, and `:868`, all of which return `{ hash, url, owned }`. The sentence's real point is that publish adds no *cert-liveness* field; as written the "only" reads as the full return shape. Recast: "Publish therefore returns `{ hash, url, owned }` and adds no cert-liveness field it cannot back." [rule: skills/gricean-maxims/SKILL.md § Manner]

- **should-fix** "DoD" is used unexpanded in four section headings (`:481`, `:669`, `:748`, `:906`) and expanded only incidentally at `:1027` ("Definition of done for this design job"). Expand on first use at `:481`. [rule: roles/jurors/copyeditor/AGENT.md § Operating norms]

- **should-fix** `:1019` writes "§ 4.2/OQ1"; every other reference spells it out ("open question 1", `:367`; "open question 4", `:742`, `:761`; "open question 6", `:560`). Use "open question 1". [rule: roles/jurors/copyeditor/AGENT.md § Operating norms]

- **should-fix** `:391-394` chains two `it`s with different antecedents: "*it* is a public liveness oracle" (= `ask`) then "but *it* is a reason to move the control surface off" (= the fact of that reachability, not `ask`). Name the second subject. [rule: skills/gricean-maxims/SKILL.md § Manner]

- **should-fix** Four mid-paragraph line-wrap orphans left by successive edits, in a file otherwise hard-wrapped near 80 columns: `:33` (the single word "on"), `:240` ("not cover it anyway, § 4)."), `:390` ("amplifier. Because"), `:566` ("formula per"). Reflow those paragraphs. [proposed-rule: a hard-wrapped design document is reflowed after an edit so no line inside a paragraph is a one- or two-word orphan]

**Notes (out of scope but worth flagging):**

- `:614-621` The parenthetical under "**Invariant and its guard**" runs three chained clauses and buries the operative instruction ("enumerating the whole cookie surface is what keeps the invariant from passing green with a derived cookie left unprefixed") at the end. Split into two sentences, leading with the instruction. comment-only. [rule: skills/gricean-maxims/SKILL.md § Manner]
- `:933-934` § 9's opener mixes tense across one coordination: "question 5 **is** settled for Increment 1 and question 6 **was** settled by Increment 2's shipping". Make both past or both present. comment-only. [rule: roles/jurors/copyeditor/AGENT.md § Operating norms, voice and tense consistency]

**Clean on this seat's mechanical backstops:** zero em-dashes (`skills/em-dash-style/SKILL.md`), zero typist-hostile code points (no `→`, `…`, curly quotes, `≤`; the doc consistently types `->` in the mermaid graph and prose) (`skills/typist-friendly-code-points/SKILL.md`), zero Latin shorthand (`skills/no-latin-shorthand/SKILL.md`), the one figure is mermaid rather than ASCII line-art (`roles/jurors/pedant/AGENT.md` § Layered project rules), and cross-tree links are relative (`skills/relative-paths/SKILL.md`). Section transitions read cleanly: each increment section opens with a `**Goal:**` line and each *As built* note is anchored to the increment it corrects, so the spec-versus-shipped voice split is followed rather than drifting.

Self-improvement: the copyeditor brief's mechanical backstops (em-dash, code points, Latin shorthand, ASCII figures) are all grep-checkable in one pass, but the brief describes them as prose to read for. A one-block shell snippet in the brief's Operating norms would let the seat clear all four in a single command and spend its budget on the judgment-bound findings (jargon introduction, tense drift, pronoun antecedents) that no grep can reach. Routing as a `[proposed-rule]`-adjacent note to the gardener rather than a role edit from this dispatch.
