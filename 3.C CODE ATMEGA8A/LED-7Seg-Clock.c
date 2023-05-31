#include <mega8.h>
#include <delay.h>
#include <i2c.h>
#include <ds1307.h>
#include <stdio.h>

#define alarmTime 9                // means 4.5 second
#define exitMenuTime 32000         // means about  second
#define dateShowOffTime 8000       // means about 7 second
#define dateShowOnTime 5           // means about 1 second
#define fastEditBrightnessTimeon 5 // means about 1 second
#define buzzerPin PORTD .1
#define sevenSegmentPins PORTB
#define clickPin !PIND .0
#define fastEditBrightnessMultiple 5 // means 5 percent change
#define blinkWhenChangeNumberTimeOn 4
#define blinkWhenChangeNumberTimeOff 1

eeprom unsigned char alMinute, alHour, brightnessMem, alarmSet, muteState1;

enum commandType
{
    HOME,
    BRIGHTNESSHOME,
    SHOWDATE,
    MENU,
    SETTIME,
    SETDATE,
    SETALARM,
    EXIT,
    BRIGHTNESS,
    ALARM,
    MUTE,
    SUM,
    MINUS,
    ON,
    OFF,
    CLOCK,
    ONE,
    BIP,
    EVER
};

unsigned char positionNumber = 1, segmentPinState[4], h = 0, m = 0, s = 0, left = 0, right = 0, timedisabeHomeTemp = 0, runnigState = HOME, menuPosition = SETTIME, clickState = 0, disabeHomeTempState = 0, seqNumber = 0;
unsigned char counterBlinkNumber = 0, blinkNumberChageState = 0, portEnable[5] = {1, 1, 1, 1, 1}, brightnessSet = 99, muteState = 0, ym = 0, mm = 0, dm = 0, w = 0, tempSecondBip = 60;
int ys = 0, ms = 0, ds = 0, counterSecondTime = 0;

void brightness(unsigned char timeBR);
void portConfig();
void stopIntrupts();
void startIntrupts();
void startTimers();
void stopTimers();
void backToHome(unsigned char timeStop);
void startCounterTimer();
void stopCounterTimer();
void fastEditBrightness(unsigned char addOrMinus);
void blinkNumberChangeTimer();
void digitalWritePortC(unsigned char portNumber);
void buzzer(unsigned int timeBuzz, unsigned int timeSleep);

