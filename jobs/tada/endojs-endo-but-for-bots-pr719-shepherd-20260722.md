Shepherded #719 and posted the evidence-based classification on the PR.

- Confirmed URL-only diff atop current master `adae30a9`; no changes made.
- Local URL suite: 37 passed.
- CI passes URL-relevant checks; remaining failures reproduce on master: CBOR dependency, TextEncoder Prettier debt, and 16 stale `setup-node` zizmor pins.
- Follow-up: green master separately; #719 remains blocked only by inherited debt.
