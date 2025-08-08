import os
import re
import argparse

# 版本号与音乐名的映射
VERSION_TO_MUSIC = {
    "20": "锦上京",
    "19": "兽王园",
    "18": "虹龙洞",
    "17": "鬼形兽",
    "16": "天空璋",
    "15": "绀珠传",
    "14": "辉针城",
    "13": "神灵庙",
    "12": "星莲船",
    "11": "地灵殿",
    "10": "风神录",
}


def main():
    # 添加外部参数解析
    parser = argparse.ArgumentParser(
        description="Process dialogue files with version info."
    )
    parser.add_argument(
        "--thver", required=True, help="Specify the TH version (e.g., TH17)."
    )
    args = parser.parse_args()
    thver = args.thver  # 获取版本号

    # 根据版本号获取音乐名
    if thver not in VERSION_TO_MUSIC:
        raise ValueError(f"Unsupported version: {thver}")
    music_name = VERSION_TO_MUSIC[thver]

    path = "./msg/"
    output_dir = "./dialogue/"  # 输出文件夹路径

    # 确保输出文件夹存在
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    for root, folders, files in os.walk(path):
        for file in files:
            for file in files:
                if (
                    file in [".gitignore"]
                    or "staff" in file
                    or "vs" in file
                    or "end" in file
                    or "output" in file
                ):
                    continue
                else:
                    convertMsg(root, file, output_dir, music_name)


def convertMsg(root, file_name, output_dir, music_name):
    # 提取文件名中的数字
    match = re.search(r"\d+", file_name)
    if match:
        file_number = int(match.group())
    else:
        raise ValueError(f"No number found in file name: {file_name}")

    # 用于存储解析结果
    parsed_lines = []

    # 正则表达式匹配
    dialogue_pattern = re.compile(r"17;(.+)")
    bgm_pattern = re.compile(r"\b19\b")
    char_pattern = re.compile(r"^\s*(7|8;)")  # 匹配角色标识

    # 读取文件并逐行解析
    with open(os.path.join(root, file_name), "r+", encoding="utf-8") as file:
        current_dialogue = []
        current_char = None  # 当前角色
        for line in file:
            stripped_line = line.strip()

            # 检查是否是角色标识
            char_match = char_pattern.match(stripped_line)
            if char_match:
                current_char = char_match.group(1)
                continue

            # 检查是否是日文对话
            dialogue_match = dialogue_pattern.match(stripped_line)
            if dialogue_match:
                # 提取日文文本并加入当前对话块
                current_dialogue.append(dialogue_match.group(1))
                continue

            # 检查是否是 BGM 切换
            if bgm_pattern.search(stripped_line):
                # 如果有未输出的对话块，先输出对话
                if current_dialogue:
                    parsed_lines.append("ja")
                    parsed_lines.append("<br />".join(current_dialogue))
                    parsed_lines.append("zh")
                    parsed_lines.append("")
                    current_dialogue = []

                # 插入 BGM 切换格式
                parsed_lines.append("bgm")
                parsed_lines.append("ja")
                parsed_lines.append(
                    f"{{{{{music_name}音乐名|2|{file_number * 2 + 1}}}}}"
                )
                parsed_lines.append("zh")
                parsed_lines.append(
                    f"{{{{{music_name}音乐名|1|{file_number * 2 + 1}}}}}"
                )
                continue

            # 如果遇到非对话行且当前对话块不为空，输出对话块
            if current_dialogue:
                parsed_lines.append(f"char\n{current_char if current_char else ''}")
                parsed_lines.append("ja")
                parsed_lines.append("<br />".join(current_dialogue))
                parsed_lines.append("zh")
                parsed_lines.append("")
                current_dialogue = []

    # 如果文件结束时还有未输出的对话块，输出它
    if current_dialogue:
        parsed_lines.append(f"char\n{current_char if current_char else ''}")
        parsed_lines.append("ja")
        parsed_lines.append("<br />".join(current_dialogue))
        parsed_lines.append("zh")
        parsed_lines.append("")

    # 将结果写入输出文件
    output_file_path = os.path.join(output_dir, file_name + "_output.txt")
    with open(output_file_path, "w", encoding="utf-8") as output_file:
        output_file.write("\n".join(parsed_lines))

    print("解析完成，结果已保存。")


main()
