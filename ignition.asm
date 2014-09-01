  LIST        P=16F876A
    INCLUDE     p16f876a.inc
 __CONFIG _FOSC_HS & _WDTE_OFF & _PWRTE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _WRT_OFF & _CP_OFF

;Порядок - от старшего к младшему (little-endian).
TMR0PRELOAD50US     equ     0x38        ;Предустановленное значение таймера.
TMR1PR1             equ     0xff
CONST_ZERO          equ     0x00
CONST_ONE           equ     0x01
CONST_FF            equ     0xff
CONST_160           equ     .160
CONST_192           equ     .192        ;Сдвинутое на 4 разряда влево число 12.
CONST_12            equ     .12
TOOTH_ANGLE         equ     .12         ;Количество градусов между зубами x2.
TOOTH_NUMBER        equ     .58         ;Количество зубов.
ANGLE_MAX_H         equ     0x02        ;Максимальный угол х2. Старший байт.
ANGLE_MAX_L         equ     0xD0        ;Максимальный угол х2. Младший байт.
TOOTH_OFFSET        equ     .10         ;Номер первого зуба после пробела.
TOOTH_MAX           equ     .58         ;Максимальное количество зубов.
ANGLE_CORRECT_ITER  equ     .3          ;Количество итераций коррекции
                                        ; подсчета скорости после обнаружения
                                        ; метки.
STATUS_MARK         equ     .0          ;Флаг состояния - метка.
STATUS_STOP         equ     .1          ;Флаг состояния - останов.
STATUS_IGN_EN       equ     .2          ;Флаг состояния - зажигание разрешено.
STATUS_TOOTH_MISS   equ     .4          ;Флаг состояния - первое беззубье,
                                        ; ставится один раз либо после запуска.
;*Предопределенные углы зажигания. В шестнадцатиричном виде и сдвинутые на 4
; разряда влево. Соответствуют градусам ANGLE_IGN_N.
;НЕ ЗАБЫВАТЬ ПРИ ИСПОЛЬЗОВАНИИ RAM ПЕРЕМЕННЫХ ПРИМЕНЯТЬ КОМАНДУ MOVLW.
        ignition1L      equ	0x40
        ignition2L      equ	0x80
        ignition3L      equ	0xC0
        ignition4L      equ	0x0
        ignition5L      equ	0x40
        ignition6L      equ	0x80
        ignition7L      equ	0xC0
        ignition8L      equ	0x0
        ignition9L      equ	0x40
        ignition10L     equ	0x80
        ignition11L     equ	0xC0
        ignition12L     equ	0x0

        ignition1H      equ	0x1
        ignition2H      equ	0x2
        ignition3H      equ	0x3
        ignition4H      equ	0x5
        ignition5H      equ	0x6
        ignition6H      equ	0x7
        ignition7H      equ	0x8
        ignition8H      equ	0xA
        ignition9H      equ	0xB
        ignition10H     equ	0xC
        ignition11H     equ	0xD
        ignition12H     equ	0xF

;*Предопределенные углы зажигания.
;TODO Должны задаваться и корректироваться с пульта. А пока заданы железно.
ANGLE_IGN_1         equ     .20
ANGLE_IGN_2         equ     .40
ANGLE_IGN_3         equ     .60
ANGLE_IGN_4         equ     .80
ANGLE_IGN_5         equ     .100
ANGLE_IGN_6         equ     .120
ANGLE_IGN_7         equ     .140
ANGLE_IGN_8         equ     .160
ANGLE_IGN_9         equ     .180
ANGLE_IGN_10        equ     .200
ANGLE_IGN_11        equ     .220
ANGLE_IGN_12        equ     .240

