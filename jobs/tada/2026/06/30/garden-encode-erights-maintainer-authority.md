Both landings verified. Inbox empty.

---

## Completion report

**Job:** Encode that `erights` holds full maintainer authority, so a gardener treats an erights directive the same as a kriskowal directive and stops re-routing erights lifecycle directives to the maintainer inbox for a separate authorization.

**What I did** — landed the encoding in the two always-read docs that PR-handling gardeners actually consult, not one ephemeral place:

1. **`roles/COMMON.md` § External-repo etiquette** (main2, pushed `a27a6da74..82cb05166`). Added a *Maintainer-authority actors* paragraph: "the maintainer" includes `erights` (full authority); an erights directive **is** the authorization for lifecycle/maintainer-level actions (PR-close, withdraw-and-open-fresh, design dispositions) that the comment/reactji relaxations don't cover on their own; gardeners act directly and do **not** re-route to the maintainer inbox. Cites the exact defect (the routed "withdraw all three and open fresh"). Also added a note in § Authority structure of upstream projects clarifying the two axes don't conflict — the endo/README topic-scoping governs *technical review weight on upstream endojs/endo*, while authorization-to-act is settled by the new *Maintainer-authority actors* rule.

2. **`journal2:projects/endo-but-for-bots/README.md` § Standing authorizations** (landed via `land-journal-edit.sh`). Added a *Lifecycle directives from a maintainer-authority are self-authorizing* paragraph right after the destructive-action carve-out that tripped the gardener: a lifecycle directive from kriskowal **or** erights is self-authorizing on this repo; act directly, don't route to the inbox.

**Hard boundary preserved in both edits:** authority ≠ credentials. The elevation governs *who can authorize a bot action on a repo the bot can already act on* — it confers no upstream `endojs/endo` credentials, so closing/merging/commenting on upstream `endojs/endo` (e.g. a kriskowal-authored `endojs/endo#NNNN`) stays with kriskowal and the boatman identity-switch path regardless of who issued the directive.

**Already-in-place (verified, not changed):** `erights` is on both `journal2:maintainers/allowlist` and `trusted-senders/allowlist`.

**Verification:** both landings confirmed reachable on `origin/main2` and `origin/journal2`. Inbox empty at completion.

**Follow-ups:** none required. The auto-memory `feedback_erights_has_full_maintainer_authority` already records the directive; the doc encoding now backs it where gardeners read every cycle.
