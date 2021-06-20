######################################## VARIABLE #######################################

myname=vbird
unset myname
echo ${myname}
myarray=(a b c d e)
echo ${myarray[*]}
echo ${myarray[2]}
#關聯数組
capital["one"]="sdkjfdlksf"
capital["two"]="sdkjf"
capital["three"]="sdf"

$(date "+%Y%m%d") #Equit `date "+%Y%m%d`

#test命令是shell环境中测试条件表达式的实用工具。
test n1 -[eq][ge][gt][le][lt][ne] n2 #Test number.
test str1 [=][!=][<][>][-n][-z] str2 #Test string.
test -[d][e][f][r][s][w][x][O][G] file #Test file.
test file1 -[nt][nt] file2

#判断表达式
if test                 #表达式为真
if test !               #表达式为假
test 表达式1 –a 表达式2 #两个表达式都为真
test 表达式1 –o 表达式2 #两个表达式有一个为真
test 表达式1 !  表达式2 #条件求反

#判断字符串
test –n 字符串         #字符串的长度非零
test –z 字符串         #字符串的长度是否为零
test 字符串1＝字符串2  #字符串是否相等，若相等返回true
test 字符串1!＝字符串2 #字符串是否不等，若不等反悔false

#判断整数
test 整数1 -eq 整数2 #整数相等
test 整数1 -ge 整数2 #整数1大于等于整数2
test 整数1 -gt 整数2 #整数1大于整数2
test 整数1 -le 整数2 #整数1小于等于整数2
test 整数1 -lt 整数2 #整数1小于整数2
test 整数1 -ne 整数2 #整数1不等于整数2

#判断文件
test File1 –ef File2 #两个文件是否为同一个文件，可用于硬连接。主要判断两个文件是否指向同一个inode。
test File1 –nt File2 #判断文件1是否比文件2新
test File1 –ot File2 #判断文件1比是否文件2旧
test –b file         #文件是否块设备文件
test –c File         #文件并且是字符设备文件
test –d File         #文件并且是目录
test –e File         #文件是否存在 （常用）
test –f File         #文件是否为正规文件 （常用）
test –g File         #文件是否是设置了组id
test –G File         #文件属于的有效组ID
test –h File         #文件是否是一个符号链接（同-L）
test –k File         #文件是否设置了Sticky bit位
test –b File         #文件存在并且是块设备文件
test –L File         #文件是否是一个符号链接（同-h）
test –o File         #文件的属于有效用户ID
test –p File         #文件是一个命名管道
test –r File         #文件是否可读
test –s File         #文件是否是非空白文件
test –t FD           #文件描述符是在一个终端打开的
test –u File         #文件存在并且设置了它的set-user-id位
test –w File         #文件是否存在并可写
test –x File         #文件属否存在并可执行

####################################### STRUCT #######################################

#IF
if cmd #Cmd return 0=TRUE;other=FALSE.
then
	cmd1 && cmd2
elif cmd
	cmd1 || cmd2
else
	cmd
fi

#CASE
case variable in
pattern1 | pattern2)
	cmd
	cmd;;
pattern3)
	cmd;;
*)
	cmd;;
esac

#FOR
for expression
do
	cmd
	if cmd
		break [n]
		[continue]
	fi
done > outputfile

#WHILE
while expression
do
	cmd
done

####################################### FUNCTION #######################################

#Function.
function func_name
{
    local i
    local j

	expression

    return values
}

func_name parameter1 parameter2 ...
   ${0}      ${1}       ${2}    ...
