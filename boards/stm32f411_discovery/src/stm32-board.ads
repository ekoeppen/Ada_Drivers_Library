------------------------------------------------------------------------------
--                                                                          --
--                  Copyright (C) 2015-2016, AdaCore                        --
--                                                                          --
--  Redistribution and use in source and binary forms, with or without      --
--  modification, are permitted provided that the following conditions are  --
--  met:                                                                    --
--     1. Redistributions of source code must retain the above copyright    --
--        notice, this list of conditions and the following disclaimer.     --
--     2. Redistributions in binary form must reproduce the above copyright --
--        notice, this list of conditions and the following disclaimer in   --
--        the documentation and/or other materials provided with the        --
--        distribution.                                                     --
--     3. Neither the name of STMicroelectronics nor the names of its       --
--        contributors may be used to endorse or promote products derived   --
--        from this software without specific prior written permission.     --
--                                                                          --
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS    --
--   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT      --
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR  --
--   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT   --
--   HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, --
--   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT       --
--   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,  --
--   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY  --
--   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT    --
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE  --
--   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.   --
--                                                                          --
--                                                                          --
--  This file is based on:                                                  --
--                                                                          --
--   @file    stm32f429i_discovery.h                                        --
--   @author  MCD Application Team                                          --
--   @version V1.1.0                                                        --
--   @date    19-June-2014                                                  --
--   @brief   This file contains definitions for STM32F429I-Discovery Kit   --
--            LEDs, push-buttons hardware resources.                        --
--                                                                          --
--   COPYRIGHT(c) 2014 STMicroelectronics                                   --
------------------------------------------------------------------------------

--  This file provides declarations for devices on the STM32F429 Discovery kits
--  manufactured by ST Microelectronics.

with STM32.Device;  use STM32.Device;

with STM32.GPIO;    use STM32.GPIO;
with STM32.SPI;     use STM32.SPI;

with L3GD20;

with Ada.Interrupts.Names;  use Ada.Interrupts;

package STM32.Board is

   pragma Elaborate_Body;

   ----------
   -- LEDs --
   ----------

   subtype User_LED is GPIO_Point;

   Green_LED : User_LED renames PD12;
   Orange_LED : User_LED renames PD13;
   Red_LED   : User_LED renames PD14;
   Blue_LED : User_LED renames PD15;

   LCH_LED : User_LED renames Red_LED;

   All_LEDs  : GPIO_Points := Green_LED & Red_LED & Orange_LED & Blue_LED;

   procedure Initialize_LEDs;
   --  MUST be called prior to any use of the LEDs unless initialization is
   --  done by the app elsewhere.

   procedure Turn_On  (This : in out User_LED) renames STM32.GPIO.Set;
   procedure Turn_Off (This : in out User_LED) renames STM32.GPIO.Clear;
   procedure Toggle   (This : in out User_LED) renames STM32.GPIO.Toggle;

   procedure All_LEDs_Off with Inline;
   procedure All_LEDs_On  with Inline;

   procedure Toggle_LEDs (These : in out GPIO_Points) renames STM32.GPIO.Toggle;

   ---------------
   -- SPI3 Pins --
   ---------------

   --  Required for the gyro and LCD so defined here

   SPI1_SCK     : GPIO_Point renames PA5;
   SPI1_MISO    : GPIO_Point renames PA6;
   SPI1_MOSI    : GPIO_Point renames PA7;
   NCS_MEMS_SPI : GPIO_Point renames PE3;
   MEMS_INT1    : GPIO_Point renames PE0;
   MEMS_INT2    : GPIO_Point renames PE1;

   -----------------
   -- User button --
   -----------------

   User_Button_Point     : GPIO_Point renames PA0;
   User_Button_Interrupt : constant Interrupt_ID := Names.EXTI0_Interrupt;

   procedure Configure_User_Button_GPIO;
   --  Configures the GPIO port/pin for the blue user button. Sufficient
   --  for polling the button, and necessary for having the button generate
   --  interrupts.

   ----------
   -- Gyro --
   ----------

   Gyro_SPI : SPI_Port renames SPI_1;
   --  The gyro and LCD use the same port and pins. See the STM32F429 Discovery
   --  kit User Manual (UM1670) pages 21 and 23.

   Gyro_Interrupt_1_Pin : GPIO_Point renames MEMS_INT1;
   Gyro_Interrupt_2_Pin : GPIO_Point renames MEMS_INT2;
   --  Theese are the GPIO pins on which the gyro generates interrupts if so
   --  commanded. The gyro package does not references these, only clients'
   --  interrupt handlers do.

   Gyro : L3GD20.Three_Axis_Gyroscope;

   procedure Initialize_Gyro_IO;
   --  This is a board-specific routine. It initializes and configures the
   --  GPIO, SPI, etc. for the on-board L3GD20 gyro as required for the F429
   --  Disco board. See the STM32F429 Discovery kit User Manual (UM1670) for
   --  specifics.

end STM32.Board;
