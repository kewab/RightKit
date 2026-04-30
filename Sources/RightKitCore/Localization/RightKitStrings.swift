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
        case .chinese: return "状态"
        case .english: return "Status"
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
        case .chinese: return "这些目录会出现在复制到和移动到菜单里。"
        case .english: return "These destinations will appear in Copy To and Move To menus."
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
        case .chinese: return "第一版先提供固定的轻量模板。"
        case .english: return "The first version ships with a fixed minimal template set."
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
