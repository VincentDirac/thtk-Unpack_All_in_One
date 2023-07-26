f = open("BgmForAll.ini", "r+", encoding="utf-8")
h = open("BGMForAll+.ini", "w+", encoding="utf-8")
for bgmDataLines in f.readlines():
    if "BGM = " in bgmDataLines:
        bgmDataLines = bgmDataLines.split(" ")
        if "TH128_08" in bgmDataLines[2]:
            bgmDataLines[2] = "プレイヤーズスコア,"
        g = open("./data/musiccmt.txt", "r+", encoding="utf-8")
        for bgmNameLines in g.readlines():
            if "@bgm/" in bgmNameLines:
                bgmFileName = bgmNameLines.lstrip("@bgm/").rstrip("\n")
            if "♪" in bgmNameLines:
                if bgmFileName.upper() in bgmDataLines[2]:
                    bgmName = bgmNameLines.lstrip("♪").rstrip("\n")
                    bgmDataLines[2] = bgmName + ","
                    break
        bgmDataLines = (" ").join(bgmDataLines)
        h.write(bgmDataLines)
    else:
        h.write(bgmDataLines)