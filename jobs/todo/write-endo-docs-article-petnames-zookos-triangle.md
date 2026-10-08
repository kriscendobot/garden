---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Write an article on petnames and Zooko's triangle for docs.endojs.org

Maintainer request (2026-10-08): generate an article on **petnames and Zooko's triangle**
for docs.endojs.org. Deliver it as a DRAFT PR on `endojs/endo-but-for-bots`, base `llm`.

## Find where the site comes from before writing

The docs live under `docs/` in the Endo repo (`docs/guide.md`, `docs/reference.md`,
`docs/message-passing.md`, and so on). Nothing in this repo's text names docs.endojs.org, so
establish how that site is built and published: look for a docs build config, a site
generator, a sidebar or navigation index, and a CI workflow, in `endo-but-for-bots` and in
`endojs/endo`. Put the article where the build will pick it up, add the navigation entry the
site needs, and say in the PR body what you found. If the site's source is only in the
upstream `endojs/endo` and cannot be changed from this fork, say so in the PR and place the
article under `docs/` anyway so the maintainer can carry it.

## Content

Audience: a JavaScript developer new to Endo and to capability security. Voice and format:
match the existing `docs/` pages and `docs/house-style/`.

1. **Zooko's triangle.** The claim that a name cannot be at once human-meaningful, secure,
   and decentralized. Credit it correctly, state the three properties precisely, and explain
   why each pairing of two is easy and the third is hard, with familiar examples (DNS,
   public keys and hashes, a local address book). Mention the real known results honestly: the
   trilemma is a claim about a single global namespace, and later systems have argued over
   whether it is escaped or only relocated. Do not overclaim.
2. **Petnames.** The petname idea: names are local, chosen by the holder, and map to
   unforgeable references, so a name's meaning is private to the namer. Distinguish the
   *petname* (what I call it), the *proposed name* or *edge name* (what it calls itself), and
   the *key or reference* (what it is). Explain how this gives up global agreement to get
   security and decentralization together, and why that fits object capabilities.
3. **Petnames in Endo.** Ground this in what the code actually does today; read the daemon's
   pet-store, name resolution, paths, and the help text, and the designs under `designs/` and
   `docs/` that touch naming. Cover: pet names for values and agents, how paths traverse
   named references, naming a guest's introduced values, how a name is bound and re-bound,
   and what is *not* a petname (a locator or sturdyref is a bearer reference, not a name).
   Include short, runnable examples that you have actually run against a daemon, with the real
   output. Never invent API names or command output.
4. **Consequences and honest limits.** What petnames do not give you: shared vocabulary
   between parties, discovery, and any global uniqueness. How to design interfaces around that
   (introduce, do not look up).
5. **Further reading.** Primary sources, each cited with a link you have confirmed resolves:
   the originating statements of the triangle and of petnames, and the relevant Endo designs.

## Rules

- **Verify, do not recall.** Every claim about attribution, dates, or Endo behavior is checked
  against a source or the running code. If you cannot verify a claim, cut it or flag it in
  the PR description as unverified; do not soften it into plausible prose.
- Diagrams use mermaid, validated per `skills/mermaid-validation/SKILL.md`; no ASCII art.
- Run the repo's docs lint/format and link checks locally before pushing, and the CI-equivalent
  checks (a docs CI failure is an automation defect).
- The garden's prose norms apply: no Latin shorthand, American spelling, no Botese filler.
- Keep it one article, readable in about ten to fifteen minutes. Do not rewrite other pages;
  link to them.

## Completion

Open the PR as a DRAFT; the automatic gauntlet (clean, panel, fix-loop, un-draft) follows. The
maintainer reviews every change to Endo, so finish by sending the PR link to the maintainer
inbox with one sentence naming what to check first (the Endo-behavior section).
