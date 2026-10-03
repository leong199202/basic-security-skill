# Basic Security Skill

A Claude skill that runs a security pass on an app when you say **"basic security"**: it audits the code against a pre-launch checklist for AI/vibe-coded apps and fixes the gaps it finds.

- Skill: [`skills/basic-security/SKILL.md`](skills/basic-security/SKILL.md)
- Source checklist: [The Complete Pre-Launch Security Checklist for Vibe-Coded Apps](https://app.notion.com/p/The-Complete-Pre-Launch-Security-Checklist-for-Vibe-Coded-Apps-3b7512560bf28158a7a9e80ce3849e1e) (Notion)

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
| Mobile | SEC-M1 – SEC-M4 |

New checks are appended with new IDs; existing IDs are never renumbered.

## Updates

Every two weeks the top AI-coding security issues are reviewed against this skill. Issues it does not already cover are offered as optional additions, and only the ones accepted are added here.

## Credits

- SEC-01 to SEC-30 and SEC-M1 to SEC-M4 are based on [The Complete Pre-Launch Security Checklist for Vibe-Coded Apps](https://app.notion.com/p/The-Complete-Pre-Launch-Security-Checklist-for-Vibe-Coded-Apps-3b7512560bf28158a7a9e80ce3849e1e) (Notion).
- SEC-31 to SEC-40 came from the 2026-10 research review. Each check's source links are listed in the **Sources** section of [`SKILL.md`](skills/basic-security/SKILL.md#sources).
