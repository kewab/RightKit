import Foundation

struct RightKitStrings {
    let language: AppLanguage

    var ready: String {
        switch language {
        case .chinese: return "就绪"
        case .english: return "Ready"
        }
    }

    var favoritesTab: String {
        switch language {
        case .chinese: return "常用目录"
        case .english: return "Favorites"
        }
    }

    var templatesTab: String {
        switch language {
        case .chinese: return "新建文件"
        case .english: return "Templates"
        }
    }

    var statusTab: String {
        switch language {
        case .chinese: return "通用设置"
        case .english: return "General"
        }
    }

    var generalSettingsTitle: String {
        switch language {
        case .chinese: return "通用设置"
        case .english: return "General Settings"
        }
    }

    var generalSettingsSubtitle: String {
        switch language {
        case .chinese: return "控制菜单显示、触发方式和基础权限引导。"
        case .english: return "Control menu visibility, trigger methods, and permission guidance."
        }
    }

    var favoriteDirectoriesTitle: String {
        switch language {
        case .chinese: return "常用目录"
        case .english: return "Favorite Directories"
        }
    }

    var favoriteDirectoriesSubtitle: String {
        switch language {
        case .chinese: return "这些目录会出现在复制到、移动到和常用目录菜单里。"
        case .english: return "These destinations appear in Copy To, Move To, and Favorites menus."
        }
    }

    var favoriteDirectoriesEmptyHint: String {
        switch language {
        case .chinese: return "点击左下角 + 添加一个目录。"
        case .english: return "Click the + button below to add a directory."
        }
    }

    var noFavoriteDirectories: String {
        switch language {
        case .chinese: return "还没有常用目录。"
        case .english: return "No favorite directories yet."
        }
    }

    var addDirectory: String {
        switch language {
        case .chinese: return "添加目录"
        case .english: return "Add Directory"
        }
    }

    var reload: String {
        switch language {
        case .chinese: return "重新载入"
        case .english: return "Reload"
        }
    }

    var templatesTitle: String {
        switch language {
        case .chinese: return "新建文件模板"
        case .english: return "New File Templates"
        }
    }

    var templatesSubtitle: String {
        switch language {
        case .chinese: return "管理右键“新建文件”菜单中显示的模板。"
        case .english: return "Manage templates shown in the New File context menu."
        }
    }

    var launchAndDisplayTitle: String {
        switch language {
        case .chinese: return "启动与显示"
        case .english: return "Launch & Display"
        }
    }

    var triggerMethodsTitle: String {
        switch language {
        case .chinese: return "触发方式"
        case .english: return "Trigger Methods"
        }
    }

    var permissionsTitle: String {
        switch language {
        case .chinese: return "权限"
        case .english: return "Permissions"
        }
    }

    var permissionsDescription: String {
        switch language {
        case .chinese: return "部分功能无法使用时，您可以授予完全磁盘访问权限来解决。"
        case .english: return "If some actions fail, granting Full Disk Access can help resolve permission issues."
        }
    }

    var watchPermissionGuide: String {
        switch language {
        case .chinese: return "观看权限设置教学 >>"
        case .english: return "Watch Permission Guide >>"
        }
    }

    var permissionSetupGuide: String {
        switch language {
        case .chinese: return "权限设置引导 >>"
        case .english: return "Permission Setup Guide >>"
        }
    }

    var triggerMethodOne: String {
        switch language {
        case .chinese: return "按住修饰键 鼠标右键点击"
        case .english: return "Hold a modifier key and right-click"
        }
    }

    var triggerMethodTwo: String {
        switch language {
        case .chinese: return "鼠标中键点击"
        case .english: return "Middle mouse button click"
        }
    }

    var triggerMethodThree: String {
        switch language {
        case .chinese: return "触控板上三指轻点 / 三指点按"
        case .english: return "Three-finger tap / click on trackpad"
        }
    }

    var viewHowToUse: String {
        switch language {
        case .chinese: return "查看使用方法 >>"
        case .english: return "View How To Use >>"
        }
    }

    var showMenuBarIcon: String {
        switch language {
        case .chinese: return "显示菜单栏图标"
        case .english: return "Show menu bar icon"
        }
    }

    var scopeLabel: String {
        switch language {
        case .chinese: return "使用范围:"
        case .english: return "Scope:"
        }
    }

