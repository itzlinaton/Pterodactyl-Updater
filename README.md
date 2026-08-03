<img width="3816" height="1024" alt="banner" src="https://github.com/user-attachments/assets/bf37e455-39c6-4270-9719-9075fe0b7f41" />

# 🐦 Pterodactyl-Updater

### 🚀 Automatically keep your Pterodactyl Panel & Wings `up-to-date`!

Tired of manually downloading updates for Pterodactyl? Feel free to sit back and allow the updater to handle it for you!

[![Downloads Latest](https://img.shields.io/github/downloads/itzlinaton/Pterodactyl-Updater/latest/total?style=for-the-badge&logo=github&logoColor=white&label=Downloads%20Latest&color=007ec6)](https://github.com/itzlinaton/Pterodactyl-Updater/releases)
![License](https://img.shields.io/github/license/itzlinaton/Pterodactyl-Updater?style=for-the-badge)
![Last Commit](https://img.shields.io/github/last-commit/itzlinaton/Pterodactyl-Updater?style=for-the-badge&logo=git)

---

## ✨ Features

🔄 **Automatic Panel & Wings update checks**
- The tool checks every **6 hours** for new available Wings & Panel Updates.
- Allowing your Pterodactyl installations to be up-to-date!

📦 **Automatic updater script checks**
- Checks for new versions of the updater itself every **6 hours** to keep the tool up-to-date!

---

## 🖥️ Supported Systems

> [!NOTE]
> This script currently only supports Ubuntu as of now. Other operating systems are not supported at this time!

| System | Status |
| --- | --- |
| 🐧 Ubuntu | 🟢 **Supported** |

---

## 📥 Installation

Install **Pterodactyl-Updater** by running:

```sh
curl -sSL https://raw.githubusercontent.com/itzlinaton/Pterodactyl-Updater/main/installer.sh | bash
```

After installation is complete, you may now execute the command below:

```sh
ptero-update
```

This will check for available **Panel & Wings updates** and apply them when needed.
Optionally use this command if you **do not** have automatic updates enabled.

---

## 🔄 Updating the Script

To update **Pterodactyl-Updater** itself, run:

```sh
ptero-update-installer
```

---

## 🖼️ Themes & Addons

> [!CAUTION]
> This script may **cause issues** with **themes** and **addons**. **Themes** and **addons** are not officially supported by default in Pterodactyl and may be overwritten during installation processes.

---

## ⚙️ Configuration

Automatic update checks run every **6 hours**.

The following features are optional:

- 🐦 Panel & Wings update checks
- 📦 Script update checks

To disable one of the following checks, execute the update script which can be found above (`ptero-update-installer`)

---

## 🤝 Contributing

Want to help improve **Pterodactyl-Updater**?

Contributions are welcome! Feel free to open a **pull request** with improvements, fixes, or new features.

---

## ⭐ Support

If this project helped you, consider giving it a star!

Your support helps keep the project maintained ❤️

---

<div align="center">

⭐ Thanks for using **Pterodactyl-Updater**!

</div>
