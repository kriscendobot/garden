**Fix round 3 for endojs/endo-but-for-bots PR #1431 is pushed and CI is green.**

I applied the panel-3 must-fix items to `designs/hardened-text-codecs-shim.md` in one follow-up commit, `32c1368078`. The head moved from `160e1c7481` to `32c1368078` through `safe-push-pr-head.sh` (advance mode, so no history was rewritten). `ci-wait-merge.sh --no-merge` returned rc 0: 28 checks, 0 failed.

**Copyeditor (the request-changes seat):**
- Every backreference now uses the full section title, § Revision: encapsulated constructors.
- The list of codec behaviors the replacement keeps is now written in parallel form.
- The dense sentence in Design Decision 4 is split into three.

**Should-fix items from the other seats:**
- **Decomplector:** the guard that stops a second taming pass now decides only by the maker's own `WeakSet`. If it finds a binding that is not one of its replacements and whose prototype is already frozen, it throws a `TypeError`; it no longer skips silently. Test item 8 covers that case, and § Compatibility describes what a second copy of SES now does. § Compatibility also says that importing SES-for-XS repoints the prototype's `constructor` even if `lockdown()` is never called.
- **Critic:** the design now lists "replace only where the host constructor is affected" as a rejected alternative, with reasons. It says the claim that the host constructor stays unreachable rests on current host behavior, and names what would break it. It also says the move of `SharedURL` onto the shared maker is not yet checked (`SharedURL` has its own error message and copies static helpers), so the maker takes the message name as a parameter and leaves static members to the caller. It adds that SES documents no supported-browser floor yet.
- **Skeptic:**
  - Test item 9 now covers a Proxy or an accessor `F.prototype` in `Reflect.construct`.
  - Only Chromium has been measured. The design makes no claim about Firefox or WebKit, and the changeset is to say "observed on Chromium 137 and earlier".
  - A new note says the codec fix can ship alone, but users on affected Chromium get no relief until the `URL` and `URLSearchParams` follow-up lands.
- **Ergonomist:**
  - The note on the `Host !== TextDecoder` change now names where users will find it: the `.changeset/` entry and a note in `packages/ses/docs/guide.md`.
  - The no-`new` error message is stated to match `%SharedURL%` on purpose.
  - § Lockdown sequencing is renumbered to start at 1 instead of 0.
- **Novice:** the top banner has a short plain-language summary, the version range "before 138" is marked as inferred where it first appears, and there is a worked trace of `new TextDecoder()`.
- **Pedant:** the fourth bullet now starts with "It repoints…" like the other three.
- I also changed bare `#3369` references to `endojs/endo#3369`, because a bare number links to the wrong repository.

The spelling (orthographer) and stock-phrase (thesaurus) greps both report 0 hits on the commit.

**Follow-ups:**
- The changeset and guide note, and the `TypeError` for a frozen prototype on an unknown binding, are now commitments for the implementation PR.
- The `SharedURL` adoption check belongs to the `URL` and `URLSearchParams` follow-up.
- The driver re-posts panel-4; I did not run the panel again.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1431-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2574295 cached reads)
- Output: 17722 tokens
- Cost: $1.564939
- Wall-clock: 910s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