;*Номера углов.
ANGLE_NUM_1            equ     .1
ANGLE_NUM_2            equ     .2
ANGLE_NUM_3            equ     .3
ANGLE_NUM_4            equ     .4
ANGLE_NUM_5            equ     .5
ANGLE_NUM_6            equ     .6
ANGLE_NUM_7            equ     .1
ANGLE_NUM_8            equ     .2
ANGLE_NUM_9            equ     .3
ANGLE_NUM_10           equ     .4
ANGLE_NUM_11           equ     .5
ANGLE_NUM_12           equ     .6
    cblock  0x20
        
        tmr0tickCounterL
        tmr0tickCounterH
        tmr0tickCounterPrevL
        tmr0tickCounterPrevH
        tmr0tickCounterPrevTmpL
        tmr0tickCounterPrevTmpH
        anglePerTick
        angleTempL                      ;Текущий градус. (Максимум 720)
        angleTempH
        ;Углы разряда катушек. Пока предопределены и сделаны константами.
        ; TODO Сделать ввод с пульта улов зажигания.
        ;ignition1L
        ;ignition2L
        ;ignition3L
        ;ignition4L
        ;ignition5L
        ;ignition6L
        ;ignition7L
        ;ignition8L
        ;ignition9L
        ;ignition10L
        ;ignition11L
        ;ignition12L
        ;ignition1H
        ;ignition2H
        ;ignition3H
        ;ignition4H
        ;ignition5H
        ;ignition6H
        ;ignition7H
        ;ignition8H
        ;ignition9H
        ;ignition10H
        ;ignition11H
        ;ignition12H
        ;Для подпрограммы сравнения
        xH
        yH
        xL
        yL
        ;Для поиска углов заряда.
        ignitionTempL           ;Угол разряда - временная переменная.
        ignitionTempH
        subChargeAngleL         ;Разница между углами заряда и текущим.
        subChargeAngleH
        divChargeTicks          ;Количество тиков на разницу subChargeAngle.
        angleFlag1              ;Флаги текущих номеров углов. С 1-го по 6-й.
        angleFlag2              ;Флаги текущих номеров углов. С 7-го по 12-й.
        angleFlagTemp           ;Временная переменная для angleFlagN.
        angleNumber             ;Номер угла. TODO Обратить внимание на его
                                ; надобность в программе.
        ;Временные переменные для того, чтобы во время прерывания по таймеру0
        ; в обработке прерывания по входу не изменялись одни и те же переменные.
        tmr0tickCounterLt
        tmr0tickCounterHt
        anglePerTickt
        angleTempLt
        angleTempHt
    endc

bank0	macro	; Macro bank0
 	bcf     STATUS, RP0	; Reset RP0 bit = Bank0
 	endm	; End of macro

bank1	macro	; Macro bank1
 	bsf     STATUS, RP0	; Set RP0 bit = Bank1
 	endm        ; End of macro
bank2	macro	; Macro bank0
    bcf     STATUS, RP0 ;
 	bsf     STATUS, RP1	; Clear RP0 bit and set RP1 bit = Bank2
 	endm	; End of macro

;*****variable definitions
context UDATA_SHR
cs_W        res 1
cs_STATUS   res 1
DIVSOR      res 1
DIV_LO      res 1
DIV_HI      res 1
Q           res 1
statusByte      res 1           ;Флаги: 0 бит - 1я метка, 1 бит -
                                ; останов, 3 бит - ВМТ, 4 - первое
                                ; обнаружение беззубья.
toothCounter	res 1
;***** Вектор сброса************************************************************
RESET:   CODE    0x0000
        pagesel start
        goto    start

;***** Вектор прерывания********************************************************
ISR:     code    0x0004
    ;Прерывания не запрещаем намеренно. Время выполнения <50мсек.
    ;***save context
    movwf   cs_W
    movf    STATUS, w
    movwf   cs_STATUS
    ;***Выбор прерывания.

    btfsc   INTCON, T0IF
    goto    tmr0intHandler          ;Прерывание по таймеру0.
    goto    isr_end

    ;***Прерывание по таймеру0.