    var systemDiskScope: String {
        switch language {
        case .chinese: return "系统磁盘"
        case .english: return "System Disk"
        }
    }

    var iconColumnTitle: String {
        switch language {
        case .chinese: return "图标"
        case .english: return "Icon"
        }
    }

    var realPathColumnTitle: String {
        switch language {
        case .chinese: return "真实路径"
        case .english: return "Real Path"
        }
    }

    var displayNameColumnTitle: String {
        switch language {
        case .chinese: return "显示名称（双击编辑/按住拖拽）"
        case .english: return "Display Name"
        }
    }

    var enabledColumnTitle: String {
        switch language {
        case .chinese: return "启用"
        case .english: return "Enabled"
        }
    }

    var suffixColumnTitle: String {
        switch language {
        case .chinese: return "后缀"
        case .english: return "Suffix"
        }
    }

    var mainMenuColumnTitle: String {
        switch language {
        case .chinese: return "主菜单"
        case .english: return "Main Menu"
        }
    }

    var showIcons: String {
        switch language {
        case .chinese: return "显示图标"
        case .english: return "Show Icons"
        }
    }

    var enableFavoriteDirectories: String {
        switch language {
        case .chinese: return "启用常用目录"
        case .english: return "Enable Favorite Directories"
        }
    }

    var openFileAfterCreate: String {
        switch language {
        case .chinese: return "新建文件后自动打开"
        case .english: return "Open new file after creation"
        }
    }

    var playPromptSound: String {
        switch language {
        case .chinese: return "开启提示音"
        case .english: return "Play prompt sound"
        }
    }

    var addTemplateFile: String {
        switch language {
        case .chinese: return "添加模板文件"
        case .english: return "Add Template File"
        }
    }

    var finderMenuTroubleshooting: String {
        switch language {
        case .chinese: return "右键菜单失效的解决方法 >>"
        case .english: return "Fix Missing Finder Menu >>"
        }
    }

    var resetDefaults: String {
        switch language {
        case .chinese: return "恢复默认"
        case .english: return "Reset Defaults"
        }
    }

    var statusTitle: String {
        switch language {
        case .chinese: return "RightKit 状态"
        case .english: return "RightKit Status"
        }
    }

    var statusSubtitle: String {
        switch language {
        case .chinese: return "宿主 App 已就绪，Finder 菜单由扩展目标接入。"
        case .english: return "Host app is ready. Finder menu wiring comes from the extension target."
        }
    }

    var appGroup: String {
        switch language {
        case .chinese: return "App Group"
        case .english: return "App Group"
        }
    }

    var favoriteDirectoriesCount: String {
        switch language {
        case .chinese: return "常用目录"
        case .english: return "Favorite Directories"
        }
    }

    var fileTemplatesCount: String {
        switch language {
        case .chinese: return "文件模板"
        case .english: return "File Templates"
        }
    }

    var cutItemsCount: String {
        switch language {
        case .chinese: return "剪切项目"
        case .english: return "Cut Items"
        }
    }

    var languageLabel: String {
        switch language {
        case .chinese: return "语言"
        case .english: return "Language"
        }
    }

    var reloadSharedState: String {
        switch language {
        case .chinese: return "重新载入共享状态"
        case .english: return "Reload Shared State"
        }
    }

    var clearCutState: String {
        switch language {
        case .chinese: return "清空剪切状态"
        case .english: return "Clear Cut State"
        }
    }

    var newFile: String {
        switch language {
        case .chinese: return "新建文件"
        case .english: return "New File"
        }
    }

    var copyTo: String {
        switch language {
        case .chinese: return "复制到"
        case .english: return "Copy To"
        }
    }

    var moveTo: String {
        switch language {
        case .chinese: return "移动到"
        case .english: return "Move To"
        }
    }

    var copyPath: String {
        switch language {
        case .chinese: return "拷贝路径"
        case .english: return "Copy Path"
        }
    }

    var cut: String {
        switch language {
        case .chinese: return "剪切"
        case .english: return "Cut"
        }
    }

    var paste: String {
        switch language {
        case .chinese: return "粘贴"
        case .english: return "Paste"
        }
    }

    var noTemplates: String {
        switch language {
        case .chinese: return "没有文件模板"
        case .english: return "No File Templates"
        }
    }

