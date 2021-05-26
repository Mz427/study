#文件浏览器
netrw:
    #ex模式下命令:
    :Explore - opens netrw in the current window
    :Sexplore - opens netrw in a horizontal split
    :Vexplore - opens netrw in a horizontal split
    #配置文件项:
    let g:netrw_banner = 0
    let g:netrw_liststyle = 3
    let g:netrw_browse_split = 4
    let g:netrw_altv = 1
    let g:netrw_winsize = 25
    let g:netrw_banner = 0
#打开新文件：
    :e filename
    :newtab filename
    :split filename
    :vsplit filename
