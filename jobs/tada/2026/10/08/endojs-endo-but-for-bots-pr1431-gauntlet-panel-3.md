Panel round 3 on endojs/endo-but-for-bots PR #1431 finished with a **must-fix** disposition, and the verdict is posted on the PR.

**What I did**
- Made an isolated checkout of the PR head (`endojs/endo-but-for-bots`, branch `design/hardened-text-codecs-encapsulation`, head `160e1c7481`).
- Ran `panel.sh` in single-round mode against the PR's `baseRefOid` `fda1ff5` (`llm-fda1ff5`). The diff is only `designs/hardened-text-codecs-shim.md`, 382 lines added and 4 removed.
- The panel printed `design-panel single-round — must-fix`. I can't confirm its exit code: I ran it under `setsid`, which forked, so the `exit=0` in the log is from the wrapper, not the panel. The panel did print a verdict, which a seat or decider error would not do, so I treated it as exit 0.
- All 9 seats returned ok:
  - copyeditor asked for changes.
  - critic, skeptic, decomplector, ergonomist, novice and pedant were comment-only, and all but pedant carry should-fix findings.
  - orthographer and thesaurus approved.
- Two pre-checks fired:
  - The same mechanism (`prototype` / `prototype.constructor`) drew must-fix in rounds 1 and 2. This time the decomplector judged it necessary, since it reuses the existing `SharedURL` pattern.
  - The design spans 4 layers without an ownership-map section. The decomplector worked one out and found it coherent.
- Posted the combined review on the PR (2026-10-08T00:22:05Z). It went up as **COMMENTED** because GitHub won't let the bot request changes on its own PR, the same as rounds 1 and 2. Its header says "Panel round 3 — must-fix".
- The `gh` wrapper first refused the post because the review used a bare `#3369` alongside `endojs/endo`. I rewrote those references as `endojs/endo#3369`.

**Main should-fix themes for the fix stage**
1. **Frozen-prototype check (decomplector):** the code treats a frozen prototype as proof SES already replaced the constructor. It should check its own `WeakSet` instead and throw when the prototype is frozen but the binding is not in the set.
2. **Unconditional replacement (critic):** the design should weigh a feature-tested replacement against what the always-on one costs: `Host !== TextDecoder`, and a changed `constructor` on the shared prototype.
3. **"Host constructor unreachable" claim (critic, skeptic):** it rests on how hosts behave today and should say so. Test 9 also needs a case where `new.target.prototype` is a Proxy or getter.
4. **Default path still throws (skeptic):** `lockdown()` keeps throwing on the default path until the `URL`/`URLSearchParams` follow-up lands. The design should say whether the codec fix ships alone, and should say "observed on Chromium ≤137" rather than "before 138".
5. **Where the identity break is explained (ergonomist):** name the changeset and docs locations, and make the no-`new` error message tell the caller what to do.
6. **Structure and readability (novice, ergonomist, critic, copyeditor):** put a short summary at the top of the revision, define terms before first use, fold or shorten the "Superseded" notes, and use consistent section backreferences.

**Follow-ups:** none from this stage. The gauntlet driver owns the next fix stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1431-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (705926 cached reads)
- Output: 4072 tokens
- Cost: $0.7438011999999999
- Wall-clock: 646s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
