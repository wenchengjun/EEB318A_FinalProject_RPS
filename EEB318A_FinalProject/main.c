#include <stdint.h>

// 定義 Memory-mapped I/O 位址
#define SW_REG       (*((volatile uint32_t *)0x4000))
#define BTN_REG      (*((volatile uint32_t *)0x4004))
#define SEVENSEG_REG (*((volatile uint32_t *)0x4008))
#define LED_REG      (*((volatile uint32_t *)0x400C))
#define TIMER_REG    (*((volatile uint32_t *)0x4010))

void delay(int count) {
    volatile int i;
    for (i = 0; i < count; i++);
}

// 十進位轉 BCD 格式
uint32_t to_bcd(uint32_t val) {
    return ((val / 10) << 4) | (val % 10);
}

int main() {
    uint32_t player_score = 0;
    uint32_t comp_score = 0;

    SEVENSEG_REG = 0x0000;
    LED_REG = 0x0000;

    while (1) {
        uint32_t btn_status = BTN_REG;

        // 若按下 BTNU (上方按鈕)，重置
        if (btn_status & 0x02) {
            player_score = 0;
            comp_score = 0;
            SEVENSEG_REG = 0x0000;
            LED_REG = 0x0000;
            delay(50000); 
            continue;
        }

        // 若按下 BTNC (中間按鈕)，確認出拳
        if (btn_status & 0x01) {
            uint32_t player_choice = SW_REG & 0x03; // 0=石頭, 1=布, 2=剪刀
            if (player_choice > 2) continue;

            uint32_t comp_choice = TIMER_REG % 3;
            uint32_t led_out = 0;

            if (player_choice == comp_choice) {
                led_out = (1 << 13); // 平手
            } else if ((player_choice == 0 && comp_choice == 2) ||
                       (player_choice == 1 && comp_choice == 0) ||
                       (player_choice == 2 && comp_choice == 1)) {
                player_score++;
                if (player_score > 99) player_score = 99;
                led_out = (1 << 15); // 玩家勝
            } else {
                comp_score++;
                if (comp_score > 99) comp_score = 99;
                led_out = (1 << 14); // 電腦勝
            }

            LED_REG = led_out;
            uint32_t display_val = (to_bcd(player_score) << 8) | to_bcd(comp_score);
            SEVENSEG_REG = display_val;

            // 等待玩家放開確認按鈕
            while (BTN_REG & 0x01) { delay(1000); }
            delay(50000); 
        }
    }
    return 0;
}