void dotBlink(unsigned char state)
{
    switch (state)
    {
    case OFF:
        rtc_write(0x07, 0x00);
        break;
    case ON:
        rtc_write(0x07, 0x10);
        break;
    }
}
int m2s(int ym, int mm, int dm, int *ys, int *ms, int *ds)
{
    unsigned long int ys1, ym1;
    int ym2, ys2, mm1, ms1, k, ms0;
    ym1 = ym + 2000;
    k = ym1 % 4;
    ym1--;
    ym1 = ym1 * 365;
    if (mm == 1)
    {
        mm1 = 0;
    }
    if (mm == 2)
    {
        mm1 = 31;
    }
    if (mm == 3)
    {
        mm1 = 59;
    }
    if (mm == 4)
    {
        mm1 = 90;
    }
    if (mm == 5)
    {
        mm1 = 120;
    }
    if (mm == 6)
    {
        mm1 = 151;
    }
    if (mm == 7)
    {
        mm1 = 181;
    }
    if (mm == 8)
    {
        mm1 = 212;
    }
    if (mm == 9)
    {
        mm1 = 243;
    }
    if (mm == 10)
    {
        mm1 = 273;
    }
    if (mm == 11)
    {
        mm1 = 304;
    }
    if (mm == 12)
    {
        mm1 = 334;
    }
    if (k == 0)
    {
        mm1++;
    }
    ym1 = ym1 + mm1;
    ym1 = ym1 + dm;
    ym2 = ym + 2000;
    ym2--;
    ym2 = ym2 / 4;
    ym1 = ym1 + ym2;
    ym1 = ym1 - 226899;
    ys2 = ym2 - 155;
    ys1 = ym1 - ys2;
    *ys = ys1 / 365;
    *ys = *ys - 1299;
    ms1 = ys1 % 365;
    ms0 = 1;
    if (ms1 > 31)
    {
        ms0++;
        ms1 = ms1 - 31;
    }
    if (ms1 > 31)
    {
        ms0++;
        ms1 = ms1 - 31;
    }
    if (ms1 > 31)
    {
        ms0++;
        ms1 = ms1 - 31;
    }
    if (ms1 > 31)
    {
        ms0++;
        ms1 = ms1 - 31;
    }
    if (ms1 > 31)
    {
        ms0++;
        ms1 = ms1 - 31;
    }
    if (ms1 > 31)
    {
        ms0++;
        ms1 = ms1 - 31;
    }
    if (ms1 > 30)
    {
        ms0++;
        ms1 = ms1 - 30;
    }
    if (ms1 > 30)
    {
        ms0++;
        ms1 = ms1 - 30;
    }
    if (ms1 > 30)
    {
        ms0++;
        ms1 = ms1 - 30;
    }
    if (ms1 > 30)
    {
        ms0++;
        ms1 = ms1 - 30;
    }
    if (ms1 > 30)
    {
        ms0++;
        ms1 = ms1 - 30;
    }
    *ds = ms1;
    *ms = ms0;
    return *ys;
    return *ms;
    return *ds;
}
void buzzer(unsigned int timeBuzz, unsigned int timeSleep)
{
    if (muteState1)
    {
        buzzerPin = 1;
        delay_ms(timeBuzz);
        buzzerPin = 0;
        if (timeSleep > 0)
            delay_ms(timeSleep);
    }
}
void changePositionNumber(unsigned char position)
{
    PORTC = PORTC & 0xf0;
    switch (position)
    {
    case 1:
        digitalWritePortC(1);
        break;
    case 2:
        digitalWritePortC(2);
        break;
    case 3:
        digitalWritePortC(3);
        break;
    case 4:
        digitalWritePortC(4);
        break;
    };
}
void digitalWritePortC(unsigned char portNumber)
{
    switch (portNumber)
    {
    case 1:
        if (portEnable[1])
            PORTC .0 = 1;
        break;
    case 2:
        if (portEnable[2])
            PORTC .1 = 1;
        break;
    case 3:
        if (portEnable[3])
            PORTC .2 = 1;
        break;
    case 4:
        if (portEnable[4])
            PORTC .3 = 1;
        break;
    };
}
unsigned char digitalWritePort(unsigned char input)
{
    switch (input)
    {
    case 1:
        return 6;
    case 2:
        return 91;
    case 3:
        return 79;
    case 4:
        return 102;
    case 5:
        return 109;
    case 6:
        return 125;
    case 7:
        return 7;
    case 8:
        return 127;
    case 9:
        return 111;
    case 0:
        return 63;
    case 'e':
        return 121;
    case 'r':
        return 112;
    case 'b':
        return 124;
    case 'p':
        return 115;
    case 'o':
        return 92;
    case 'f':
        return 113;
    case 'l':
        return 56;
    case 'c':
        return 88;
    case 't':
        return 120;
    case 'x':
        return 118;
    case 'a':
        return 119;
    case 'i':
        return 48;
    case 'h':
        return 116;
    case 'v':
        return 62;
    case '.':
        return 0;
    case 'd':
        return 94;
    case 'n':
        return 84;
    };
}
void showString(unsigned char counterSegment, unsigned char input, unsigned char numberSegment)
{
    counterSegment--;
    if (counterSegment)
    {
        switch (numberSegment)
        {
        case 1:
            segmentPinState[numberSegment - 1] = digitalWritePort(input / 10);
            segmentPinState[numberSegment] = digitalWritePort(input % 10);
            break;
        case 2:
            segmentPinState[numberSegment] = digitalWritePort(input / 10);
            segmentPinState[numberSegment + 1] = digitalWritePort(input % 10);
            break;
        };
    }
    else
    {
        segmentPinState[numberSegment - 1] = digitalWritePort(input);
    }
}
void blinkNumber()
{
    switch (positionNumber)
    {
    case 1:
        sevenSegmentPins = segmentPinState[0];
        changePositionNumber(positionNumber);
        positionNumber = 2;
        break;
    case 2:
        sevenSegmentPins = segmentPinState[1];
        changePositionNumber(positionNumber);
        positionNumber = 3;
        break;
    case 3:
        sevenSegmentPins = segmentPinState[2];
        changePositionNumber(positionNumber);
        positionNumber = 4;
        break;
    case 4:
        sevenSegmentPins = segmentPinState[3];
        changePositionNumber(positionNumber);
        positionNumber = 1;
        break;
    };
    counterSecondTime++;
}
void resetClickState()
{
    clickState = 0;
}
void setClickState()
{
    clickState = 1;
}
void resetVolume()
{
    right = 0;
    left = 0;
}
void resetCounterSecondTime()
{
    counterSecondTime = 0;
}
void volumeCheck()
{
    if (clickPin)
    {
        while (clickPin)
            ;
        buzzer(100, 0);
        setClickState();
        resetCounterSecondTime();
        if (runnigState == HOME)
        {
            dotBlink(OFF);
            runnigState = MENU;
            resetClickState();
        }
    }
    switch (runnigState)
    {
    case MENU:
        if (counterSecondTime > exitMenuTime)
        {
            resetCounterSecondTime();
            runnigState = HOME;
            buzzer(100, 0);
        }
        break;
    case HOME:
        if (counterSecondTime > dateShowOffTime)
        {
            runnigState = SHOWDATE;
            backToHome(dateShowOnTime);
            resetCounterSecondTime();
        }
        if (right == 2 | left == 2)
        {
            runnigState = BRIGHTNESSHOME;
        }
        break;
    }
}
void fastEditBrightness(unsigned char addOrMinus)
{
    unsigned char counterFor = 0;
    for (counterFor = 0; counterFor < fastEditBrightnessMultiple; counterFor++)
    {
        switch (addOrMinus)
        {
        case SUM:
            if (brightnessSet < 99)
                brightnessSet++;
            break;
        case MINUS:
            if (brightnessSet > 1)
                brightnessSet--;
            break;
        }
    }
    brightness(brightnessSet);
    backToHome(fastEditBrightnessTimeon);
    showString(2, brightnessSet, 2);
    showString(1, 'b', 1);
    showString(1, 'r', 2);
}
void backToHome(unsigned char timeStop)
{
    timedisabeHomeTemp = timeStop;
    startCounterTimer();
    disabeHomeTempState = 1;
}
void checkTimeDisabeHomeTemp()
{
    if (disabeHomeTempState)
    {
        if (timedisabeHomeTemp > 0)
        {
            timedisabeHomeTemp--;
        }
        else
        {
            stopCounterTimer();
            runnigState = HOME;
            disabeHomeTempState = 0;
        }
    }
}
unsigned char checkVolumeRight()
{
    if (left == 2)
    {
        buzzer(3, 0);
        resetVolume();
        return 1;
    }
    else
    {
        return 0;
    }
}
unsigned char checkVolumeLeft()
{
    if (right == 2)
    {
        buzzer(3, 0);
        resetVolume();
        return 1;
    }
    else
    {
        return 0;
    }
}
interrupt[EXT_INT0] void ext_int0_isr(void)
{
    switch (left)
    {
    case 0:
        right = 1;
        break;
    case 1:
        right = 2;
        break;
    };
    resetCounterSecondTime();
}
interrupt[EXT_INT1] void ext_int1_isr(void)
{
    switch (right)
    {
    case 0:
        left = 1;
        break;
    case 1:
        left = 2;
        break;
    };
    resetCounterSecondTime();
}
interrupt[TIM1_OVF] void timer1_ovf_isr(void)
{
    checkTimeDisabeHomeTemp();
    blinkNumberChangeTimer();
    TCNT1H = 0x9E58 >> 8;
    TCNT1L = 0x9E58 & 0xff;
}
interrupt[TIM2_OVF] void timer2_ovf_isr(void)
{
    blinkNumber();
}
interrupt[TIM2_COMP] void timer2_comp_isr(void)
{
    changePositionNumber(0);
}
void brightness(unsigned char timeBR)
{
    unsigned char temp = 0;
    OCR2 = 0;
    timeBR = (timeBR * 255) / 100;
    for (temp = 0; temp < timeBR; temp++)
    {
        if (OCR2 < 255)
        {
            OCR2 = OCR2 + 1;
        }
    }
}
void blinkNumberChangeTimer()
{
    if (blinkNumberChageState)
    {
        if (counterBlinkNumber < blinkWhenChangeNumberTimeOff)
        {
            counterBlinkNumber++;
            switch (seqNumber)
            {
            case 1:
                portEnable[1] = 0;
                portEnable[2] = 0;
                break;
            case 2:
                portEnable[3] = 0;
                portEnable[4] = 0;
                break;
            }
        }
        else
        {
            if (counterBlinkNumber < blinkWhenChangeNumberTimeOn)
            {
                counterBlinkNumber++;
                switch (seqNumber)
                {
                case 1:
                    portEnable[1] = 1;
                    portEnable[2] = 1;
                    break;
                case 2:
                    portEnable[3] = 1;
                    portEnable[4] = 1;
                    break;
                }
            }
            else
            {
                counterBlinkNumber = 0;
            }
        }
    }
}
void blinkEditNumber(unsigned char seqNu)
{
    if (blinkNumberChageState)
    {
        stopCounterTimer();
        blinkNumberChageState = 0;
        portEnable[1] = 1;
        portEnable[2] = 1;
        portEnable[3] = 1;
        portEnable[4] = 1;
    }
    if (seqNu > 0)
    {
        seqNumber = seqNu;
        startCounterTimer();
        blinkNumberChageState = 1;
    }
}
void showClock()
{
    rtc_get_time(&h, &m, &s);
    if (m == 0)
    {
        if (tempSecondBip > s)
        {
            if (h<22 & h> 7)
            {
                buzzer(500, 500);
                buzzer(500, 0);
            }
        }
        tempSecondBip = s;
    }
    if (alarmSet == 1 | alarmSet == 2)
    {
        if (alHour == h & alMinute == m)
        {
            runnigState = ALARM;
            if (alarmSet == 1)
                alarmSet = 0;
        }
    }
    showString(2, h, 1);
    showString(2, m, 2);
    dotBlink(ON);
}
void showDate()
{
    dotBlink(OFF);
    rtc_get_date(&w, &dm, &mm, &ym);
    m2s(ym, mm, dm, &ys, &ms, &ds);
    showString(2, ms, 1);
    showString(2, ds, 2);
}
void playAlarm()
{
    unsigned char counterFor = 0;
    dotBlink(OFF);
    showString(2, alHour, 1);
    showString(2, alMinute, 2);
    for (counterFor = 0; counterFor < alarmTime; counterFor++)
    {
        buzzer(300, 200);
    }
    runnigState = HOME;
}
void exitMenu()
{
    runnigState = HOME;
    menuPosition = SETTIME;
    resetClickState();
    blinkEditNumber(0);
}
void showStringReady(unsigned char stringName)
{
    switch (stringName)
    {
    case CLOCK:
        showString(1, 'c', 1);
        showString(1, 'l', 2);
        showString(1, 'o', 3);
        showString(1, 'c', 4);
        break;
    case EXIT:
        showString(1, 'e', 1);
        showString(1, 'x', 2);
        showString(1, 'i', 3);
        showString(1, 't', 4);
        break;
    case ALARM:
        showString(1, 'a', 1);
        showString(1, 'l', 2);
        showString(1, 'a', 3);
        showString(1, 'r', 4);
        break;
    case BRIGHTNESS:
        showString(1, 'b', 1);
        showString(1, 'r', 2);
        showString(1, 'i', 3);
        showString(1, 9, 4);
        break;
    case ONE:
        showString(1, '.', 1);
        showString(1, 'o', 2);
        showString(1, 'n', 3);
        showString(1, 'e', 4);
        break;
    case ON:
        showString(1, '.', 1);
        showString(1, '.', 2);
        showString(1, 'o', 3);
        showString(1, 'n', 4);
        break;
    case OFF:
        showString(1, '.', 1);
        showString(1, 'o', 2);
        showString(1, 'f', 3);
        showString(1, 'f', 4);
        break;
    case BIP:
        showString(1, '.', 1);
        showString(1, 'b', 2);
        showString(1, 'i', 3);
        showString(1, 'p', 4);
        break;
    case SHOWDATE:
        showString(1, 'd', 1);
        showString(1, 'a', 2);
        showString(1, 't', 3);
        showString(1, 'e', 4);
        break;
    case EVER:
        showString(1, 'e', 1);
        showString(1, 'v', 2);
        showString(1, 'e', 3);
        showString(1, 'r', 4);
        break;
    default:
        break;
    }
}
void setBrightnessMenu()
{
    resetClickState();
    blinkEditNumber(2);
    while (clickState == 0 & runnigState == MENU)
    {
        volumeCheck();
        if (checkVolumeRight())
        {
            if (brightnessSet < 99)
                brightnessSet++;
        }
        if (checkVolumeLeft())
        {
            if (brightnessSet > 1)
                brightnessSet--;
        }
        showString(2, brightnessSet, 2);
    }
    brightness(brightnessSet);
    brightnessMem = brightnessSet;
    exitMenu();
}
void setTimeMenu()
{
    unsigned char hour = h, minute = m;
    resetClickState();
    showString(2, h, 1);
    showString(2, m, 2);
    blinkEditNumber(1);
    while (clickState == 0 & runnigState == MENU)
    {
        volumeCheck();
        if (checkVolumeRight())
        {
            if (hour < 24)
                hour++;
        }
        if (checkVolumeLeft())
        {
            if (hour > 0)
                hour--;
        }
        showString(2, hour, 1);
    }
    resetClickState();
    blinkEditNumber(2);
    while (clickState == 0 & runnigState == MENU)
    {
        volumeCheck();
        if (checkVolumeRight())
        {
            if (minute < 59)
                minute++;
        }
        if (checkVolumeLeft())
        {
            if (minute > 0)
                minute--;
        }
        showString(2, minute, 2);
    }
    rtc_set_time(hour, minute, 0);
    exitMenu();
}
void setDateMenu()
{
    resetClickState();
    showString(1, 4, 1);
    showString(1, 'e', 2);
    showString(2, ym, 2);
    while (clickState == 0 & runnigState == MENU)
    {
        volumeCheck();
        if (checkVolumeRight())
        {
            if (ym < 99)
                ym++;
        }
        if (checkVolumeLeft())
        {
            if (ym > 0)
                ym--;
        }
        showString(2, ym, 2);
    }
    resetClickState();
    showString(1, 'n', 1);
    showString(1, 'n', 2);
    showString(2, mm, 2);
    while (clickState == 0 & runnigState == MENU)
    {
        volumeCheck();
        if (checkVolumeRight())
        {
            if (mm < 59)
                mm++;
        }
        if (checkVolumeLeft())
        {
            if (mm > 0)
                mm--;
        }
        showString(2, mm, 2);
    }
    resetClickState();
    showString(1, 'd', 1);
    showString(1, 'a', 2);
    showString(2, dm, 2);
    while (clickState == 0 & runnigState == MENU)
    {
        volumeCheck();
        if (checkVolumeRight())
        {
            if (dm < 59)
                dm++;
        }
        if (checkVolumeLeft())
        {
            if (dm > 0)
                dm--;
        }
        showString(2, dm, 2);
    }
    rtc_set_date(7, dm, mm, ym);
    exitMenu();
}
void setAlarmMenu()
{
    unsigned char alHour1 = 0, alMinute1 = 0;
    alHour1 = h;
    alMinute1 = m;
    resetClickState();
    alarmSet = 0;
    while (clickState == 0 & runnigState == MENU)
    {
        switch (alarmSet)
        {
        case 0:
            showStringReady(OFF);
            if (checkVolumeRight())
            {
                alarmSet = 1;
            }
            if (checkVolumeLeft())
            {
                alarmSet = 2;
            }
            break;
        case 1:
            showStringReady(ONE);
            if (checkVolumeRight())
            {
                alarmSet = 2;
            }
            if (checkVolumeLeft())
            {
                alarmSet = 0;
            }
            break;
        case 2:
            showStringReady(EVER);
            if (checkVolumeRight())
            {
                alarmSet = 0;
            }
            if (checkVolumeLeft())
            {
                alarmSet = 1;
            }
            break;
        }
        volumeCheck();
    }
    if (alarmSet)
    {
        resetClickState();
        showString(2, h, 1);
        showString(2, m, 2);
        blinkEditNumber(1);
        while (clickState == 0 & runnigState == MENU)
        {
            volumeCheck();
            if (checkVolumeRight())
            {
                if (alHour1 < 24)
                    alHour1++;
            }
            if (checkVolumeLeft())
            {
                if (alHour1 > 0)
                    alHour1--;
            }
            showString(2, alHour1, 1);
        }
        resetClickState();
        blinkEditNumber(2);
        while (clickState == 0 & runnigState == MENU)
        {
            volumeCheck();
            if (checkVolumeRight())
            {
                if (alMinute1 < 59)
                    alMinute1++;
            }
            if (checkVolumeLeft())
            {
                if (alMinute1 > 0)
                    alMinute1--;
            }
            showString(2, alMinute1, 2);
        }
        alHour = alHour1;
        alMinute = alMinute1;
    }
    exitMenu();
}
void setMuteMenu()
{
    resetClickState();
    while (clickState == 0 & runnigState == MENU)
    {
        switch (muteState)
        {
        case 0:
            showStringReady(OFF);
            if (checkVolumeRight())
            {
                muteState = 1;
            }
            if (checkVolumeLeft())
            {
                muteState = 1;
            }
            break;
        case 1:
            showStringReady(ON);
            if (checkVolumeRight())
            {
                muteState = 0;
            }
            if (checkVolumeLeft())
            {
                muteState = 0;
            }
            break;
        }
        volumeCheck();
    }
    muteState1 = muteState;
    exitMenu();
}
void fastEditBrightnessMenu()
{
    dotBlink(OFF);
    if (checkVolumeRight())
    {
        fastEditBrightness(SUM);
    }
    if (checkVolumeLeft())
    {
        fastEditBrightness(MINUS);
    }
}
void showMenu()
{
    dotBlink(OFF);
    switch (menuPosition)
    {
    case SETTIME:
        showStringReady(CLOCK);
        if (clickState)
            setTimeMenu();
        if (checkVolumeRight())
            menuPosition = SETDATE;
        if (checkVolumeLeft())
            menuPosition = EXIT;
        break;
    case SETDATE:
        showStringReady(SHOWDATE);
        if (clickState)
            setDateMenu();
        if (checkVolumeRight())
            menuPosition = SETALARM;
        if (checkVolumeLeft())
            menuPosition = SETTIME;
        break;
    case SETALARM:
        showStringReady(ALARM);
        if (clickState)
            setAlarmMenu();
        if (checkVolumeRight())
            menuPosition = BRIGHTNESS;
        if (checkVolumeLeft())
            menuPosition = SETDATE;
        break;
    case BRIGHTNESS:
        showStringReady(BRIGHTNESS);
        if (clickState)
            setBrightnessMenu();
        if (checkVolumeRight())
            menuPosition = MUTE;
        if (checkVolumeLeft())
            menuPosition = SETALARM;
        break;
    case MUTE:
        showStringReady(BIP);
        if (clickState)
            setMuteMenu();
        if (checkVolumeRight())
            menuPosition = EXIT;
        if (checkVolumeLeft())
            menuPosition = BRIGHTNESS;
        break;
    case EXIT:
        showStringReady(EXIT);
        if (clickState)
            exitMenu();
        if (checkVolumeRight())
            menuPosition = SETTIME;
        if (checkVolumeLeft())
            menuPosition = MUTE;
        break;
    }
}

