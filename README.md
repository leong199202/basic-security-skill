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

The first time you run it, Claude asks whether you want the optional **weekly research** and which AI should run it (see below). Answer once and it won't ask again.

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

## Weekly research (any AI model)

Optional. Once a week, an AI of your choice looks up the newest security problems in AI-built apps and lists only the ones this skill doesn't cover yet, each with an everyday example, a one-line fix and a source link. You pick which to add and dismiss the rest.

Think of it like a weekly newsletter that only tells you about the risks your checklist is missing.

It works with **whatever AI you use**: Claude, ChatGPT, Gemini, a local model through Ollama, and so on.

**Set it up when you install the skill.** Pick one:

- **Let the skill ask you.** The first time you run "basic security", it asks whether to turn weekly research on and which AI to use, and saves your answer to `~/.config/basic-security/research.env`.
- **Run the setup script** from a copy of this repo: `scripts/setup-research.sh`. It asks the same questions, stores your API key privately (only you can read the file) and can add a weekly cron job for you.
- **Use GitHub Actions** (no computer needed): in your copy of this repo, go to Settings, Secrets and variables, Actions. Add variables `AI_BASE_URL` and `AI_MODEL` and a secret `AI_API_KEY`. The [weekly workflow](.github/workflows/weekly-research.yml) then runs every Monday and opens an issue with the report. Without those settings it does nothing.
- **No scheduler at all:** paste [`weekly-research-prompt.md`](skills/basic-security/weekly-research-prompt.md) plus `SKILL.md` into any AI chat once a week.

**Choosing your AI.** `scripts/weekly-research.sh` reaches your model in one of two ways:

| Setting | Use it for | Example |
|---|---|---|
| `AI_COMMAND` | Any AI command-line tool that reads a prompt and prints an answer | `claude -p`, `llm -m <model>`, `ollama run <model>` |
| `AI_BASE_URL` + `AI_MODEL` + `AI_API_KEY` | Any provider with an OpenAI-compatible API | OpenAI `https://api.openai.com/v1`, Gemini `https://generativelanguage.googleapis.com/v1beta/openai`, Anthropic `https://api.anthropic.com/v1`, OpenRouter `https://openrouter.ai/api/v1`, Ollama `http://localhost:11434/v1` |

Settings you put in the environment win over the saved file, so you can switch models for one run, for example `AI_MODEL=<other-model> scripts/weekly-research.sh`. Reports are saved to `research/reports/<date>.md`. To turn it off, run the setup script again and answer "no".

**Good to know:** the research is only as fresh as your AI's access to the web. A model without web search falls back on what it already knows and says so at the top of the report.

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

## Disclaimer

Please read this before you rely on this skill.

- **Provided "as is".** This skill is shared for free, with no warranty of any kind. The authors and contributors are not responsible for any loss, damage, breach, fine or other problem that comes from using it, or from relying on its results.
- **Not professional advice.** Nothing here is legal, security, compliance or other professional advice. The privacy-law checks (LAW-01 to LAW-17) are general information only, laws change often, and they may not match your situation or country.
- **It can miss things.** Automated checks and AI-made fixes can be wrong or incomplete. A clean result does not mean your app is secure, and it is not a guarantee that your app meets any law, regulation or standard. Always review every change yourself before you ship it.
- **Using it commercially?** If you use this skill for a business, a paid product, or an app that handles other people's data or money, you are strongly advised to have your app and your legal obligations checked by a qualified expert, such as a security professional or lawyer with years of real experience in this area, before you launch.

By using this skill you accept that you use it at your own risk.

## License

[MIT](LICENSE). Anyone can use, copy, change and share this skill, including for commercial projects, as long as they keep the license notice. It comes with no warranty: it helps catch common security gaps but is not a guarantee that an app is secure.

---

Last updated: 2026-10-31
