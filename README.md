# Basic Security Skill

A Claude skill that runs a security pass on an app when you say **"basic security"**: it audits the code against a pre-launch checklist for AI/vibe-coded apps and fixes the gaps it finds.

- Skill: [`skills/basic-security/SKILL.md`](skills/basic-security/SKILL.md)
- Source checklist: [The Complete Pre-Launch Security Checklist for Vibe-Coded Apps](https://app.notion.com/p/The-Complete-Pre-Launch-Security-Checklist-for-Vibe-Coded-Apps-3b7512560bf28158a7a9e80ce3849e1e) (Notion)

## How to use

### Option 1: Ask Claude in this project (easiest)

Type **"basic security on"** followed by your repo name, for example:

> basic security on Delivery-Planner

Claude reads your code, checks it against every item in this skill, fixes what it safely can, and opens a **draft pull request** with the changes. Nothing reaches your live app until you merge that pull request.

### Option 2: Run it on your own computer

1. Copy the `skills/basic-security` folder from this repo into your Claude skills folder: `~/.claude/skills/` (so you end up with `~/.claude/skills/basic-security/SKILL.md`).
2. Open your project in Claude Code.
3. Type **basic security**.

Claude makes the fixes directly in your project folder. Look over the changes before you commit them.

### Review only (no changes)

Add **"audit only"** to the command if you just want a check-up without anything being touched:

> basic security audit only on Delivery-Planner

Think of it like a home inspection: you get a list of what's wrong and what would fix it, but nobody starts repairs. Problems show up as **Gap** in the results. When you're happy with the list, run plain "basic security" to have them fixed.

### What it fixes and what it leaves to you

- **Fixes in code:** things that are safe and contained, such as moving a secret key out of the website code, adding a missing permission check, or limiting how fast someone can retry a password.
- **Launch and privacy-law checks:** the launch-readiness checks (test vs live setup, outage handling, alerts, account deletion, login leaks, database changes, slow pages) and the privacy-law checks by country work the same way: what can be done in code is fixed (for example a cookie consent banner, a "delete my account" button, an unsubscribe link, a "you're chatting with an AI" notice), and the rest is marked "Needs you" (for example signing up for alerts, adding email DNS records, appointing a data protection officer, final privacy-policy wording). The law checks are general information, not legal advice.
- **Leaves to you (marked "Needs you"):** anything outside the code or hard to undo, such as changing a leaked password or key, turning on backups, billing limits or two-step login in a provider's dashboard, or big upgrades that might break the app. Claude tells you exactly where to click.

After making fixes, Claude runs your project's existing tests to check nothing broke.

### Reading the results

Every run ends with a table, one row per check, with "Needs you" items listed first:

| Status | What it means |
|---|---|
| **Fixed** | There was a gap and Claude closed it. |
| **Already OK** | Your app already handles this. |
| **Needs you** | Needs an action only you can take (see above). |
| **N/A** | Doesn't apply, e.g. payment checks when your app takes no payments. |
| **Gap** | Audit-only runs: a problem found but not fixed yet. |

Each row also says where in the code it is and, in plain words, what changed or what to do.

**Tip:** run it again after adding a big new feature, since new features can open new holes.

## Structure

Each check has a stable ID so new threats can be compared against what is already covered:

| Section | IDs |
|---|---|
| Secrets and keys | SEC-01 – SEC-03 |
| Database | SEC-04 – SEC-05 |
| Auth and access control | SEC-06 – SEC-10 |
| Rate limiting and abuse | SEC-11 – SEC-13 |
| Input and output | SEC-14 – SEC-18 |
| Payments | SEC-19 – SEC-20 |
| AI features | SEC-21 – SEC-22 |
| Deployment and ops | SEC-23 – SEC-30 |
| Server trust boundaries (added 2026-10) | SEC-31 – SEC-35 |
| Storage, database functions and hidden routes (added 2026-10) | SEC-36 – SEC-39 |
| AI coding tools in the repo (added 2026-10) | SEC-40 |
| Hidden data, shop logic, platforms and assistant secrets (added 2026-10-19) | SEC-41 – SEC-45 |
| AI chat, live updates and login settings (added 2026-10-19) | SEC-46 – SEC-50 |
| Supply chain, pipelines, agents and defaults (added 2026-10-30) | SEC-51 – SEC-58 |
| Launch readiness (added 2026-10-30) | SEC-59 – SEC-67 |
| Digital and privacy law by region (added 2026-10-30) | LAW-01 – LAW-17 |
| Mobile | SEC-M1 – SEC-M4 |

New checks are appended with new IDs; existing IDs are never renumbered.

## Updates

Every week the top AI-coding security issues are reviewed against this skill. Issues it does not already cover are offered as optional additions, and only the ones accepted are added here.

## Credits

- SEC-01 to SEC-30 and SEC-M1 to SEC-M4 are based on [The Complete Pre-Launch Security Checklist for Vibe-Coded Apps](https://app.notion.com/p/The-Complete-Pre-Launch-Security-Checklist-for-Vibe-Coded-Apps-3b7512560bf28158a7a9e80ce3849e1e) (Notion).
- SEC-31 to SEC-40 came from the 2026-10 research review, and SEC-41 to SEC-50 from the 2026-10-19 reviews, and SEC-51 to SEC-58 from the 2026-10-30 review. SEC-59 to SEC-67 and LAW-01 to LAW-17 came from the 2026-10-30 pre-launch checklist review. Each check's source links are listed in the **Sources** section of [`SKILL.md`](skills/basic-security/SKILL.md#sources).

## License

[MIT](LICENSE). Anyone can use, copy, change and share this skill, including for commercial projects, as long as they keep the license notice. It comes with no warranty: it helps catch common security gaps but is not a guarantee that an app is secure.

---

Last updated: 2026-10-30
