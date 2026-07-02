#!/bin/bash
#
# ClaudeCodeAutoSetup — one-command project generator for Claude Code
#
# Interactive usage:
#   ./setup.sh
#
# Remote usage (no clone needed):
#   curl -fsSL https://raw.githubusercontent.com/AgenticAIJP/ClaudeCodeAutoSetup/main/setup.sh | bash
#
# Non-interactive usage (for scripts / CI):
#   ./setup.sh <type-number 1-6> <project-name> [ja|en]
#
# i18n design:
#   - Human-facing guide files ship in BOTH languages, side by side:
#       settings.ja.sample.md / settings.en.sample.md
#   - Claude-facing files (CLAUDE.md, rules, commands, ...) are stored as
#       X.ja.md / X.en.md in templates/ and resolved to X.md at generation
#     time based on the selected language (keeps Claude's context single-language).

set -euo pipefail

REPO_TARBALL="https://github.com/AgenticAIJP/ClaudeCodeAutoSetup/archive/refs/heads/main.tar.gz"
VERSION="1.1.0"

# When piped via `curl | bash`, stdin is the script itself.
# Read user input from /dev/tty instead.
if [ -t 0 ]; then
  INPUT="/dev/stdin"
else
  INPUT="/dev/tty"
fi

say() { printf '%b\n' "$1"; }

ARG_TYPE="${1:-}"
ARG_NAME="${2:-}"
ARG_LANG="${3:-}"

say ""
say "┌─────────────────────────────────────────────┐"
say "│  ClaudeCodeAutoSetup v${VERSION}                   │"
say "│  Claude Code プロジェクトを一発生成          │"
say "│  One-command Claude Code project generator   │"
say "└─────────────────────────────────────────────┘"
say ""

# --- 0. Choose language ------------------------------------------------------

LANG_KEY=""
while [ -z "$LANG_KEY" ]; do
  if [ -n "$ARG_LANG" ]; then
    lang_choice="$ARG_LANG"; ARG_LANG=""
  else
    say "言語を選んでください / Choose your language:"
    say ""
    say "  1) 日本語"
    say "  2) English"
    say ""
    printf "[1-2] (default: 1): "
    read -r lang_choice < "$INPUT" || { say ""; say "❌ Cannot read input. Use arguments instead: ./setup.sh <1-6> <name> [ja|en]"; exit 1; }
  fi
  lang_choice="${lang_choice:-1}"
  case "$lang_choice" in
    1|ja|JA) LANG_KEY="ja" ;;
    2|en|EN) LANG_KEY="en" ;;
    *) say "⚠️  1 か 2 を入力してください / Please enter 1 or 2." ;;
  esac
done

if [ "$LANG_KEY" = "ja" ]; then
  OTHER_LANG="en"
  MSG_DOWNLOADING="📦 テンプレートをダウンロード中..."
  MSG_DL_FAILED="❌ ダウンロードに失敗しました。ネットワークを確認してください。"
  MSG_TPL_MISSING="❌ テンプレートが見つかりませんでした。"
  MSG_CHOOSE_TYPE="プロジェクトのタイプを選んでください:"
  MSG_TYPE_1="  1) 汎用ベース      — まずはこれ。最小のきれいな骨格"
  MSG_TYPE_2="  2) Webアプリ型     — frontend / backend 分離"
  MSG_TYPE_3="  3) APIサービス型   — routes / services / models"
  MSG_TYPE_4="  4) CLIツール型     — commands / handlers"
  MSG_TYPE_5="  5) AI Agent型      — agents / skills / tools + MCP"
  MSG_TYPE_6="  6) ドキュメント型  — 学習サイト・技術ブログ"
  MSG_TYPE_PROMPT="番号を入力 [1-6] (デフォルト: 1): "
  MSG_TYPE_INVALID="⚠️  1〜6 の番号を入力してください。"
  MSG_NAME_PROMPT="プロジェクト名を入力 (例: my-app): "
  MSG_NAME_EMPTY="⚠️  プロジェクト名を入力してください。"
  MSG_NAME_INVALID="⚠️  英数字・ハイフン・アンダースコア・ドットのみ使えます。"
  MSG_NAME_EXISTS="⚠️  その名前は既に存在します。別の名前を入力してください。"
  MSG_NO_INPUT="❌ 入力を読み取れませんでした。引数指定も使えます: ./setup.sh <1-6> <名前> [ja|en]"
  MSG_GENERATING="🔧 生成中:"
  MSG_DONE="✅ 完成！ 生成された構造:"
  MSG_NEXT="次の一歩:"
  MSG_STEP2="2. CLAUDE.md を開き、<!-- TODO --> の3箇所を埋める(概要・技術スタック)"
  MSG_STEP3="3. claude を起動して開発開始！"
  MSG_HINT="💡 各設定ファイルの隣にある *.ja.sample.md がその場の解説書です。"
  TYPE_LABEL_1="汎用ベース"; TYPE_LABEL_2="Webアプリ型"; TYPE_LABEL_3="APIサービス型"
  TYPE_LABEL_4="CLIツール型"; TYPE_LABEL_5="AI Agent型"; TYPE_LABEL_6="ドキュメント型"
