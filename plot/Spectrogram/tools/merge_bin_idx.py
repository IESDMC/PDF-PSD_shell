from datetime import datetime
# =====Change log===== #
# 1. try except and with open (Finished)

# =====Parameters settings===== #
fileArg = open('./inputArguments.temp', "r")
string_arg = fileArg.readline()
string_arg = string_arg.strip()
list_arg = string_arg.split(' ')
net = list_arg[0]
station = list_arg[1]
loc = list_arg[2]
cha = list_arg[3]
year = list_arg[4]
month = list_arg[5]
fileArg.close()

# =====Procedure===== #
# /home/dmc/QC/PDF/STATS/TW.EC1F.--/EHZ/Y2020/HOUR/
fileDir = '/home/dmc/QC/PDF/STATS/'+net+'.'+station+'.'+loc+'/'+cha+'/Y'+year+'/HOUR'
print('Processing: merging .bin & hour.idx')
print(fileDir)
binList = []
try:
    fileBin = open('./bin.temp', "r")
except IOError:
    raise
else:
    print('./bin.temp --> ready')
    for x in fileBin:
        x = x.strip()
        binList.append(x)
    fileBin.close()

# /home/dmc/QC/PDF/STATS/TW.EC1F.--/EHZ/Y2020/HOUR/hour.idx
hourIdxDir = fileDir+'/hour.idx'
try:
    fileHourIdx = open(hourIdxDir, "r")
except IOError:
    raise
else:
    print('./hour.idx --> ready')
    tempIdxList = fileHourIdx.readlines()

print('merging')
for Bin in binList:
    binDir = fileDir+'/'+Bin
    jday = Bin[1:4]
    try:
        fileBin = open(fileDir+'/'+Bin, "r")
    except IOError:
        continue
    else:
        tempList = []
        for x in tempIdxList:
            x = x.strip()
            lines = x.split('\t')
            if lines[0] == jday:
                tempList.append(lines)
        mergedList = []
        for x in fileBin:
            x = x.strip()
            lines = x.split('\t')
            timeIndex = lines.pop(0)
            matches = [y for y in tempList if y[2] == timeIndex]
            date_time_obj = datetime.strptime(matches[0][1], '%H:%M')
            a_timedelta = date_time_obj - datetime(1900, 1, 1)
            seconds = a_timedelta.total_seconds()
            secondsInDayScale = seconds/86400
            lines.insert(0, round(secondsInDayScale,4))
            mergedList.append(lines)
        fileBin.close()
        with open(Bin+'.temp', 'w') as filehandle:
            for listitem in mergedList:
                filehandle.write('%s\t' % listitem[0])
                filehandle.write('%s\t' % listitem[1])
                filehandle.write('%s\n' % listitem[2])
        del tempList[:]
        del mergedList[:]

fileHourIdx.close()
print('--> done')
