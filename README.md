
# Project Aliases (Zsh Plugin)

A lightweight **Zsh plugin** to manage **per-project shell aliases**.  
Aliases are **loaded automatically** when you enter a project folder and **removed automatically** when you leave.  

![Project Aliases demo](/assets/project-aliases.svg)

---

## ⚡ Quick Start
```bash
# Inside your project folder
echo "alias run='npm run dev'" > .proj_aliases
echo "alias test='npm test'" >> .proj_aliases

cd ~/my-project
# [project-aliases] Alias loaded from ~/my-project/.proj_aliases

run
# Executes: npm run dev

cd ..
# [project-aliases] Project aliases removed
```

---

## ✨ Features
- Define aliases per project in a `.proj_aliases` file.
- Automatically **load aliases** when entering a project folder.
- Automatically **unload them** when leaving.
- Keep a clean shell environment — no alias pollution between projects.
- Helper commands:

    - palias list → view currently active project aliases

    - palias edit → edit currently project aliases

    - palias reload → reload aliases for the current project without leaving the folder

---

## 📦 Installation

### **Oh My Zsh**
1. Clone the plugin into your Oh My Zsh custom plugins folder:
   ```bash
   git clone https://github.com/dvigo/project-aliases.git ~/.oh-my-zsh/custom/plugins/project-aliases
   ```
2. Enable it in your `~/.zshrc`:
   ```bash
   plugins=(... project-aliases)
   ```
3. Reload Zsh:
   ```bash
   source ~/.zshrc
   ```

---

## 🎥 Demo

TBD

---

## ⚙️ Configuration

No extra configuration is needed.  
Simply create a `.proj_aliases` file in the root of any project you want to use aliases in.

**Example `.proj_aliases`**
```bash
alias run="npm run dev"
alias lint="eslint src/"
alias up="docker-compose up -d"
alias down="docker-compose down"
```

---

## 🖊️ Usage

### Available commands:
```bash
palias list    # Shows active project aliases
palias edit    # Opens the current project's .proj_aliases in your editor
palias reload  # Reload aliases from the current project's .proj_aliases

```

### Example session:
```bash
cd ~/dev/my-api
# [project-aliases] Alias loaded from ~/dev/my-api/.proj_aliases

up      # runs docker-compose up -d
down    # runs docker-compose down

# If you modify .proj_aliases while inside the project
palias reload
# [project-aliases] Aliases reloaded from ~/dev/my-api/.proj_aliases

cd ..
# [project-aliases] Project aliases removed
```

---

## 🔧 Roadmap
- [ ] Add support for `.proj_aliases.d/` folder with multiple alias files.
- [ ] Add an option to persist aliases across shells until manually cleared.
- [ ] Add support for project-specific environment variables.

---

## 📜 License
GNU General Public License v3.0 — See [LICENSE](LICENSE) for details.

---