tmr0intHandler:
        movlw   TMR0PRELOAD50US         ;Загружаем в таймер0 предуставку
        movwf   TMR0                    ; для 50мкс.
        bcf     INTCON, T0IF            ;Сброс флага прерывания.

        ;**Инкремент количества тиков.
        ;Если метка обнаружена, то игнорирование.
        btfsc   statusByte, STATUS_MARK
        goto    skipTmr0CounterInc
        movlw   CONST_ONE
        addwf   tmr0tickCounterL
        btfsc   STATUS, C
        addwf   tmr0tickCounterH
    skipTmr0CounterInc

        ;***Увеличение текущего полуградуса (сдвинутого на 4 разряда влево).
        movfw   anglePerTick
        addwf   angleTempL, f
        btfsc   STATUS, C
        incf    angleTempH, f

        ;***Сравнение текущего угла с заданными и включение зажигания.
        ;*Проверка разрешения зажигания. Если не разрешено, то переход.
        btfsc   statusByte, STATUS_IGN_EN
        goto    ignitionDisabled
        ;**Сначала копирование во временные переменные текущего угла, а затем
        ; для каждого угла проверка на наличие установки зарда (PORTB,Nbit ==0),
        ; если идет заряд, то расчет продолжается, если не идет заряд, то расчет
        ; для этого угла пропускается.
    ignition:
        movfw   angleTempL
        movwf   xL
        movfw   angleTempH
        movwf   xH
        ;*Первый.
        btfsc   PORTB, ANGLE_NUM_1              ;Если стоит на заряде, то расчет.
        goto    ignition1skip
        movlw   ignition1L
        movwf   yL
        movlw   ignition1H
        movwf   yH
        call    compare16bit
        btfss   STATUS, C
        bsf     PORTB, ANGLE_NUM_1          ;Если сравнялись, то зажигание.
        clrf    angleFlag1                  ;TODO Подумать, где и как более
        clrf    angleFlag2                  ; рационально обнулять флаги.
        bsf     angleFlag1, ANGLE_NUM_2         ;Ставим флаг следующего угла.
        goto    ignitionSetFinish
    ignition1skip
        ;Второй
        btfsc   PORTB, ANGLE_NUM_2
        goto    ignition2skip
        movlw   ignition2L
        movwf   yL
        movlw   ignition2H
        movwf   yH
        call    compare16bit
        btfss   STATUS, C
        bsf     PORTB, ANGLE_NUM_2
        clrf    angleFlag1
        clrf    angleFlag2
        bsf     angleFlag1, ANGLE_NUM_3
        goto    ignitionSetFinish
    ignition2skip
        ;Третий.
        btfsc   PORTB, ANGLE_NUM_3
        goto    ignition3skip
        movlw   ignition3L
        movwf   yL
        movlw   ignition3H
        movwf   yH
        call    compare16bit
        btfss   STATUS, C
        bsf     PORTB, ANGLE_NUM_3
        clrf    angleFlag1
        clrf    angleFlag2
        bsf     angleFlag1, ANGLE_NUM_4
        goto    ignitionSetFinish
    ignition3skip
        ;Четвертый
        btfsc   PORTB, ANGLE_NUM_4
        goto    ignition4skip
        movlw   ignition4L
        movwf   yL
        movlw   ignition4H
        movwf   yH
        call    compare16bit
        btfss   STATUS, C
        bsf     PORTB, ANGLE_NUM_4
        clrf    angleFlag1
        clrf    angleFlag2
        bsf     angleFlag1, ANGLE_NUM_5
        goto    ignitionSetFinish
    ignition4skip
        ;Пятый
        btfsc   PORTB, ANGLE_NUM_5
        goto    ignition5skip
        movlw   ignition5L
        movwf   yL
        movlw   ignition5H
        movwf   yH
        call    compare16bit
        btfss   STATUS, C
        bsf     PORTB, ANGLE_NUM_5
        clrf    angleFlag1
        clrf    angleFlag2
        bsf     angleFlag1, ANGLE_NUM_6
        goto    ignitionSetFinish
    ignition5skip
        ;Шестой
        btfsc   PORTB, ANGLE_NUM_6
        goto    ignition6skip
        movlw   ignition6L
        movwf   yL
        movlw   ignition6H
        movwf   yH
        call    compare16bit
        btfss   STATUS, C
        bsf     PORTB, ANGLE_NUM_6
        clrf    angleFlag1
        clrf    angleFlag2
        bsf     angleFlag1, ANGLE_NUM_7
        goto    ignitionSetFinish
    ignition6skip
        ;*Седьмой.
        btfsc   PORTB, ANGLE_NUM_7
        goto    ignition7skip
        movlw   ignition7L
        movwf   yL
        movlw   ignition7H
        movwf   yH
        call    compare16bit
        btfss   STATUS, C
        bsf     PORTB, ANGLE_NUM_1
        clrf    angleFlag1
        clrf    angleFlag2
        bsf     angleFlag1, ANGLE_NUM_8
        goto    ignitionSetFinish
    ignition7skip
        ;Восьмой.
        btfsc   PORTB, ANGLE_NUM_8
        goto    ignition8skip
        movlw   ignition8L
        movwf   yL
        movlw   ignition8H
        movwf   yH
        call    compare16bit
        btfss   STATUS, C
        bsf     PORTB, ANGLE_NUM_2
        clrf    angleFlag1
        clrf    angleFlag2
        bsf     angleFlag1, ANGLE_NUM_9
        goto    ignitionSetFinish
    ignition8skip
        ;Девятый.
        btfsc   PORTB, ANGLE_NUM_9
        goto    ignition9skip
        movlw   ignition9L
        movwf   yL
        movlw   ignition9H
        movwf   yH
        call    compare16bit
        btfss   STATUS, C
        bsf     PORTB, ANGLE_NUM_3
        clrf    angleFlag1
        clrf    angleFlag2
        bsf     angleFlag1, ANGLE_NUM_10
        goto    ignitionSetFinish
    ignition9skip
        ;Десятый.
        btfss   PORTB, ANGLE_NUM_10
        goto    ignition10skip
        movlw   ignition10L
        movwf   yL
        movlw   ignition10H
        movwf   yH
        call    compare16bit
        btfss   STATUS, C
        bsf     PORTB, ANGLE_NUM_4
        clrf    angleFlag1
        clrf    angleFlag2
        bsf     angleFlag1, ANGLE_NUM_11
        goto    ignitionSetFinish
    ignition10skip
        ;Одиннадцатый.
        btfss   PORTB, ANGLE_NUM_11
        goto    ignition11skip
        movlw   ignition11L
        movwf   yL
        movlw   ignition11H
        movwf   yH
        call    compare16bit
        btfss   STATUS, C
        bsf     PORTB, ANGLE_NUM_5
        clrf    angleFlag1
        clrf    angleFlag2
        bsf     angleFlag1, ANGLE_NUM_12
        goto    ignitionSetFinish
    ignition11skip
        ;Двенадцатый.
        btfss   PORTB, ANGLE_NUM_12
        goto    ignition11skip
        movlw   ignition12L
        movwf   yL
        movlw   ignition12H
        movwf   yH
        call    compare16bit
        btfss   STATUS, C
        bsf     PORTB, ANGLE_NUM_6
        goto    ignitionSetFinish
    ignition12skip

    ignitionSetFinish
    ignitionDisabled
