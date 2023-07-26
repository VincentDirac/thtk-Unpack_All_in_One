f = open("BgmForAll.ini", "r+", encoding="utf-8")
h = open("BGMForAll+.ini", "w+", encoding="utf-8")
bgmList = []
for bgmDataLines in f.readlines():
    if "BGM = " in bgmDataLines:
        bgmDataLines = bgmDataLines.split(" ")
        bgmList.append([bgmDataLines[2]])
        if "TH128_08" in bgmDataLines[2]:
            bgmDataLines[2] = "プレイヤーズスコア,"
        g = open("./data/musiccmt.txt", "r+", encoding="utf-8")
        for bgmNameLines in g.readlines():
            if "@bgm/" in bgmNameLines:
                bgmFileName = bgmNameLines.lstrip("@bgm/").rstrip("\n")
            if "♪" in bgmNameLines:
                if bgmFileName.upper() in bgmDataLines[2]:
                    bgmName = bgmNameLines.lstrip("♪").rstrip("\n")
                    bgmList[-1].append(bgmName)
                    bgmDataLines[2] = bgmName + ","
                    break
        bgmDataLines = (" ").join(bgmDataLines)
        h.write(bgmDataLines)
    else:
        h.write(bgmDataLines)
bgmListFile = open("bgmList.txt", "w+", encoding="utf-8")
for i in bgmList:
    bgmListFile.write(i[0] + ", " + i[1] + "\n")
f.close()
g.close()
h.close()
bgmListFile.close()