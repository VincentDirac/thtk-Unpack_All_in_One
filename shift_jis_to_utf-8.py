import os
import chardet
# -*- coding: utf-8 -*-

L = [] # 记录要处理的文件

for root, dirs, files in os.walk(".\\"): # 要处理文件所在文件夹
    # 获得所有.txt文件
    for file in files:
        if os.path.splitext(file)[1] == '.txt':
            L.append(os.path.join(root, file))

if len(L) > 0:
    for path in L:
        # 修改编码格式
        with open(path, 'rb+') as fp:
            raw_data = fp.read()
            detected = chardet.detect(raw_data)
            encoding = detected['encoding'] if detected else None
            if encoding and encoding.lower() == 'shift_jis':
                try:
                    content = raw_data.decode('shift_jis', 'ignore').encode('utf-8') 
                    # 第一个是原来的编码，第二个是要转换的编码
                    # 可能有各别词解码不了，所以加一个'ignore'忽略小错误
                except Exception as e:
                    # 如果原编码，即decode，写错了，就会这样
                    # 可以考虑用chardet.detect检测原编码，但有些文件并没标记，故没用
                    print(f"!!!转换失败：{path}，错误：{e}")
                    continue
                print("转换成功："+path)
                fp.seek(0)      # 指针重新指向文件开头
                fp.truncate()   # 清空
                fp.write(content)
            else:
                print(f"跳过文件（非 shift_jis 编码）：{path}")