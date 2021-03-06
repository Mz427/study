vim -[o][O] {filename} #分屏打开多个文件:o水平O垂直.
    :e[dit] filename
#buffers:
    :buffers | ls
    :buffer buffer1
    :bnext
    :bprevious
    :blast
    :bfirst
    :bclose
#标签页:
    :tabs
    :tabnew   [filename]
    :tabclose [filename]
    :tabn     [filename]
    :tabp     [filename]
    :tabfirst [filename]
    :tablast  [filename]
#打开新文件(分屏):
    :sp[lit]  [filename]
    :vsp[lit] [filename]
    :clo[se]  [filename]
    #快捷键:
    Ctrl+w s   #水平分割当前窗口
    Ctrl+w v   #垂直分割当前窗口
    Ctrl+w q,c #关闭当前窗口
    Ctrl+w n   #打开一个新窗口（空文件）
    Ctrl+w o   #关闭出当前窗口之外的所有窗口
    Ctrl+w T   #当前窗口移动到新标签页
    Ctrl+w [h][j][k][l] #切换工作窗口
    Ctrl+w w   #遍历切换窗口
    Ctrl+w [H][J][K][L] #移动当前窗口
    Ctrl+w +   #增加窗口高度
    Ctrl+w -   #减小窗口高度
    Ctrl+w =   #统一窗口高度
#netrw 文件浏览器:
    #ex模式下命令:
    :Explore   #opens netrw in the current window
    :Sexplore  #opens netrw in a horizontal split
    :Vexplore  #opens netrw in a horizontal split
    #配置文件项:
    let g:netrw_banner = 0
    let g:netrw_liststyle = 3
    let g:netrw_browse_split = 4
    let g:netrw_altv = 1
    let g:netrw_winsize = 25
    let g:netrw_banner = 1
#registers 寄存器(normal):
    #类型：
    ""          #未命名寄存器,自动记录最近一次复制和删除历史.
    "0-9      " #数字寄存器,自动记录复制和删除历史.
    "-        " #自动记录删除少于一行的文本.
    "a-z, A-Z " #自定义文本.
    #只读寄存器:
    "%        " #自动记录当前文件名.
     .          #自动记录最近插入的文本.
     :          #自动记录最近执行的命令行.
    "#        " #包含当前窗口轮换文件的名字,它影响CTRL-^的工作方式.
    "=        " #返回表达式结果.
    #系统寄存器:
    "*        " #系统剪贴板.
     +          #系统剪贴板.
     ~          #从外部复制的文本.
    "_        " #黑洞寄存器.
    "/        " #最近搜索内容.
    #ex模式下命令:
    :reg[isters] {reg_name}
#macro 宏(normal):
    q{a-z}q #宏录制,共用registers寄存器.
    #使用:
    3@{a-z}       #normal模式多次执行.
    :2,5 normal @{a-z} #多行执行.
#mark 标记(normal):
    m [a-z] #当前缓存区有效.
    m [A-Z] #全局有效.
    '[a-z]  '#标记跳转.
    `[a-z]  `#标记跳转.
    d'[a-z] '#删除标记.
    :marks
# ! 与外部命令交换:
    :! command        #暂时退出vim执行命令.
    :r[ead] ! command #当前行之后读入命令输出内容.
    :2,4 ! command    #将被选行作为标准输入执行命令，结果替换被选行.
    :2,4 w ! command  #将被选行作为标准输入执行命令，结果显示在命令区.
    :. w ! bash       #执行当前行,结果显示在命令区.
#自动补全:
    CTRL-N        #向上补全
    CTRL-P        #向上补全
    CTRL-X CTRL-L #整行补全
           CTRL-N #根据当前文件里关键字补全
           CTRL-K #根据字典补全
           CTRL-T #根据同义词字典补全
           CTRL-I #根据头文件内关键字补全
           CTRL-] #根据标签补全
           CTRL-F #补全文件名
           CTRL-D #补全宏定义
           CTRL-V #补全vim命令
           CTRL-U #用户自定义补全方式
           CTRL-S #拼写建议
#tag:
