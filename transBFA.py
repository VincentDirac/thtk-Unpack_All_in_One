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
    bgmFileName = ""
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

def getBFAJson(bgmObj,filePath):
    f = open(filePath,"r+", encoding="utf-8")
    info = {}
    bgmList = []
    # 处理ZUN的特殊癖好
    spList = {
        "TH128_08.WAV":"プレイヤーズスコア"
    }
    for line in f.readlines():
        line = line.rstrip("\n")
        if line == "":
            continue
        if line != "[THBGM]":
            lines = line.split(" = ")
            key = lines[0]
            value = lines[1]
            if key == "BGM":
                # 如果是BGM列，将其转为数组
                bgmLine = value.split(", ")
                # BGM文件名字
                fileName = bgmLine[0]
                bgmName = bgmObj.get(fileName)
                if(bgmName is None):
                    # 处理复用文件名
                    if spList.get(fileName) is not None:
                        bgmName = spList.get(fileName)
                    else:
                        bgmName = fileName
                # 地址
                hexs = [bgmLine[1],bgmLine[2],bgmLine[3],bgmLine[4]]
                # 存储一个BGM对象
                bgm = {"Name":bgmName,"FileName":fileName,"Address":hexs}
                # 走你
                bgmList.append(bgm)
            else:
                # 普通键值正常写入
                info[key] = value
    info["BGM"] = bgmList
    f.close()
    return info

# 输出新的BFA信息
def outputBFA(bfaInfo,filePath):
    f = open(filePath,"w+", encoding="utf-8")
    f.write("[THBGM]\n")
    for line in bfaInfo:
        key = line
        value = bfaInfo[key]
        if key == "BGM":
            # 如果是BGM键，转回重复键模式
            newLine = "\n"
            for bgm in value:
                bgmName = bgm["Name"]
                address = ", ".join(bgm["Address"])
                newLine += key + " = " + ", ".join([bgmName,address]) + "\n"
        else:
            newLine = key + " = " + value + "\n"
        f.write(newLine)
    f.close()

# 输出曲目列表（排序后）
def outputBGMListWithSort(bgmList,filePath):
    f = open(filePath,"w+", encoding="utf-8")
    # 按文件序号排序BGM
    bgmList = sorted(bgmList, key=lambda k: k["FileName"])
    for bgm in bgmList:
        bgmLine = (", ").join([bgm["FileName"],bgm["Name"]]) + "\n"
        f.write(bgmLine)
    f.close()

bgmInfo = getMusicCMT(cmtName)
bfaInfo = getBFAJson(bgmInfo,bfaDir + "BgmForAll.ini")
outputBFA(bfaInfo,bfaDir + "BgmForAll+.ini")
outputBGMListWithSort(bfaInfo["BGM"],bfaDir + "BgmList.txt")