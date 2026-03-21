# 使用须知

## 基础32位汇编环境构建

本课程是32位汇编语言程序设计，个人使用的是win11，cpu是x86架构的，因此环境可以通过 `/Environments/vs.BuildTools.exe`

下载 `Visual Studio Build Tools`

其中的 `Desktop development with C++`

意在使用其中的

- ml.exe
- link.exe
- x64 构建工具
- Windows SDK

因此可在 `Developer Command Prompt` 中使用下列指令以验证：

```cmd
echo %VSCMD_VER%
where ml
where link
```

## 课程使用的资源包

在 `/Environments/Irvine.zip` (来自 [Asmbook](https://github.com/surferkip/asmbook)) 中解压以获得关键的

- Irvine32.inc
- Irvine32.lib

但注意：**需要整体解压，不能单独把这两个文件复制出来使用** （见[官方教程](https://www.asmirvine.com/gettingStartedVS2022/index.htm)）

解压后我采取了这样的文件夹结构以存放 Irvine 文件，达到环境和作业彻底解耦的目的：

```txt
C:\asm32\
├─bin\ <-存放后文的 *.cmd 以方便编译运行
└─third_party\Irvine\ <- 解压后的 Irvine 文件夹
```

## 一些小工具

在 `/self-learning/tools` 中涵盖了两个小工具：

- `build32.cmd` 对源代码*.asm进行编译
- `run32.cmd` 运行编译好的*.exe文件

可 `cd test` 以尝试使用终端编译并运行其中的程序，也可以借助 `/.vscode/tasks.json` 对当前打开的 *.asm 文件使用 `ctrl+shift+b` 以自动编译运行，或 `ctrl+shift+p` 以手动选择任务执行

## fzuasm

本课的正统环境，实际流程与上述一样，都是加入了资源包、编译运行脚本，除此之外还加入了系统宏以提高可读性，而在 `/fzuasm/Examples` 里，存放了所有的本课代码示例