void main(void)
{
    portConfig();
    startTimers();
    startIntrupts();
#asm("sei")
    i2c_init();
    rtc_init(0, 0, 0);
    brightness(brightnessMem);
    brightnessSet = brightnessMem;

    while (1)
    {
        volumeCheck();
        switch (runnigState)
        {
        case HOME:
            showClock();
            break;
        case MENU:
            showMenu();
            break;
        case ALARM:
            playAlarm();
            break;
        case BRIGHTNESSHOME:
            fastEditBrightnessMenu();
            break;
        case SHOWDATE:
            showDate();
            break;
        }
    }
}

void stopTimers()
{
    ASSR = 0 << AS2;
    TCCR2 = (0 << PWM2) | (0 << COM21) | (0 << COM20) | (0 << CTC2) | (0 << CS22) | (0 << CS21) | (0 << CS20);
    TCNT2 = 0x00;
    TIMSK = (0 << OCIE2) | (0 << TOIE2) | (0 << TICIE1) | (0 << OCIE1A) | (0 << OCIE1B) | (0 << TOIE1) | (0 << TOIE0);
}
void startTimers()
{
    ASSR = 0 << AS2;
    TCCR2 = (0 << PWM2) | (0 << COM21) | (0 << COM20) | (0 << CTC2) | (0 << CS22) | (1 << CS21) | (1 << CS20);
    TCNT2 = 0x00;
    OCR2 = 0xff;
    TIMSK = (1 << OCIE2) | (1 << TOIE2) | (0 << TICIE1) | (0 << OCIE1A) | (0 << OCIE1B) | (1 << TOIE1) | (0 << TOIE0);
}
void startCounterTimer()
{
    TCCR1A = (0 << COM1A1) | (0 << COM1A0) | (0 << COM1B1) | (0 << COM1B0) | (0 << WGM11) | (0 << WGM10);
    TCCR1B = (0 << ICNC1) | (0 << ICES1) | (0 << WGM13) | (0 << WGM12) | (0 << CS12) | (1 << CS11) | (1 << CS10);
    TCNT1H = 0x9E;
    TCNT1L = 0x58;
    ICR1H = 0x00;
    ICR1L = 0x00;
    OCR1AH = 0x00;
    OCR1AL = 0x00;
    OCR1BH = 0x00;
    OCR1BL = 0x00;
}
void stopCounterTimer()
{
    TCCR1A = (0 << COM1A1) | (0 << COM1A0) | (0 << COM1B1) | (0 << COM1B0) | (0 << WGM11) | (0 << WGM10);
    TCCR1B = (0 << ICNC1) | (0 << ICES1) | (0 << WGM13) | (0 << WGM12) | (0 << CS12) | (0 << CS11) | (0 << CS10);
    TCNT1H = 0x00;
    TCNT1L = 0x00;
    ICR1H = 0x00;
    ICR1L = 0x00;
    OCR1AH = 0x00;
    OCR1AL = 0x00;
    OCR1BH = 0x00;
    OCR1BL = 0x00;
}
void startIntrupts()
{
    GICR |= (1 << INT1) | (1 << INT0);
    MCUCR = (1 << ISC11) | (0 << ISC10) | (1 << ISC01) | (0 << ISC00);
    GIFR = (1 << INTF1) | (1 << INTF0);
}
void stopIntrupts()
{
    GICR |= (0 << INT1) | (0 << INT0);
    MCUCR = (0 << ISC11) | (0 << ISC10) | (0 << ISC01) | (0 << ISC00);
    GIFR = (0 << INTF1) | (0 << INTF0);
}
void portConfig()
{
    DDRB = (0 << DDB7) | (1 << DDB6) | (1 << DDB5) | (1 << DDB4) | (1 << DDB3) | (1 << DDB2) | (1 << DDB1) | (1 << DDB0);
    PORTB = (0 << PORTB7) | (0 << PORTB6) | (0 << PORTB5) | (0 << PORTB4) | (0 << PORTB3) | (0 << PORTB2) | (0 << PORTB1) | (0 << PORTB0);
    DDRC = (0 << DDC6) | (0 << DDC5) | (0 << DDC4) | (1 << DDC3) | (1 << DDC2) | (1 << DDC1) | (1 << DDC0);
    PORTC = (0 << PORTC6) | (0 << PORTC5) | (0 << PORTC4) | (0 << PORTC3) | (0 << PORTC2) | (0 << PORTC1) | (0 << PORTC0);
    DDRD = (0 << DDD7) | (0 << DDD6) | (0 << DDD5) | (0 << DDD4) | (0 << DDD3) | (0 << DDD2) | (1 << DDD1) | (0 << DDD0);
    PORTD = (0 << PORTD7) | (0 << PORTD6) | (0 << PORTD5) | (0 << PORTD4) | (1 << PORTD3) | (1 << PORTD2) | (0 << PORTD1) | (1 << PORTD0);
}