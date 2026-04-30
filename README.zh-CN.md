[English](README.md) | [简体中文](README.zh-CN.md)

# RightKit

RightKit 是一个原生 macOS Finder 右键菜单效率工具，目标是提供快速、稳定、可预期的文件操作能力。

## MVP 功能

- 新建文件
- 复制到
- 移动到
- 常用目录
- 拷贝路径
- 剪切 / 粘贴

## 技术栈

- `Swift`
- `SwiftUI`
- `AppKit`
- `Finder Sync Extension`
- `App Group` + `UserDefaults`
- `FileManager`
- `XcodeGen`

## 项目结构

- `RightKitApp`：宿主 App、设置页、引导页、共享配置管理
- `RightKitFinderExt`：Finder 右键菜单扩展
- `Sources/RightKitCore`：共享模型、存储、国际化和文件操作逻辑

## 环境要求

- macOS 13+
- Xcode
- 如果需要重新生成工程，还需要 `xcodegen`

## 快速开始

### 1. 生成 Xcode 工程

```bash
brew install xcodegen
chmod +x Scripts/generate_xcodeproj.sh
Scripts/generate_xcodeproj.sh
```

### 2. 打开工程

```bash
open RightKit.xcodeproj
```

### 3. 构建并运行 App

在 Xcode 中运行 `RightKitApp` scheme。

### 4. 启用 Finder 扩展

宿主 App 至少启动一次后，在下面位置启用 `RightKit`：

`系统设置 > 扩展 > Finder 扩展`

如果 Finder 没有立刻加载扩展，重启 Finder 即可。

## 命令行辅助脚本

### 仅运行宿主 App

```bash
chmod +x Scripts/build_app.sh Scripts/run_app.sh
Scripts/run_app.sh
```

这个路径会用 `swiftc` 构建 SwiftUI 宿主 App，输出目录是：

```text
.build/local/RightKit.app
```

它适合宿主 App 的快速迭代；Finder 扩展的开发和验证仍建议走 Xcode。

### 运行测试

```bash
chmod +x Scripts/test.sh
Scripts/test.sh
```

核心回归测试位于：

```text
Tests/RightKitCoreTests
```

## Finder 扩展说明

- 扩展源码位于 `Sources/RightKitFinderExt`
- 扩展配置位于 `Config/RightKitFinderExt.Info.plist` 和 `Config/RightKitFinderExt.entitlements`
- 共享配置通过 App Group 存储
- App 和扩展都支持中英文，默认显示中文

## 开发约束

- Finder 扩展层保持轻量，复用逻辑尽量放到 `RightKitCore`
- 优先保证稳定性，而不是功能堆叠
- 除非明确批准，不扩展 MVP 范围
