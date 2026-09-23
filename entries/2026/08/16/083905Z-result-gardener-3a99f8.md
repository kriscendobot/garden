---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-16T08:39:07Z
---
PR endojs/endo-but-for-bots#995 (design/endo-claude), gauntlet panel round 4, seat: stylist (naming). Diff base origin/llm; the local `llm` ref in the review worktree is stale (2026-07-17), so `git diff llm...HEAD` shows 3483 files; the true PR diff against `origin/llm` is designs/README.md + designs/endo-claude.md.

### Stylist (naming)

**Verdict:** request-changes

**Findings:**

- `designs/endo-claude.md:651` (`harness.js`) [should-fix] — the doc uses "the harness" 33 times to mean the *whole* `@endo/claude` package (it scrubs `ENDO_SOCK`, validates method names, fixes the `apiKeyHelper` argv, asserts the spawned argv, holds the facet), yet the package shape gives `harness.js` a much narrower job ("builds the infer exo"). The name names the whole for a part, so a reader cannot tell whether an obligation assigned to "the harness" lands in that module or elsewhere. Either rename the module to what it does (`infer.js` / `make-infer.js`) or define "the harness" as the package once at first use. [rule: roles/jurors/stylist/AGENT.md § Operating norms, "no name that lies about what the value is"]

- `designs/endo-claude.md:43,459,462,486` ("guest identifier") [should-fix] — the doc asserts the formula id is "the same designator throughout" (line 120) and DD4 calls it "the single designator", but the section heading and three prose sites call it "guest identifier", a second name for the same thing that reads like a distinct designator (pet name? session tag?). Use "guest formula id" in all four, including the heading and the README M6 note that quotes it. [proposed-rule: when a design claims a single designator "throughout", the prose must use one name for it everywhere, section headings included]

- `designs/endo-claude.md:654` (`mcp-config.js`) [should-fix] — the module comment reads "render the `--mcp-config` file (one endpoint, one bearer)", but the *preferred* stdio transport, which the build sequencing picks as the concrete v1, carries **no bearer at all** (lines 420-423, 595-596, DD4). The module's stated contract contradicts the transport it will first be built for. Reword to "one endpoint; a bearer only under the HTTP transport". [rule: roles/jurors/stylist/AGENT.md § Secondary surface, name/doc disagreement]

- `designs/endo-claude.md:191,425,650` (`DD6`, `DD8`) [should-fix] — the doc spells "Design Decision N" 12 times and abbreviates it three times, once inside the `index.js` comment that will be transcribed into source. Spell it out at all three sites. [rule: roles/jurors/stylist/AGENT.md § Abbreviated identifiers]

- `designs/endo-claude.md:654` (`mcp-config.js` filename) [comment-only] — `config` is a bare abbreviation in a freshly-authored module name; `mcp-configuration.js` is the spelled-out form. Two counterweights: the module renders the CLI's own `--mcp-config` artifact, and the repo already carries `packages/cli/src/config.js` and `packages/gateway/src/config.js`. Raised so the choice is deliberate rather than defaulted. [rule: roles/jurors/stylist/AGENT.md § Abbreviated identifiers]

**Notes (out of scope but worth flagging):**

- `designs/endo-claude.md:653` (`credentials-pool.js`) — the module also renders the `apiKeyHelper` `--settings` file, which is credential *presentation*, not pooling, while the sibling `--mcp-config` renderer gets its own module. The name understates the contents and the two renderers are factored inconsistently. [rule: roles/jurors/stylist/AGENT.md § Operating norms]

- Checked and clean: no gratuitous renames (the diff adds a new file and a README row, renaming nothing); no redundant-word concatenations (`ContentAddressStoreStore` class); `guestFormulaId` matches the dominant in-repo spelling (`formulaId`, 35 uses in `packages/daemon/src/`), so it is not an abbreviation finding.

Self-improvement: the seat's abbreviation check needs a "surrounding-code precedent" step before it fires. `mcp-config.js` tripped the mechanical never-abbreviate rule, but `packages/cli/src/config.js` and `packages/gateway/src/config.js` already spell it that way, so firing must-fix would have imposed a garden rule against project convention. Proposing to the gardener: add to `roles/jurors/stylist/AGENT.md` § Abbreviated identifiers that the seat greps the target repo for the abbreviation's existing use and downgrades to comment-only when in-repo precedent exists.