else
  OTHER_LANG="ja"
  MSG_DOWNLOADING="📦 Downloading templates..."
  MSG_DL_FAILED="❌ Download failed. Please check your network."
  MSG_TPL_MISSING="❌ Templates not found."
  MSG_CHOOSE_TYPE="Choose your project type:"
  MSG_TYPE_1="  1) Generic base    — start here; minimal clean skeleton"
  MSG_TYPE_2="  2) Web app         — split frontend / backend"
  MSG_TYPE_3="  3) API service     — routes / services / models"
  MSG_TYPE_4="  4) CLI tool        — commands / handlers"
  MSG_TYPE_5="  5) AI Agent        — agents / skills / tools + MCP"
  MSG_TYPE_6="  6) Documentation   — learning site / tech blog"
  MSG_TYPE_PROMPT="Enter a number [1-6] (default: 1): "
  MSG_TYPE_INVALID="⚠️  Please enter a number from 1 to 6."
  MSG_NAME_PROMPT="Enter a project name (e.g. my-app): "
  MSG_NAME_EMPTY="⚠️  Please enter a project name."
  MSG_NAME_INVALID="⚠️  Only letters, digits, hyphens, underscores, and dots are allowed."
  MSG_NAME_EXISTS="⚠️  That name already exists. Please choose another."
  MSG_NO_INPUT="❌ Cannot read input. Use arguments instead: ./setup.sh <1-6> <name> [ja|en]"
  MSG_GENERATING="🔧 Generating:"
  MSG_DONE="✅ Done! Generated structure:"
  MSG_NEXT="Next steps:"
  MSG_STEP2="2. Open CLAUDE.md and fill in the three <!-- TODO --> spots (overview, tech stack)"
  MSG_STEP3="3. Launch claude and start building!"
  MSG_HINT="💡 The *.en.sample.md file next to each config file is its on-the-spot documentation."
  TYPE_LABEL_1="Generic base"; TYPE_LABEL_2="Web app"; TYPE_LABEL_3="API service"
  TYPE_LABEL_4="CLI tool"; TYPE_LABEL_5="AI Agent"; TYPE_LABEL_6="Documentation"
fi

# --- 1. Locate templates (local clone or download) ---------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-.}")" 2>/dev/null && pwd || pwd)"
TEMPLATES_DIR=""
TMP_DIR=""

cleanup() { if [ -n "$TMP_DIR" ]; then rm -rf "$TMP_DIR"; fi; }
trap cleanup EXIT

if [ -d "$SCRIPT_DIR/templates/base" ]; then
  TEMPLATES_DIR="$SCRIPT_DIR/templates"
else
  say "$MSG_DOWNLOADING"
  TMP_DIR="$(mktemp -d)"
  if ! curl -fsSL "$REPO_TARBALL" | tar -xz -C "$TMP_DIR"; then
    say "$MSG_DL_FAILED"
    exit 1
  fi
  TEMPLATES_DIR="$(find "$TMP_DIR" -maxdepth 2 -type d -name templates | head -1)"
  if [ -z "$TEMPLATES_DIR" ] || [ ! -d "$TEMPLATES_DIR/base" ]; then
    say "$MSG_TPL_MISSING"
    exit 1
  fi
fi

# --- 2. Choose project type --------------------------------------------------

say ""
say "$MSG_CHOOSE_TYPE"
say ""
say "$MSG_TYPE_1"
say "$MSG_TYPE_2"
say "$MSG_TYPE_3"
say "$MSG_TYPE_4"
say "$MSG_TYPE_5"
say "$MSG_TYPE_6"
say ""

TYPE_KEY=""
while [ -z "$TYPE_KEY" ]; do
  if [ -n "$ARG_TYPE" ]; then
    choice="$ARG_TYPE"; ARG_TYPE=""
  else
    printf "%s" "$MSG_TYPE_PROMPT"
    read -r choice < "$INPUT" || { say ""; say "$MSG_NO_INPUT"; exit 1; }
  fi
  choice="${choice:-1}"
  case "$choice" in
    1) TYPE_KEY="base";      TYPE_LABEL="$TYPE_LABEL_1" ;;
    2) TYPE_KEY="webapp";    TYPE_LABEL="$TYPE_LABEL_2" ;;
    3) TYPE_KEY="api";       TYPE_LABEL="$TYPE_LABEL_3" ;;
    4) TYPE_KEY="cli";       TYPE_LABEL="$TYPE_LABEL_4" ;;
    5) TYPE_KEY="agent";     TYPE_LABEL="$TYPE_LABEL_5" ;;
    6) TYPE_KEY="docs-site"; TYPE_LABEL="$TYPE_LABEL_6" ;;
    *) say "$MSG_TYPE_INVALID" ;;
  esac
