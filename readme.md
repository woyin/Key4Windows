将原先[CapsLock+](http://cjkis.me/capslock+/) 代码进行了简化，并删除了大量不需要的文件，并大量精简了重复的内容，同步添加了部分注释。
本库的目的就是为了在Windows中实现Linux 下的Ctrl的常见组合键，实现上下左右功能，这对那些60%键盘的用户尤为实用。
其他源库的内容已经被我删除，因为是真的不需要。


## 1.怎么运行Capslock+的源码？
1. 下载 [AutoHotkey](http://www.ahkscript.org/)，并安装。
2. 从 GitHub 下载源码。
3. 运行`LinuxKey.ahk`。

## 2.能不能在XXX快捷键上实现XXX功能？

```ahk
/*
不打算修改程序本身，只想为某个按键实现功能的话，可以在这里：
1. 在lib/lib_keysFunction.ahk 添加 keyfunc_xxxx() 的函数，
2. 在 settings.ini [keys]下添加设置，
例如按下面这样写，然后添加设置：caps_f7=keyFunc_test2(apple)
3. 保存，重载 capslock+ (capslock+F5)
4. 按下 capslock+F7 试试
************************************************/
keyfunc_test2(str){
  msgbox, % str
  return
}
```

*为了避免按键设置会调到内部函数，所以规定了所有函数以`keyfunc_`开头

具体要实现什么功能，就去学下 AutoHotkey 咯，很快上手的。

## 3.那你原有的功能我想改怎么改？
`LinuxKey.ahk`是入口文件，其他所有依赖文件都扔`/lib`里了，各文件说明如下：

|文件|说明|
|:---|:---|
|lib_functions.ahk|一些依赖函数|
|lib_init.ahk|各种初始化从这里开始|
|lib_json.ahk|json库|
|lib_keysFunction.ahk|几乎所有按键功能都在这实现|
|lib_language.ahk|程序用到的字符串放到这|
|lib_loadAnimation.ahk|程序加载动画|
|lib_settings.ahk|Capslock+settings.ini设置项提取|
|lib_ydTrans.ahk|翻译|