isr_end:
    movf    cs_STATUS, w
    movwf   STATUS
    swapf   cs_W, f
    swapf   cs_W, w
    retfie

;***** Главная программа********************************************************
MAIN:    CODE
start:

; *****Инициализация
    clrf    T2CON
    clrf    TMR2
    clrf    INTCON
    clrf    PIR1
    clrf    PORTB
bank1
    clrf    PIE1
    clrf    TRISB^80H
    movlw   b'00000001'
    movwf   TRISB
bank0
    movlw   b'00000000'
    movwf   PORTB
    ;bsf     outflag, 1

bank0
    ;INTCON conf
    bsf     INTCON, GIE         ;global enable interr EN
    ;bsf     INTCON, RBIE        ;RB7:RB4 onchange interr EN
    bsf     INTCON, PEIE        ;peripheral module
    bcf     INTCON, INTE        ;INT interrupt en
    bsf     INTCON, TMR0IE      ;TMR0 interrupt en
;    ;TMR2 conf
;    ;postscale 1111=1:16
;    bsf     T2CON, TOUTPS3
;    bsf     T2CON, TOUTPS2
;    bsf     T2CON, TOUTPS1
;    bsf     T2CON, TOUTPS0
;    ;prescale 11=1:16
;    bsf     T2CON, T2CKPS1
;    bsf     T2CON, T2CKPS0
bank1
    ;OPTION_REG conf
    bsf     OPTION_REG, NOT_RBPU    ;PORTB Pull-up Enable bit: 1 = PORTB pull-ups are disabled
    bcf     OPTION_REG, INTEDG       ;Interrupt Edge Select bit: 1 = Interrupt on rising edge of RB0/INT pin, 0 =
    bcf     OPTION_REG, T0CS         ;TMR0 Clock Source Select bit: 1 = Transition on RA4/T0CKI pin
    bcf     OPTION_REG, T0SE        ;TMR0 Source Edge Select bit: 1 = Increment on high-to-low transition on RA4/T0CKI pin
    bcf     OPTION_REG, PSA         ;Assignment bit: 1 = Prescaler is assigned to the WDT, 0 = Prescaler is assigned to the Timer0 module

    ;Prescaler Rate Select bits for TMR0 or WDT. TMR0: 000 = 1:2, 111 = 1:256. WDT: 000 = 1:1, 111 = 1:128
    ;50 000ns interrupt
    bcf     OPTION_REG, PS2
    bcf     OPTION_REG, PS1
    bsf     OPTION_REG, PS0
bank0
    clrf    TMR0
    movlw   TMR0PRELOAD50US
    movwf   TMR0
bank1
    bsf     PIE1, TMR2IE
    movlw   0xff
    movwf   PR2
;*Окончание инициализации.

bank0
    bsf     T2CON, TMR2ON           ;Старт таймера.

;****** Главный цикл.
loop:
    btfsc   INTCON, INTF            ;Переход по флагу внешнего прерывания.
    goto    intHandler

    goto    chargeSearch