done

# --- 3. Project name ----------------------------------------------------------

PROJECT_NAME=""
while [ -z "$PROJECT_NAME" ]; do
  if [ -n "$ARG_NAME" ]; then
    name="$ARG_NAME"; ARG_NAME=""
  else
    printf "%s" "$MSG_NAME_PROMPT"
    read -r name < "$INPUT" || { say ""; say "$MSG_NO_INPUT"; exit 1; }
  fi
  if [ -z "$name" ]; then
    say "$MSG_NAME_EMPTY"
  elif ! printf '%s' "$name" | grep -Eq '^[A-Za-z0-9][A-Za-z0-9._-]*$'; then
    say "$MSG_NAME_INVALID"
  elif [ -e "./$name" ]; then
    say "$MSG_NAME_EXISTS"
  else
    PROJECT_NAME="$name"
  fi
done

TARGET="./$PROJECT_NAME"

# --- 4. Generate ---------------------------------------------------------------

say ""
say "$MSG_GENERATING $PROJECT_NAME ($TYPE_LABEL / $LANG_KEY)"

mkdir -p "$TARGET"
cp -R "$TEMPLATES_DIR/base/." "$TARGET/"

if [ "$TYPE_KEY" != "base" ]; then
  # Remove base paths the overlay replaces (listed in overlay's _remove file)
  if [ -f "$TEMPLATES_DIR/$TYPE_KEY/_remove" ]; then
    while IFS= read -r path; do
      case "$path" in
        ""|/*|*..*) continue ;;  # skip empty / absolute / traversal paths
        *) rm -rf "${TARGET:?}/$path" ;;
      esac
    done < "$TEMPLATES_DIR/$TYPE_KEY/_remove"
  fi
  cp -R "$TEMPLATES_DIR/$TYPE_KEY/." "$TARGET/"
fi

# Resolve languages:
#   - X.<other>.md (Claude-facing) is deleted
#   - X.<lang>.md is renamed to X.md
#   - *.sample.* files keep BOTH languages, side by side
find "$TARGET" -type f -name "*.${OTHER_LANG}.*" ! -name "*.sample.*" -exec rm -f {} +
find "$TARGET" -type f -name "*.${LANG_KEY}.*" ! -name "*.sample.*" | while IFS= read -r f; do
  mv "$f" "${f/.${LANG_KEY}./.}"
done

# Inject the type-specific section into CLAUDE.md ({{TYPE_SECTION}} marker)
SECTION_FILE="$TARGET/_type-section.md"
if [ -f "$SECTION_FILE" ] && grep -q '{{TYPE_SECTION}}' "$TARGET/CLAUDE.md"; then
  awk -v sf="$SECTION_FILE" '
    /\{\{TYPE_SECTION\}\}/ {
      while ((getline line < sf) > 0) print line
      close(sf)
      next
    }
    { print }
  ' "$TARGET/CLAUDE.md" > "$TARGET/CLAUDE.md.tmp"
  mv "$TARGET/CLAUDE.md.tmp" "$TARGET/CLAUDE.md"
fi

# Drop generator metadata files from the generated project
rm -f "$TARGET/_type-section.md" "$TARGET/_remove"

# Replace {{PROJECT_NAME}} placeholders (portable sed -i)
for f in "$TARGET/CLAUDE.md" "$TARGET/README.md"; do
  [ -f "$f" ] || continue
  sed -i.bak "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" "$f" && rm -f "$f.bak"
done

# Make hook scripts executable
chmod +x "$TARGET"/.claude/hooks/*.sh 2>/dev/null || true

# --- 5. Done --------------------------------------------------------------------

say ""
say "$MSG_DONE"
say ""
if command -v tree >/dev/null 2>&1; then
  tree -a -I '.git' "$TARGET"
else
  find "$TARGET" -not -path '*/.git/*' | sed "s|^\./||" | sort | sed 's|[^/]*/|  |g'
fi
say ""
say "$MSG_NEXT"
say ""
say "  1. cd $PROJECT_NAME"
say "  $MSG_STEP2"
say "  $MSG_STEP3"
say ""
say "$MSG_HINT"
say "   https://github.com/AgenticAIJP/ClaudeCodeAutoSetup"
say ""
