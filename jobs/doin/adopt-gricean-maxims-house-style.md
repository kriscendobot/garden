role: builder
# Adopt Grice's maxims as a standing house-style norm for all fleet communication

Maintainer directive (kriskowal, 2026-07-28): adopt Grice's maxims and incorporate
them in all communications going forward.

Source, framed as "Be concise; optimize for reader attention":
https://gist.github.com/dckc/7d477a99086a5e21d0979ecc919aaf76

The four maxims as that source states them:

- **Quantity** - make your contribution as informative as is required for the current
  purposes of the exchange, and no more informative than is required.
- **Quality** - try to make your contribution one that is true; do not say what you
  believe to be false, and do not say that for which you lack adequate evidence.
- **Relation** - be relevant. The information provided should be relevant to the
  current exchange, and irrelevant information should be omitted.
- **Manner** - be clear. Be brief, avoiding unnecessary verbosity. Be orderly,
  providing information in an order that makes sense.

Garden repo, `main2`, **DIRECT push, NO PR** per CLAUDE.md § Conventions.

## Scope

1. **Write `skills/gricean-maxims/SKILL.md`** (name it that unless you have a better
   one; say why if you rename). Sections per CLAUDE.md § Adding a skill: purpose,
   inputs, procedure, output shape, notes. Cite the gist as a fully-qualified URL
   per `skills/fully-qualified-github-urls/SKILL.md`.

   Make it **operational, not aspirational.** The existing house-style skills are
   mechanical and checkable (no em-dashes, no Latin shorthand). Grice's maxims are
   judgment calls, so a bare restatement is unusable as a norm - "be relevant" cannot
   be applied or reviewed as written. Give each maxim concrete do/don't pairs drawn
   from the shapes the fleet actually writes: a `tada` completion report, a PR
   completion-summary comment, an inline review reply, a journal entry body, an inbox
   or bus message, a panel juror's finding. Name the specific failure each maxim
   prevents. Recurring offenders worth targeting: restating the job body back to the
   reader, narrating process the reader did not ask for, hedging that adds length
   without adding information, and burying the decision under preamble.

2. **Wire it into `roles/COMMON.md`** so it binds every dispatched agent.

   **Do not create a third copy of the style index.** `roles/COMMON.md` today lists
   the standing style skills TWICE: § Style (near line 38) and § House style (near
   line 250), duplicating four entries, with § House style itself admitting "The
   first four rules are also summarized in § Style above." Register the new skill in
   § House style, the self-described consolidated index, and either consolidate the
   two sections or make § Style defer to § House style rather than re-listing. Do not
   leave the tree with the same rule stated in three places.

3. **Update the CLAUDE.md skills name index** so the new skill appears in the
   inventory.

4. **Consider the liaison.** The directive says "all communications", which includes
   the liaison's maintainer-facing prose, not only agent-authored artifacts. Decide
   whether `roles/liaison/AGENT.md` needs its own pointer given the liaison does not
   read `roles/COMMON.md` (that file is the subagent standing brief), and wire it if
   so. State your reasoning in the report.

## The failure mode to guard against explicitly

The Quantity maxim ("no more informative than is required") must **not** become a
license to drop content the garden REQUIRES. Several norms mandate specific content:
the PR completion-summary comment (head SHA, what changed mapped to addressing
commits, what was declined and why, verification status), inline review replies
anchored to the line, the journal entry shape, and the `tada` report contract. An
agent citing brevity to omit any of these is misapplying the maxim.

State this boundary in the skill in plain terms: **the maxims govern HOW something is
said, not WHETHER a required disclosure is made.** Where a required element feels
redundant, the maxims argue for saying it more compactly, never for dropping it.
Include at least one worked example of that distinction.

## Definition of done

- `skills/gricean-maxims/SKILL.md` exists, is operational rather than a restatement,
  and carries the required-content boundary with a worked example.
- `roles/COMMON.md` binds it, with the pre-existing § Style / § House style
  duplication resolved or at minimum not worsened.
- The CLAUDE.md skills index lists it.
- Every document you author here obeys the garden's own house style, including the
  rules against em-dashes, Latin shorthand, and typist-hostile code points. A skill
  about careful communication that violates the existing style rules undercuts itself.
- Direct push to `main2`. Report what you decided about the liaison and about the
  duplicate style sections.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  claimed_at: 2026-07-28T05:08:04Z
