PR #802 was re-verified as OPEN, non-draft, and MERGEABLE, but it was not green: the `zizmor` security-audit check failed and two CI checks were still in progress. No merge was attempted.

Dispatched `endojs-endo-but-for-bots-pr802-shepherd` with a 7200-second CI handler budget to diagnose and repair the failure. The failed check was recorded as https://github.com/endojs/endo-but-for-bots/actions/runs/29792338876/job/88516595161.

Follow-up: the shepherd must drive CI green before a later conductor run can merge the approved PR.
