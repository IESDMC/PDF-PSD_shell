import sys

# =====Change log===== #

# =====Parameters settings===== #
try:
    fileArg = open('./inputArguments.temp', "r")
except IOError:
    print('\n"Please run splitHourIdx.csh." This is a function of splitHourIdx.csh.\n')
    sys.exit()
else:
#    CC IT01 -- HHE
    string_arg = fileArg.readline()
#    /home/dmc/QC/PDF/STATS/CC.IT01.--/HHE/Y2014 /home/dmc/QC/PDF/STATS/CC.IT01.--/HHE/Y2015 /home/dmc/QC/PDF/STATS/CC.IT01.--/HHE/Y2016
    string_fileDir = fileArg.readline()
    string_fileDir = string_fileDir.strip()
    list_fileDir = string_fileDir.split(' ')
    fileArg.close()
    

# =====Procedure===== #
FileHourIdx = list_fileDir[0]+'/HOUR/hour.idx'
preLine = ['0','0','0']
fout = open('./isHourIdxOneYear.temp', "w")
with open(FileHourIdx, "r") as fileInfo:
    for line in fileInfo.readlines():
        line_stripped = line.strip()
        line_splited = line_stripped.split('\t')
        curLine = line_splited
#                       (1 - 365) < 0
        if (int(curLine[0])-int(preLine[0])) < 0 :
            fout.write('0')
            fout.close()
            sys.exit()
        else:
            pass
        preLine = curLine
    fout.write('1')
    fout.close()