    var openFavoriteDirectory: String {
        switch language {
        case .chinese: return "打开常用目录"
        case .english: return "Open Favorite Directory"
        }
    }

    var finderExtensionSetupTitle: String {
        switch language {
        case .chinese: return "Finder 扩展启用"
        case .english: return "Finder Extension Setup"
        }
    }

    var finderExtensionSetupSubtitle: String {
        switch language {
        case .chinese: return "右键菜单不出现，通常是 Finder 扩展目标没有签名、嵌入或启用。"
        case .english: return "If the context menu is missing, the Finder extension target is usually not signed, embedded, or enabled."
        }
    }

    var finderExtensionSetupStep1: String {
        switch language {
        case .chinese: return "1. 用完整 Xcode 打开项目，并为 RightKitApp 与 RightKitFinderExt 选择同一个 Signing Team。"
        case .english: return "1. Open the project in full Xcode and choose the same Signing Team for RightKitApp and RightKitFinderExt."
        }
    }

    var finderExtensionSetupStep2: String {
        switch language {
        case .chinese: return "2. 确认两个目标都保留 App Group: group.com.deacyn.RightKit。"
        case .english: return "2. Confirm both targets keep the App Group: group.com.deacyn.RightKit."
        }
    }

    var finderExtensionSetupStep3: String {
        switch language {
        case .chinese: return "3. 运行 RightKitApp 一次，让宿主 App 安装并嵌入 Finder 扩展。"
        case .english: return "3. Run RightKitApp once so the host app installs and embeds the Finder extension."
        }
    }

    var finderExtensionSetupStep4: String {
        switch language {
        case .chinese: return "4. 到 系统设置 > 隐私与安全性 > 扩展 > Finder 扩展，启用 RightKit；如仍未显示，再重启 Finder。"
        case .english: return "4. In System Settings > Privacy & Security > Extensions > Finder Extensions, enable RightKit; restart Finder if it still does not appear."
        }
    }

    var copyFinderActivationCommand: String {
        switch language {
        case .chinese: return "复制 Finder 启用命令"
        case .english: return "Copy Finder Activation Command"
        }
    }

    var finderExtensionSetupFootnote: String {
        switch language {
        case .chinese: return "当前工程已经包含 Finder 扩展目标，但完整构建和启用仍依赖本机已安装完整 Xcode。"
        case .english: return "The project now includes the Finder extension target, but full build and activation still require a complete local Xcode installation."
        }
    }

    var finderActivationCommandCopied: String {
        switch language {
        case .chinese: return "Finder 扩展启用命令已复制到剪贴板"
        case .english: return "Finder extension activation command copied to the clipboard"
        }
    }

    func templateTitle(for template: NewFileTemplate) -> String {
        switch (language, template.fileExtension) {
        case (.chinese, "txt"): return "文本文件"
        case (.chinese, "md"): return "Markdown 文件"
        case (.chinese, "json"): return "JSON 文件"
        default: return template.title
        }
    }

    func untitledFilename(for template: NewFileTemplate) -> String {
        switch language {
        case .chinese:
            return "未命名.\(template.fileExtension)"
        case .english:
            return template.suggestedFilename
        }
    }

    func directoryAlreadyExists(_ path: String) -> String {
        switch language {
        case .chinese: return "目录已存在：\(path)"
        case .english: return "Directory already exists: \(path)"
        }
    }

    func addedFavoriteDirectory(_ name: String) -> String {
        switch language {
        case .chinese: return "已添加常用目录：\(name)"
        case .english: return "Added favorite directory: \(name)"
        }
    }

    var removedFavoriteDirectory: String {
        switch language {
        case .chinese: return "已移除常用目录"
        case .english: return "Removed favorite directory"
        }
    }

    var templatesReset: String {
        switch language {
        case .chinese: return "模板已恢复默认"
        case .english: return "Templates reset"
        }
    }

    var cutStateCleared: String {
        switch language {
        case .chinese: return "剪切状态已清空"
        case .english: return "Cut state cleared"
        }
    }

    var reloadedSharedConfiguration: String {
        switch language {
        case .chinese: return "已重新载入共享配置"
        case .english: return "Reloaded shared configuration"
        }
    }

    func languageChanged(to language: AppLanguage) -> String {
        switch self.language {
        case .chinese: return "语言已切换为：\(language.displayName)"
        case .english: return "Language changed to: \(language.displayName)"
        }
    }
}
