/*
提出字符串放在这里(还有很多还嵌在代码中= =)
*/
language_Simplified_Chinese:
; ydTrans.ahk
global lang_yd_translating:="翻译中...  （如果网络太差，翻译请求会暂时阻塞程序，稍等就好）"
global lang_yd_name:="有道翻译"
global lang_yd_needKey:="缺少有道翻译API的key，有道翻译无法使用"
global lang_yd_fileNotExist:="文件（文件夹）不存在"
global lang_yd_errorNoNet:="发送异常，可能是网络已断开"
global lang_yd_errorTooLong:="部分句子过长"
global lang_yd_errorNoResults:="无词典结果"
global lang_yd_errorTextTooLong:="要翻译的文本过长"
global lang_yd_errorCantTrans:="无法进行有效的翻译"
global lang_yd_errorLangType:="不支持的语言类型"
global lang_yd_errorKeyInvalid:="无效的key"
global lang_yd_errorSpendingLimit:="已达到今日消费上限，或者请求长度超过今日可消费字符数"
global lang_yd_errorNoFunds:="帐户余额不足"
global lang_yd_trans:="------------------------------------有道翻译------------------------------------"
global lang_yd_dict:="------------------------------------有道词典------------------------------------"
global lang_yd_phrase:="--------------------------------------短语--------------------------------------"

global lang_settingsUserInit:=""
lang_settingsUserInit=
(
;------------ Encoding: UTF-16 ------------
;请对照 settingsDemo.ini 来配置相关设置
[Global]

[TTranslate]

[Keys]

)
global lang_settingsIniInit:=""
lang_settingsIniInit=
(
;------------ Encoding: UTF-16 ------------
; #CapsLock+ 设置样本
; - ******请务必阅读以下说明：******

; - **这里的设置是只读的，仅作说明参考，不要修改这里的设置（修改了也无效），需要自定义设置请在 settings.ini 中的对应段名中作添加修改
;     例如，需要开启开机自启动，请在 settings.ini 的 [Global] 下添加：autostart=1，并保存

; - "[]"里面是段名，不能修改
; - 各段下所有设置的格式都为：键名=键值，每行一个
; - 分号开头的是注释行，注释行不影响设置，就像这几行

;----------------------------------------------------------------
; ##全局设置
[Global]
;是否开机自启动，1为是，0为否（默认）。
autostart=0

;是否开启程序加载动画，1是（默认），0否
loadingAnimation=1

;----------------------------------------------------------------;
; ##+T翻译设置

[TTranslate]
;有道api接口
;翻译功能通过调用有道的api实现。
;接口的请求频率限制为每小时1000次，超过限制会被封禁。也就是说所有使用Capslock+翻译的人一小时内翻译的次数加起来不能超过1000次。
;有道api网址：http://fanyi.youdao.com/openapi

;接口类型，0为免费版，1为收费版。通过上面的网址申请的是免费版的，收费版是需要 email 他们来申请的。
apiType=0

;免费版的有道 api key 的 keyfrom 参数，申请 api 时要求填写的。收费版的不需要填写。
keyFrom=xxx

;有道api的key，如果自己申请到key，可以填入，这样就不用和其他人共用api接口，留空则使用自带的key，所有人共用
;注意如果是免费版的key，apiType也要相应设置为0，收费版的填写1
apiKey=0123456789

;----------------------------------------------------------------;
; ##按键功能设置

; - 可设置的按键组合有：
;   Capslock + F1~F12
;   Capslock + 0~9
;   Capslock + a~z
;   Capslock + `-=[]\;',./ 
;   Capslock + Backspace, Tab, Enter, Space, RAlt
;   Capslock + LALt + F1~F12
;   Capslock + LALt + 0~9
;   Capslock + LALt + a~z
;   Capslock + LALt + `-=[]\;',./ 
;   Capslock + LALt + Backspace, Tab, Enter, Space, RAlt

; - 以下设置键名是按键组合名，键值是对应功能，所有支持的功能都在下面

[Keys]


)

; keysFunction.ahk
global lang_kf_getDebugText:=""
lang_kf_getDebugText=
(
供 TabScript 调试用字符串
点击"OK"将它复制到剪贴板
)
return
