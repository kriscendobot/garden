---
title: "Android using capability discipline: POLA scoring, and why partial permission grants were rejected"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2010-May/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2010-May.txt.gz
source_content_sha256: 2a5e8b26baabdc86ec809f69668899b8558f61ac1fdae451c31f7ace36a114be
source_authors: [Fred (phreed), Dan Bornstein, Kevin Reid, Mark Miller, Shriram Krishnamurthi, Ihab Awad, Sandro Magi]
source_date: 2010-05 to 2010-07
thread_subject: "Android using capability discipline"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, cap-talk-open-questions]
status: current
notes: |
  Derived summary of a thread spanning three monthly bundles: 2010-May
  (sha256 2a5e8b26, the recorded top-level anchor), 2010-June (sha256
  516913c4), and 2010-July (sha256 f1ab59a6). Dan Bornstein posted as an
  Android/Dalvik engineer speaking for himself, not as an "Android Security
  Spokesman" (his words). Shriram Krishnamurthi's proposal reached the list
  forwarded by Mark Miller.
---

Abstract: Across May-July 2010 the cap-talk list worked through the most concrete confrontation of object-capability discipline with a shipping mass-market platform: Google's Android. Fred (phreed), building an application on the platform, argued that security "isn't something to be added after development is complete but is something to be conserved," and pushed for applying the principle of least authority to Android apps and for a market-visible "POLA score" that would rank apps by whether they ask for more permission than their stated purpose needs. Dan Bornstein, an Android engineer, answered from inside the design: Android is deliberately *not* a pure object-capability system and is not going to become one, so the fruitful question is (b) "implementing applications on Android using capability discipline," not (a) reforming the platform into ocap. The load-bearing exchange is his account of why the Android team **debated and rejected partial permission grants** — letting a user install an app but switch off individual permissions — on the grounds that it would (a) push developers to *ask for more* permissions ("the user can just turn off the ones they don't want") and (b) create a combinatorial explosion of untested permission subsets, producing bugs and worse end-user experience. The team's judgment was that the coarse all-or-nothing install-time manifest, plus market pressure (users down-rank permission-heavy apps), exerts pressure toward *less*-authoritied apps better than attenuable grants would. The cap-community instinct — that authority should be finely attenuable — collides here with a deployed platform's argument that attenuability backfires; that collision is recorded as open question 54.

## The two questions: reform the platform, or discipline the app

Bornstein separated two things the thread kept conflating: (a) changing or forking Android "to make something that more closely idealizes / embodies capability security," versus (b) "implementing applications on Android using capability discipline." He declared his stance plainly: "I am keenly interested in the continued development of object capability systems, but I work on Android knowing full well that it is not a pure obj-cap system and that it is not likely to transmogrify into one in the foreseeable future." He judged (a) "very nearly purely academic" and (b) "potentially quite fruitful in terms of short- to medium-term results." Fred agreed he had over-reached in calling the Android market "insecure," clarifying that the framework "seems to provide the necessary elements of a secure system" and that his real point was Marc Stiegler's ("The Lazy Programmer's Guide to Secure Computing"): security is *conserved*, designed in, not bolted on. Android's loosely-coupled `intent` mechanism, Bornstein noted, already enables high inter-app interaction, but Fred's counter was that "intents alone don't guarantee security" — they are a mechanism that *can* be part of a comprehensive approach, not a guarantee of one.

## Why partial permission grants were rejected

The technical core is Bornstein's answer to "Is there any way to provide partial permissions to an Android application?": "Nope. This was debated — at length — within the Android team." The rejection rested on two predicted failure modes:

- **Over-asking.** If a user could install an app and then turn off individual permissions, developers would ask for *more* permissions than needed "on the theory that, after all, the user could just turn off the ones they don't want" — the opposite of least authority.
- **Untested permission subsets.** Apps "would get run with unexpected permission sets, leading to worse end-user experience and more trouble for developers" — every subset of granted permissions is a distinct, untested configuration.

The team's consensus was that the status-quo coarse manifest "ends up exerting pressure exactly in the direction of reducing overly-authoritied apps," because the whole permission list is shown up front and users react to it. This is a direct, deployed-platform argument *against* the capability community's default that authority should be as attenuable as possible.

## POLA scoring and social feedback

Fred proposed ranking apps by a "POLA score": a POLA-responsible app should be "as small as possible (but no smaller)," and its resource requests should be exactly what its declared intents need; low-scoring (over-permissioned) apps would be flagged in the market, pressuring developers toward more modular, more-interacting apps. Bornstein observed this pressure *already* exists informally — market commenters ask "Why does this app need to read my location?" and one-star apps they judge permission-heavy — and said he "rarely run[s] across an app which seems to require more permissions than its stated purpose would imply," with ad-supported apps (needing internet and coarse location for targeting) the main grey area.

The list then sharpened the idea into a designed mechanism. Shriram Krishnamurthi (forwarded by Mark Miller) proposed that each requested permission carry a developer's free-form explanation of *why* it is needed, and that users be able to *vote per capability*, each capability shown in a color reflecting its vote — "heavily red" for a capability many people find disconcerting. This gives the crowd a low-effort channel (a check-box, not an argument by email) to signal a suspicious request back to the developer, who "might even realize it is better to write the application without need for that capability." Ihab Awad noted this linking of a social graph to permission grants was first formulated by Joel Truher. Kevin Reid raised the standard hazard with the obvious alternative of *mock* permissions: a stubbed capability can have unexpected consequences — a mock (empty) contact list handed to a syncing app might cause it to *delete* the real contacts upstream — so "try it with low authority" is not free of risk either.

## Bearing on Endo

The thread is the canonical statement of a tension Endo lives with: the object-capability ideal wants authority to be arbitrarily attenuable (a caretaker, a facet, a revocable forwarder for any grant), while a shipping platform's engineers argue that user-facing *attenuability* of a coarse permission set backfires into over-asking and untested configurations. Endo's answer is not user-toggled subsets of a declared manifest but *composition*: authority is attenuated by the code that forwards it (a [[powerbox]] hands out exactly the facet a request needs, a [[caretaker-pattern]] wraps a revocable one), so the "untested subset" explosion never arises because each attenuated capability is an ordinary object with its own tested behavior. Bornstein's over-asking argument is real and unsolved at the *platform-manifest* granularity; it is dissolved at the *object-reference* granularity where Endo operates. See the [[principle-of-least-authority]] and [[powerbox]] concepts, and open question 54.

Source: [cap-talk 2010-May archive](http://www.eros-os.org/pipermail/cap-talk/2010-May/) and its June/July continuations (Internet Archive original-bytes `id_` snapshots of `2010-May.txt.gz` sha256 `2a5e8b26`, `2010-June.txt.gz` sha256 `516913c4`, `2010-July.txt.gz` sha256 `f1ab59a6`), thread "Android using capability discipline", 2010-05 to 2010-07.
