;~ 初始化段，也就是自动运行段，所有需要自动运行的代码放这里，然后放到程序最开头
SetTimer, initAll, -400 ;等个100毫秒，等待其他文件的include都完成

return

initAll:
Suspend, On ;挂起所有热键

IniRead, loadingAnimation, settings.ini, Global, loadingAnimation, 1
IniRead, language, settings.ini, Global, language, 0

if(loadingAnimation != "0")
	gosub, showLoading

;------------  language -----------
;  language:=CLsets.global.language

; 字符串初始化,这个要第一个运行
;  if(language and IsLabel("language_" . language))
;  	gosub, language_%language%
;  else if(getSystemLanguage() == "Chinese_PRC")
;  	gosub, language_Simplified_Chinese
;  else if(getSystemLanguage() == "Chinese_Hong_Kong" or getSystemLanguage() == "Chinese_Taiwan")
;  	gosub, language_Traditional_Chinese
;  else
;  	gosub, language_English
gosub, language_Simplified_Chinese
;------------  /language -----------

gosub, settingsInit ;初始化设置

Suspend, Off

if(loadingAnimation != "0")
	gosub, hideLoading
return