${#} #Amount of paramters.
${*} #All paramters as a string.
${@} #All paramters as ${#} strings.
shift
getopts

####################################### REDIRECT #######################################

cmd > outputfile; cmd 1> outputfile; cmd 2> outputfile
cmd outputfile 2>&1
cmd < inputfile
cmd << EOF
.....
EOF

exec 1> test.out
exec 3>&1

#######################################   job     #######################################

trap SIG_NAME
trap -- SIG_NAME

test.sh &
nohup test.sh &

jobs -l
fg %1 #or "fg PID"; same blow.
bg %1
kill %1 #"kill -l" to display all signal.
nice
renice

ps -ef #Linux
ps -Aj #OpenBSD
ps -aj #FreeBSD

####################################### awk/gawk  #######################################

gawk [option] '{program}' file

#FIELDWIDTHS 由空格分隔的一列数字，定义了每个数据字段确切宽度
#FS          输入字段分隔符
#RS          输入记录分隔符
#OFS         输出字段分隔符
#ORS         输出记录分隔符
#ARGC        当前命令行参数个数
#ARGIND      当前文件在ARGV中的位置
#ARGV        包含命令行参数的数组
#CONVFMT     数字的转换格式（参见printf语句），默认值为%.6 g
#ENVIRON     当前shell环境变量及其值组成的关联数组
#ERRNO       当读取或关闭输入文件发生错误时的系统错误号
#FILENAME    用作gawk输入数据的数据文件的文件名
#FNR         当前数据文件中的数据行数
#IGNORECASE  设成非零值时，忽略gawk命令中出现的字符串的字符大小写
#NF          當前記錄的最後一個字段
#NR          已处理的输入记录数
#OFMT        数字的输出格式，默认值为%.6 g
#RLENGTH     由match函数所匹配的子字符串的长度
#RSTART      由match函数所匹配的子字符串的起始位置

#eq:
echo "My name is Rich." | gawk 'BEGIN {} {$4="Christine"; print $0} END{}'
#or
echo "My name is Rich." | gawk '{
$4="Christine"
print $0
}'
#From script file.
gawk -F : -f script.gawk data_file
#gawk script example:
{
    text=""
    print $1 test $6
}
#字段匹配
$2 ~ /string1/
#Struct command
if (condition)
 statement1
else
 statement2

while (condition)
{
 statements
}
for (i = 1; i < 4; i++)
{
 total += $i
}
#格式化打印
printf "format string", var1, var2 . . .
#function
function name([variables])
{
 statements
}

#######################################   sed     #######################################

[address][s][d][i][a][flags]
sed [-n] [-e script] [-f file]

#eq:
sed -e 's/string1/string2/; s/string3/string4/' data_file
#From script.
sed -e '
s/string1/string2/
s/string3/string4/' data_file
#From script file.
sed -f script.sed data_file

#Option s:
sed 's/pattern/replacement/[number][g][p][w file]'
sed '2,4s/pattern/replacement/'
sed '/pattern/s/pattern/replacement/'
sed '2,3{
s/pattern/replacement/
s/pattern1/replacement1/
}'
#Option d:
sed '2,3d' file.txt
sed '3,$d' file.txt
sed '/pattern1/,/pattern12/d' file.txt
#Option i,a,c:
sed '3a\
    new_line1\
    new_line2' file.txt
#Option r:
sed '/number 2/r data.txt' file.txt
#Option y:
sed 'y/abc/a1b1c1/'
#Option =:
#Print line number.
sed '=' file.txt
#Option l:
#Print \t.
sed -n 'l' file.txt
#Option for more than one lines: N, D, P:

#Hold space
#Options:
#h 将模式空间复制到保持空间
#H 将模式空间附加到保持空间
#g 将保持空间复制到模式空间
#G 将保持空间附加到模式空间
#x 交换模式空间和保持空间的内容

#Option !:
sed -n '/header/!p' data.file
sed -n '1!G; h; $p' data_file
#Option b:
[address]b [label]
sed '{2,3b ; s/This is/Is this/ ; s/line./test?/}' data2.txt
sed '{/first/b jump1 ; s/This is the/No jump on/
:jump1
s/This is the/Jump here on/}' data2.txt
#Option t:
[address]t [label]
echo "This, is, a, test, to, remove, commas. " | sed -n '{
> :start
> s/,//1p
> t start
> }'
#&
#\1
$ echo "That furry cat is pretty" | sed 's/furry \(.at\)/\1/'
That cat is pretty

#######################################   grep    #######################################

#shell通配符
字符	                       含义
*	                    匹配0个或多个任意字符
?	                    匹配一个任意字符
[list]	                匹配list中的任意单个字符
[!list]	[^list]         匹配除list中的任意单个字符
[c1-c2]	                匹配c1-c2间的任意单个字符
{string1,string2,...}	匹配string1、string2等中的一个字符串

#BRE
.               匹配一个任意字符
*               匹配0个或多个重复字符
[abc] or [^abc] 匹配abc或除abc中的任意单个字符
[c1-c2]         匹配c1-c2间的任意单个字符
#錨字符
^               開头
$               結尾
#ERE
?               匹配0个或一个任意字符
+               匹配一个或多个重复字符
{m} or {m,n}    匹配m或m-n个重复字符
expr1|expr2     匹配expr1或expr2
(abc)           將abc組看做單個字符

#######################################  commands  #######################################

date -d "1 day ago" "+%Y%m%d %H:%M:%S"
date -s "20120528 10:56:34"
