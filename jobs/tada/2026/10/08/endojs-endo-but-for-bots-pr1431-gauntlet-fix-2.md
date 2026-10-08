I applied the round-2 fixes to endojs/endo-but-for-bots#1431, pushed them as one follow-up commit, and CI is green (28 checks, 0 failed).

**Verdict read:** The panel-2 review is on head `324dc3dc42d` and its overall result was must-fix. Only the skeptic seat requested changes. The critic, decomplector, ergonomist and novice left comments only, and copyeditor, pedant, orthographer and thesaurus approved. The review has no items explicitly labeled must-fix, so I applied the skeptic's should-fix items and the comment-seat items that several seats raised.

**Changes to `designs/hardened-text-codecs-shim.md`** (commit `160e1c7481`, pushed with `safe-push-pr-head.sh` in advance mode, `324dc3dc42` → `160e1c7481`):
- **Scope of the #3369 claim:** The design now says the revision narrows endojs/endo#3369 but does not close it. `lockdown()` still throws on Chromium before 138 in the default mode, now because of `URLSearchParams` and `%InitialURL%` instead of the codecs. The issue closes when the follow-up revision of `hardened-url-shim` lands. The doc also gives the order of the follow-ups. That follow-up is described in the design but is not posted as a job yet.
- **Test item 7:** It now tests the codec fix on its own, so it no longer depends on the URL follow-up. It runs on Chrome for Testing 137 (affected) and 138 (clean), with `URL` and `URLSearchParams` deleted before `lockdown()`. The long walk sentence is now a short list of steps.
- **Security argument:** The design now explains why the host constructor can't be reached: WebIDL operations never return their constructor, `new.target` passes information one way only, and the replacement has only its own `name`, `length` and `prototype`. It also lists the escape channels neither the argument nor the walk covers.
- **Test item 9 additions:**
  - Calling `Reflect.construct` with an arbitrary `new.target` never exposes the host constructor.
  - `name` and `length` match the host's.
  - Calling without `new` throws an error that names the constructor.
  - An invalid label throws the same error class as the host.
- **Rejected alternative added:** giving the replacement a fresh prototype. The cost of changing host-shared state is now stated where the choice is made.
- **Shared maker:** The design names one maker, `encapsulateHostConstructor` in `encapsulate-host-constructor.js`, for the codecs now and for `SharedURL`/`URLSearchParams` later, so the delegator isn't copied again.
- **Idempotence:** If the prototype is already frozen, the taming skips it. A new compatibility note covers more than one copy of SES in a realm: a second copy wraps the first copy's replacement again, which behaves the same apart from one extra call frame per construction.
- **Changeset note:** The SES changeset will tell users about the change in constructor identity and when the workaround can be retired.
- **Superseded sections:** A banner at the top says the Revision section overrides earlier text. The "What is the Problem" and "Lockdown sequencing" sections now carry superseded notes, and the sequencing list gains a step 0 for the replacement.
- **Readability:** I split the measured Chromium versions from the inferred affected range, and the tests now pin only the measured versions. I also added short definitions of WebIDL, SES-for-XS, `getGlobalIntrinsics` and `addIntrinsics`.

**Follow-ups:**
- I did not re-run the panel; the driver posts panel-3 next.
- The `URL`/`URLSearchParams` follow-up the design names still needs a job of its own.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1431-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (897531 cached reads)
- Output: 12560 tokens
- Cost: $0.9892502
- Wall-clock: 860s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
