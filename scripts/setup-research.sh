#!/usr/bin/env bash
# First-install setup for the weekly AI-coding security research.
# Asks whether to turn it on and which AI model/tool to use, saves the answer,
# and can add a weekly cron job. Safe to run again to change your choice.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_FILE="${BASIC_SECURITY_CONFIG:-$HOME/.config/basic-security/research.env}"

ask() { local reply; read -r -p "$1 " reply; printf '%s' "$reply"; }

save() {
  mkdir -p "$(dirname "$CONFIG_FILE")"
  (umask 077; printf '%s\n' "$@" > "$CONFIG_FILE")
  echo "Saved to $CONFIG_FILE (readable only by you)."
}

echo "Basic Security: weekly research setup"
echo "Once a week, an AI of your choice looks up the newest AI-coding security"
echo "problems and lists the ones this skill does not cover yet, for you to add or skip."
echo

case "$(ask 'Turn on weekly research? [y/N]')" in
  [yY]*) ;;
  *) save "RESEARCH_ENABLED=no"; echo "Weekly research is off. Run this script again any time to turn it on."; exit 0 ;;
esac

echo
echo "Which AI do you want to use?"
echo "  1) An AI command-line tool you already have (Claude Code, llm, Ollama, ...)"
echo "  2) An AI provider's API (OpenAI, Gemini, Anthropic, OpenRouter, a local server, ...)"
choice="$(ask 'Pick 1 or 2:')"

if [[ "$choice" == "1" ]]; then
  echo "Type the command that takes a prompt on its input and prints the answer."
  echo "Examples: claude -p   |   llm -m <model>   |   ollama run <model>"
  cmd="$(ask 'Command:')"
  [[ -n "$cmd" ]] || { echo "No command given, nothing saved." >&2; exit 1; }
  save "RESEARCH_ENABLED=yes" "AI_COMMAND=$cmd"
elif [[ "$choice" == "2" ]]; then
  echo "Common API addresses:"
  echo "  OpenAI      https://api.openai.com/v1"
  echo "  Gemini      https://generativelanguage.googleapis.com/v1beta/openai"
  echo "  Anthropic   https://api.anthropic.com/v1"
  echo "  OpenRouter  https://openrouter.ai/api/v1"
  echo "  Ollama      http://localhost:11434/v1"
  url="$(ask 'API address:')"
  model="$(ask 'Model name (as your provider writes it):')"
  read -r -s -p "API key (hidden; leave empty for a local server, or to set AI_API_KEY yourself): " key; echo
  [[ -n "$url" && -n "$model" ]] || { echo "Address and model are required, nothing saved." >&2; exit 1; }
  lines=("RESEARCH_ENABLED=yes" "AI_BASE_URL=$url" "AI_MODEL=$model")
  [[ -n "$key" ]] && lines+=("AI_API_KEY=$key")
  save "${lines[@]}"
else
  echo "Please pick 1 or 2. Nothing saved." >&2
  exit 1
fi

echo
case "$(ask 'Add a weekly cron job on this computer (Mondays 09:00)? [y/N]')" in
  [yY]*)
    line="0 9 * * 1 \"$ROOT/scripts/weekly-research.sh\" >> \"$HOME/.config/basic-security/research.log\" 2>&1"
    { crontab -l 2>/dev/null | grep -vF "$ROOT/scripts/weekly-research.sh" || true; echo "$line"; } | crontab -
    echo "Cron job added. Reports go to $ROOT/research/reports/."
    ;;
  *) echo "No cron job added. Run $ROOT/scripts/weekly-research.sh yourself, or see the README for other schedulers." ;;
esac
