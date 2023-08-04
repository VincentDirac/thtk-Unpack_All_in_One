from argparse import ArgumentParser

arg_parser = ArgumentParser()
arg_parser.add_argument('-c', '--cmt', help='musiccmt文件名(路径)', metavar='File')
arg_parser.add_argument('-d', '--dir', help='BFA配置所在目录', metavar='File')
args = arg_parser.parse_args()
cmtName = args.cmt if args.cmt else './data/musiccmt.txt'
bfaDir = args.dir if args.dir else './bgm/'

def getMusicCMT(filePath):
    f = open(filePath,"r+", encoding="utf-8")
    bgmObj = {}
    for line in f.readlines():
        if "@bgm/" in line:
            # 查找BGM文件名
            bgmFileName = line.lstrip("@bgm/").rstrip("\n").rstrip(".wav").upper() + ".WAV"
        elif "♪" in line:
             # 查找BGM名
             bgmName = line.lstrip("♪").rstrip("\n")
             bgmObj[bgmFileName] = bgmName
    f.close()
    return bgmObj

bgmObj = getMusicCMT(cmtName)
bfaFile = open(bfaDir + "BgmForAll.ini", "r+", encoding="utf-8")
bfaNewFile = open(bfaDir + "BGMForAll+.ini", "w+", encoding="utf-8")
bgmListFile = open(bfaDir + "BgmList.txt", "w+", encoding="utf-8")
for bgmDataLine in bfaFile.readlines():
    if "BGM = " in bgmDataLine:
        bgmDataLine = bgmDataLine.lstrip("BGM = ")
        bgmDataLines = bgmDataLine.split(", ")
        bgmFileName = bgmDataLines[0]
        # BGM名称处理
        bgmName = bgmObj.get(bgmFileName)
        if bgmName != None:
            bgmDataLines[0] = bgmName
        # 拼接BGM数据
        bgmDataLine = "BGM = " + (", ").join(bgmDataLines)
        # 写入BFA文件
        bfaNewFile.write(bgmDataLine)
        # 写入BGM列表
        bgmListFile.write(bgmFileName + ", " + bgmDataLines[0] + "\n")
    else:
        # 复制BFA配置
        bfaNewFile.write(bgmDataLine)
        
bfaFile.close()
bfaNewFile.close()