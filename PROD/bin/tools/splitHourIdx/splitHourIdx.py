import sys

# =====Change log===== #
# 1. split hour.idx (Finished)

# =====Parameters settings===== #
try:
    fileArg = open('./inputArguments.temp', "r")
except IOError:
    print('\n"Please run splitHourIdx.csh." This is a function of splitHourIdx.csh.\n')
    sys.exit()
else:
#with open('./inputArguments.temp', "r") as fileArg:
#    CC IT01 -- HHE
    string_arg = fileArg.readline()
    string_arg = string_arg.strip()
    list_arg = string_arg.split(' ')
    net = list_arg[0]
    station = list_arg[1]
    loc = list_arg[2]
    cha = list_arg[3]
#    /home/dmc/QC/PDF/STATS/CC.IT01.--/HHE/Y2014 /home/dmc/QC/PDF/STATS/CC.IT01.--/HHE/Y2015 /home/dmc/QC/PDF/STATS/CC.IT01.--/HHE/Y2016
    string_fileDir = fileArg.readline()
    string_fileDir = string_fileDir.strip()
    list_fileDir = string_fileDir.split(' ')
    print('--> reading: %s/HOUR/hour.idx' % list_fileDir[0])
    fileArg.close()
    

# =====Procedure===== #
FileHourIdx = list_fileDir[0]+'/HOUR/hour.idx'
FileHourIdxNew = FileHourIdx+'.new'

preLine = ['0','0','0']
print('--> writing: %s' % FileHourIdxNew)
fout = open(FileHourIdxNew, "w")
i = 0
with open(FileHourIdx, "r") as fileInfo:
    for line in fileInfo.readlines():
        line_stripped = line.strip()
        line_splited = line_stripped.split('\t')
        curLine = line_splited
#                       (1 - 365) < 0
        if (int(curLine[0])-int(preLine[0])) < 0 :
#            print('Year change')
            fout.close()
            i = i + 1 
            filename = list_fileDir[i]+'/HOUR/hour.idx'
            print('--> writing: %s' %filename)
            fout = open(filename, "w")
            fout.write(line)
        else:
            fout.write(line)
        preLine = curLine
    fout.close()
