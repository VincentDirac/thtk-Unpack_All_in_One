import os
import chardet
# -*- coding: utf-8 -*-

filesList = []  # 记录要处理的文件

for root, dirs, files in os.walk(".\\", topdown=True):  # 要处理文件所在文件夹
    # 忽略指定文件夹
    ignore_dirs = {"thtk", ".git", ".vscode", ".pytest_cache", "dist", "build", ".pixi"}
    dirs[:] = [d for d in dirs if d not in ignore_dirs]
    # 获得所有文本文件
    for file in files:
        SUPPORTED_EXTENSIONS = [
            ".txt",
            ".md",
            ".html",
            ".xml",
            ".json",
            ".py",
            ".js",
            ".css",
            ".csv",
            ".tsv",
            ".pl",
        ]
        if os.path.splitext(file)[1].lower() in SUPPORTED_EXTENSIONS:
            # 只处理指定后缀的文件
            filesList.append(os.path.join(root, file))

if len(filesList) > 0:
    for path in filesList:
        # 修改编码格式
        with open(path, "rb+") as fp:
            raw_data = fp.read()
            detected = chardet.detect(raw_data)
            encoding = detected["encoding"] if detected else None
            if encoding and encoding.lower() != "utf-8":
                try:
                    content = raw_data.decode("shift_jis", "ignore").encode("utf-8")
                    # 第一个是原来的编码，第二个是要转换的编码
                    # 可能有各别词解码不了，所以加一个'ignore'忽略小错误
                except Exception as e:
                    # 如果原编码，即decode，写错了，就会这样
                    print(f"!!!转换失败：{path}，错误：{e}")
                    continue
                print("转换成功：" + path)
                fp.seek(0)  # 指针重新指向文件开头
                fp.truncate()  # 清空
                fp.write(content)
            else:
                print(f"跳过文件（非 shift_jis 编码）：{path}")
