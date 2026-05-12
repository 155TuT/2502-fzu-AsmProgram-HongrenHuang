# 程序流程图

## 1. 主程序流程图 (main)

```mermaid
graph TD
    A[开始] --> B[输出提示信息]
    B --> C[ReadString <br/>EAX = 实际字符串长度]
    C --> D[Len = AX<br/>保存字符串长度]
    D --> E[ESI = STRING<br/>ECX = Len]
    E --> F[RemoveConsecutiveChar<br/>删除连续重复字符<br/>EAX = 新长度]
    F --> G[ESI = STRING<br/>ECX = EAX 去重后长度]
    G --> H[ReverseString<br/>字符串倒序存放]
    H --> I[Len = AX<br/>保存最终长度]
    I --> J[输出倒序后的字符串和字符串长度]
    J --> K[结束]
```

## 2. RemoveConsecutiveChar 子程序流程图

```mermaid
graph TD
    A[入口:<br/>ESI=字符串首地址<br/>ECX=字符串长度] --> B[push ESI, EDI, EBX<br/>保存寄存器]
    B --> C{是否为空串}
    C -->|是| D[RCC_Exit]
    C -->|否| E[EDI = ESI<br/>写指针指向首地址]
    E --> F[BL = ESI 首个字符<br/>EDI = BL 写入<br/>ESI++ / EDI++ / ECX--]
    F --> G{ECX = 0 ?}
    G -->|是| H1[RCD_Finish]
    G -->|否| I[读取当前字符]
    I --> J{AL = BL ?<br/>是否重复}
    J -->|重复| K[跳过不写入]
    J -->|不重复| L[BL = AL 更新<br/>EDI = AL 写入<br/>EDI++ 写指针后移]
    K --> M[ESI++ / ECX--]
    L --> M
    M --> N{ECX = 0 ?}
    N -->|否| I
    N -->|是| H1
    H1[EDI = 0<br/>写入字符串结束符] --> O[EAX = EDI<br/>记录写指针位置]
    D --> O
    O --> P[pop EBX, EDI, ESI<br/>恢复寄存器<br/>EAX = EAX - ESI<br/>新长度=写指针-首地址]
    P --> Q[RET 返回<br/>EAX=新字符串长度]
```

## 3. ReverseString 子程序流程图

```mermaid
graph TD
    A[入口:<br/>ESI=字符串首地址<br/>ECX=字符串长度] --> B{长度小于等于 1 ?}
    B -->|是| C[完成]
    B -->|否| D[EDI = ESI + ECX - 1<br/>尾指针指向末字符]
    D --> E{ESI 大于等于 EDI ?<br/>指针相遇或交错}
    E -->|是| C
    E -->|否| F[AL = ESI 取头字符<br/>BL = EDI 取尾字符]
    F --> G[ESI = BL 尾写到头<br/>EDI = AL 头写到尾]
    G --> H[ESI++ 头指针后移<br/>EDI-- 尾指针前移]
    H --> E
```

## 算法说明

### 删除连续重复字符算法
采用双指针法原地操作：
- **读指针 (ESI)**: 遍历原始字符串
- **写指针 (EDI)**: 指向去重后字符串的当前写入位置
- 维护变量 BL 记录上一个写入的字符，如果当前字符与 BL 相同则跳过，否则写入并更新 BL

### 字符串倒序算法
采用双指针从两端向中间靠拢：
- **头指针 (ESI)**: 初始指向字符串首字符
- **尾指针 (EDI)**: 初始指向字符串末字符
- 交换两个指针所指字符，然后头指针后移、尾指针前移，直至两者相遇

### 示例
输入: `aaabccadcccl1222`
- 去重后: `abcadcl12`
- 倒序后: `21lcdacba`