; **** Внешнее прерывание b0.
; TODO подуамать, надо ли тут сбрасывать таймер0.
;Не в векторе прерывания обработка, по причине долгих вычислений.
intHandler:
        banksel INTCON
        bcf     INTCON, INTF            ;Сбрасываем флаг прерывания.

        ;*Остановить таймер. Скопировать переменные во временные. Перезапустить
        ; таймер.
        banksel T2CON
        bcf     T2CON, TMR2ON
        movfw   tmr0tickCounterL
        movwf   tmr0tickCounterLt
        movfw   tmr0tickCounterH
        movwf   tmr0tickCounterHt
        movlw   CONST_ZERO                  ;Обнуляем счетчик тиков.
        movwf   tmr0tickCounterL
        movwf   tmr0tickCounterH
        movfw   anglePerTick
        movwf   anglePerTickt
        movfw   angleTempL
        movwf   angleTempLt
        movfw   angleTempH
        movwf   angleTempHt
        clrf    TMR0
        movlw   TMR0PRELOAD50US
        movwf   TMR0
        bsf     T2CON, TMR2ON
        
        movlw   0x01                        ;Инкремент счетчика зубов.
        addwf   toothCounter                ;

        bcf     statusByte, STATUS_STOP     ;Сброс флага останова.
        bsf     statusByte, STATUS_IGN_EN   ;Установка флага разрешения зажигания.
        ;*Поиск беззубья.
        ;Копирование оперируемых предыдущих значений во временные переменные.
    toothMissSearch:
        movfw   tmr0tickCounterPrevL
        movwf   tmr0tickCounterPrevTmpL
        movfw   tmr0tickCounterPrevH
        movwf   tmr0tickCounterPrevTmpH
        rlf     tmr0tickCounterPrevTmpH, w    ;Увеличиваем натоящее значение в x2.
        btfsc   STATUS, C                     ;Если случился перенос, сюда
        goto    cmpEnd                        ; программа не могла дойти (останв).
        rlf     tmr0tickCounterPrevTmpL, f    ;Но стоит немного подстраховаться
        rlf     tmr0tickCounterPrevTmpH, f    ; и идти cmpEnd.
        ;Сравниваем временные промежтуки между зубьями.
        ;Сравнение происходит вычитанием значения настоящего счетчика из
        ; предыдещего*2 значения счетчика. Если результат положительный или нулевой,
        ; то превышение времени в 2 раза - метка.
        movfw   tmr0tickCounterPrevTmpH
        subwf   tmr0tickCounterHt, w        ;Настоящее минус предыдущее*2.
        btfss   STATUS,C
        goto    cmpEnd                        ;Результат отрицательный по H байту.
        btfss   STATUS,Z
        goto    markDetected                  ;Метка обнаружена - ставится флаг.
        goto    cmpLByte                      ;Переход на сравнение L байта.
    cmpLByte
        ;Старший байт счетчика дискрет оказался равным, поэтому
        ; сравниваются младшие.
        movfw   tmr0tickCounterPrevTmpL
        subwf   tmr0tickCounterLt, w
        btfss   STATUS, C
    markDetectedSet
        bsf     statusByte, STATUS_MARK         ;Метка обнаружена.
    cmpEnd
        ;Запись актуальных в предыдущие.
        movfw   tmr0tickCounterLt
        movwf   tmr0tickCounterPrevL
        movfw   tmr0tickCounterHt
        movwf   tmr0tickCounterPrevH
    ;* Поиск беззубья окончен.

    ; **** Метка обнаружена.
    ;Если метка обнаружена, то выполнение блока и пропуск
    ; следующих блоков - обнаружение останова и расчет скорости. Если не
    ; обнаружена, то игнорирование блока и выполнение блоков обнаружения
    ; останова и расчета скорости
        btfss   statusByte, STATUS_MARK
        goto    markDetectedFinish
    markDetected:
        movlw   CONST_ZERO
        movwf   toothCounter            ;Обнуление счетчика зубов.
        clrf    angleFlag1              ;Сброс флагов номеров углов зажигания и
        clrf    angleFlag2              ; установка флага первого угла.
        bsf     angleFlag1, ANGLE_NUM_1
        btfsc   statusByte, STATUS_TOOTH_MISS     ;Проверка флага первого беззубья.
        goto    skipFirstToothMiss
        bsf     statusByte, STATUS_TOOTH_MISS     ;Установка флага первого
        skipFirstToothMiss                        ; обнаружения беззубья.
        bcf     INTCON, INTF
        goto    skipCalcAnglePerTick              ;Пропуск следующих блоков.
    markDetectedFinish
        ;***Обнаружение останова.
    stopSearch:
        ; ;Определяем останов по времени между зубьями не менее 0,05с при дискрете 50мкс.
        btfss   tmr0tickCounterHt, 3   
        goto    skipStopSearch
        bsf     statusByte, STATUS_STOP         ;Ставится флаг останова.
        bcf     statusByte, STATUS_TOOTH_MISS   ;Сброс флага первого беззубья.
        bcf     statusByte, STATUS_IGN_EN       ;Снимается флаг разрешения зажигания.
    skipStopSearch
        ;***Подсчет количества градусов на тик.
    calcAnglePerTick:
        movf    tmr0tickCounterLt, f            ;Если счетчик равен нулю, то переход.
        btfsc   STATUS, Z
        goto    skipCalcAnglePerTick
        ;Загружаем переменные для вычислений.
        movlw   CONST_192                       
        movwf   DIV_LO
        clrf    DIV_HI
        movfw   tmr0tickCounterLt
        movwf   DIVSOR
        call    div16by8                        ;
        movwf   anglePerTickt
    skipCalcAnglePerTick

        ;**Сброс флага метки.
        bcf     statusByte, STATUS_MARK

        ;*Корректировка угла по таблице соответствия зуба и угла.
        ;  И копируется в текущий угол.
        ;TODO Поразмышлять за надобностью проверки счетчика на ноль. Ибо
        ; случиться нулю в счетчике не должно из-за инкремента в начале intHandler.
    toothTableCorrect:
        movf    toothCounter, f
        btfsc   STATUS, Z               ;Если установлен, то счетчик зуб равен нулю,
        goto    skipZeroToothCounter    ; пропускаем уменьшение и таблицу.
        movfw   toothCounter            ;Сначала младший разряд.
        addlw   CONST_FF                ;Уменьшаем содержимое w на единицу.
        call    ReadTable
        movwf   angleTempLt
        movfw   toothCounter            ;Теперь старший разряд.
        call    ReadTable
        movwf   angleTempHt
    skipZeroToothCounter

    ;****Сравнение текущего угла с заданными и включение зарядки катушек.
    ;**Сначала идет поиск номера текущего угла. Затем вычисления угла зарядки.
    chargeSearch:
        btfss   angleFlag1, ANGLE_NUM_1
        goto    skipAngleFlag1
        ;Запись во временные переменные значения угла зажигания и флажкового байта
        ; номеров угла (angleFlag). Общее для вычисления всех углов это только
        ; текущий угол.
        movfw   angleFlag1
        movwf   angleFlagTemp
        movlw   ignition1L
        movwf   ignitionTempL
        movlw   ignition1H
        movwf   ignitionTempH
        goto    chargeNumberSearchEnd
        skipAngleFlag1
            btfss   angleFlag1, ANGLE_NUM_2
            goto    skipAngleFlag2
            movfw   angleFlag1
            movwf   angleFlagTemp
            movlw   ignition2L
            movwf   ignitionTempL
            movlw   ignition2H
            movwf   ignitionTempH
            goto    chargeNumberSearchEnd
        skipAngleFlag2
            btfss   angleFlag1, ANGLE_NUM_3
            goto    skipAngleFlag3
            movfw   angleFlag1
            movwf   angleFlagTemp
            movlw   ignition3L
            movwf   ignitionTempL
            movlw   ignition3H
            movwf   ignitionTempH
            goto    chargeNumberSearchEnd
        skipAngleFlag3
            btfss   angleFlag1, ANGLE_NUM_4
            goto    skipAngleFlag4
            movfw   angleFlag1
            movwf   angleFlagTemp
            movlw   ignition4L
            movwf   ignitionTempL
            movlw   ignition4H
            movwf   ignitionTempH
            goto    chargeNumberSearchEnd
        skipAngleFlag4
            btfss   angleFlag1, ANGLE_NUM_5
            goto    skipAngleFlag5
            ;Запись во временные переменные значения текущего угла.
            movfw   angleFlag1
            movwf   angleFlagTemp
            movlw   ignition5L
            movwf   ignitionTempL
            movlw   ignition5H
            movwf   ignitionTempH
            goto    chargeNumberSearchEnd
        skipAngleFlag5
            btfss   angleFlag1, ANGLE_NUM_6
            goto    skipAngleFlag6
            ;Запись во временные переменные значения текущего угла.
            movfw   angleFlag1
            movwf   angleFlagTemp
            movlw   ignition6L
            movwf   ignitionTempL
            movlw   ignition6H
            movwf   ignitionTempH
            goto    chargeNumberSearchEnd
        skipAngleFlag6
            btfss   angleFlag2, ANGLE_NUM_7
            goto    skipAngleFlag7
            ;Запись во временные переменные значения текущего угла.
            movfw   angleFlag2
            movwf   angleFlagTemp
            movlw   ignition7L
            movwf   ignitionTempL
            movlw   ignition7H
            movwf   ignitionTempH
            goto    chargeNumberSearchEnd
        skipAngleFlag7
            btfss   angleFlag2, ANGLE_NUM_8
            goto    skipAngleFlag8
            ;Запись во временные переменные значения текущего угла.
            movfw   angleFlag2
            movwf   angleFlagTemp
            movlw   ignition8L
            movwf   ignitionTempL
            movlw   ignition8H
            movwf   ignitionTempH
            goto    chargeNumberSearchEnd
        skipAngleFlag8
            btfss   angleFlag2, ANGLE_NUM_9
            goto    skipAngleFlag9
            ;Запись во временные переменные значения текущего угла.
            movfw   angleFlag2
            movwf   angleFlagTemp
            movlw   ignition9L
            movwf   ignitionTempL
            movlw   ignition9H
            movwf   ignitionTempH
            goto    chargeNumberSearchEnd
        skipAngleFlag9
            btfss   angleFlag2, ANGLE_NUM_10
            goto    skipAngleFlag10
            ;Запись во временные переменные значения текущего угла.
            movfw   angleFlag2
            movwf   angleFlagTemp
            movlw   ignition10L
            movwf   ignitionTempL
            movlw   ignition10H
            movwf   ignitionTempH
            goto    chargeNumberSearchEnd
        skipAngleFlag10
            btfss   angleFlag2, ANGLE_NUM_11
            goto    skipAngleFlag11
            movfw   angleFlag2
            movwf   angleFlagTemp
            movlw   ignition11L
            movwf   ignitionTempL
            movlw   ignition11H
            movwf   ignitionTempH
            goto    chargeNumberSearchEnd
        skipAngleFlag11
            btfss   angleFlag2, ANGLE_NUM_12
            goto    skipAngleFlag12
            movfw   angleFlag2
            movwf   angleFlagTemp
            movlw   ignition12L
            movwf   ignitionTempL
            movlw   ignition12H
            movwf   ignitionTempH
            goto    chargeNumberSearchEnd
        skipAngleFlag12
    chargeNumberSearchEnd
        ;**Далее вычисление разницы между углом зажигания и текущим углом.
        ;TODO На будущее - учитывать, что разница может быть отрицательной.
        subwf   angleTempHt, w
        movwf   subChargeAngleH
        movwf   DIV_HI
        movfw   ignitionTempL
        subwf   angleTempLt, w
        movwf   subChargeAngleL
        movwf   DIV_LO
        ;Деление разницы на текущую скорость. Получаем количество тиков.
        movfw   anglePerTick
        movwf   DIVSOR
        call    div16by8
        movwf   divChargeTicks
        clrc
        rrf     divChargeTicks, f   ;Результат двигаем вправо на 4 разряда.
        rrf     divChargeTicks, f
        rrf     divChargeTicks, f
        rrf     divChargeTicks, w
        ;Исходя из того, что на тик приходится 50мкс, а время от заряда до разряда
        ; 8мс, то количество тиков должно быть не менее 160. Если менее 160, то
        ; включаем заряд. 160-divChargeTicks . Если positive, то C==1
        sublw   CONST_160
        btfss   STATUS, C
        goto    chargeSkip
        movfw   angleFlagTemp
        iorwf   PORTB, f
    chargeSkip

