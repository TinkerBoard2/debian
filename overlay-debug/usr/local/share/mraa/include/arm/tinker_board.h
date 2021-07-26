/*
 * Author: Brian <brian@vamrs.com>
 * Copyright (c) 2019 Vamrs Corporation.
 *
 * SPDX-License-Identifier: MIT
 */

#pragma once

#ifdef __cplusplus
extern "C" {
#endif

#include "mraa_internal.h"

#define MRAA_TINKER2_GPIO_COUNT 28
#define MRAA_TINKER2_I2C_COUNT  2
#define MRAA_TINKER2_SPI_COUNT  2
#define MRAA_TINKER2_UART_COUNT 2
#define MRAA_TINKER2_PWM_COUNT  3
#define MRAA_TINKER2_AIO_COUNT  0
#define MRAA_TINKER2_PIN_COUNT  40

#define MRAA_TINKERS_GPIO_COUNT 28
#define MRAA_TINKERS_I2C_COUNT  2
#define MRAA_TINKERS_SPI_COUNT  2
#define MRAA_TINKERS_UART_COUNT 3
#define MRAA_TINKERS_PWM_COUNT  2
#define MRAA_TINKERS_AIO_COUNT  0
#define MRAA_TINKERS_PIN_COUNT  40

#define MRAA_TINKEREDGET_GPIO_COUNT 28
#define MRAA_TINKEREDGET_I2C_COUNT  2
#define MRAA_TINKEREDGET_SPI_COUNT  1
#define MRAA_TINKEREDGET_UART_COUNT 2    //UART1 and UART3
#define MRAA_TINKEREDGET_PWM_COUNT  3
#define MRAA_TINKEREDGET_AIO_COUNT  0
#define MRAA_TINKEREDGET_PIN_COUNT  40

mraa_board_t *
        mraa_tinkerboard();

#ifdef __cplusplus
}
#endif
