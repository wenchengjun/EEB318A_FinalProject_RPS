# 基於 RISC-V 與 MMIO 的互動式猜拳系統實作

## 1. 專題名稱
基於 RISC-V 與 Memory-mapped I/O 的互動式猜拳系統實作

## 2. 使用開發板
Digilent Basys 3 FPGA 開發板 (Artix-7)

## 3. 使用工具版本
* **硬體合成與燒錄**：Xilinx Vivado [請填寫你的版本，例如 2022.2]
* **軟體編譯工具**：RISC-V GNU Toolchain [請填寫你的版本]

## 4. 專案資料夾結構
* `/hw`：包含所有 Verilog 硬體設計模組與 RISC-V CPU 核心原始碼。
* `/sw`：包含 RISC-V 執行的遊戲主程式 `main.c`。
* `/constraints`：包含 Basys 3 的實體腳位約束檔 `Basys3_Master.xdc`。
* `report.pdf`：期末專題成果報告。

## 5. 如何產生 bitstream
1. 開啟 Vivado 並建立一個新的 RTL Project，選擇對應的 FPGA 型號 (xc7a35tcpg236-1)。
2. 將 `/hw` 資料夾下的所有 `.v` 檔案加入 Design Sources。
3. 將 `/constraints` 資料夾下的 `.xdc` 檔案加入 Constraints。
4. 在左側 Flow Navigator 中點擊 **Generate Bitstream**，產生 `.bit` 檔。

## 6. 如何載入或修改 RISC-V 程式
1. 進入 `/sw` 資料夾，修改 `main.c`。
2. 使用 RISC-V GNU Toolchain 進行編譯，轉換為 16 進位的機器碼格式。
3. 將產生的機器碼檔案放入 Vivado 專案中載入至 RISC-V 核心的 Instruction Memory 模組中。

## 7. 如何燒錄到 FPGA 開發板
1. 使用 Micro-USB 線連接 Basys 3 開發板。
2. 在 Vivado 點擊 **Open Hardware Manager** > **Open Target** > **Auto Connect**。
3. 點擊 **Program Device** 進行燒錄。

## 8. 如何操作與測試
1. **系統重置**：按下 `BTNU`。
2. **選擇出拳**：切換 `SW[1:0]`。`00` 石頭、`01` 布、`10` 剪刀。
3. **確認出拳**：按下 `BTNC`。
4. **查看結果**：
   * 七段顯示器：左兩碼玩家分數，右兩碼電腦分數。
   * `LED[15]` 玩家獲勝，`LED[14]` 電腦獲勝，`LED[13]` 平手。

## 9. 已知問題
* 若按下確認鍵過久未放開，可能會觸發連續出拳。

## 10. 外部來源與授權說明
* RISC-V 核心修改自課堂實作專案。
* MMIO 周邊控制器、解彈跳模組與猜拳邏輯軟體為自行開發。
