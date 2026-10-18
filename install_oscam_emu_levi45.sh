#!/bin/sh
# ============================================================
#  OSCam EMU Levi45 Installer Script
#  Package: enigma2-plugin-softcams-oscam-emu-pcsc-levi45
#  Version: 11968-803
#  By Levi45
# ============================================================

IPK_URL="https://raw.githubusercontent.com/ahmeds200917/A.Shawky/refs/heads/main/enigma2-plugin-softcams-oscam-emu-pcsc-levi45_11968-803_all.ipk"
IPK_FILE="/tmp/oscam-emu-levi45.ipk"

echo "=================================================="
echo "   تنصيب OSCam EMU Levi45 11968-803"
echo "=================================================="

# التحقق من وجود الإنترنت
ping -c 1 8.8.8.8 > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "خطأ: لا يوجد اتصال بالإنترنت!"
    echo "تأكد من اتصال الرسيفر بالإنترنت ثم أعد المحاولة."
    exit 1
fi

echo "جاري تحميل الحزمة..."
wget -O "$IPK_FILE" "$IPK_URL" 2>/dev/null || curl -L -o "$IPK_FILE" "$IPK_URL"

if [ ! -f "$IPK_FILE" ]; then
    echo "فشل تحميل الحزمة!"
    exit 1
fi

echo "تم التحميل بنجاح."
echo "جاري إزالة أي نسخة قديمة من OSCam..."

# إزالة النسخ القديمة
opkg remove enigma2-plugin-softcams-oscam-* > /dev/null 2>&1
opkg remove oscam* > /dev/null 2>&1

echo "جاري تنصيب الحزمة..."
opkg install --force-overwrite --force-reinstall --force-depends "$IPK_FILE"

if [ $? -eq 0 ]; then
    echo ""
    echo "=================================================="
    echo "   تم التنصيب بنجاح!"
    echo "=================================================="
    echo "سيتم إعادة تشغيل الإنجما خلال 5 ثواني..."
    echo "بعد الإقلاع اختر السوفتكام من قائمة السوفتكامز"
    sleep 5
    killall -9 enigma2
else
    echo ""
    echo "حدث خطأ أثناء التنصيب."
    echo "جرب التنصيب يدوياً:"
    echo "opkg install --force-overwrite $IPK_FILE"
fi

# تنظيف
rm -f "$IPK_FILE"
exit 0