loopEnd:
    goto    loop

;***************Подпрограммы****************************************************
;***** Сравнение 8-битных
     ;Y-X
     ; if X=Y then now Z=1.
compare8bit:
    clrc
    movf    xL, w
    subwf   yL, w
return
;***** Сравнение 16-битных
; signed and unsigned 16 bit comparison routine:
; by David Cary 2001-03-30
; returns the correct flags (Z and C)
; to indicate the X=Y, Y<X, or X<Y.
; Does not modify X or Y.
     ;Y-X
     ; if X=Y then now Z=1.
     ; if Y<X then now C=0.
     ; if X<=Y then now C=1.
compare16bit:
    clrc
    movf    xH, w
    subwf   yH, w
comp1H
    btfss   STATUS, Z
    goto result
    movf    xL, w
    subwf   yL, w
    result
return

;***** Подпрограмма деления
; copyright, Peter H. Anderson, MSU, July 10, '97
;http://www.phanderson.com/PIC/16C84/calc_disc_2.html
div16by8:       ; DIV_HI and DIV_LO / DIVSOR.  result to Q
                ; does not deal with divide by 0 case
    movf    DIVSOR, f
    btfsc   STATUS, Z
    goto    DIV_DONE
	CLRF Q
DIV_1
	MOVF DIVSOR, W
	SUBWF DIV_LO, F
	BTFSS STATUS, C	; if positive skip
	GOTO BORROW
	GOTO DIV_2
BORROW
	MOVLW .1
	SUBWF DIV_HI, F	; DIV_HI = DIV_HI - 1
	BTFSS STATUS, C	; if no borrow occurred
	GOTO DIV_DONE
DIV_2
	INCF Q, F
	GOTO DIV_1
DIV_DONE
    movfw   Q
        return


;******Поисковая таблица соответствия угла по номеру зуба.
ORG         0x800
ReadTable:
    clrf    PCLATH
    bsf     PCLATH, 3
    addwf   PCL, f
    ;       Возврат угла.   Порядок и номер зуба.
    retlw        0x0	     ;LO  1
    retlw        0x0		    ;HI
    retlw        0xC0	     ;LO  2
    retlw        0x0		    ;HI
    retlw        0x80	     ;LO  3
    retlw        0x1		    ;HI
    retlw        0x40	     ;LO  4
    retlw        0x2		    ;HI
    retlw        0x0	     ;LO  5
    retlw        0x3		    ;HI
    retlw        0xC0	     ;LO  6
    retlw        0x3		    ;HI
    retlw        0x80	     ;LO  7
    retlw        0x4		    ;HI
    retlw        0x40	     ;LO  8
    retlw        0x5		    ;HI
    retlw        0x0	     ;LO  9
    retlw        0x6		    ;HI
    retlw        0xC0	     ;LO  10
    retlw        0x6		    ;HI
    retlw        0x80	     ;LO  11
    retlw        0x7		    ;HI
    retlw        0x40	     ;LO  12
    retlw        0x8		    ;HI
    retlw        0x0	     ;LO  13
    retlw        0x9		    ;HI
    retlw        0xC0	     ;LO  14
    retlw        0x9		    ;HI
    retlw        0x80	     ;LO  15
    retlw        0xA		    ;HI
    retlw        0x40	     ;LO  16
    retlw        0xB		    ;HI
    retlw        0x0	     ;LO  17
    retlw        0xC		    ;HI
    retlw        0xC0	     ;LO  18
    retlw        0xC		    ;HI
    retlw        0x80	     ;LO  19
    retlw        0xD		    ;HI
    retlw        0x40	     ;LO  20
    retlw        0xE		    ;HI
    retlw        0x0	     ;LO  21
    retlw        0xF		    ;HI
    retlw        0xC0	     ;LO  22
    retlw        0xF		    ;HI
    retlw        0x80	     ;LO  23
    retlw        0x10		    ;HI
    retlw        0x40	     ;LO  24
    retlw        0x11		    ;HI
    retlw        0x0	     ;LO  25
    retlw        0x12		    ;HI
    retlw        0xC0	     ;LO  26
    retlw        0x12		    ;HI
    retlw        0x80	     ;LO  27
    retlw        0x13		    ;HI
    retlw        0x40	     ;LO  28
    retlw        0x14		    ;HI
    retlw        0x0	     ;LO  29
    retlw        0x15		    ;HI
    retlw        0xC0	     ;LO  30
    retlw        0x15		    ;HI
    retlw        0x80	     ;LO  31
    retlw        0x16		    ;HI
    retlw        0x40	     ;LO  32
    retlw        0x17		    ;HI
    retlw        0x0	     ;LO  33
    retlw        0x18		    ;HI
    retlw        0xC0	     ;LO  34
    retlw        0x18		    ;HI
    retlw        0x80	     ;LO  35
    retlw        0x19		    ;HI
    retlw        0x40	     ;LO  36
    retlw        0x1A		    ;HI
    retlw        0x0	     ;LO  37
    retlw        0x1B		    ;HI
    retlw        0xC0	     ;LO  38
    retlw        0x1B		    ;HI
    retlw        0x80	     ;LO  39
    retlw        0x1C		    ;HI
    retlw        0x40	     ;LO  40
    retlw        0x1D		    ;HI
    retlw        0x0	     ;LO  41
    retlw        0x1E		    ;HI
    retlw        0xC0	     ;LO  42
    retlw        0x1E		    ;HI
    retlw        0x80	     ;LO  43
    retlw        0x1F		    ;HI
    retlw        0x40	     ;LO  44
    retlw        0x20		    ;HI
    retlw        0x0	     ;LO  45
    retlw        0x21		    ;HI
    retlw        0xC0	     ;LO  46
    retlw        0x21		    ;HI
    retlw        0x80	     ;LO  47
    retlw        0x22		    ;HI
    retlw        0x40	     ;LO  48
    retlw        0x23		    ;HI
    retlw        0x0	     ;LO  49
    retlw        0x24		    ;HI
    retlw        0xC0	     ;LO  50
    retlw        0x24		    ;HI
    retlw        0x80	     ;LO  51
    retlw        0x25		    ;HI
    retlw        0x40	     ;LO  52
    retlw        0x26		    ;HI
    retlw        0x0	     ;LO  53
    retlw        0x27		    ;HI
    retlw        0xC0	     ;LO  54
    retlw        0x27		    ;HI
    retlw        0x80	     ;LO  55
    retlw        0x28		    ;HI
    retlw        0x40	     ;LO  56
    retlw        0x29		    ;HI
    retlw        0x0	     ;LO  57
    retlw        0x2A		    ;HI
    retlw        0xC0	     ;LO  58
    retlw        0x2A		    ;HI
    retlw        0x80	     ;LO  59
    retlw        0x2B		    ;HI
    retlw        0x40	     ;LO  60
    retlw        0x2C		    ;HI

END
